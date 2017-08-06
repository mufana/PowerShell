
    $params = @{}
        $params.InterfaceAlias = 'Ethernet', 'Wi-Fi' 
	    $ActiveAdapter = (Get-NetIPInterface @params | Where-Object { ($_.ConnectionState -eq 'Connected') -and ($_.AddressFamily -eq 'ipv4') }).InterfaceAlias

    $CurrentIP = (Get-NetIPAddress -InterfaceAlias $ActiveAdapter | Where-Object {$_.AddressFamily -eq 'ipv4'}).IPAddress | clip

