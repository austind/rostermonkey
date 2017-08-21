<# --------------------------------------------------------------------------
   Vendor-specific Scripting
   --------------------------------------------------------------------------

   This file is sourced last by Export-DataToVendor.ps1. You can put any
   vendor-specific scripting here, most useful if they require special data
   formatting or custom upload scripts/apps.

   ------------------------------------------------------------------------- #>
# Aeries Extract
$StdOut = $VendorLogsPath + 'AeriesExtract.stdout.log'
$StdErr = $VendorLogsPath + 'AeriesExtract.stderr.log'
$UploadExe = $VendorUploadPath + 'AeriesExtract.exe'
Write-Log "Calling vendor uploader: ${UploadExe}" $LogFile
$ExeArgs = @{
    FilePath               = $UploadExe
    # For some strange reason, enabling output redirection crashes AeriesExtract.exe. >:(
    #RedirectStandardOutput = $StdOut
    #RedirectStandardError  = $StdErr
}
Start-Process @ExeArgs -NoNewWindow -Wait -WorkingDirectory $VendorUploadPath -Verbose