class Slack{

    GetConfiguration()
    {
        [String]$registryPath = "HKCU:\Software\PowerSlack"
        If(Test-Path -Path $registryPath){
            Get-Item $registryPath | Out-Host
        }
    }

    AddConfiguration($Uri)
    {
        [String]$registryPath = "HKCU:\Software\PowerSlack"
        if(-not (Test-Path -Path $registryPath)){
            New-Item -Path $registryPath
        }
        $value = 'SlackUri'
        if((Get-Item $registryPath).GetValue($value)){
        }else{
            New-ItemProperty $registryPath -Name $value -Value $Uri -Force | Out-Host
        }
    }

    RemoveConfiguration()
    {
        [String]$registryPath = "HKCU:\Software\PowerSlack"
        If(Test-Path -Path $registryPath){
            Remove-Item -Path $registryPath -Force
        }
    }

    SendMessage($Message)
    {
        [String]$registryPath = "HKCU:\Software\PowerSlack"
        $Uri = (Get-ItemProperty -Path $registryPath).SlackUri
        $payload = @{
               text = "$Message"
        } | ConvertTo-Json
        try{
            Invoke-RestMethod -Method Post -Uri $Uri -Body $payload
        }catch{
            if($_.Exception.Message -eq "The remote server returned an error: (400) Bad Request."){
                $errorResponse = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($errorResponse)
                $responseBody = $reader.ReadToEnd();
                throw "Could not send message. Make sure you have specified the correct webhook URI, errorcode: 0x$('{0:X8}' -f $_.Exception.HResult), message: $responseBody"
            }elseif($_.Exception.Message -eq "The remote server returned an error: (404) Not found."){
                $errorResponse = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($errorResponse)
                $responseBody = $reader.ReadToEnd();
                throw "Could not send message. Make sure you have specified the correct webhook URI, errorcode: 0x$('{0:X8}' -f $_.Exception.HResult), message: $responseBody"
            }
        }

    }
}
