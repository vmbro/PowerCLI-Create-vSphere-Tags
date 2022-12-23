$path = "c:\vmList.csv" # Path for the csv file to be exported
$vcenter = "vCenterFQDN" # Your vCenter name -  vcenter.domain.local
$user = "username" # Your vCenter username - administrator@vsphere.local or domain\username
$password = "password" # Your vCenter password
try {
    Disconnect-VIServer -server * -confirm:$false
}
catch {
    #"Could not find any of the servers specified by name."
}
Connect-VIServer -Server $vcenter -User $user -Password $password | out-null
$vms = Get-VM 
$vmList = @()
foreach ($vm in $vms) {
    $vmInfo = "" | Select-Object Name, OperatingSystem, PowerState
    $vmInfo.Name = $vm.Name
    $vmInfo.OperatingSystem = $vm.Guest.OSFullName
    $vmInfo.PowerState = $vm.PowerState
    $vmList += $vmInfo
}
$vmList | Export-Csv -Path $path -NoTypeInformation
Disconnect-VIServer -Server * -Confirm:$false
write-host $vmList.Count " virtual machines were exported to : " $path -ForegroundColor Green 
