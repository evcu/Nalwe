#!/bin/bash

# Description:  Demo script to demonstrate the usage of the scripts.
# Usage: 		./demo.sh corpus
# Example:      ./demo.sh wiki.txt =
# Note: 		Call the script from the folder it is in.  

wget http://dumps.wikimedia.org/enwiki/latest/enwiki-latest-pages-articles.xml.bz2
bzip2 -c -d enwiki-latest-pages-articles.xml.bz2 | perl prePerl.pl > wiki.txt