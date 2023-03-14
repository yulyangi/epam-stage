#!/usr/bin/python3
# this script convert 'output.txt' to the 'output.json'
# you can execute this script in a shell like "sudo python3 output.py /path/to/the/output.txt/file"
# you cat execute this script in a shell without arguments
# in this case 'output.txt' must be in the same directory as the script

import json
import sys
import os


def main():
    # if 'output.txt' in the same directory as the script this statement is executed
    if len(sys.argv) == 1:
        write_to_the_file('output.json', read_the_file('output.txt'))
    # if 'output.txt' passes as argument this script this statement is executed
    elif len(sys.argv) == 2:
        output_txt = sys.argv[1]
        source_path = os.path.abspath(output_txt)
        name, ext = os.path.splitext(source_path)
        dest_path = name + '.json'
        write_to_the_file(dest_path, read_the_file(output_txt))
    else:
        print('You can specify only one argument or "output.txt" must be in the same directory as the script. '
              'Something went wrong!')
        sys.exit()


def read_the_file(file):
    # declare some lists and dictionaries
    new_dict = dict()
    sub_dict = dict()
    list_sub_dict = list()
    new_list = list()

    # open the file, read the content, write the content to the 'new_dict' dictionaries
    with open(file, 'r') as file:
        content = file.read().splitlines()
        for item in content:
            new_list.append(item.split(' '))
        new_dict['testName'] = ' '.join(new_list[0][1:3])

        for item in new_list[2:-2]:
            if item[0] == 'not':
                sub_dict['name'] = ' '.join(item[5:-1])
                sub_dict['status'] = False
                sub_dict['duration'] = item[-1]
                list_sub_dict.append(sub_dict.copy())
            else:
                sub_dict['name'] = ' '.join(item[4:-1])
                sub_dict['status'] = True
                sub_dict['duration'] = item[-1]
                list_sub_dict.append(sub_dict.copy())

        new_dict['test'] = list_sub_dict

        sub_dict.clear()
        sub_dict['success'] = new_list[-1][0]
        sub_dict['failed'] = new_list[-1][5]
        sub_dict['rating'] = new_list[-1][10][0:-2]
        sub_dict['duration'] = new_list[-1][-1]

        new_dict['summary'] = sub_dict

        return new_dict


# write 'new_dict' to the output.json
def write_to_the_file(file, new_dict):
    with open(file, 'w') as file:
        json.dump(new_dict, file, indent=4)


if __name__ == '__main__':
    main()
