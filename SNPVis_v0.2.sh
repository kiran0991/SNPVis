#!/bin/bash
#================================================================================================================================
# HEADER
#================================================================================================================================
# TITLE
#-
#- SNPVis v0.2
#-    Text-based and Parsable application for viewing bam alignments with SNP along with flanking region 
#================================================================================================================================
#% SYNOPSIS
#+    ${SCRIPT_NAME} [-help] [-b/-bam=filename] [-f/-fasta=filename] [-c/-vcf=filename] [-n/-flank Int] [-o/-out=output_directory_path]
#%
#% DESCRIPTION
#%    A lightweight text based application for visualizing short read alignments. It provides an easy-to-parse text based outout
#%    for viewing alignments across loci with a focus on accurate visualization of SNP,Indels or insertions.
#%
#% OPTIONS
#%	   -h, --help					Show this help text
#%	   -b, --BAM					Coordinate sorted BAM file
#%	   -f, --FASTA					Reference FASTA file used in aligment
#%	   -c, --VCF 					SNP/Indels file
#%	   -n, --FLANK					Flanking region across the SNP position(50)
#%	   -o, --OUT  					Output directory(./OUT)
#%	   -v, --version				Print script information
#%
#% EXAMPLES
#%    ${SCRIPT_NAME} -b Chr1.bam -f genome.fasta -c Chr1.vcf -n 50 -o ./
#%
#================================================================================================================================
#- IMPLEMENTATION
#-    version         ${SCRIPT_NAME} (www.bionivid.com) 0.2.0
#-    author          KIRAN BANKAR & ROHIT SHUKLA 
#-    copyright       Copyright (c) http://www.bionivid.com
#-    script_id       07
#-    contact         kiran@bionivid.com / rohit@bionivid.com 
#-    address         Bionivid Technology Pvt Ltd, Banglore 560037
#-    availibility    SNPVis is available as a standard binary executable. The source code will be available under upon request.
#================================================================================================================================
#- DIPENDANCY
#-     Samtools v0.19 or above
#================================================================================================================================
#- HISTORY
#-    2016/07/09 : Kiran : Script creation
#-
#================================================================================================================================
# END_OF_HEADER
#================================================================================================================================

VERSION=0.2.0

HELP=

############################################ HELP ##################
  #== needed variables ==#
SCRIPT_HEADSIZE=$(head -200 ${0} |grep -n "^# END_OF_HEADER" | cut -f1 -d:)
SCRIPT_NAME="$(basename ${0})"

 #== usage functions ==#
usage() { printf "Usage: "; head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#+" | sed -e "s/^#+[ ]*//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
usagefull() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#[%+-]" | sed -e "s/^#[%+-]//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g" ; }
scriptinfo() { head -${SCRIPT_HEADSIZE:-99} ${0} | grep -e "^#-" | sed -e "s/^#-//g" -e "s/\${SCRIPT_NAME}/${SCRIPT_NAME}/g"; }

if [ $# == 0 ] ; then
    usagefull
    exit 1;
fi

#while [[ $# -gt 1 ]]
#do
#key="$1"
#case $key in

#while getopts ":vhbfcno:" optname
#  do
#    case "$optname" in
    
for i in "$@"
do
	case $i in
        -b=*|-bam=*)
        BAM="${i#*=}"
        #echo $BAM
        shift # past argument
        ;;
        -c=*|-vcf=*)
        VCF="${i#*=}"
        #echo $VCF
        shift # past argument
        ;;
        -f=*|-fasta=*)
        FASTA="${i#*=}"
        #echo $FASTA
        shift # past argument
        ;;
        -n=*|-flank=*)
        FLANK="${i#*=}"
        echo $FLANK
        shift # past argument
        ;;
        -o=*|-out=*)
        OUT="${i#*=}"
        #echo $OUT
        shift # past argument
        ;;
        -v)
        echo "Version $VERSION"
        exit 0;
        ;;
        -h)
        echo ""
        usage
        echo "
Authors - KIRAN BANKAR & ROHIT SHUKLA @ Bionivid Technology Pvt Ltd, Banglore 560037"
        exit 0;
        ;;
        -help)
        usagefull
        exit 0;
        ;;
        "?")
        echo "
ERROR : Unknown option $OPTARG"
        exit 0;
        ;;
        ":")
        echo "No argument value for option $OPTARG"
        exit 0;
        ;;
        *)
        echo "
