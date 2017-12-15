

$server = ''
$user = ''
$pass = ''
$dns1 = ''
$dns2 = ""
$ntp1 = ''
$snmpAddr = '' # snmp address

# setting dhcp to 0 and dns1
if ($dns1.Length -gt 2) {
Write-Host Disabling dhcp dns on $server -ForegroundColor Yellow
racadm -r $server -u $user -p $pass config -g cfgLanNetworking -o cfgDNSDomainNameFromDHCP 0
Write-Host setting dns server1 $dns1 -ForegroundColor Green
racadm -r $server -u $user -p $pass config -g cfgLanNetworking -o cfgDNSServer1 $dns1 
}

# setting dns2
if ($dns2.Length -gt 2) {
Write-Host setting dns server1 $dns2 -ForegroundColor Green
racadm -r $server -u $user -p $pass config -g cfgLanNetworking -o cfgDNSServer2 $dns2
}

# configure ntp server 1
if ($ntp1.Length -gt 2) {
Write-Host settings $ntp1 as the ntp server1
racadm -r $server -u $user -p $pass set iDRAC.NTPConfigGroup.NTP1 $ntp1
}

# enable snmp
write-host enabling snmp agent -ForegroundColor Green
racadm -r $server -u $user -p $pass set iDRAC.SNMP.AgentEnable 0
write-host setting snmp TrapFormat -ForegroundColor Green
racadm -r $server -u $user -p $pass set iDRAC.SNMP.TrapFormat 1
write-host setting snmp target $snmpAddr
racadm -r $server -u $user -p $pass set iDRAC.SNMP.Alert.DestAddr $snmpAddr
write-host enabling snmp alert -ForegroundColor Green
racadm -r $server -u $user -p $pass set iDRAC.SNMP.Alert.Enable 1
