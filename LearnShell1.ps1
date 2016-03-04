Break 

# List directory contents

Write-Host -ForegroundColor Cyan "List content with 'dir " 
    dir C:\Temp
Write-Host -ForegroundColor Cyan "List content with 'ls " 
    ls C:\Temp
Write-Host -ForegroundColor Cyan "List content with 'Get-ChildItem " 
    Get-ChildItem C:\Temp

# Get all aliases defined for <Get-ChildItem>
    Get-Alias -Definition Get-ChildItem

# Get all aliases for your local Windows Box
    Get-Alias

# Create new alias for <Select-String>
New-Alias -Name grep -Value Select-String

# Proof that the newly created alias exists
    Get-Alias -Definition Select-String

# Use your new alias
    cat 'somefile' | grep 'sometext'

# Show all commands on your local Windows Box
    Get-Command

# Show all commands on your local Windows Box
    Get-Comand | Out-GridView
