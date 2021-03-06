[CmdLetBinding()]
Param(
     [Parameter(Mandatory=$False,HelpMessage="Please enter computer Name")]
     [String]$ComputerName = "$env:Computername",
     [Parameter(Mandatory=$True,HelpMessage="Please enter start time")]
     [Int]$StartTime,
     [Parameter(Mandatory=$True,HelpMessage="Please enter end time")]
     [Int]$EndTime,
     [Parameter(Mandatory=$True,HelpMessage="Please enter working days number")]
     [String]$WorkingDays
     )

Try{
    $Return = Invoke-WmiMethod  -Namespace "Root\ccm\ClientSDK" -Class CCM_ClientUXSettings  -Name SetBusinessHours -ArgumentList @($EndTime,$StartTime,$WorkingDays) -ComputerName $ComputerName -ErrorAction STOP
    
    If($Return.ReturnValue -eq 0){
        Write-Host " - Successfully configured Business Hours" -ForegroundColor GREEN
    }
}
Catch{
    Write-Host "Error: $($_.Exception.Message)"
}    