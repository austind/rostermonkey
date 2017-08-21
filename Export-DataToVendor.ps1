<#
.SYNOPSIS
   Export-DataToVendor.ps1 is a framework for automatically sending user data 
   from SQL to a third-party vendor, usually as CSV via SFTP.

.DESCRIPTION
   Export-DataToVendor.ps1 provides a way to automate the process of pulling
   data out of a SQL database (usually an SIS such as Aeries), and submitting
   that data securely to the third party vendor (such as a learning management
   or assessment system, like i-Ready).

   Most vendors have standardized on CSV-formatted data sent to an SFTP
   server. Some vendors use tab-separated values (TSV), which is also supported.
   SFTP support is built-in, but you can also use this framework to call third
   party upload tools or scripts after data is exported.

   Overview:
    1. Match all settings in Config\Global.config.ps1 to your environment
    2. Copy Vendors\_TEMPLATE and rename to match your vendor (alphanumeric)
    3. Rewrite SQL to generate the appropriate exports for your vendor
    4. Update Vendors\<Name>\Vendor.config.ps1 appropriately
    5. Call .\Export-DataToVendor.ps1 -Vendor <Vendor-Name> to run

   Folder structure:
    \ExportDataToVendor.ps1           - Main script
    \Binaries\*.exe                   - Binary dependencies
    \Config\Global.config.ps1         - Global configuration file
    \Modules\*.psm1                   - Module dependencies
    \Vendors\                         - Vendor scripts root
    \Vendors\<Name>\Vendor.config.ps1 - Vendor-specific config (required)
    \Vendors\<Name>\Vendor.script.ps1 - Vendor-specific scripting (optional)
    \Vendors\<Name>\Vendor.info.txt   - Documentation (support info, etc).
    \Vendors\<Name>\Export            - Destination for exported CSV or TSV
    \Vendors\<Name>\Logs              - Destination for job logs
    \Vendors\<Name>\SQL               - SQL files (ending in *.sql)
    \Vendors\<Name>\Upload            - Files related to uploads (optional)

   When calling from Task Scheduler:
    - Action: Start a program
    - Program/Script: PowerShell (no .exe required)
    - Add arguments: ".\Export-DataToVendor.ps1 -Vendor <Name>" (include quotes)
    - Start in: <$ScriptRoot>
        (Wherever Export-DataSetup.ps1 lives, e.g., C:\Scripts\Export)

.NOTES
   Author: Austin de Coup-Crank <adecoup@bcoe.org>
   Version: 2.5

.PARAMETER Vendor
   The Vendor parameter specifies which vendor script you want to run. It must
   have a correspoding folder in Vendors\<$Vendor> or else the script will fail.

.EXAMPLE
   Export-DataToVendor.ps1 -Vendor iReady

   #Requires -Version 3
   Also requires .NET Framework 4.5, PowerShell 5.0, or PowerShell Community
   Extensions to support ZIP file creation
#>

[CmdletBinding()]
Param (
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [string]$Vendor
)

Begin {
    # Global variables
    [datetime]$Date = Get-Date

    # Source global configuration
    . ".\Config\Global.config.ps1"

    # Leading slash: no
    # Trailing slash: yes

    # System paths
    [string]$SystemModulesPath  = "$ScriptRoot" + 'Modules\'
    [string]$SystemBinariesPath = "$ScriptRoot" + 'Binaries\'
    [string]$SystemVendorsPath  = "$ScriptRoot" + 'Vendors\'

    # Vendor paths
    [string]$VendorPath       = "$SystemVendorsPath" + "$Vendor" + '\'
    [string]$VendorConfigFile = "$VendorPath" + 'Vendor.config.ps1'
    [string]$VendorScriptFile = "$VendorPath" + 'Vendor.script.ps1'
    [string]$VendorSqlPath    = "$VendorPath" + 'SQL\'
    [string]$VendorExportPath = "$VendorPath" + 'Export\'
    [string]$VendorUploadPath = "$VendorPath" + 'Upload\'
    [string]$VendorLogsPath   = "$VendorPath" + 'Logs\'

    # Logging
    [string]$LogName = "${Vendor}-export_$(Get-Date -Format yyyy-MM-dd_HHmmss).log"
    [string]$LogFile = "$VendorLogsPath" + $LogName

    # Binary paths
    [string]$SftpExe = "$SystemBinariesPath" + 'psftp.exe'

    # Validate vendor path first
    If (!(Test-Path $VendorPath)) {
        Write-Error "Fatal: Vendor path does not exist: ${VendorPath}"
        Exit 1
    }

    # Import modules
    # 3rd party modules
    Import-Module PSCX # Required for Write-Zip
    # 1st party modules
    ForEach ($Module in (Get-ChildItem $SystemModulesPath -Recurse -Include "*.psm1")) {
        Import-Module "$($Module.FullName)" -Force
    }

    # Validate critical paths
    $CriticalPathList = @(
        $SystemModulesPath,
        $SystemBinariesPath,
        $SystemVendorsPath,
        $VendorConfigFile,
        $VendorSqlPath,
        $VendorExportPath
    )
    ForEach ($CriticalPath in $CriticalPathList) {
        If (!(Test-Path -Path $CriticalPath)) {
            Write-Log "Exiting: Critical system path or file does not exist: $CriticalPath" $LogFile 'Error'
            Exit 1
        }
    }


    # Prune logs
    #Prune-DirectoryTree -SearchBase $VendorLogsPath -Filter *.log -DaysToKeep 30 -LogFile $LogFile

    Write-Log "Exporting data to $Vendor as ${env:USERDOMAIN}\${env:USERNAME}" $LogFile

    # Ensure at least 1 file exists in $VendorSqlPath
    $SqlFileList = Get-ChildItem $($VendorSqlPath + '\*.sql')
    If ($SqlFileList.Count -eq 0) {
        Write-Log "Exiting: No *.sql files to process in $VendorSqlPath." $LogFile 'Error'
        Exit 1
    }
    Write-Log "Found $($SqlFileList.Count) *.sql files in $VendorSqlPath" $LogFile

    # Source vendor configuration
    . $VendorConfigFile
    Write-Log "Sourced vendor config file: $VendorConfigFile" $LogFile
 }

