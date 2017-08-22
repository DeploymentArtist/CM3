param(
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)] 
        [String] 
        $OUPath, 
        [Parameter(Mandatory=$true,ValueFromPipeline=$false)] 
        [String] 
        $NewUPNSuffix
)

# //***************************************************************************
# // ***** Script Header *****
# //
# // Solution:  
# // File:      ChangePrincipalName.ps1
# // Author:	Jakob Gottlieb Svendsen, Coretech A/S. http://blog.coretech.dk
# // Purpose:   Change Principal Name of users in specific OU + Sub OUs
# //			
# //
# // Usage:     .\ChangePrincipalName.ps1 -OUPath "OU=Users,OU=HRDemo,OU=Cloud,DC=cloud,DC=local" -NewUPNSuffix test.test
# //
# // Above examples will change all users UPN to username@test.test in OU OU=Users,OU=HRDemo,OU=Cloud,DC=cloud,DC=local and Sub OUs
# //
# // CORETECH A/S History:
# // 1.0.0     JGS 03/09/2014  Created initial version.
# //
# // Customer History:
# //
# // ***** End Header *****
# //***************************************************************************
#//----------------------------------------------------------------------------
#//  Main routines
#//----------------------------------------------------------------------------

import-module ActiveDirectory
$users = Get-ADUser -SearchBase $OUPath -Filter * 

foreach($user in $users)
{

    $newUPN = 
    $user | Set-ADUser  -UserPrincipalName "$($user.UserPrincipalName.Substring(0,$user.UserPrincipalName.IndexOf('@')+1))$NewUPNSuffix"
}

#//----------------------------------------------------------------------------
#//  End Script
#//----------------------------------------------------------------------------