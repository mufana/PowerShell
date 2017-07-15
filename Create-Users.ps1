#Requires -Version 3
  
<#
=================================================================
Filename      :  Create-Users.ps1
Version       :  0.1
Created by    :  Mufana
Created on    :  13-06-2017

Last Modified : 

OS            :  Windows Server 2012 R2
PSversion     :  5.1

Organization  :  AR
                 CopyRight (C) 2017, All Rights Reserved
================================================================
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
$Users = Import-Csv -Path "C:\Scripts\Users.csv"            
Import-Module activedirectory
#===============================================================


#============================Script=============================       
Foreach ($User in $Users) {
    $cn = $user.cn
    $fn = $User.firstname
    $ln = $user.lastname
    $dis = $cn
    $mail = $user.maildomain
    $UPN = $fn + "." + $ln + "@" + $mail  
    $sam = $User.sam
    $ou = $user.ou
    $pwd = $user.password
    $Desc =  $User.description

    New-ADUser -name "$cn" `
        -DisplayName "$Dis" `
        -SamAccountName "$sam" `
        -UserPrincipalName $UPN `
        -GivenName "$fn" `
        -Surname "$ln" `
        -Description "$Desc" `
        -Enabled $true `
        -Path "$OU" `
        -AccountPassword (ConvertTo-SecureString $pwd -AsPlainText -Force) `
        -ChangePasswordAtLogon $false `
        –PasswordNeverExpires $true `
        -server contoso.com `
    }
#===============================================================      
