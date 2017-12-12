<#
.SYNOPSIS
    set the hostname for dell iDRAC servers
.DESCRIPTION
    opens up a csv file. put the ip addresses of idrac, root password and the domain name to be set
.NOTES
    File Name      : idracSetDomain.ps1
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

$csv = "$PSScriptRoot/idracRootPassChange.csv"
get-process | Select-Object idrac_ip_address, root_password, DomainName| Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv
Read-Host "Hit Enter/Return to proceed"
Write-Host "processing your entries from the csv file...."
$csv = Import-Csv $csv
foreach ($line in $csv) 
 {
    $idrac_ip_address = $($line.idrac_ip_address)
    $root_password = $($line.root_password)
    $DomainName = $($line.DomainName)
    Write-Host "setting $DomainName as DomainName on $idrac_ip_address"
    racadm -r $idrac_ip_address -u "root" -p $root_password set iDRAC.NIC.DNSDomainName $DomainName
 }
