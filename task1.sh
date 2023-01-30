#!/bin/bash

# check valid input
if [[ $# -ne 1 ]]; then
    echo "Provide a file path as an argument to this script!"
    exit -1
fi

# check if the file exists
test -f $1 || { echo "file ${1} does not exist"; exit -1; }

# creating a backup of file
orig_file=$1
cp $orig_file "${orig_file}.backup"
new_file=$(echo $orig_file | sed "s/.csv/_new.csv/")

# write the header to the new file
echo $(head -n 1 $orig_file) > $new_file

# this code create an array with duplicate names
# this names have an email with location id
# names in the form: "jdoe" for more readability
declare -a all_names
while IFS="," read -r id location_id name title email department
do
    full_name=( $name )
    first_letter_of_name=${full_name[0]:0:1}
    last_name=${full_name[-1]}
   
    # get array with all names
    all_names+=( ${first_letter_of_name,,}${last_name,,} )
    # get array with uniqe names
    uniq_names=( $( echo ${all_names[@]} |  tr ' ' '\n' | sort -u | tr '\n' ' ' ) )
    # get array only with duplicate names
    dup_name=($(comm -3 <(printf "%s\n" "${all_names[@]}" | sort) <(printf "%s\n" "${uniq_names[@]}" | sort) | sort -n))
done <<< $(tail -n +2 $orig_file)
# echo ${dup_name[@]}


while IFS="," read -r id location_id name title email department
do
    full_name=( $name )
    upper_name=${full_name[@]^}
    first_letter_of_name=${full_name[0]:0:1}
    last_name=${full_name[-1]}
   
    if [[  ${dup_name[*]} =~  ${first_letter_of_name,,}${last_name,,} ]]; then
        new_email="${first_letter_of_name,,}${last_name,,}${location_id}@abc.com"
    else
        new_email="${first_letter_of_name,,}${last_name,,}@abc.com"
    fi   

    echo $id,$location_id,$upper_name,$title,$new_email,$department >> $new_file 
done <<< $(tail -n +2 $orig_file)

