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

param (
    [Parameter(Mandatory=$true)]
    [string] $ArchivedLogsPath, 
    [int] $Days = 7
)

# output files to same folder as PS1 file
$OutputFolder = "$([System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition))\"

# Get time of script execution in format YYYYMMDDThhmmss+ZZZZ
# For example 20190717T121751+1000 for 17 July 2019 12:17:51 PM in GTM+10
$ExecutionTimeStamp = Get-Date -Format o | ForEach-Object {$_ -replace "[-:]|(\.[0-9]{7})"}

# Copy archive logs that are $Days old 
$TmpRoboFolder = "$OutputFolder`Tmp_$ExecutionTimeStamp\"
robocopy "$ArchivedLogsPath" "$TmpRoboFolder" *.* /s /maxage:$Days /fp

# Compress copied files into ZIP archive
$ZipFile = "$OutputFolder`ArchivedLogs_$ExecutionTimeStamp.zip"
Compress-Archive -Path "$TmpRoboFolder" -DestinationPath "$ZipFile" 

# Remove temp folder
Remove-Item -Recurse -Force "$TmpRoboFolder"