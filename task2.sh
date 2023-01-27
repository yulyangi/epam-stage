#!/bin/bash

# check if input provided
if [[ ! ${1+x} ]]; then
    echo "Provide a file path as an argument to this script!"
    exit -1
fi

# check if file exists
test -f $1 || { echo "file ${1} does not exist"; exit -1; }

# create a backup of original file
cp $1 "${1}.backup"

# new file name
output_file=$(echo $1 | sed "s/.txt/.json/")

# geting first and last lines of file
first_line=$(head -n 1 $1)
last_line=$(tail -n 1 $1)

# geting body of file
body_file=$(tail -n +3 $1 | head -n -2)

# getting last line of body
last_bodyline=$(tail -n 3 $1 | head -n 1)

# getting testName and writing it to the file
test_name=$(echo $first_line | cut -d" " -f2-3)
echo -e {'\n\t'\"testName\": \"$test_name\", > $output_file
echo -e '\t'\"tests\": [ >> $output_file

while read line
do
    # converting line to array and splitting
    IFS=" " read -a a_line <<< $line

    # getting name of a test and writing it to the file
    if [[ $a_line[0]} == 'ok' ]]; then
        name_start=2
        status='true'
    else
        name_start=3
        status='false'
    fi

    tmp=${a_line[@]:$name_start}
    tmp2=$(echo $tmp | rev | cut -d" " -f2- | rev)
    name=$(echo ${tmp2::-1})

    # writing the name and the status to the file
    echo -e '\t\t'{'\n\t\t\t'\"name\": \"$name\", >> $output_file
    echo -e '\t\t\t'\"status\": $status, >> $output_file
    
    # adding duration of the test to the file
    duration_of_test=${a_line[-1]}
    if [[ $line == $last_bodyline ]]; then
        echo -e '\t\t\t'\"duration\": \"$duration_of_test\"'\n\t\t'} >> $output_file
    else
        echo -e '\t\t\t'\"duration\": \"$duration_of_test\"'\n\t\t'}, >> $output_file
    fi

done <<< $body_file

# writing a summary
echo -e '\t'],'\n\t'\"summary\": { >> $output_file

# getting a number of successfull tests and writing it to the file
success=$(echo $last_line | cut -d" " -f1)
echo -e '\t\t'\"success\": $success, >> $output_file

# getting a number of failed tests and writing it to the file
failed=$(echo $last_line | cut -d" " -f6)
echo -e '\t\t'\"failed\": $failed, >> $output_file

# getting a rating and writing it to the file
tmp_r=$(echo  $last_line | cut -d" " -f11)
rating=$(echo ${tmp_r::-2})
echo -e '\t\t'\"rating\": $rating, >> $output_file

#getting a duration and writing it to the file
duration=$(echo $last_line | cut -d" " -f13)
echo -e '\t\t'\"duration\": \"$duration\"'\n\t'}'\n'} >> $output_file

