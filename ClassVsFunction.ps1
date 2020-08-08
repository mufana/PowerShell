class SlackMessage 
{
    hidden [string]$_webHookUri

    SlackMessage([string]$webHookUri)
    {
        $this._webHookUri = $webHookUri
    }

    [string]Send([string]$message)
    {
        $jsonPayload = $this.ConvertMessageToJson($message)
        $result = $this.InvokeWebRequest($jsonPayload)
        return $result
    }

    hidden [string]ConvertMessageToJson($message)
    {
        $payload = @{
            text = $message
        }

        $jsonPayload = $payload | ConvertTo-Json
        return $jsonPayload
    }

    hidden [string]InvokeWebRequest([string]$jsonPayLoad)
    {
        $results = Invoke-RestMethod -Uri $this._webHookUri -Method POST -Body $jsonPayLoad
        return $results
    }
}

function SendSlackMessage {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]
        $webHookUri,

        [Parameter(Mandatory)]
        [string]
        $Message
    )

    $payload = @{
        text = $message
    } | ConvertTo-Json
    
    Invoke-RestMethod -Uri $webHookUri -Method POST -Body $payload
}
