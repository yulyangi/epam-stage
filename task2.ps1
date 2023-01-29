# specify script's parameters
Param(
    [Parameter(Mandatory=$true)]
    $specify_file
)

$file = Import-Csv $specify_file

$new_file=@()
$names_occurs_more_ones=@()

# get array with all names
foreach($item in $file){
    [System.Collections.ArrayList]$names_occurs_more_ones=$names_occurs_more_ones + $item.Name.ToLower()
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

    # check if names occurs more then once and assign different emails
    if ( $names_occurs_more_ones.Contains($item.Name.ToLower()) = $true ){
        $email= $fullname[0][0]+$fullname[1]+$item.location_id+"@abc.com"
    }
    else {
        # name occurs only once - email without location_id
        $email= $fullname[0][0]+$fullname[1]+"@abc.com"
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

# write to the new file without qoutes and write file to the dirrectory where input file
$new_file | ConvertTo-CSV -NoTypeInformation | 
% { $_ -Replace '"', ""} | 
Out-File ((Get-ChildItem -Path $specify_file) | %{$_.FullName}).Replace('.csv', '_new.csv')
