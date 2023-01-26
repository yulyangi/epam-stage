#!/bin/bash

# check valid input
if [[ $# -ne 1 ]]; then
echo "Invalid input!"
exit 1
fi

output_file=output.json

# getting first and last lines of file
first_line=$(head -n 1 $1)
last_line=$(tail -n 1 $1)

# getting body of file
body_file=$(tail -n +3 $1 | head -n -2)

# getting first and last line of body
first_bodyline=$(head -n 3 $1 | tail -n 1)
last_bodyline=$(tail -n 3 $1 | head -n 1)

# getting testName and writing it to the file
test_name=$(echo $first_line | cut -d" " -f2-3)
echo -e {'\n\t'\"testName\": \"$test_name\", > $output_file
echo -e '\t'\"tests\": [{ >> $output_file

while read line
do
    # converting line to array and splitting
    IFS=" " read -a a_line <<< $line

    # getting name of test and writing it to the file
    tmp=${a_line[@]:4}
    tmp2=$(echo $tmp | rev | cut -d" " -f2- | rev)
    name=$(echo ${tmp2::-1})
    # check if line is first to write without curly brace
    if [[ $line == $first_bodyline ]]; then
        echo -e '\t\t\t'\"name\": \"$name\", >> $output_file
    else
        echo -e '\t\t'{'\n\t\t\t'\"name\": \"$name\", >> $output_file
    fi

    # getting result (either 'ok' or 'not') of test and writing it to the file
    tmp=${a_line[0]}
    if [[ $tmp == 'ok' ]]; then
        status='true'
    elif [[ $tmp == 'not' ]]; then
        status='false'
    fi
    echo -e '\t\t\t'\"status\": $status, >> $output_file

    # getting duration of test and writing it to the file
    # check it if last line for not adding a comma after curly brace
    if [[ $line == $last_bodyline ]]; then
        duration_of_test=${a_line[-1]}
        echo -e '\t\t\t'\"duration\": \"$duration_of_test\"'\n\t\t'} >> $output_file
    else
        duration_of_test=${a_line[-1]}
        echo -e '\t\t\t'\"duration\": \"$duration_of_test\"'\n\t\t'}, >> $output_file
    fi

done <<< $body_file

# writing summary
echo -e '\t'],'\n\t'\"summary\": { >> $output_file

# getting number of successfull tests and writing it to the file
success=$(echo $last_line | cut -d" " -f1)
echo -e '\t\t'\"success\": $success, >> $output_file

# getting number of failed tests and writing it to the file
failed=$(echo $last_line | cut -d" " -f6)
echo -e '\t\t'\"failed\": $failed, >> $output_file

# getting rating and writing it to the file
tmp_r=$(echo  $last_line | cut -d" " -f11)
rating=$(echo ${tmp_r::-2})
echo -e '\t\t'\"rating\": $rating, >> $output_file

#getting duration and writing it to the file
duration=$(echo $last_line | cut -d" " -f13)
echo -e '\t\t'\"duration\": \"$duration\"'\n\t'}'\n'} >> $output_file

