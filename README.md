 SNPVis v0.2
 
    Text-based and Parsable application for viewing bam alignments with SNP along with flanking region 
 SYNOPSIS
 
    SNPVis_v0.2.sh [-help] [-b/-bam=filename] [-f/-fasta=filename] [-c/-vcf=filename] [-n/-flank Int] [-o/-out=output_directory_path]

 DESCRIPTION
 
    A lightweight text based application for visualizing short read alignments. It provides an easy-to-parse text based outout
    for viewing alignments across loci with a focus on accurate visualization of SNP,Indels or insertions.

 OPTIONS
 
	   -h, --help					Show this help text
	   
	   -b, --BAM					Coordinate sorted BAM file
	   
	   -f, --FASTA					Reference FASTA file used in aligment
	   
	   -c, --VCF 					SNP/Indels file
	   
	   -n, --FLANK					Flanking region across the SNP position(50)
	   
	   -o, --OUT  					Output directory(./OUT)
	   
	   -v, --version				Print script information
	   

 EXAMPLES
 
    SNPVis_v0.2.sh -b Chr1.bam -f genome.fasta -c Chr1.vcf -n 50 -o ./
    

 IMPLEMENTATION
 
    version         SNPVis_v0.2.sh (www.bionivid.com) 0.2.0
    
    author          KIRAN BANKAR & ROHIT SHUKLA 
    
    copyright       Copyright (c) http://www.bionivid.com
    
    script_id       07
    
    contact         kiran@bionivid.com / rohit@bionivid.com 
    
    address         Bionivid Technology Pvt Ltd, Banglore 560037
    
    availibility    SNPVis is available as a standard binary executable. The source code will be available under upon request.
    
 DIPENDANCY
 
     Samtools v0.19 or above
     
 HISTORY
 
    2016/07/09 : Kiran : Script creation
    
