Import-Module SMLets -Force

Function Set-SCSMEnumeration {
    [CmdletBinding(SupportsShouldProcess=$true)]
    Param(
        [string]$SourceEnumeration,
        [string]$DestinationEnumeration,
        $InputObject
    )

    if ($PSCmdlet.ShouldProcess($InputObject,$DestinationEnumeration)) {
        Set-SCSMObject -SMObject $InputObject -PropertyHashtable @{TierQueue=$DestinationEnumeration}
    }

}

$originEnum = (Get-SCSMEnumeration | Out-GridView -Title "Select origin enumeration" -PassThru)

$destinationEnum = (Get-SCSMEnumeration | Out-GridView -Title "Select destination enumeration" -PassThru)

$WorkItemClass = Get-SCSMClass System.WorkItem.Incident$

$Incidents = Get-SCSMObject -Class $WorkItemClass -filter "TierQueue -eq $($originEnum.Id)"

if ($Incidents -eq $null) {
    Write-Output "No incidents match the selected criteria"
    exit;
}

foreach ($I in $Incidents) {
    Set-SCSMEnumeration -DestinationEnumeration $destinationEnum.Name -InputObject $I -WhatIf
}