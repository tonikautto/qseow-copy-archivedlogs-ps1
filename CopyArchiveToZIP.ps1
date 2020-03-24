#Requires -RunAsAdministrator

# MIT License
# 
# Copyright (c) 2020 Toni Kautto
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE`
# SOFTWARE.

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