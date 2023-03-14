#!/usr/bin/python3
# this script update 'accounts.txt'
# you can execute this script in a shell like "python3 accounts.py /path/to/the/accounts.txt/file"
# you can execute this script in a shell like "./accounts.py /path/to/the/accounts.csv/file" as well
# you can execute this script in a shell without any arguments
# in this case 'account.txt' should be in the same directory as the script

import sys
import os
import csv


def main():
    # if 'accounts.txt' in the same directory as the script this statement is executed
    if len(sys.argv) == 1:
        write_to_the_file('accounts_new.csv', read_the_file('accounts.csv'))
    # if 'output.txt' passes as argument this script this statement is executed
    elif len(sys.argv) == 2:
        file_csv = sys.argv[1]
        source_path = os.path.abspath(file_csv)
        name, ext = os.path.splitext(source_path)
        dest_path = name + '_new.csv'
        write_to_the_file(dest_path, read_the_file(file_csv))
    else:
        print('You can specify only one argument or "accounts.csv" must be in the same directory as the script. '
              'Something went wrong!')
        sys.exit()


def read_the_file(file):
    # declare some vars
    dupl_names = dict()
    result = list()
    all_names = list()

    # crate dictionary with names as key and occurrences as value
    with open(file, 'r') as f:
        reader = csv.reader(f)
        next(reader)
        for row in reader:
            first_name = row[2][0].lower()
            last_name = row[2].lower().split(' ')
            all_names.append(first_name + last_name[1])
        for name in all_names:
            dupl_names[name] = all_names.count(name)

    # read all other columns
    with open(file, 'r') as f:
        reader = csv.reader(f)
        next(reader)
        for row in reader:
            id = row[0]
            location_id = row[1]
            old_name = row[2].split(' ')
            name = f'{old_name[0].capitalize()} {old_name[1].capitalize()}'
            title = row[3]
            if dupl_names[old_name[0][0].lower() + old_name[1].lower()] > 1:
                email = f'{old_name[0][0].lower() + old_name[1].lower()}{location_id}@abc.com'
            else:
                email = f'{old_name[0][0].lower() + old_name[1].lower()}@abc.com'
            result.append([id, location_id, name, title, email])
    return result


# write result to the file
def write_to_the_file(file, result):
    with open(file, 'w') as f:
        writer = csv.writer(f)
        writer.writerow(['id', 'location_id', 'name', 'department', 'email'])
        for word in result:
            writer.writerow(word)


if __name__ == '__main__':
    main()
