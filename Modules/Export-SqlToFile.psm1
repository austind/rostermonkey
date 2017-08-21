Function Export-SqlToFile {
    [CmdletBinding()]
    Param (
        [string]$SqlServer,
        [string]$SqlUser,
        [string]$SqlPassword,
        [string]$SqlDb,
        [psobject]$SqlFile,
        [string]$OutType = 'csv',
        [string]$OutPath
    )
    $SqlQuery    = [IO.File]::ReadAllText($SqlFile)
    $BaseOutFile = $OutPath + [string]$SqlFile.Name.Split('.')[0]
    $Result = Invoke-SqlQuery $SqlServer $SqlUser $SqlPassword $SqlDb $SqlQuery
    Switch ($OutType.toLower()) {
        'csv' {
            $Extension = '.csv'
            $Delimiter = ','
            $OutFile   = $BaseOutFile + $Extension
            $Result | Export-Csv -NoTypeInformation -Path $OutFile -Delimiter $Delimiter -Force
        }
        'tsv' {
            $Extension = '.txt'
            $Delimiter = "`t"
            $TmpFile   = $BaseOutFile + '.tmp'
            $OutFile   = $BaseOutfile + $Extension
            $Result | Export-Csv -NoTypeInformation -Path $TmpFile -Delimiter $Delimiter -Force
            Get-Content $TmpFile | ForEach { $_ -replace '"', '' } |
                Out-File -FilePath $OutFile -Force -Encoding Ascii
            Remove-Item $TmpFile -Force
        }
        'xlsx' {
            # The Export-Xlsx cmdlet *is* capable of exporting objects directly to .xlsx,
            # But my crack-pot Invoke-SqlCommand cmdlet returns a "dataset" instead of a normal
            # object. This means doing a plain `$Result | Export-Xlsx` gives me a bunch of extra
            # columns I don't care about, that I assume are part of the dataset object.

            # I tried for a while to refactor Invoke-SqlCommand so it would return a "normal" object,
            # but ran out of time. Dumping it to CSV first, then converting to XLSX is a workaround.
            # (btw, newer versions of PS include native SQL cmdlets, but this needs to support PS2.0)
            $Extension = '.xlsx'
            $Delimiter = ','
            $TmpFile   = $BaseOutFile + '.tmp'
            $OutFile   = $BaseOutfile + $Extension
            $Result | Export-Csv -NoTypeInformation -Path $TmpFile -Delimiter $Delimiter -Force
            Import-Csv $TmpFile | Export-Xlsx -Path $OutFile -WorksheetName 'Sheet' -Force
            Remove-Item $TmpFile -Force
        }
    }
}