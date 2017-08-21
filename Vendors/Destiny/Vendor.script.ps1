<# --------------------------------------------------------------------------
   Vendor-specific Scripting
   --------------------------------------------------------------------------

   This file is sourced last by Export-DataToVendor.ps1. You can put any
   vendor-specific scripting here, most useful if they require special data
   formatting or custom upload scripts/apps.

   ------------------------------------------------------------------------- #>
# Uploading is done through several batch files. This simply executes each of
# them. If any are added, they will be automatically run.
$AutomationPath = $VendorUploadPath + 'automate\'
$BatchFileList = Get-ChildItem $($AutomationPath + 'process_remote_*.bat')
Write-Log "Running all process_remote_*.bat in $AutomationPath" $LogFile
ForEach ($BatchFile in $BatchFileList) {
    Write-Log "Executing ${BatchFile}..." $LogFile
    Start-Process -NoNewWindow "cmd.exe" "/c $($BatchFile.FullName)" -Wait -WorkingDirectory $AutomationPath
}