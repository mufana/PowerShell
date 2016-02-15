<#
=================================================================
 Filename      :  Get-IP.ps1
 Version       :  0.1
 Created by    :  Mufana
 Created on    :  15/2/2016

 Organization  :  Mufana Solutions
                  CopyRight (C) 2016, All Rights Reserved
================================================================
#>

Function IP-2Clip {

    $params = @{}
        $params.InterfaceAlias = 'Ethernet', 'Wi-Fi' 
	    $ActiveAdapter = (Get-NetIPInterface @params | Where-Object { ($_.ConnectionState -eq 'Connected') -and ($_.AddressFamily -eq 'ipv4') }).InterfaceAlias

    $CurrentIP = (Get-NetIPAddress -InterfaceAlias $ActiveAdapter | Where-Object {$_.AddressFamily -eq 'ipv4'}).IPAddress | clip
}
