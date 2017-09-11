# Retrieveing gene coordinates and drawing genes using Perl

In this file, I will explain how to draw the genes of any genome stored in MyRast or MIBig. You will need to download six scripts, all of which are in this repo: **getThatDrawing.pl**, **listof6s.pl**, **Rast_Final.pl**, **BGC_final.pl**, **fileCreator.pl**, and **3_Draw.pl** (the last one was created by @nselem).

First, you need to run **listof6s.pl**. This script takes an svg tree as the input. This program was created as a way to gather data from the organisms in your phylogenetic tree; in this case, a tree in svg format, like the one in this repo, **3.tree**. 
Once you have your data sotred in this way, run the program and your results will be stored in a file called *newgenomes.txt*, where you will be able to see  the retrieved data of your organisms.

## MIBig or Rast?
If your genes are in MIBig, you have to use the program **BGC_final.pl**, whereas you will need **Rast_Final.pl** if your genes are from Rast. If you have genes both in Rast and MIBig, use both.

## Using BGC_final.pl
First of all, you need to modify this script to write the input and output directories, since this program doesn't use Getopt::Long to take these directories yet.

The values you eed to modify are:
* $bgcsFile = your MIBig fasta :file where the program will retrieve the gene data from.
* $bgcGenomes= a text file where your genome data is stored.
* $destination= the directory where you want your gene files to be written.

This program takes these three values as input and returns BGC gene files with .input extension written in the outpout directory you specify ($destination).

## Using Rast_Final.pl
Okay, so this program not only retrieves Rast gene coordinates, it also looks for those genes in ActinoSmash and colors them cyan if they are, and if you have a phylogenetic tree associated with this gene drawing you want to create, this program will retrieve the color of each central gene and color it according to its color in the tree. So this program needs to have these vaules changed:
* $outputdir= the directory where you want your files to be written.
* $inputdir= the directory where you have your actinos.ids file.
* $RastIdfFile= $inputdir/your actinos.ids file.
* $ornament= $inputdir/your tree file (if you have one).
* $genomeFiles the files where you have your .txt Rast files.

This program uses GetOpt::Long to retrieve x number of genes left and y number of genes right, and returns files with the genome number and the central gene number with .input extension that contain the gene data needed for the drawing program.

## Using fileCreator.pl
This file only takes a tree and an Actinos.ids file as the input and returns the Rast and BGC genes contained in it. Then it creates the .input file list that the drwaing program will need for later use.

## Using 3_Draw.pl
This program is the ones that will actually draw your genes when all the neessary data is obtained.

## Setting up getThatDrawing.pl
If you have both Rast and MIBig genes you want to be drawn, you don't have to change none of the first to variables. However, if you only have MIBig files, comment the $rastFiles variable, and comment the $BGCFiles variable if you only have Rast files.

When calling 3_Draw.pl, don't change anything except the last value (which is salida by default), which is the directory where all your .input files are stored and where the program will create your gene drawings.

I hope this was helpful. Feel free to hit me up with questions or comments. Happy coding, everyone!
