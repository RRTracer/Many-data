#import des bibliothèque necessaire au scan arp 
from scapy.all import *


def scan_arp(target):
    ans, unans = srp(Ether(dst="ff:ff:ff:ff:ff:ff")/ARP(pdst=target), timeout=2, retry=20)
    return ans

if __name__ == "__main__":
    target = input("Entrez l'adresse IP de la cible: ")
    print(scan_arp(target))
