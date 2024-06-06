# Script for periodic cleanup of files

param(
    [Parameter(Mandatory)]
    # Target directory to clean up
    [string] $targetPath,
    [Parameter(Mandatory)]
    # Minimum file age in days for deletion
    [double] $daysAge,
    [Parameter(Mandatory)]
    # log file
    [string] $logFile,
    # recurse ?
    [switch] $recurse = $false,
    # force deletion (to handle hidden/system files)
    [switch] $force = $false,
    # output width
    [double] $width = 512,
    # dry run for remove-item
    [switch] $dryrun = $false,
    [string] $match = "*"
)
 

$getChildItemArgs = @{
    Path = "$targetPath"
    File = $true
    Recurse = $recurse
}
 

$removeItemArgs = @{
    Force = $force
    Verbose = $true
    WhatIf = $dryrun
}
 

$outFileArgs = @{
    FilePath = "$logFile"
    Width = $width
}
 

$dateThreshold = (Get-Date).AddDays(-1*$daysAge)
 

Get-ChildItem @getChildItemArgs | Where-Object { $_.FullName -like "$match" -and $_.LastWriteTime -lt $dateThreshold } | Remove-Item @removeItemArgs 4>&1 | Out-File @outFileArgs
