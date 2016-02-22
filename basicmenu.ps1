# Create the menu
$menu = $(
    "`n"
    "==================================`n"
    "Example Menu"
    "`n"
    "[1] - Option 1`n"
    "[2] - Option 2`n"
    "[3] - Option 3`n"
    "[4] - Option 4`n"
    "[5] - Option 5`n"
    "[6] - Option 6`n"
    "[X] - Exit`n"
    "`n"
    "==================================`n"
    "`n"
    "Enter Menu Option Number:"
    )

# Loop through the menu

Do {
    Write-Host -fore cyan "$menu"
    $Option = Read-Host
    $Input = @("1","2","3","4","5","6","X") -contains $Option 
    If (-Not $Input) {Write-Host -fore red "Option not valid"}
    }

    Until ($Input) Switch ($Option) { 
        "1" {write-host "Option 1"}
        "2" {write-host "Option 2"}
        "3" {write-host "Option 3"}
        "4" {write-host "Option 4"}
        "5" {write-host "Option 5"}
        "6" {write-host "Option 6"}
        "X" {exit}
        } 
