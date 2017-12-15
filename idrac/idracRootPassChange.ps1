<#
.SYNOPSIS
    changes the idrac's root password
.DESCRIPTION
    opens up a csv file. put the ip addresses of idrac, old password and new password
    in their respective columns.
.NOTES
    File Name      : idracRootPassChange.ps1
    Author         : gajendra d ambi
    Date           : Dec 2017
    Prerequisite   : PowerShell v4+, Dell OpenManage DRAC Tools, includes Racadm (64bit) v8.1 or higher
    Copyright      - None
.LINK
    Script posted over: github.com/MrAmbiG
#>

#Start of Script

Write-Host "
A CSV file will be opened (open in excel/spreadsheet)
populate the values,
save & close the file,
Hit Enter to proceed
" -ForegroundColor Blue -BackgroundColor White

$csv = "$PSScriptRoot/idracRootPassChange.csv"
get-process | Select-Object idrac_ip_address, currentPassword, NewPassword| Export-Csv -Path $csv -Encoding ASCII -NoTypeInformation
Start-Process $csv
Read-Host "Hit Enter/Return to proceed"
Write-Host "processing your entries from the csv file...."
$csv = Import-Csv $csv
foreach ($line in $csv) 
 {
    $idrac_ip_address = $($line.idrac_ip_address)
    $currentPassword = $($line.currentPassword)
    $NewPassword = $($line.NewPassword)
    racadm -r $idrac_ip_address -u "root" -p $currentPassword --nocertwarn set iDRAC.Users.2.Password $NewPassword
 }
