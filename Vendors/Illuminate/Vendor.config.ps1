<# --------------------------------------------------------------------------
   Vendor-specific Configuration
   --------------------------------------------------------------------------

   This file is sourced after Global.config.ps1, so you can override anything
   set there if you want further customization.

   ------------------------------------------------------------------------- #>

<# -------------------------------------------------------------------------
   General
   ------------------------------------------------------------------------- #>

<# What type of data to export
    Values: CSV or TSV
    CSV: Comma-separated values, surrounded by double-quotes
    TSV: Tab-separated values, surrounded by no quotes
    Which to use depends on the vendor. If in doubt, use CSV.                #>
[string]$ExportType = 'tsv'

<# Whether or not to call Vendors\<Vendor-Name>\Vendor.script.ps1
    Vendor.script.ps1 is a way to add vendor-specific scripting/logic. Most
    vendors standardize on using SFTP--but others, such as Destiny, are based
    on legacy batch files.
    You can also use this file alongside $SftpEnabled, if you need to do any
    other non-upload-related stuff.
    This file is called last by Export-DataToVendor.ps1.                     #>
[switch]$VendorScriptEnabled = $true



<# -------------------------------------------------------------------------
   SFTP                                     Ignored if $SftpEnabled = $false
   ------------------------------------------------------------------------- #>

<# Whether or not to use SFTP
    If set to $true, the main script automatically uploads exports to
    the vendor with the settings given below.
    If set to $false, the main script will not automatically SFTP
    anything, and you must use Vendor.script.ps1 to upload the data some other
    way, possibly by calling a different third-party program or script.      #>
[switch]$SftpEnabled = $true

# SFTP username
[string]$SftpUsername  = ''

# SFTP password
[string]$SftpPassword  = ''

# SFTP hostname
[string]$SftpHostname  = 'sftp.illuminateed.com'

<# SFTP host RSA key
   This is important because whether PSFTP trusts a host key is user-dependent.
   If you specify the host key here, it won't matter what account you run the 
   automation script under, because it will trust this explicit host key,
   instead of prompting for it.
   You can get the host key by asking the vendor (unlikely) or connecting
   manually and copying it (most likely)                                     #>
[string]$SftpHostKey   = '3d:78:70:7e:1b:64:b0:59:d3:d2:03:68:bd:f3:b3:30'

<# Path on remote SFTP host to upload files to
   Depending on the vendor, you may need to put files in a specific folder,
   such as "imports." Check with the vendor, or load up the SFTP connection
   in a program like FileZilla to browse the remote directories.
   this argument does not need leading or trailing slashes. In most cases,
   just put the name of the destination folder.
   Examples:
   [string]$SftpRemotePath = '/imports'
   [string]$SftpRemotePath = '/imports/data'                                  #>
[string]$SftpRemotePath = '/gridley'



<# -------------------------------------------------------------------------
   Email notifications                     Ignored if $EmailEnabled = $False
   ------------------------------------------------------------------------- #>

# Whether to send reports
[switch]$EmailEnabled = $false 

# Subject line
[string]$EmailSubject = 'Example Updates'

# Email body text in HEREDOC syntax. Can use variables, etc.
[string]$EmailBody = @"
-----------
EMAIL BODY
GOES HERE
-----------
"@

# What address to use in reports' From field.
# This does not have to be the same as $SmtpUsername, which is the actual
# account on the mail server that authenticates the message
[string]$EmailFrom    = 'noreply@example.org'

# String or array of strings containing recipients for reports
# E.g. [string[]]$EmailTo = 'admin1@example.org','admin2@example.org'
[string[]]$EmailTo    = 'someone@example.org'