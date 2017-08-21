<# --------------------------------------------------------------------------
   Vendor-specific Scripting
   --------------------------------------------------------------------------

   This file is sourced last by Export-DataToVendor.ps1. You can put any
   vendor-specific scripting here, most useful if they require special data
   formatting or custom upload scripts/apps.

   ------------------------------------------------------------------------- #>

# THIS VERSION REQUIRES POWERSHELL 5.0. THE EXISTING Vendor.script.ps1 HAS BEEN MODIFIED
# TO ACCOMMODATE LIMITATIONS IN POWERSHELL 3.0. We cannot upgrade to PS5.0 on Server 2008;
# PS5.0 requries Server 2008 R2 or higher.

# Since Benchmark doesn't offer native CSV+SFTP, I decided to automate the posting
# of CSVs through HTTPS. It mimics the same behavior as if one logged into the webGUI
# and manually submitted the CSVs through the website.
# This method is somewhat more fragile than others, since it can break without notice,
# so keep an eye on the error logs.

# Root path containing all CSVs to upload
$CsvPath = $VendorExportPath

# Login info
   $Realm = ''
$Username = ''
$Password = ''
$District = 123456

# List of CSVs to upload.
# TODO: This would be better done actually searching $CsvPath above instead of hard-coding them
# But then again, this is also nice because I can specify the order of processing easier this way
$CsvList = @(
    'Teachers.csv'
    'Students.csv'
    'Classes.csv'
)

# Initial request URI and headers
# Derived from manually inspecting a request with Chrome dev tools
$BaseUri = 'https://techadmin.benchmarkuniverse.com'
$Headers = @{
    'Accept'           = '*/*'
    'Accept-Encoding'  = 'gzip, deflate, br'
    'Accept-Language'  = 'en-US,en;q=0.8'
    'Content-Type'     = 'multipart/form-data; boundary=----WebKitFormBoundarynydMOBVUvB5ysQvF'
    'Host'             = 'techadmin.benchmarkuniverse.com'
    'Origin'           = 'https://techadmin.benchmarkuniverse.com'
    'Referer'          = 'https://techadmin.benchmarkuniverse.com/'
    'User-Agent'       = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.96 Safari/537.36'
    'X-Requested-With' = 'XMLHttpRequest'
}

# Start constructing the request hashtable
$Request = @{
    # Method is always POST
    Method = 'POST'

    # Add in headers from above
    Headers = $Headers

    # Stores response cookies and info in $Session variable
    # Call future requests with WebSession = $Session to reuse
    SessionVariable = 'Session'

    # Derived from manually inspecting a request with Chrome dev tools
    Uri = $BaseUri + '/root/login'
}
# This body is in the multipart/form-data content-type, which is *usually* reserved for when we POST a binary file...
# for some reason they use that content-type for plain logins. Usually we would use application/x-www-form-urlencoded
# with plain key/value pairs separated by ampersands (e.g. key1=value1&key2=value2&key3=value3)
$Request['Body'] = @"
------WebKitFormBoundarynydMOBVUvB5ysQvF
Content-Disposition: form-data; name="realm"

${Realm}
------WebKitFormBoundarynydMOBVUvB5ysQvF
Content-Disposition: form-data; name="username"

${Username}
------WebKitFormBoundarynydMOBVUvB5ysQvF
Content-Disposition: form-data; name="password"

${Password}
------WebKitFormBoundarynydMOBVUvB5ysQvF--
"@

# Log in!
Write-Log "Logging in to $($Request.Uri) ..." $LogFile
$Response = Invoke-WebRequest @Request

If ($Response.StatusCode -eq 200) {

    # If successful, continue submitting CSVs
    Write-Log "Logged in successfully." $LogFile
    ForEach ($Csv in $CsvList) {

        # Construct full file path to CSV files
        $CsvFile = "${CSvPath}\${Csv}"

        # Used in the body below (e.g., "classes", "students")
        $Type = $Csv.split('.')[0].toLower()

        # This isn't needed anymore because we are now using the session in $WebSession below
        $Request.Remove('SessionVariable')

        # These will be present in the $Session variable
        $Request.Remove('Headers')

        # The format of this body was obtained by using Chrome dev tools to inspect a manual POST's body
        # The HEREDOC syntax (using @" ... "@ makes it easier to presreve newline formatting)
        # WARNING: The districtID below will (of course) vary from district to district
        $Request['Body'] = @"
------WebKitFormBoundarynydMOBVUvB5ysQvF
Content-Disposition: form-data; name="districtID"

${District}
------WebKitFormBoundarynydMOBVUvB5ysQvF
Content-Disposition: form-data; name="type"

${Type}
------WebKitFormBoundarynydMOBVUvB5ysQvF
Content-Disposition: form-data; name="file"; filename="${Csv}"
Content-Type: application/vnd.ms-excel

$(Get-Content $CsvFile -Raw)
------WebKitFormBoundarynydMOBVUvB5ysQvF
"@

        # Update variable with new request info
        $Request['Uri'] = $BaseUri + '/processing/requestImport/'

        # This passes the all-important session cookie, obtained from the login request
        $Request['WebSession'] = $Session

        # Submit
        Write-Log "Sending ${Csv} ..." $LogFile
        $Response = Invoke-WebRequest @Request

        If ($Response.StatusCode -eq 200) {
            # Success
            Write-Log "Sent ${Csv} successfully." $LogFile

        } Else {
            # Failure
            Write-Log "Sending ${Csv} failed; response: $($Response.StatusCode) - $($Response.StatusDescription)" $LogFile
        }
        # Let's not overwhelm the server...
        Start-Sleep 5
    }

    # Log out
    # This is probably not necessary, but I like to keep things clean.
    # I really doubut anyone on their end is auditing headers for requests to /root/logout, but best to be safe
    $Request['Method'] = 'GET'
    $Request['Uri'] = $BaseUri + '/root/logout/'
    $Request.Remove('Body')
    $Request.WebSession.Headers.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8'
    # TODO: Why do these return the string 'True' without Out-Null?
    $Request.WebSession.Headers.Remove('X-Requested-With') | Out-Null
    $Request.WebSession.Headers.Remove('Origin')           | Out-Null
    $Request.WebSession.Headers.Remove('Content-Type')     | Out-Null
    Write-Log "Logging out..." $LogFile
    $Response = Invoke-WebRequest @Request
    If ($Response.StatusCode -eq 200) {
        # Success
        Write-Log "Logged out successfully." $LogFile
    } Else {
        # Failure
        Write-Log "Logging out failed; response: $($Response.StatusCode) - $($Response.StatusDescription)" $LogFile
        # TODO: Catch this error and send email so we know when this code breaks, so we can update it
    }

} Else {
    # Initial login failed
    Write-Log "Login failed; response: $($Response.StatusCode) - $($Response.StatusDescription)" $LogFile
    # TODO: Catch this error and send email so we know when this code breaks, so we can update it
}