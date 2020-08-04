function Get-Joke{
    [CmdletBinding()]
    param()
          
    $headers = @{
        accept = "application/json"
    }
    
    $returnValue = Invoke-RestMethod -Method Get -Uri https://icanhazdadjoke.com -Headers $headers

    Write-Output $returnValue.Joke
}