Process {
    # Execute & export SQL
    $ExportArgs = @{
        SqlServer   = $SqlServer
        SqlUser     = $SqlUser
        SqlPassword = $SqlPassword
        SqlDb       = $SQLDB
        OutType     = $ExportType
        OutPath     = $VendorExportPath
    }
    Write-Log "`$SqlServer   = $SqlServer"   $LogFile
    Write-Log "`$SqlUser     = $SqlUser"     $LogFile
    Write-Log "`$SqlPassword = <not logged>" $LogFile
    Write-Log "`$SqlDb       = $SqlDb"       $LogFile

    $i = 0
    ForEach ($SqlFile in $SqlFileList) {
        $i++
        $ExportArgs['SqlFile'] = $SqlFile
        Try {
            Export-SqlToFile @ExportArgs
            Write-Log "Exported SQL $i of $($SqlFileList.Count) $SqlFile" $LogFile
        }
        Catch {
            Write-Log "Unable to export SQL $i of $($SqlFileList.Count) ${SqlFile}: $($_.Error.Message)" $LogFile 'Error'
        }
    }

    # Compress exports as ZIP archive, if requested
    If ($CompressExport) {
        $ZipFileName = "${VendorPath}${Vendor}-Export.zip"
        Try {
            If (Test-Path "${VendorExportPath}${Vendor}-Export.zip") {
                Remove-Item "${VendorExportPath}${Vendor}-Export.zip"
            }

            # The only way to create ZIP files natively is using .NET 4.5
            # Since that conflicts with other export systems, I decided to use
            # PowerShell Community Extensions module which includes Write-Zip.
            #Compress-Archive -ZipFileName $ZipFileName -SourceDir $VendorExportPath
            Write-Zip -OutputPath $ZipFileName -Path "${VendorExportPath}\*.csv"
            Get-ChildItem $VendorExportPath | Remove-Item -Force
            Move-Item $ZipFileName $VendorExportPath -Force
            Write-Log "Compressed $i exported files as ZIP archive to $ZipFileName" $LogFile
        }
        Catch {
            Write-Log "Unable to compress files as ZIP archive: $($_.Error.Message)" 'Error'
        }
    }

    # Execute SFTP, if requested
    If ($SftpEnabled) {

        # Build SFTP batch file to feed into psftp.exe
        $SftpBatchFile = $VendorUploadPath + 'Sftp.batch.txt'
        If (Test-Path $SftpBatchFile) {
            Remove-Item -Path $SftpBatchFile -Force
        }
        "lcd `"$VendorExportPath`"" | Add-Content $SftpBatchFile
        If (($SftpRemotePath) -and ($SftpRemotPath -ne '')) {
            "cd `"$SftpRemotePath`""| Add-Content $SftpBatchFile
        }
        Get-ChildItem $VendorExportPath | ForEach {
            "put `"$($_.FullName)`""| Add-Content $SftpBatchFile
        }
        "quit"                      | Add-Content $SftpBatchFile

        # Begin SFTP
        Write-Log "`$SftpHostname  = $SftpHostname"    $LogFile
        Write-Log "`$SftpUsername  = $SftpUsername"    $LogFile
        Write-Log "`$SftpPassword  = <not logged>"     $LogFile
        Write-Log "`$SftpBatchFile = $SftpBatchFile"   $LogFile
        Write-Log "`$SftpHostKey   = $SftpHostKey"     $LogFile
        Write-Log "--------- BEGIN SFTP LOG ---------" $LogFile
        $VerbosePreference = 'Continue'
        Write-Verbose "(SFTP log will be appended to log file)"
        $VerbosePreference = 'SilentlyContinue'
        $SftpArgs = @{
            SftpExe       = $SftpExe
            SftpUsername  = $SftpUsername
            SftpPassword  = $SftpPassword
            SftpHostname  = $SftpHostname
            SftpHostkey   = $SftpHostKey
            SftpBatchFile = $SftpBatchFile
            SftpLogFile   = $VendorLogsPath + 'sftp.log'
        }
        Send-SftpFiles @SftpArgs
        
        # Append SFTP logs to main log
        $VendorTempLog = $VendorLogsPath + 'temp.log'
        Get-Content $LogFile, $SftpArgs['SftpLogFile'] | Out-File $VendorTempLog
        Remove-Item -Path $LogFile -Force
        Rename-Item -Path $VendorTempLog -NewName $LogFile -Force
        Remove-Item -Path $SftpArgs['SftpLogFile'] -Force
        Write-Log "--------- END SFTP LOG ---------" $LogFile
    }

    # Source/run vendor script, if requested
    If ((Test-Path $VendorScriptFile) -and ($VendorScriptEnabled)) {
        Write-Log "Sourcing vendor script: $VendorScriptFile" $LogFile
        . $VendorScriptFile
    }
}

End {
    Write-Log "Data export to $Vendor complete" $LogFile
}