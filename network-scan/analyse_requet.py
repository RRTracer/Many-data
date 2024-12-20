#!/usr/bin/env python3

## création d'un programme qui analyse les requet du reseau comme whireshark

from scapy.all import *
from scapy.layers.inet import IP, ICMP, UDP, TCP

def main():
    target = input("Entrez l'adresse IP de la cible: ")
    print(scan_arp(target))

if __name__ == "__main__":
    main()