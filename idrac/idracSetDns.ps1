<#
.SYNOPSIS
    set DNS on dell iDRAC servers
.DESCRIPTION
    opens up a csv file. put the ip addresses of idrac, root username, password, dns1, dns2
.NOTES
    File Name      : idracSetDns.ps1
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

$csv = "$PSScriptRoot/idracSetDns.csv"
get-process | Select-Object idrac_ip_address, root_password, dns1, dns2| Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv
Read-Host "Hit Enter/Return to proceed"
Write-Host "processing your entries from the csv file...."
$csv = Import-Csv $csv
foreach ($line in $csv) 
 {
    $idrac_ip_address = $($line.idrac_ip_address)
    $root_password = $($line.root_password)
    $dns1 = $($line.dns1)
    $dns2 = $($line.dns2)
    $user = 'root'

    Write-Host "setting on $idrac_ip_address"
    # setting dhcp to 0 and dns1
    if ($dns1.Length -gt 2) {
    Write-Host Disabling dhcp dns on $server -ForegroundColor Yellow
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn config -g cfgLanNetworking -o cfgDNSDomainNameFromDHCP 0
    Write-Host setting dns server1 $dns1 -ForegroundColor Green
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn config -g cfgLanNetworking -o cfgDNSServer1 $dns1
    }

    # setting dns2
    if ($dns2.Length -gt 2) {
    Write-Host setting dns server1 $dns2 -ForegroundColor Green
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn config -g cfgLanNetworking -o cfgDNSServer2 $dns2
    }
 }