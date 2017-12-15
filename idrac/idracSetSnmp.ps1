<#
.SYNOPSIS
    set the snmp for dell iDRAC servers
.DESCRIPTION
    opens up a csv file. put the ip addresses of idrac, root password, snmp address
.NOTES
    File Name      : idracSetSnmp.ps1
    Author         : gajendra d ambi
    Date           : Dec 2017
    Prerequisite   : PowerShell v4+, Dell OpenManage DRAC Tools, includes Racadm (64bit) v8.1 or higher
    Copyright      - None
.LINK
    Script posted over: github.com/MrAmbiG/
#>
#Start of Script
Write-Host "
A CSV file will be opened (open in excel/spreadsheet)
populate the values,
save & close the file,
Hit Enter to proceed
" -ForegroundColor Blue -BackgroundColor White

$csv = "$PSScriptRoot/idracSetSnmp.csv"
get-process | Select-Object idrac_ip_address, root_password, snmpAddress, snmpString | Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv
Read-Host "Hit Enter/Return to proceed"
Write-Host "processing your entries from the csv file...."
$csv = Import-Csv $csv
foreach ($line in $csv)
{
    $idrac_ip_address = $($line.idrac_ip_address)
    $root_password = $($line.root_password)
    $snmpAddress = $($line.snmpAddress)
    $snmpString = $($line.snmpString)
    $user = 'root'
    # enable snmp
    write-host enabling snmp agent -ForegroundColor Green
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn set iDRAC.SNMP.AgentEnable 0
    write-host setting snmp TrapFormat v2 -ForegroundColor Green
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn set iDRAC.SNMP.TrapFormat 1
    write-host setting snmp target $snmpAddress
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn set iDRAC.SNMP.Alert.DestAddr $snmpAddress
    write-host setting snmp community string $snmpString
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn set iDRAC.SNMP.AgentCommunity $snmpString
    write-host enabling snmp alert -ForegroundColor Green
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn set iDRAC.SNMP.Alert.Enable 1
}