ERROR : Unknown error while processing options
        "
        usagefull
        exit 0;
        ;;
    esac
done
#shift $((OPTIND - 1))



#VCF=$1
#BAM=$2
#FASTA=$3
#FLANK=$4
#OUT=$5

################## SET DEFAULT VALUE START #########################

if [ -z "${FLANK}" ]; then 
    FLANK=50
else 
    FLANK=${FLANK}
fi

if [ -z "${OUT}" ]; then 
    OUT="./OUT"
else 
    OUT=${OUT}
fi

if [ -f "$BAM" ];
then
   echo ""
else
   echo "
   File $BAM does not exist
   " >&2
   exit 0;
fi

if [ -f "$FASTA" ];
then
   echo ""
else
   echo "
   File $FASTA does not exist
   " >&2
   exit 0;
fi

if [ -f "$VCF" ];
then
   echo ""
else
   echo "
   File $VCF does not exist
   " >&2
   exit 0;
fi


COLS=`expr $FLANK + $FLANK`
export COLUMNS=$COLS
mkdir -p $OUT
################## SET DEFAULT VALUE END #########################

#echo "
#$VCF
#$FASTA
#$BAM
#$OUT
#$FLANK
#"

################## MAKE DICT START #########################

if test ! -f $BAM.bai
then
    echo "Creating Bam Index!"
    samtools index $BAM
fi

if test ! -f $FASTA.fai
then
    echo "Creating FASTA Index!"
    samtools faidx $FASTA
fi

##### get chrome length ####

#Chromosome length file - using fasta index

samtools faidx $FASTA

declare -A CHROM_DICT

END=`wc -l $FASTA.fai`

## Ref : http://stackoverflow.com/questions/169511/how-do-i-iterate-over-a-range-of-numbers-defined-by-variables-in-bash

for i in $(seq 1 1 $chrs)
{
	#echo $i
	CHROM_DICT=( [`cut -f1  $FASTA.fai`]=`cut -f2 $FASTA.fai`)
	
}

#echo "${CHROM_DICT[Chr1]}"

################## MAKE DICT END ###########################

################## PROCESS CHROM LOC START #################



#col 1,2 of VCF
#
#VCF_col2-flank ____ VCF_col2+flank
#flank-start ____   flank end



#grep -v "^#" $VCF > "Temp.txt"

#VCF_REC=`wc -l Temp.txt`

#head Temp.txt

awk '{if($0 !~ /^#/){print $1"\t"$2}}' $VCF > Temp.txt

while read line
do

	
	Chr=`echo "${line}" | awk '{print $1;}'`
	Pos=`echo "${line}" | awk '{print $2;}'`
	
	PosSt=` expr $Pos - $FLANK `
	PosEnd=` expr $Pos + $FLANK `
	
	#echo "$Chr  $Pos"
	
	#Ref: http://stackoverflow.com/questions/18668556/comparing-numbers-in-bash
	#-eq # equal
	#-ne # not equal
	#-lt # less than
	#-le # less than or equal
	#-gt # greater than
	#-ge # greater than or equal
	
	if test $PosSt -lt 1
	then
		PosSt=1
	fi
	
	if test $PosEnd -gt "${CHROM_DICT[$Chr]}"
	then
		PosEnd="${CHROM_DICT[$Chr]}"
	fi
	
	REGION="$Chr:$PosSt-$PosEnd"
	
	#echo $REGION
	
	########## PROCESS ALIGNMENT VIEW ###########
	samtools tview -p $REGION $BAM $FASTA -d T > .with_ref.txt
	samtools tview -p $REGION $BAM -d T > .without_ref.txt
	WITHREF='.with_ref.txt'
	WITHOUTREF='.without_ref.txt'
	echo "Processing variation Position $Chr-$Pos"
	VARPRIME="$Chr-$Pos.aln.var.txt"
	#WC=`wc -l $WITHREF | awk '{print $1}'`
	WC=`awk 'FNR==3 {print;}' $WITHOUTREF`
	
	#echo "\n$WC\n"
	
	awk -v cons="$WC" '{if(FNR==3){print cons;print;}else{print;}}' $WITHREF >$OUT/$VARPRIME
	
	rm .with_ref.txt .without_ref.txt
	
	#exit 0;
	
done < Temp.txt

################## PROCESS CHROM LOC START #################

rm Temp.txt
rm .with_ref.txt .without_ref.txt
########################################### END ####################
