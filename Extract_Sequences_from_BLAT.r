setwd("/Users/SAI/Documents/!Projects/!!Burmeistera/Genomics/Capture_Probe_Design/Comparison/BLAT/Hydra-B1_all_Reads_Geneious")

#I tried but then I remembered I had a function written by jon Eastman to read a .pslx and pick
#the longest of the possible hits. See below.

#Reads in data but no headers
#x <- read.table("Hydra_All_Genes.fasta_vs_B1_vs_All_Reads_Geneiois_40_percent_done_1790_genes_output_target_enrichment_probe_sequences.fasta.pslx.txt", sep = "\t", skip = 5, as.is = T)

#Read header
#xx <- readLines("Hydra_All_Genes.fasta_vs_B1_vs_All_Reads_Geneiois_40_percent_done_1790_genes_output_target_enrichment_probe_sequences.fasta.pslx.txt", n = 5)
#xx <- read.table(pipe("grep ^match Hydra_All_Genes.fasta_vs_B1_vs_All_Reads_Geneiois_40_percent_done_1790_genes_output_target_enrichment_probe_sequences.fasta.pslx.txt"))

#Add two extra column names for QUERY and TARGET sequences
#xxx <- matrix(NA, 1, 2)
#xxx[,1] <- ("Query_Seq")
#xxx[,2] <- ("Target_Seq")
#xxx
#xx <- cbind(xx, xxx)
#names(xx) <- xx[1,]


#Function written by Jon Eastman to read .pslx files from BLAT
read.pslx=function(file){
  ll=readLines(file)
  ll=ll[ll!=""]
  g=grep("--------",ll)
  if(length(g)) ll=ll[-g]
  
  st=ifelse(length(g<-grep("match",ll)), max(g), 0)+1
  ncol=length(unlist(strsplit(ll[st],"\t")))
  header=ll[1:st]
  mm=matrix(NA, ncol=ncol, nrow=length(ll[(zz<-st:length(ll))]))
  for(i in zz) mm[i-(st-1),]=unlist(strsplit(ll[i], "\t"))
  header=header[grep("match",header)]
  tmp=strsplit(header, "\t")
  nms=lapply(tmp, function(x) gsub(" ", "", gsub("'", "", gsub("-", "", gsub(".", "", x, fixed=TRUE)))))
  nms[[2]]=c(nms[[2]], rep("", (hl<-length(nms[[1]]))-length(nms[[2]])))
  tt=c(sapply(1:hl, function(x) if((z<-nms[[2]][x])=="") return(nms[[1]][x]) else return(paste(nms[[1]][x],z,sep="_"))), "QUERY", "TARGET")
  colnames(mm)=tt
  dd=data.frame(mm,stringsAsFactors=FALSE)
  dd
}

## FINDS LONGEST MATCH in QUERY --> querySEQ
trim_querySEQ.pslx=function(pslx){
  dat=pslx
  seq=strsplit(dat$QUERY, ",")
  dat$querySEQ=sapply(seq, function(x) {y=sapply(x, nchar); x[min(which(y==max(y)))]})
  dat$hit_size=sapply(dat$querySEQ, nchar)
  dat
}

#Read in pslx file
x <- read.pslx("B3_vs_All_Reads_SPAdes_Sondovac_1489_genes_output_target_enrichment_probe_sequences.fasta_vs_B4_vs_All_Reads_SPAdes_Sondovac_1478_genes_output_target_enrichment_probe_sequences.fasta.pslx.txt")
#Check proper dimension
dim(x)
#Pic the longest of the possible hit sequences
xx <- trim_querySEQ.pslx(x)
#dim(xx)
#str(xx)
#Extract columns shared by both Query and Target 
z <- matrix(nrow = nrow(xx), ncol = 2)
z[,2] <- xx$querySEQ
z[,1] <- paste(">",seq(from = 1, to = nrow(z), by = 1), sep = "")
z[,2] <- paste("\n", z[,2], sep = "")

write.table(z, file = "B3_B4_Shared.fasta", row.names = F, col.names = F, quote = F)
