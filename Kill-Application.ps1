#Requires -Version 3.0

<#
=================================================================
Filename      :  Kill-Application.ps1
Version       :  0.2
Created by    :  Mufana
Created on    :  16-01-2017

Last Modified : 

OS            :  Microsoft Windows Server 2012 R2
PSversion     :  3.0
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
Version    :: 0.2 - Update
ChangedBy  :: Mufana
ChangeLog  :: Added multiple GUI / Verification windows + Added logging.
              Solved bug that script didn't exit if no environment was selected. 
              Added function <Show-msgbox> to display information to the user.
              Added function <Write-Console> to write specific info to the console.   
ChangeDate :: 17-01-2017
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


# Sideload additional modules to generate the GUI.
# _______________________________________________________________________________ 
#[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
#[void] [System.Reflection.Assembly]::LoadWithPartialName("System.Drawing") 

# Set Vars
# _______________________________________________________________________________ 
$TestAppExe = "Notepad.exe"
$ProdAppExe = "Notepad.exe"

# Create the table that contains all the data
# _______________________________________________________________________________ 
$App = New-Object System.Data.DataTable
$App.Columns.Add((New-Object System.Data.DataColumn ‘Name’, ([string])))
$App.Columns.Add((New-Object System.Data.DataColumn ‘SQLServer’, ([string])))
$App.Columns.Add((New-Object System.Data.DataColumn ‘SQLInstance’, ([string])))
$App.Columns.Add((New-Object System.Data.DataColumn ‘Database’, ([string])))
$App.Columns.Add((New-Object System.Data.DataColumn ‘Executable’, ([string])))
$App.Rows.Add("Test","Lab1","Lab1","TestDB","$TestAppExe")
$App.Rows.Add("Production","Lab1","Lab1","ProductionDB","$ProdAppExe")

# Function Get-Environment
# _______________________________________________________________________________ 
Function Get-Environment
{
$objForm = New-Object System.Windows.Forms.Form 
$objForm.Text = "Select environment"
$objForm.Size = New-Object System.Drawing.Size(300,250) 
$objForm.StartPosition = "CenterScreen"

$objForm.KeyPreview = $True
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Enter") 
    {$global:objChoice=$objListBox.SelectedItem;$objForm.Close()}})
$objForm.Add_KeyDown({if ($_.KeyCode -eq "Escape") 
    {$objForm.Close()}})

$OKButton = New-Object System.Windows.Forms.Button
$OKButton.Location = New-Object System.Drawing.Size(75,130)
$OKButton.Size = New-Object System.Drawing.Size(75,23)
$OKButton.Text = "OK"
$OKButton.Add_Click({$global:objChoice=$objListBox.SelectedItem;$objForm.Close()})
$objForm.Controls.Add($OKButton)

$CancelButton = New-Object System.Windows.Forms.Button
$CancelButton.Location = New-Object System.Drawing.Size(150,130)
$CancelButton.Size = New-Object System.Drawing.Size(75,23)
$CancelButton.Text = "Cancel"
$CancelButton.Add_Click({$objForm.Close()})
$objForm.Controls.Add($CancelButton)

$objLabel = New-Object System.Windows.Forms.Label
$objLabel.Location = New-Object System.Drawing.Size(10,20) 
$objLabel.Size = New-Object System.Drawing.Size(280,20) 
$objLabel.Text = "Select environment: "
$objForm.Controls.Add($objLabel) 

$objListBox = New-Object System.Windows.Forms.ListBox 
$objListBox.Location = New-Object System.Drawing.Size(10,40) 
$objListBox.Size = New-Object System.Drawing.Size(260,20) 
$objListBox.Height = 90

$App | foreach-object{
[void] $objListBox.Items.Add($_.Name)
}

$objForm.Controls.Add($objListBox) 

$objForm.Topmost = $True

$objForm.Add_Shown({$objForm.Activate()})
[void] $objForm.ShowDialog()
Return $objChoice
}
# _______________________________________________________________________________ 


# Function Messagebox
# _______________________________________________________________________________ 
Function Show-MsgBox
 
    ($Text,$Title="",[Windows.Forms.MessageBoxButtons]$Button = "OK",[Windows.Forms.MessageBoxIcon]$Icon="Information"){
    [Windows.Forms.MessageBox]::Show("$Text", "$Title", [Windows.Forms.MessageBoxButtons]::$Button, $Icon) | ?{(!($_ -eq "OK"))}
}
# _______________________________________________________________________________ 



# Function Write-Console
# _______________________________________________________________________________ 
Function Write-Console {

    Param (
        [String]$String
        )

        $Time = Get-Date -Format T
        $Write = $time + " " + $String
        Write-Host -fore green $Write

    }
# _______________________________________________________________________________ 



# General Script Body
# _______________________________________________________________________________
Write-Console "Kill Appliction Executable"
Write-Console "Started on: $env:COMPUTERNAME"
Write-Console "By: $env:USERNAME"
 
$Environment = Get-Environment
Write-Console "Chosen environment: $Environment"
If((Show-MsgBox -Title "Chosen environmentis: $Environment" -Text "The Chosen environment is: <$Environment> Continue!?" -Button YesNo -Icon information) -eq 'No'){Exit}

else{
    $chosen = $App |select-object * | Where-Object{$_.Name -eq $Environment}
   }

# Set the local vars
$SQLServer = $chosen.SQLServer
$SQLInstance = $chosen.SQLInstance
$SQLDatabase = $chosen.Database
$ApplicionExe = $chosen.Executable
$Outfile = "C:\Scripts\ActiveComputers.txt"

# Create the new PowerShell session and pass the local vars to the remote sessions with $Using    
$Session = New-PSSession -ComputerName $SQLServer
$Connections = Invoke-Command -Session $Session -ScriptBlock { Invoke-SQLcmd -query "exec sp_who" -Serverinstance `
 $Using:SQLInstance -Database $Using:SQLDatabase }
Remove-PSSession $Session
# Sort active connections based on machinename
$Temp = $Connections |Where-object {$_.hostname -like "*Lab*"}
$ActiveHosts = $temp.hostname | sort-object -Unique

# Kill the Application process on each host
$Activehosts | Out-File $Outfile
Write-Console "To see on which hosts the application is will be closed, check: $Outfile"
If((Show-MsgBox -Title "Application will be closed" -Text "On $($ActiveHosts.count) desktop(s) The application will be closed. Continue!?" -Button YesNo -Icon Warning) -eq 'No'){Exit}
Foreach ($Comp in $ActiveHosts) {
    taskkill /s $Comp /IM "Notepad.exe" 
    Write-Console "Application.exe closed op: $Comp"
    }
If((Show-MsgBox -Title "Application closed" -Text "Application is closed on: $($ActiveHosts.count) desktop(s)." -Icon Information)){Exit}
