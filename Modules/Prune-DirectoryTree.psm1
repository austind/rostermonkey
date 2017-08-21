Function Prune-DirectoryTree {
    <#
        .NAME
            Prune-DirectoryTree.ps1

        .SYNOPSIS
            Deletes any files found below a given root directory, which both match a
            given filename pattern, and were modified before a given age (in days).

        .DESCRIPTION
            Starting at a given root directory ($SearchBase), searches for any files 
            matching a filename pattern ($Filter). The file is deleted if its
            LastWriteTime attribute is older than $DaysToKeep. Optionally logs
            progress to a file ($LogFile).

        .SYNTAX
            Prune-DirectoryTree.ps1 

        .PARAMETER  SearchBase
        .PARAMETER  Filter
        .PARAMETER  DaysToKeep
        .PARAMETER  ComputerName
        .PARAMETER  LogFile

        .EXAMPLE
            TODO
    #>

    [CmdletBinding()]
    Param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$SearchBase,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$Filter,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1,65535)]
           [int]$DaysToKeep = 31,
        #[string[]]$ComputerName = 'localhost',
        [string]$LogFile
    )

    $CutoffTimestamp = [DateTime]::Today.AddDays(-($DaysToKeep))
      $ScriptRunTime = [DateTime]::Now.DateTime

    # Logging
    Function Write-Log {
        Param (
            [string]$Entry
        )
        If ($LogFile) {
            Add-Content -Value "$Entry" -Path $LogFile
        } Else {
            Write-Output $Entry
        }
    }

    # Get items to delete
    $ItemsToDelete = Get-ChildItem -Path $SearchBase -Recurse -Include $Filter |
        Where-Object { $_.LastWriteTime -lt $CutoffTimestamp }
    If ($ItemsToDelete.Count) {
        $Count = $ItemsToDelete.Count
    } ElseIf ($ItemsToDelete) {
        $Count = 1
    } Else {
        $Count = 'no'
    }

    # Sanity checking

    # Do it
    Write-Log $ScriptRunTime
    Write-Log " Path: ${SearchBase}"
    Write-Log " Pattern: `"${Filter}`""
    Write-Log " Found ${Count} items older than ${DaysToKeep} days"
    If ($ItemsToDelete) {
        ForEach ($Item in $ItemsToDelete) {
            Try {
                $Item | Remove-Item
                Write-Log " - Deleted $($Item.Name)"
            }
            Catch {
                Write-Log " - Unable to delete $($Item.Name): $($_.Error.Message)"
            }
        }
    }
    Write-Log "`n"
}