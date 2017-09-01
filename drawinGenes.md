# Retrieveing gene coordinates and drawing genes using Perl

In this file, I will explain how to draw the genes of any genome stored in MyRast or MIBig. You will need to download four scripts, all of which are in this repo, **listof6s.pl**, **geneCoordRetriever.pl**, **BGC_final.pl** and **3_Draw.pl** (the last one was created by @nselem).

First, you need to run **listof6s.pl**. This script takes an svg tree as the input. This program was created as a way to gather data from the organisms in your phylogenetic tree; in this case, a tree in svg format, like the one in this repo, **3.tree**. 
Once you have your data sotred in this way, run the program and your results will be stored in a file called *newgenomes.txt*, where you will be able to see  the retrieved data of your organisms.

## MIBig or Rast?
If your genes are in MIBig, you have to use the program **BGC_final.pl**, whereas you will need **geneCoordRetriever** if your genes are from Rast. 

## Using BGC_final.pl

