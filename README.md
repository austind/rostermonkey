# RosterMonkey

A flexible PowerShell framework that automates roster syncs from a SQL-based Student Information System (SIS) to cloud-based learning systems.

## Requires

* PowerShell 2.0+
* Built-in scripts assume Aeries SIS, but any SIS that you can run SQL against will work

## Overview

RosterMonkey takes the monkey work out of syncing school rosters to third party apps, by providing a straighforward way to export SQL queries and upload them. Each vendor has their own schema, file format, and upload requirements. RosterMonkey aims to abstract as much of this as possible, so you can focus on vendor-specific requirements, instead of rewriting boilerplate. Everything uses the same SQL server info and credentials, but each vendor gets their own configuration, SQL statements, log files, and optional custom scripts. 

In essence, RosterMonkey:

* Takes a set of SQL statement files
* Runs them against a given SQL server
* Dumps the results to a specified file type (usually CSV, but TSV and XLSX are also supported)
* Does something with the resulting files (usually uploading via SFTP — but custom actions are also common)

## Native Support

### File Formats

* CSV — comma-separated values, enclosed in double-quotes `"`
* TSV — tab-separated values, with no enclosing quotes
* XLSX — Microsoft Excel spreadsheet
* ZIP — used in addition to the above formats, but compresses the resulting files in a .ZIP

### Upload Methods

* SFTP - Secure File Transfer Protocol (via psftp.exe)

### Vendors

* AIMSweb
* Benchmark Universe
* ClassLink
* McGraw-Hill ConnectED
* Follett Destiny
* Holt McDougal Online
* Illuminate DNA (Data 'n' Assessments)
* i-Ready
* Language LIVE!
* Typing Club

## Extensible Support

Every vendor has its own `Vendor.script.ps1`, which is arbitrary code to execute after SQL exports have run. With this, you can do anything you like.

For example, for Benchmark Universe wanted like $4k to enable SFTP support. I thought this pretty unreasonable, so I wrote a custom script that uploads data via their web frontend, using `Invoke-WebRequest`.

I've also used the vendor script to copy exported data to the personal folder of the user responsible for manual uploads. Whenever they want to upload fresh data, they only have to look in that one place.

## How To Use

1. Match all settings in \Config\Global.config.ps1 to your environment
1. Copy \Vendors\_TEMPLATE and rename to match your vendor (alphanumeric)
1. Rewrite SQL to generate the appropriate exports for your vendor
1. Update \Vendors\<Name>\Vendor.config.ps1 appropriately
1. Call `.\Export-DataToVendor.ps1 -Vendor <Vendor-Name>` to run

### Folder structure

```
\ExportDataToVendor.ps1           - Main script
\Binaries\*.exe                   - Binary dependencies
\Config\Global.config.ps1         - Global configuration file
\Modules\*.psm1                   - Module dependencies
\Vendors\                         - Vendor scripts root
\Vendors\<Name>\Vendor.config.ps1 - Vendor-specific config (required)
\Vendors\<Name>\Vendor.script.ps1 - Vendor-specific scripting (optional)
\Vendors\<Name>\Vendor.info.txt   - Documentation (support info, etc).
\Vendors\<Name>\Export            - Destination for exported CSV/TSV/whatever
\Vendors\<Name>\Logs              - Destination for job logs
\Vendors\<Name>\SQL               - SQL files (ending in *.sql)
\Vendors\<Name>\Upload            - Files related to uploads (optional)
```

### Automating with Task Scheduler
- Action: Start a program
- Program/Script: `PowerShell` (no .exe required)
- Add arguments: `".\Export-DataToVendor.ps1 -Vendor <Name>"` (include quotes)
- Start in: <$ScriptRoot>
	(Wherever `Export-DataSetup.ps1` lives, e.g., C:\Scripts\Export)