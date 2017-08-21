# http://stackoverflow.com/questions/1153126/how-to-create-a-zip-archive-with-powershell

Function Compress-Archive {
    Param (
        $ZipFileName,
        $SourceDir
    )
    Add-Type -Assembly System.IO.Compression.FileSystem
    $CompressionLevel = [System.IO.Compression.CompressionLevel]::Optimal
    [System.IO.Compression.ZipFile]::CreateFromDirectory($SourceDir,
        $ZipFileName, $CompressionLevel, $false)
}