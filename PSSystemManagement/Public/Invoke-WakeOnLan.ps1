function Invoke-WakeOnLan {
    [CmdletBinding()]
    param (

       [Parameter(
           Mandatory=$true
       )]
       [string]$MACAddress,

       [Parameter()]
       [string]$BroadcastIP = "255.255.255.255",

       [Parameter()]
       [int]$Port = 9
    )
    
    begin {
    }
    
    process {
        $broadcastIp    = [System.Net.IPAddress]::Parse($BroadcastIP)
        $macAddress     = ($MACAddress -replace "[^[0-9A-F]").ToUpperInvariant()
        $target         = 0,2,4,6,8,10 | ForEach-Object { [convert]::ToByte($MACAddress.Substring($_, 2), 16) }
        $packet         = (,[byte]255 * 6) + ($target * 16)

        Write-Verbose -Message "MAC: $($macAddress)"
        Write-Verbose -Message "BROADCAST: $($broadcastIp):$Port"
        Write-Verbose -Message "PACKET:`n$($packet)"

        $udpClient = New-Object -TypeName System.Net.Sockets.UdpClient
        $udpClient.Connect($broadcastIp, $Port)
        $udpClient.Send($packet, $packet.Length) | Out-Null
    }
    
    end {
    }
}