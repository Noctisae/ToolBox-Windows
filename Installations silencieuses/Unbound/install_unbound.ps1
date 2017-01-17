param([String]$directory_to_scan="E:\Convert",
    [String]$extension_to_convert="avi",
    [String]$extension_to_convert_to="webm",
    [String]$quality="good",
    [Int32]$cpu_used=3,
    [String]$deadline="realtime",
    [Int32]$resolution=1080,
    [Int32]$threads=3)

try{
    Copy-Item ".\sources" -Destination "C:\Program Files\Unbound" -Recurse
    $process = start-process -FilePath "C:\Program Files\Unbound/unbound-service-install.exe" -PassThru -Wait

    #TODO

    #DO registry changes made by installer
    #HKLM\Sofware\Unbound\InstallLocation
    #HKLM\Sofware\Unbound\ConfigFile  == service.conf
    #HKLM\Sofware\Unbound\CronAction
    #HKLM\Sofware\Unbound\CronTime == 24h 

    #Do registry changes for uninstalling
    #HKLM\Software\Microsoft\Windows\CurrentVersion\Uninstall\Unbound


    #On change les serveurs DNS de la carte possédant une adresse IP valide
    Import-Module DnsClient
    $interfaces = Get-DnsClientServerAddress
    $index_card = 0;
    $interfaces | Foreach-Object{
        if($_.AddressFamily -eq 2){
            if(($_.ServerAddresses -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$") -and ($_.ServerAddresses -neq "" ))
            {
                $index_card = $_.InterfaceIndex;
                return;
            }
        }
    }
    Set-DnsClientServerAddress -InterfaceIndex $index_card -ServerAddresses ("127.0.0.1","")
}
catch{
    $ErrorMessage = $_.Exception.Message
    Write-Host $ErrorMessage
}
