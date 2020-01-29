#Requires -RunAsAdministrator

# IMPORTANT, define the exact path to QSEoW ArchivedLogs folder 
$ArchivedLogsPath = "\\server\share\ArchivedLogs\"

# RoboCopy files from ArchivedLogs folder to temp folder
# Only copy files that are 7 days or younger

$OutputFolder = "$([System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition))\"
$ExecutionTimeStamp = Get-Date -Format o | ForEach-Object {$_ -replace "[-:]|(\.[0-9]{7})"}
$TmpRoboFolder = "$OutputFolder`Tmp_$ExecutionTimeStamp\"

robocopy "$ArchivedLogsPath" "$TmpRoboFolder" *.* /s /maxage:7 /fp

# Compress copied files to timestamped ZIP file
$ZipFile = "$OutputFolder`ArchivedLogs_$ExecutionTimeStamp.zip"
Compress-Archive -Path "$TmpRoboFolder" -DestinationPath "$ZipFile" 

# Remove temp folder
Remove-Item -Recurse -Force "$TmpRoboFolder"