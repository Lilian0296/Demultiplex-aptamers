
<!-- README.md is generated from README.Rmd. Please edit that file -->

## Demultiplexpackages

The goal of Demultiplexpackages is to demultiplex SELEX data: fasta
files with different rounds SELEX sequencing data

## Installation

You can install the development version of Demultiplexpackages like so:

    install.packages("~/Demultiplexpackages_0.1.zip", repos = NULL, type = "win.binary",INSTALL_opts=c("--no-multiarch"))

You can find test data in data file:

``` r
library(Demultiplexpackages)
```

## data preprocess

``` r
filepath = "data-raw/test.fasta"
format = 'fasta'
data <- Input_preprocessed(filepath,format)
```

## demultiplex

You can check the output folder to see the results (ensure your output
folder is empty)

``` r
pathout <- "output/"
barcode2 <-"AAAAAAAAATCGCATGATCCGATC"
barcode4 <-"ACCTTGGGATCGCATGATCCGATC"
barcode6 <-"TCTCTCTCATCGCATGATCCGATC"
x <- list(barcode2=barcode2,barcode4=barcode4,barcode6=barcode6)
primer_fd <-"ATCGCATGATCCGATC"
primer_rv <-"GGCAGGCAGGCAGGCA"

demultiplex(x,data,primer_fd,primer_rv,pathout)
#>   filtering output/barcode2.fasta
#>   filtering output/barcode4.fasta
#>   filtering output/barcode6.fasta
```

# Basic resources

The R packages listed are required for running this package. *R
version 4.1.2 (2021-11-01) *R packages: Biostrings_2.62.0, QuasR_1.34.0,
dplyr_1.0.7, stringr_1.4.0

# References

1.  H. Pages, P. Aboyoun, R. Gentleman and S. DebRoy (2021). Biostrings:
    Efficient manipulation of biological strings. R package version
    2.62.0. <https://bioconductor.org/packages/Biostrings>
2.  Gaidatzis D, Lerch A, Hahne F, Stadler MB. QuasR: Quantification and
    annotation of short reads in R. Bioinformatics 31(7):1130-1132
    (2015).
3.  Langmead B, Trapnell C, Pop M, Salzberg SL. Ultrafast and
    memory-efficient alignment of short DNA sequences to the human
    genome. Genome Biology 10(3):R25 (2009).
4.  Au KF, Jiang H, Lin L, Xing Y, Wong WH. Detection of splice
    junctions from paired-end RNA-seq data by SpliceMap. Nucleic Acids
    Research, 38(14):4570-8 (2010).
5.  Kim D, Langmead B, Salzberg SL. HISAT: a fast spliced aligner with
    low memory requirements. Nat Methods, 12(4):357-60 (2015).
