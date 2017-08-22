# -----------------------------------------------------------------------------
# General config
# -----------------------------------------------------------------------------

# Absolute path where Export-DataToVendor.ps1 lives
[string]$ScriptRoot = 'C:\Scripts\RosterMonkey\'

# -----------------------------------------------------------------------------
# SQL server and database connection
# -----------------------------------------------------------------------------

# SQL server's FQDN or IP
[string]$SQLServer   = ''

# Username with permissions to run queries in vendor scripts
[string]$SQLUser     = ''

# SQL password
[string]$SQLPassword = ''

# (Aeries only) The suffix of the database name.
# E.g., For DST15000ExampleSchool, the suffix is 'ExampleSchool'
[string]$SQLDBSuffix = ''

# Automatically selects Aeries SQL database based on school year.
# Rolls over July 1.
# TODO: Roll this over based on a configurable roll date.
If ($Date.Month -ge 7) {
      $SqlYear = [int]$Date.Year.toString().Substring(2,2)
} Else {
      $SqlYear = [int]$Date.Year.toString().Substring(2,2) - 1
}

# Hardcode it if you don't want auto-detection.
#[string]$SQLDB = ''
[string]$SQLDB       = 'DST' + [string]$SqlYear + '000' + [string]$SQLDBSuffix

# -----------------------------------------------------------------------------
# Logging
# -----------------------------------------------------------------------------

# Whether to write logs to <Vendor>\Logs
# TODO: This check not implemented yet (logs are written no matter what)
[switch]$LoggingEnabled = $true

# The number of logs to keep for each vendor
# TODO: Not yet implemented
[int]$LogsToKeep = 7

# -----------------------------------------------------------------------------
# Email reports                           TODO: Not fully implemented or tested
# -----------------------------------------------------------------------------

# NOTE: These are global defaults, and can be overridden in vendor scripts

# Whether to send reports
[switch]$EmailEnabled = $false 

# What address to use in reports' From field.
# This does not have to be the same as $SmtpUsername, which is the actual
# account on the mail server that authenticates the message
[string]$EmailFrom    = 'noreply@example.org'

# String or array of strings containing recipients for reports
# E.g. [string[]]$EmailTo = 'admin1@example.org','admin2@example.org'
[string[]]$EmailTo    = 'someone@example.org'

# Username / email address to send reports from, also used for 
[string]$SmtpUsername = 'service@example.org'
[string]$SmtpPassword = 'P@55w0rd'
[string]$SmtpServer   = 'mail.example.org'
[int]$SmtpPort        = 587