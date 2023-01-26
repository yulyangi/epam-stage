# check number of parameters
if ($args.Count -ne 3) {
echo "ERROR! 3 parameters are mandatory: 
ip_address_1 in format x.x.x.x,
ip_address_2 in the format x.x.x.x
network_mask in the format x.x.x.x or x"
Exit
}

# address assignment
$ip_address_1 = $args[0]
$ip_address_2 = $args[1]
$submask = $args[2]
$valid_add = '^(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)$'

# check valid addresses
if ($ip_address_1 -notmatch $valid_add -or $ip_address_2 -notmatch $valid_add) {
echo "ERROR! Invalid IP address!"
Exit
}
elseif ($submask -notmatch $valid_add -and $submask -isnot [int]) {
echo "ERROR! Invalid network_mask!"
Exit
}
elseif ($submask -is [int] -and $submask -gt 32 -or $submask -lt 0) {
echo "ERROR! Invalid network_mask!"
Exit
}

# converting network submask
if ($submask -as [int] -and $submask -ne 0) {
$shift = 64 - $submask
[System.Net.IPAddress]$submask = 0  
$submask = [System.Net.IPAddress]::HostToNetworkOrder([int64]::MaxValue -shl $shift)
}


# assignment text info (subnet address) to vars
$ip_subnet_1 = ([IPAddress] (([IPAddress] $ip_address_1).Address -band ([IPAddress] $submask).Address)).IPAddressToString
$ip_subnet_2 = ([IPAddress] (([IPAddress] $ip_address_2).Address -band ([IPAddress] $submask).Address)).IPAddressToString

# check if subnets equal
if ($ip_subnet_1 -eq $ip_subnet_2) { echo "Yes" } else { echo "No" }
