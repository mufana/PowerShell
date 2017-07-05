#Requires -Version 3
  
<#
=================================================================
Filename      :  Create-Homefolder.ps1
Version       :  0.1
Created by    :  Mufana
Created on    :  13-06-2017

Last Modified : 

OS            :  Windows Server 2012 R2
PSversion     :  5.1

Organization  :  AR
                 CopyRight (C) 2017, All Rights Reserved
================================================================
****************************************************************
*  USE AT YOUR OWN RISK. DON'T USE IF YOU DO NOT UNDERSTAND    * 
*          WHAT THIS SCRIPT DOES OR HOW IT WORKS,              *
****************************************************************
#>

<#
===============================TODO=============================


===============================TODO=============================
#>

<#
============================ChangeLog===========================
Author     :: Mufana
#_______________________________________________________________
Version    :: 0.1 - Initial release
#_______________________________________________________________
Version    ::
ChangedBy  :: 
ChangeLog  :: 
ChangeDate ::
#_______________________________________________________________
Version    ::
ChangedBy  :: 
ChangeLog  :: 
ChangeDate ::
#_______________________________________________________________
Version    ::
ChangedBy  :: 
ChangeLog  :: 
ChangeDate ::
============================ChangeLog===========================
#>

#==========================General Vars=========================
# Location of Homefolders on DFS\Home
$Homefolders = "C:\Temp\DFS\Home"

# Newly created users in the Active Directory
$Folders = Import-Csv -Path "C:\_Data\_Scripts\PowerShell Scripts\JBScripts\Create-Users\users.csv"

# Get current date and conver tot dd-MM-yy notation
$Day = (Get-Date).ToString("dd-MM-yy")

# Set logpath and logfile location
$Logpath = "C:\Temp\DFS\"
$Logfile = $Logpath + "New-Homedirs" + $Day + ".log"
#===============================================================


#===========================Functions===========================
# Function that enables logging

If(-not($Logpath | Test-Path)){New-Item $Logpath -type directory}
New-Item $Logfile -type file -force -value "Creation of homedirs for new users..." 
Add-Content $Logfile -Value ""
Function Write-Log {

    Param (
        [Parameter(ValueFromPipeLine=$True)]
        [string]$Logstring)

    $time = get-date -Format T
    $logstring  = $time +" "+ $Logstring

    Add-Content $Logfile -Value $Logstring
}
#===============================================================


#============================Script=============================
# Create Homefolder foreach newly created user

    Foreach ($Folder in $Folders) {
    $HomeDir = $Folder.cn

        # Check if the homedir that will be created already exist on the DFS share.
        $Check = Test-Path -path $Homefolders\$HomeDir
    
        If ($Check -eq $True) { 
            Write-Log "Userfolder: $Homedir already exist on the DFS Share." 
            Write-Host -ForegroundColor Red "$Homedir already exist on the DFS Share"
        }

        Else {         
            Write-Log "Userfolder: $Homedir is created on the DFS Share"
            New-Item -ItemType Directory -Path $Homefolders\$HomeDir
            Write-Host -ForegroundColor Green "$Homedir created"
        }
    }
#===============================================================