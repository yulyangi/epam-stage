#!/bin/bash

# check valid input
if [[ $# -ne 1 ]]; then
echo "Invalid input!"
exit 1
fi

output_file=accounts_new.csv

# getting body of file
body_of_file=$(tail -n +2 $1)

# write header to new file
echo $(head -n 1 $1) > $output_file

while IFS="," read -r id location_id name title email department
do
    full_name=( $name )
    upper_name=${full_name[@]^}
    first_letter_of_name=${full_name[0]:0:1}
    last_name=${full_name[-1]}
    new_email=${first_letter_of_name,}.${last_name,,}@abc.com
    echo $id,$location_id,$upper_name,$title,$new_email,$department >> $output_file 
done <<<$body_of_file
