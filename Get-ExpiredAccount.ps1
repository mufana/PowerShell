Function Get-ExpiredAccount {
 
    [cmdletbinding()]
 
    Param (
        [Switch]$Contoso,
        [Switch]$CollectUsers,
        [Switch]$Cleanup
    )
#------------------------------------------------------------------------------------------------------#
    # Set the search date of the: collExpiredEmployees
    $Date = (Get-Date).AddDays("-90")
 #------------------------------------------------------------------------------------------------------#
# Switch organisation contoso
    If ($Contoso)
    {
        # Home/Profile location of the DFS share
        $HomeDir    = "C:\DFSRoots\Home"
 
        # Splat params for Get-ADUser
        $Params = @{
            LDAPFilter = "(&(objectCategory=person)(objectClass=user))"
            SearchBase = "ou=users,ou=corp,dc=contoso,dc=com"
            Server     =  "contoso.com"
            Properties = @("SamAccountName", "GivenName", "Surname", "userPrincipalName", "AccountExpirationDate", "AccountExpires", "lastLogon", "PasswordExpired", "Enabled", "CanonicalName") 
        }
    }
#------------------------------------------------------------------------------------------------------#
    # Define empty results array
    $Results = @()
 
    # Run the query on Active Directory and search for users whose accounts has expired for at least 3 months
    $collExpiredEmployees = (Get-AdUser @Params) | Where-Object {$_.AccountExpires -le "$($Date.ToFileTimeUtc())"} 
 #------------------------------------------------------------------------------------------------------#
    # Collect expired users
    If ($CollectUsers)
    {
        # Select the results (parameters) to export 
        $Select = @("EmployeeID", "FirstName", "LastName", "Active", "Account active until: (mm-dd-yyyy)", "Homedirectory")
 
        # Loop through users
        Foreach ($Employee in $collExpiredEmployees)
        {
            $UserID = $Employee.SamAccountName
 
            # Check if the employee has a homedirectory
            $CheckHomeDir = (Get-Item "$HomeDir\$UserID*")
             
            # Convert the UnixDate to UTC Time
            $Expires = ($Employee.AccountExpires)
            Foreach ($ExpirationDate in $Expires) {$ExpiredDate = (Get-Date $Expires -UFormat %x)}
 
            # Convert the UnixDate to UTC Time
            $LastLogon = ($Employee.lastLogon)
            Foreach ($Logon in $LastLogon) {$LastDate = (Get-Date $Logon -UFormat %x)}
        
            # Create the property block
            $Props = @{
                EmployeeID                            = $Employee.samAccountName
                FirstName                             = $Employee.GivenName
                LastName                              = $Employee.Surname
                Active                                = $Employee.Enabled
                "Account active until: (mm-dd-yyyy)"  = $ExpiredDate
                Homedirectory                         = $CheckHomeDir
            }
 
            # Create new psobject for each user
            $Results += New-Object psobject -Property $Props
        }  
    }
 
    # Display results on screen
    $Results | Select $Select
#------------------------------------------------------------------------------------------------------#
    # CleanUp the home/profile directories and disable expired accounts
    If ($Cleanup)
    {
        # Select the results (parameters) to export 
        $Select = @("EmployeeID", "FirstName", "LastName", "Active", "Account active until: (mm-dd-yyyy)", "Homedirectory","Location")

        # Set the tartget path for the move
        $Target = "ou=InActive,ou=corp,dc=contoso,dc=com"
 
        # Loop through users
        Foreach ($Employee in $collExpiredEmployees)
        {
            $UserID = $Employee.SamAccountName

            # Check if the employee has a homedirectory / profiledirectory
            $CheckHomeDir = (Get-Item "$HomeDir\$UserID*")
 
            # Delete the homedirectory
            If ($CheckHomeDir.Exists -eq $True)
            {

                # Remove directory structure
                robocopy C:\temp\Empty $CheckHomeDir /MIR

                # Remove directory
                Remove-Item $CheckHomeDir -WhatIf
                $Checkhomedir = "Deleted"
            }

            # Disable the useraccount
            Set-Aduser $UserID -Enabled $False

            # Move the Account to different OU
            Move-ADObject -Identity "CN=$UserID,ou=Users,ou=corp,dc=contoso,dc=com" -TargetPath $Target

            # Get-ADUser
            $Collect = Get-ADUser -Identity $UserID -server "contoso.com" -Properties *

            Foreach ($User in $Collect)
            {
 
                # Convert the UnixDate to UTC Time
                $Expires = ($User.AccountExpires)
                Foreach ($ExpirationDate in $Expires) {$ExpiredDate = (Get-Date $Expires -UFormat %x)}

                # Create a new property block
                $Props = @{
                    EmployeeID                           = $User.samAccountName
                    FirstName                            = $User.GivenName
                    LastName                             = $User.Surname
                    Active                               = $User.Enabled
                    "Account active until: (mm-dd-yyyy)" = $ExpiredDate
                    Homedirectory                        = $CheckHomeDir
                    Location                             = $User.DistinguishedName
                }
 
                $Results += New-Object psobject -Property $Props
            }
        }
 
            # Display results on screen
            $Results | Select $Select
    }
#------------------------------------------------------------------------------------------------------#
}