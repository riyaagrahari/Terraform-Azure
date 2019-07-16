Connect-AzAccount

$ResourceGroup="RG1"
$port=2800

$inboundRule1="Inbound-ReplicaDB-PrimaryDB-Communication"
$outboundRule1="Outbound-PrimaryDB-RelicaDB-Communication"
$inboundRule2="Inbound-PrimaryDB-ReplicaDB-Communication"
$outboundRule2="Outbound-ReplicaDB-PrimaryDB-Communication"

#name of NSG as per setup made by you
$NSGname="NSG3"

$NSGreplicaName="NSG3-replica"

$r = Get-AzResource | Where {$_.ResourceGroupName -eq $ResourceGroup -and $_.ResourceType -eq "Microsoft.Network/networkSecurityGroups"}

$NSG = Get-AzNetworkSecurityGroup -Name $NSGname -ResourceGroupName $ResourceGroup

# inbound security rule.
$NSG | Add-AzNetworkSecurityRuleConfig -Name $inboundRule1 -Description "Allow Inbound Communication from Secondary Replica Database to Primary DB" -Access Allow `
    -Protocol * -Direction Inbound -Priority 3400 -SourceAddressPrefix "20.0.3.0/24" -SourcePortRange $port `
    -DestinationAddressPrefix "10.0.3.0/24" -DestinationPortRange $port


# outbound security rule.
$NSG | Add-AzNetworkSecurityRuleConfig -Name $outboundRule1 -Description "Allow Outbound Communication from  Primary Database to Secondary DB" -Access Allow `
    -Protocol * -Direction Outbound -Priority 3400 -SourceAddressPrefix "10.0.3.0/24" -SourcePortRange $port `
    -DestinationAddressPrefix "20.0.3.0/24" -DestinationPortRange $port

# Update Network security group rules
$NSG | Set-AzNetworkSecurityGroup

$NSG2 = Get-AzNetworkSecurityGroup -Name $NSGreplicaName -ResourceGroupName $ResourceGroup

# inbound security rule for replica DB.
$NSG2 | Add-AzNetworkSecurityRuleConfig -Name $inboundRule2 -Description "Allow Inbound Communication from Primary Database to Secondary Replica DB " -Access Allow `
    -Protocol * -Direction Inbound -Priority 3400 -SourceAddressPrefix "10.0.3.0/24" -SourcePortRange $port `
    -DestinationAddressPrefix "20.0.3.0/24" -DestinationPortRange $port


# outbound security rule for replica DB.
$NSG2 | Add-AzNetworkSecurityRuleConfig -Name $outboundRule2 -Description "Allow Outbound Communication from Secondary Replica Database to Primary DB" -Access Allow `
    -Protocol * -Direction Outbound -Priority 3400 -SourceAddressPrefix "20.0.3.0/24" -SourcePortRange $port `
    -DestinationAddressPrefix "10.0.3.0/24" -DestinationPortRange $port

# Update Network security group rules for replica DB
$NSG2 | Set-AzNetworkSecurityGroup
