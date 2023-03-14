# specify script's parameters
Param(
    [Parameter(Mandatory=$true)]
    [IPAddress]$ip_address_1,
    [Parameter(Mandatory=$true)]
    [IPAddress]$ip_address_2,
    [Parameter(Mandatory=$true)]
    # input network_mask as string 
    $network_mask
)


function Print {
	Param(
	[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
	[boolean]$Same
	)	      
    Write-Host  $(If ($Same -eq $true) {"YES"} Else {"NO"}) -ForegroundColor yellow    
}


# converting network mask
function Convert-Mask {
  param(
    [Parameter(Mandatory=$true)]
    [ValidateRange(0, 32)]
    [Int]$MaskBits
  )
  $mask = ([Math]::Pow(2, $MaskBits) - 1) * [Math]::Pow(2, (32 - $MaskBits))
  $bytes = [BitConverter]::GetBytes([UInt32]$mask)
  (($bytes.Count - 1)..0 | ForEach-Object { [String]$bytes[$_] }) -join "."
}


function Same-Network {
    Param(
	    [Parameter(Mandatory)]
	    $IP1,
	    [Parameter(Mandatory)]
	    $IP2,
	    [Parameter(Mandatory)]
	    [IPAddress]$Mask
        )

        # Write-Host $IP1
        # Write-Host $IP2
        # Write-Host $Mask

        $subnet_1 = ([IPAddress]($IP1.Address -band $Mask.Address)).IPAddressToString
        $subnet_2 = ([IPAddress]($IP2.Address -band $Mask.Address)).IPAddressToString

        # Write-Host "SUBNET1=$($subnet_1)"
        # Write-Host "SUBNET2=$($subnet_2)"		
    
        ($subnet_1 -eq $subnet_2)			     
}

# checking network mask
try {
    # check if network_mask is integer
    $network_mask = if ($network_mask -is [int]){
        Convert-Mask $network_mask
        }
        # check if network_mask can be vaild
        elseif (([IPAddress]$network_mask -is [IPAddress]) -eq $true){
        [IPAddress]$network_mask
        }
}
# output all errors as "Invalid input!'
catch {   
    Write-Host "Invalid input!"
    Exit
}

Same-Network $ip_address_1 $ip_address_2 $network_mask | Print
