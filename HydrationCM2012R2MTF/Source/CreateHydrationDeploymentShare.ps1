# Check for elevation
If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole(`
    [Security.Principal.WindowsBuiltInRole] "Administrator"))
{
    Write-Warning "Oupps, you need to run this script from an elevated PowerShell prompt!`nPlease start the PowerShell prompt as an Administrator and re-run the script."
	Write-Warning "Aborting script..."
    Break
}

# Check free space on C: - Minimum for the Hydration Kit is 45 GB
$NeededFreeSpace = "48318382080"
$disk = Get-wmiObject Win32_LogicalDisk -computername . | where-object {$_.DeviceID -eq "C:"} 

[float]$freespace = $disk.FreeSpace;
$freeSpaceGB = [Math]::Round($freespace / 1073741824);

if($disk.FreeSpace -lt $NeededFreeSpace)
{
Write-Warning "Oupps, you need at least 45 GB of free disk space"
Write-Warning "Available free space on C: is $freeSpaceGB GB"
Write-Warning "Aborting script..."
Break
}

# Validation OK, create Hydration Deployment Share
$MDTServer = (get-wmiobject win32_computersystem).Name

Add-PSSnapIn Microsoft.BDD.PSSnapIn -ErrorAction SilentlyContinue 
md C:\HydrationCM2012R2MTF\DS
new-PSDrive -Name "DS001" -PSProvider "MDTProvider" -Root "C:\HydrationCM2012R2MTF\DS" -Description "Hydration CM2012 R2" -NetworkPath "\\$MDTServer\HydrationCM2012R2MTF$" -Verbose | add-MDTPersistentDrive -Verbose

md C:\HydrationCM2012R2MTF\ISO\Content\Deploy
new-item -path "DS001:\Media" -enable "True" -Name "MEDIA001" -Comments "" -Root "C:\HydrationCM2012R2MTF\ISO" -SelectionProfile "Everything" -SupportX86 "False" -SupportX64 "True" -GenerateISO "True" -ISOName "HydrationCM2012R2MTF.iso" -Verbose
new-PSDrive -Name "MEDIA001" -PSProvider "MDTProvider" -Root "C:\HydrationCM2012R2MTF\ISO\Content\Deploy" -Description "Hydration CM2012 R2 Media" -Force -Verbose

# Copy sample files to Hydration Deployment Share
Copy-Item -Path "C:\HydrationCM2012R2MTF\Source\Hydration\Applications" -Destination "C:\HydrationCM2012R2MTF\DS" -Recurse -Verbose -Force
Copy-Item -Path "C:\HydrationCM2012R2MTF\Source\Hydration\Control" -Destination "C:\HydrationCM2012R2MTF\DS" -Recurse -Verbose -Force
Copy-Item -Path "C:\HydrationCM2012R2MTF\Source\Hydration\Operating Systems" -Destination "C:\HydrationCM2012R2MTF\DS" -Recurse -Verbose -Force
Copy-Item -Path "C:\HydrationCM2012R2MTF\Source\Hydration\Scripts" -Destination "C:\HydrationCM2012R2MTF\DS" -Recurse -Verbose -Force
Copy-Item -Path "C:\HydrationCM2012R2MTF\Source\Media\Control" -Destination "C:\HydrationCM2012R2MTF\ISO\Content\Deploy" -Recurse -Verbose -Force
