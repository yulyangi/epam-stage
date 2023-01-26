# check valid input
if ($args.Count -ne 1) {
echo "ERROR! 1 parameters are mandatory"
Exit
}

$file=Import-CSV $args

$new_file=@()

foreach($item in $file){
   $temp=$item.name.ToLower()
   $fullname=$temp.split(" ")
   $new_file = $new_file + [PSCustomObject]@{
   id=$item.id;
   location_id=$item.location_id;
   name=( Get-Culture ).TextInfo.ToTitleCase( $item.Name.ToLower() );
   title=$item.title;
   email= $fullname[0][0]+"."+$fullname[1]+$item.location_id+"@abc.com";
   department=$item.department}
   }

# write to new file without qoutes
$new_file | ConvertTo-CSV -NoTypeInformation | 
% { $_ -Replace '"', ""} | Out-File .\new_accounts.csv
