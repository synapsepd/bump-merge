@echo off
echo Installing GIT Bump-Merge....
cls

REM Ensure you are running this as an adminstrator :-)
REM Use Chocolatey to ensure current version of GIT and GIT-LFS are installed, as they are pre-reqs
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -InputFormat None -ExecutionPolicy Bypass -Command "iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))" && SET "PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin"

choco upgrade chocolatey -y -r
choco install git git-lfs -y -r
choco upgrade all -y -r

REM Actual Install
@"%SystemRoot%\System32\WindowsPowerShell\v1.0\powershell.exe" -NoProfile -ExecutionPolicy Bypass -Command "& '%~dpn0.ps1'"
