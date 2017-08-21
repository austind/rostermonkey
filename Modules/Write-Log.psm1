Function Write-Log {
    [CmdletBinding()]
    Param (
        [Parameter(
            Mandatory = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [ValidateNotNullOrEmpty()]
        [string]$Message,

        [Parameter(Mandatory = $true)]
        [string]$LogFile,

        [Parameter(Mandatory = $false)]
        [ValidateSet('Info', 'Warn', 'Error')]
        [string]$Level = 'Info'
    )
    Begin {
        # Show verbose messages
        $VerbosePreference = 'Continue'

        # Build timestamp
        $Timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'

        # Check and/or create log path
        If (!(Test-Path $LogFile)) {
            Try {
                Write-Verbose "Log file $LogFile does not exist. Attempting to create."
                New-Item $LogFile -Force -ItemType File > $null
            }
            Catch {
                Write-Error "Log file $LogFile creation failed."
                Exit 1
            }
            Write-Verbose "Log file $LogFile created successfully."
        }
    }
    Process {
        Switch ($Level) {
            'Info' {
                Write-Verbose $Message
                $LevelString = 'INFO:'
            }
            'Warn' {
                Write-Warning $Message
                $LevelString = 'WARN:'
            }
            'Error' {
                Write-Error $Message
                $LevelString = 'ERROR:'
            }
        }
        "$Timestamp $LevelString $Message" | Out-File -FilePath $LogFile -Append
    }

}