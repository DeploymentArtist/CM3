$Users = Import-Csv "C:\Setup\Scripts\Users.csv" -Delimiter ";"
$Password = ConvertTo-SecureString -String "P@ssw0rd" -AsPlainText -Force
$OUPath = "OU=Users,OU=ViaMonstra,DC=corp,DC=viamonstra,DC=com"

foreach($item in $Users){
    New-ADUser -Name $Item.FullName -DisplayName $item.FullName -AccountPassword $Password -SamAccountName $Item.UserName `
    -UserPrincipalName "$($Item.UserName)@corp.viamonstra.com" -Path $OUPath -Enabled $True -PasswordNeverExpires $True -Verbose
} 
