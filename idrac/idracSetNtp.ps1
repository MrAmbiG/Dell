<#
.SYNOPSIS
    set the ntp for dell iDRAC servers
.DESCRIPTION
    opens up a csv file. put the ip addresses of idrac, root password and ntp
.NOTES
    File Name      : idracSetNtp.ps1
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

$csv = "$PSScriptRoot/idracSetNtp.csv"
get-process | Select-Object idrac_ip_address, root_password, ntp1, ntp2 | Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv
Read-Host "Hit Enter/Return to proceed"
Write-Host "processing your entries from the csv file...."
$csv = Import-Csv $csv
foreach ($line in $csv) 
 {
    $idrac_ip_address = $($line.idrac_ip_address)
    $root_password = $($line.root_password)
    $ntp1 = $($line.ntp1)
    $ntp2 = $($line.ntp2)
    $user = 'root'

    Write-Host setting $ntp1 as the ntp 
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn set iDRAC.NTPConfigGroup.NTP1 $ntp1

    if ($ntp2.Length -gt 2) {
    Write-Host settings $ntp2 as the ntp 
    racadm -r $idrac_ip_address -u $user -p $root_password --nocertwarn set iDRAC.NTPConfigGroup.NTP1 $ntp2
    }
 }