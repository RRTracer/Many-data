#!/bin/bash
#
# script de Eric Bachard

entree=$1

sortie=${1/.pdf/_reduit.pdf}

#type=/screen
type=/ebook

gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=${type} -dNOPAUSE -dQUIET -dBATCH -sOutputFile=${sortie} ${entree}