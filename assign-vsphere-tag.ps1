$csv = Import-Csv -Path 'C:\vmList.csv' # File path to be imported.
$vcenter = "vCenterFQDN" # Your vCenter name -  vcenter.domain.local
$user = "username" # Your vCenter username - administrator@vsphere.local or domain\username
$password = "password" # Your vCenter password
$categoryName = "Backup-Test" # Your Backup Category that will be created vSphere Tags.
$totalVM = $csv.Count
try {
    Disconnect-VIServer -server * -confirm:$false
}
catch {
    #"Could not find any of the servers specified by name."
}
Connect-VIServer -Server $vcenter -User $user -Password $password | out-null
$i = 0
foreach ($data in $csv) {
    If (Get-Tag -Category $categoryName | Where-Object { $_.Name -eq $data.Tag }) {
        New-TagAssignment -Tag $data.Tag -Entity $data.Name | out-null
        $i++
    }
    else {
        New-Tag -Name $data.Tag -Category $categoryName | out-null
        New-TagAssignment -Tag $data.Tag -Entity $data.Name | out-null
        $i++
    }
    write-host "Processing:" $i"/"$totalVM "-> " $data.Tag "tag has been assigned to the " $data.Name " virtual  machine." -ForegroundColor Green
}
Disconnect-VIServer -Server * -Confirm:$false 
