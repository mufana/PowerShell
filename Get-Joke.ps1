function Get-Joke{
    [CmdletBinding()]
    param()
          
    $headers = @{
        accept = "application/json"
    }
    
    $returnValue = [PSCustomObject]@{
        Data = $null
        Error = @{
            Code = $null
            Message = $null
        }
    }

    try {
        $returnValue.Data = Invoke-RestMethod -Method Get -Uri https://icanhazdadjoke.com/ -Headers $headers
    } catch {
        $ex = $PSItem
        $returnValue.Error.Message = $ex.Exception.Message
        $returnValue.Error.Code = "0x$('{0:X8}' -f $ex.Exception.HResult)"
        Write-Error $returnValue.Error.Message
    }

    Write-Output $returnValue.Data.Joke
}
