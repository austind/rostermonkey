# -----------------------------------------------------------------------------
# CONFIGURATION
# -----------------------------------------------------------------------------
# Source main script
. "..\Export-DataSetup.ps1"

# Email
    $SendEmail = $false
    $EmailFrom = "Google Updates <googleupdates@${EmailDomain}>"
      $EmailTo = "adecoup@bcoe.org"
 $EmailSubject = "Google Updates"
    $EmailBody = @"
-----------
EMAIL BODY
GOES HERE
-----------
"@

# -----------------------------------------------------------------------------
# EXPORT
# -----------------------------------------------------------------------------
Export-SqlToCsv

# -----------------------------------------------------------------------------
# UPLOAD
# -----------------------------------------------------------------------------
# &