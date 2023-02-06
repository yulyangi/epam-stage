# this script works in PS7
# specify script's parameters
Param(
    [Parameter(Mandatory=$true)]
    $specify_file
)

$file = Import-Csv $specify_file

$new_file=@()
$names_occurs_more_ones=@()

# get array with all names in format 'jdoe'
foreach($item in $file){
    $temp=$item.Name.ToLower()
    $fullname=$temp.split(" ")
    $name= $fullname[0][0]+$fullname[1]
    [System.Collections.ArrayList]$names_occurs_more_ones += $name
    }

# get another array with unique names   
[System.Collections.ArrayList]$names_unique = $names_occurs_more_ones | sort -Unique

# get array with names that accure more then one
foreach($item in $names_unique){
    $names_occurs_more_ones.Remove($item)
    }

# echo $names_occurs_more_ones

# main loop
foreach($item in $file){
    $temp=$item.Name.ToLower()
    $fullname=$temp.split(" ")
    $name= $fullname[0][0]+$fullname[1]

    # check if name occurs more then once and assign different emails
    if ( $names_occurs_more_ones.Contains($name) = $true ){
        $email= $name+$item.location_id+"@abc.com"
    }
    else {
        # name occurs only once - email without location_id
        $email= $name+"@abc.com"
    }

    $new_file = $new_file + [PSCustomObject]@{
    id=$item.id;
    location_id=$item.location_id;
    name=( Get-Culture ).TextInfo.ToTitleCase( $item.Name.ToLower() );
    title=$item.title;
    email=$email;
    department=$item.department
   }
}

# this code works only in PS7
$new_path = ((Get-ChildItem -Path $specify_file) | %{$_.FullName}).Replace('.csv', '_new.csv')
$new_file | Export-Csv -UseQuotes AsNeeded -Path $new_path -NoTypeInformation 