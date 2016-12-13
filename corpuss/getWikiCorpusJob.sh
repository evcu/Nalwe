#!/bin/bash

# Description:  Demo script to demonstrate the usage of the scripts.
# Usage: 		./demo.sh corpus
# Example:      ./demo.sh wiki.txt =
# Note: 		Call the script from the folder it is in.  

#wget http://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2
#bzip2 -c -d enwiki-latest-pages-articles.xml.bz2 | perl prePerl.pl > wiki.txt

#PBS -lnodes=1
#PBS -lwalltime=10:00:00
#PBS -S /bin/bash
cd \$TMPDIR
cp corpuss/prePerl.pl ./
wget http://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2
bzip2 -c -d enwiki-latest-pages-articles.xml.bz2  | perl prePerl.pl > wiki.txt
cp wiki.txt $HOME/ionalwe/corpuss/
