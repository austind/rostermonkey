Function Send-SftpFiles {
    Param (
        $SftpExe,
        $SftpUsername,
        $SftpPassword,
        $SftpHostname,
        $SftpHostkey,
        $SftpBatchFile,
        $SftpLogFile
    )

    # Start-Process does not allow logging both stdout and stderr to the same file
    $SftpErrFile = $SftpLogFile + '.err'
    $SftpArgs = @{
        FilePath               = $SftpExe
        ArgumentList           = "-l ${SftpUsername} -pw ${SftpPassword} ${SftpHostname} -b `"${SftpBatchFile}`" -hostkey ${SftpHostKey} -batch"
        RedirectStandardOutput = $SftpLogFile
        RedirectStandardError  = $SftpErrFile
        NoNewWindow            = $True
        Wait                   = $True
    }
    Start-Process @SftpArgs

    # Concatenate stdout and stderr logs
    $SftpTmpFile = $SftpLogFile + '.tmp'
    Get-Content $SftpErrFile, $SftpLogFile | Out-File $SftpTmpFile
    Remove-Item -Path $SftpLogFile -Force
    Remove-Item -Path $SftpErrFile -Force
    Rename-Item -Path $SftpTmpFile -NewName $SftpLogFile -Force
}