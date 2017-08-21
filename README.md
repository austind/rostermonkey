# RosterMonkey

A flexible PowerShell framework that automates roster syncs from Aeries SIS to cloud-based learning tools.

## Requires

* PowerShell 2.0+
* Built-in scripts assume Aeries SIS, but any SIS that you can run SQL against will work

## Overview

RosterMonkey takes (most of) the monkey work out of syncing school rosters to third party apps, by providing a straighforward way to export SQL queries to CSV/TSV/XLSX and upload them, usually via SFTP.

RosterMonkey takes a given set of SQL queries, runs them against an SIS SQL server, dumps the results to a file format of your choice (e.g., CSV or XLSX), then sends those files to a remote SFTP server. Several apps/vendors are supported out of the box, but it's easy to add support to new vendors as needed.

## Supported Services

* AIMSweb
* Benchmark Universe
* ClassLink
* McGraw-Hill ConnectED
* Follett Destiny
* Holt McDougal Online
* Illuminate DNA (Data 'n Assessments)
* i-Ready
* Language LIVE!
* Typing Club