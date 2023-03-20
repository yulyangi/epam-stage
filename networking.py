import ipaddress
import sys


def main():
    net1, net2 = get_info()
    check_network(net1, net2)


def get_info():
    try:
        ip1 = ipaddress.ip_address(input('Enter first IP address: '))
        ip2 = ipaddress.ip_address(input('Enter second IP address: '))
        subnet = input('Enter subnent mask in the format x.x.x.x or xx: ')
        net1 = ipaddress.ip_network(str(ip1) + '/' + str(subnet), strict=False)
        net2 = ipaddress.ip_network(str(ip2) + '/' + str(subnet), strict=False)
        return net1, net2
    except ValueError as err:
        print('IP address or subnet mask is invalid: ', err)
        sys.exit(1)


def check_network(net1, net2):
    if net1 == net2:
        print(f'IP are in the same network.')
    else:
        print(f'IP are not in the same network.')


if __name__ == '__main__':
    main()
