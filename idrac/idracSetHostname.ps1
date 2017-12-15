<#
.SYNOPSIS
    set the hostname for dell iDRAC servers
.DESCRIPTION
    opens up a csv file. put the ip addresses of idrac, hostname to be set
.NOTES
    File Name      : idracSetHostname.ps1
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

$csv = "$PSScriptRoot/idracSetHostname.csv"
get-process | Select-Object idrac_ip_address, root_password, hostname | Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv
Read-Host "Hit Enter/Return to proceed"
Write-Host "processing your entries from the csv file...."
$csv = Import-Csv $csv
foreach ($line in $csv) 
 {
    $idrac_ip_address = $($line.idrac_ip_address)
    $root_password = $($line.root_password)
    $hostname = $($line.hostname)
    Write-Host "setting $hostname as hostname on $idrac_ip_address"
    racadm -r $idrac_ip_address -u "root" -p $root_password --nocertwarn set iDRAC.NIC.DNSDomainName $domain    
 }
