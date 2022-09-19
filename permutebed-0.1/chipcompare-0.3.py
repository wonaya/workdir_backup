### TO DO: UPDATE NAME SO THAT OVERLAP DOES NOT CONFUSE OTHERS
#!/usr/bin/env python
  
import os,sys
import numpy as np
import matplotlib.mlab as mlab
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import scipy
import datetime
from math import *
from scipy import stats
from optparse import OptionParser, OptionGroup
from urllib2 import urlopen
import math
import random

def permutation(static_set, test_set, coordinate_N, fai, permutation_cycle) :
    #print static_set, test_set, coordinate_N, fai, permutation_cycle
    try :
        os.mkdir("tmp")
    except OSError :
        os.chdir(".")
    ### first Bed
    filter_file = open("tmp/test_chip.bed", 'w')
    for a in open(test_set, 'r') :
        filter_file.write(a)
    filter_file.close()
    ### second ChIP
    filter_file = open("tmp/static_chip.bed", 'w')
    for a in open(static_set, 'r') :
        filter_file.write(a)
    filter_file.close()
    
    ### intersect 
    os.system("intersectBed -wa -a tmp/test_chip.bed -b tmp/static_chip.bed > tmp/test_static_overlap.bed")
    os.system("intersectBed -wo -a tmp/test_chip.bed -b tmp/static_chip.bed > tmp/test_static_overlap_count.bed")
    a = open("tmp/test_static_overlap.bed",'r')
    alines = a.readlines()
    o = open("tmp/test_chip.bed", 'r')
    olines = o.readlines()
    original_perc = float(len(set(alines)))/float(len(set(olines)))*100
    values = []
    for b in open("tmp/test_static_overlap_count.bed", 'r') :
        values.append(int(b.split("\t")[-1].strip("\n")))
    original_bp = sum(values)
    print str(original_perc)+"%", str(original_bp)+"bp"
    print "\nstart time:", datetime.datetime.now()
    perm_perc = []
    perm_bp = []
    percent_out = open("overlap_percent.out", 'w')
    id = 0
    for x in range(0,int(permutation_cycle)) :
        id += 1
        if coordinate_N != None :
            os.system("shuffleBed -i tmp/test_chip.bed -g "+fai+" -excl "+coordinate_N+" > tmp/"+str(x)+".bed")
        else :
            os.system("shuffleBed -i tmp/test_chip.bed -g "+fai+" > tmp/"+str(x)+".bed")
        os.system("intersectBed -wa -a tmp/"+str(x)+".bed -b tmp/static_chip.bed > tmp/"+str(x).split(".")[0]+"_static_overlap.bed")
        os.system("intersectBed -wo -a tmp/"+str(x)+".bed -b tmp/static_chip.bed > tmp/"+str(x).split(".")[0]+"_static_overlap_count.bed")
        values = []
        for b in open("tmp/"+str(x).split(".")[0]+"_static_overlap_count.bed", 'r') :
            values.append(int(b.split("\t")[-1].strip("\n")))
        perm_bp.append(sum(values))
        a = open("tmp/"+str(x).split(".")[0]+"_static_overlap.bed", 'r')
        alines = a.readlines()
        perc = float(len(set(alines)))/float(len(set(olines)))*100
        perm_perc.append(perc)
        percent_out.write(str(id)+"\t"+str(sum(values))+"\t"+str(perc)+"\n")
    print "end time:", datetime.datetime.now() # 5 min for 1000 peaks 1000 times, 
    count = 0
    percent_out.close()
    for perm in perm_perc :
    ## enrichment (>=), depletion (<=)
        if perm >= original_perc : 
            count += 1
    pval = float(count)/float(permutation_cycle)
    plt.hist(perm_perc, bins=50, facecolor='green', alpha=0.75)
    plt.xlabel('percentage overlap (%) '+str(original_perc)+' '+str(pval))
    plt.ylabel('frequency')
    plt.plot([original_perc, original_perc], [0,100], 'k-', lw=2, color='r')
    plt.savefig(test_set.split(".")[0]+"_overlap_"+static_set.split(".")[0]+".png")
    plt.close()

    count_bp = 0
    for perm in perm_bp :
        if perm >= original_bp :
            count_bp += 1
    pval = float(count_bp)/float(permutation_cycle)
    plt.hist(perm_bp, bins=50, facecolor='green', alpha=0.75)
    plt.xlabel('bp overlap '+str(original_bp)+' '+str(pval))
    plt.ylabel('frequency')
    plt.plot([original_bp, original_bp], [0,100], 'k-', lw=2, color='r')
    plt.savefig(test_set.split(".")[0]+"_overlap_"+static_set.split(".")[0]+"_bp.png")
    os.system("rm -Rf tmp")

parser = OptionParser()
allgroup = OptionGroup(parser, "Required for permutation tests")
allgroup.add_option("--test_1", dest="static", help="not permutated set (.bed or .broadPeak)")
allgroup.add_option("--test_2", dest="test", help="permutated set (.bed or .broadPeak)")
allgroup.add_option("--Ncoord", dest="ncoord", help="coordinates of N in bedgraph format maize_chrOnly_Ns.bed not required")
allgroup.add_option("--permutate_n", dest="permutate_n", help="no_of_permutation_cycles_to_run", default=1000)
allgroup.add_option("--fai", dest="fai", help="genome index file")
parser.add_option_group(allgroup)
(options, args) = parser.parse_args()

def main():
    permutation(options.static,options.test,options.ncoord,options.fai,options.permutate_n)    

if __name__ == "__main__":
    main()   
