library(Biostrings)
library(QuasR)
library(dplyr)
library(stringr)


#' Data preprocess
#'
#' @param filepath the path of your sequencing data
#' @param format fasta or fastq
#'
#' @return dataframe
#' @importFrom  Biostrings readDNAStringSet
#'
#' @export
#'
#' @examples
Input_preprocessed <-function(filepath,format){
  data <- readDNAStringSet(filepath,format=format)
  data <- as.data.frame(data)
  colnames(data) <- "seq"
  return(data)
}


#' demultiplex barcodes and trim primers
#'
#' @param x the list of barcodes
#' @param data the output from Input_preprocessed()
#' @param primer_fd the string of your forward primers
#' @param primer_rv the string of your reverse primers
#' @param pathout the path of your output folder (should be empty)
#'
#' @return files of each barcodes before and after trimming primers
#' @importFrom Biostrings DNAString reverseComplement DNAStringSet writeXStringSet readDNAStringSet
#' @import stringr
#' @importFrom QuasR preprocessReads
#' @importFrom  dplyr mutate
#'
#' @export
#'
#' @examples
demultiplex <- function(x,data,primer_fd,primer_rv,pathout){
  for (i in 1:length(x)){
    barcode_fd <-  DNAString(as.character(x[i]))
    barcode_rv <- reverseComplement(barcode_fd)
    b_f <-grep(pattern=x[[i]],data$seq)
    b_r <-grep(pattern=as.character(barcode_rv),data$seq)
    b_f <-as.data.frame(data[b_f,])
    b_r <-as.data.frame(data[b_r,])
    b_r <-as.data.frame(reverseComplement(DNAStringSet(b_r$`data[b_r, ]`)))
    colnames(b_f) <- "seq"
    colnames(b_r) <- "seq"
    b.data <-rbind(b_f,b_r)
    write.csv(b.data,paste(pathout, names(x[i]),".csv",sep = ''),row.names = FALSE)
    saveRDS(b.data,paste(pathout, names(x[i]),".rds",sep = ''))
    b.data <- mutate(b.data,Len=nchar(seq))
    b_stringset <- DNAStringSet(b.data$seq)
    filename_fasta <- paste(pathout, names(x[i]),".fasta",sep = '')
    writeXStringSet(b_stringset,filename_fasta,format='fasta')
    filename_fasta_pro <-paste(pathout, names(x[i]),"_dropprimers",".fasta",sep = '')
    b_dropprimers <-QuasR::preprocessReads(filename_fasta,
                                           outputFilename=filename_fasta_pro,
                                           minLength=30,Lpattern = primer_fd,Rpattern = primer_rv,
                                           truncateEndBases = 5)

    b_noprimers <- readDNAStringSet(filename_fasta_pro,format='fasta')
    b.filter <- as.data.frame(b_noprimers)
    colnames(b.filter) <- "seq"
    b.filter <- mutate(b.filter,Len=nchar(seq),ID=names(x[i]))
    write.csv(b.filter, paste(pathout, names(x[i]),"_dropprimers",sep = ''),row.names = FALSE)
    saveRDS(b.filter, paste(pathout, names(x[i]),"_dropprimers",".rds",sep = ''))
  }

}
