#Fonction pour Windows Server, ne marche pas sur les Windows clients
Function Add-DNSEntryA{
    param([String]$ZoneName="microsoft.com",
    [String]$EntryName="$env:computername",
    [String]$IPAddress="test")

    try{
        Import-Module DNSServer;
        if($IPAddress -eq "test"){
            $Networks = (Get-WmiObject Win32_NetworkAdapterConfiguration -ComputerName $env:computername -EA Stop | ? {$_.IPEnabled}).IPAddress
            $Networks | ForEach-Object {
                if($_ -match "^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$")
                {
                    $IPAddress = $_;
                    return;
                }
            }
        }
        if($IPAddress){
            Write-Host "IP Address supplied or found, adding DNS Record"
            $dns = Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $EntryName
            if($dns){
                Remove-DnsServerResourceRecord -ZoneName $ZoneName -RRType "A" -Name $EntryName
            }
            Add-DnsServerResourceRecordA -Name $EntryName -ZoneName $ZoneName -IPv4Address $IPAddress
        }
        else{
            Write-Host "No IPV4 Address found on this computer, exiting...."
        }
    }
    catch{
        $ErrorMessage = $_.Exception.Message
        Write-Host $ErrorMessage
    }

}

#Fonction pour Windows Server, ne marche pas sur les Windows clients
Function Add-DNSEntryCName{
    param([String]$ZoneName="microsoft.com",
    [String]$EntryName="$env:computername",
    [String]$HostNameAlias ="alias.$env:computername")
    try{
        Import-Module DNSServer;
        $dns = Get-DnsServerResourceRecord -ZoneName $ZoneName -Name $EntryName
        if($dns){
            Remove-DnsServerResourceRecord -ZoneName $ZoneName -RRType "CName" -Name $EntryName
        }
        Add-DnsServerResourceRecordA -Name $EntryName -ZoneName $ZoneName -HostNameAlias $HostNameAlias
    }
    catch{
        $ErrorMessage = $_.Exception.Message
        Write-Host $ErrorMessage
    }

}