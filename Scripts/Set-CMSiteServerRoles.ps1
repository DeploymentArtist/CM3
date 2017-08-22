<#
.Synopsis
   This script installs CM12 Site Server prereqs
.DESCRIPTION
.EXAMPLE
    Set-CMSiteServerRoles.ps1 -Computer Localhost -Source d:\Sources\sxs -SiteServer
     This will install all the required WS2012 roles/features for Site Server Role
.EXAMPLE
    Set-CMSiteServerRoles.ps1 -Computer APPCatalog -Source d:\Sources\sxs -ApplicationCatalog
    This will install all the required WS2012 roles/features for ApplicationCatalog Site Role
.EXAMPLE
    Set-CMSiteServerRoles.ps1 -Computer DPServer -Source d:\Sources\sxs -DistributionPoint
    This will install all the required WS2012 roles/features for DistributionPoint Site Role
.EXAMPLE
    Set-CMSiteServerRoles.ps1 -Computer MPServer -Source d:\Sources\sxs -ManagementPoint
    This will install all the required WS2012 roles/features for ManagementPoint Site Role
.EXAMPLE
    Set-CMSiteServerRoles.ps1 -Computer SUPServer -Source d:\Sources\sxs -SoftwareUpdatePoint
    This will install all the required WS2012 roles/features for SoftwareUpdatePoint Site Role
.NOTES
    Developed by Kaido Järvemets
    Version 1.0

#>
[CmdLetBinding()]
   Param(
   [Parameter(Mandatory=$True, HelpMessage = "Please enter Site Server Name")]
     $Computer,
   [Parameter(Mandatory=$True, HelpMessage = "Please enter Windows Server Installation source files location")]
     $Source,
     [Switch]$SiteServer,
     [Switch]$ApplicationCatalog,
     [Switch]$DistributionPoint,
     [Switch]$ManagementPoint,
     [Switch]$SoftwareUpdatePoint
     )

$SiteServerScriptBlock = {
    Param($Source)
    #Site Server
    Install-WindowsFeature -Name NET-Framework-Core -Source $Source
    Install-WindowsFeature -Name RDC
}

$ApplicationCatalogScriptBlock = {
    Param($Source)
    #Application Point
    Install-WindowsFeature -Name NET-HTTP-Activation
    Install-WindowsFeature -Name NET-Non-HTTP-Activ
    Install-WindowsFeature -Name Web-App-Dev
    Install-WindowsFeature -Name Web-Asp-Net
    Install-WindowsFeature -Name Web-Asp-Net45
    Install-WindowsFeature -Name Web-Metabase
    Install-WindowsFeature -Name Web-Default-Doc 
    Install-WindowsFeature -Name Web-Static-Content
    Install-WindowsFeature -Name Web-Windows-Auth
}

$DistributionPointScriptBlock = {
    Param($Source)
    #Distribution Point
    Install-WindowsFeature -Name Web-ISAPI-Ext
    Install-WindowsFeature -Name Web-Windows-Auth
    Install-WindowsFeature -Name Web-Metabase
    Install-WindowsFeature -Name Web-WMI
    Install-WindowsFeature -Name RDC
}

$ManagementPointScriptBlock = {
    Param($Source)
    #Management Point
    Install-WindowsFeature -Name Web-ISAPI-Ext
    Install-WindowsFeature -Name Web-Windows-Auth
    Install-WindowsFeature -Name Web-Metabase
    Install-WindowsFeature -Name Web-WMI
    Install-WindowsFeature -Name BITS
}

$SoftwareUpdatePointScriptBlock = {
    Param($Source)    
    #Software Update Point
    Install-WindowsFeature -Name NET-Framework-Core -Source $Source
    Install-WindowsFeature -Name NET-Framework-45-Features -Source $Source

}

#***************** Script Entry Point ******************************

if($SiteServer){
    Invoke-Command -ScriptBlock $SiteServerScriptBlock -ComputerName $Computer -ArgumentList $Source
}

if($DistributionPoint){
    Invoke-Command -ScriptBlock $DistributionPointScriptBlock -ComputerName $Computer -ArgumentList $Source
}
if($ManagementPoint){
    Invoke-Command -ScriptBlock $ManagementPointScriptBlock -ComputerName $Computer -ArgumentList $Source
}
if($SoftwareUpdatePoint){
    Invoke-Command -ScriptBlock $SoftwareUpdatePointScriptBlock -ComputerName $Computer -ArgumentList $Source
}
if($ApplicationCatalog){
    Invoke-Command -ScriptBlock $ApplicationCatalogScriptBlock -ComputerName $Computer -ArgumentList $Source
}