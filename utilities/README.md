# ONT Picoamperage Data Extraction Utilities 

## fast5_RNA2pAs
Extracts the mean picoamperage (pA) levels after event detection from a binary ONT FAST5 (HDF5) file and prints them to standard output.  
If you have a directory of *individual* FAST5 files (such as provided in this repo), you might do the following to generate individual 
text files of mean event level sequences:

```bash
for f in ../SquiggleStreamSource_FAST5_Files/R1_71_1/*.fast5; do fast5_RNA2pAs $f > ${f/fast5/event_means.txt}; done
```

# fasta_RNA2pAs
Translates a nucleotide sequence in FastA format into a sequence of expected mean picoamperage (pA) levels, using a k-mer model such as the one 
for RNA provided by ONT at https://raw.githubusercontent.com/nanoporetech/kmer_models/master/r9.4_180mv_70bps_5mer_RNA/template_median69pA.model

If multiple sequences are contained in the FastA file, each will be output to its own file with the prefix given as the third argument, and the 
name from the FastA description line (all characters up to the first space in the description line). An empty file output prefix can be used like so:

```shell
fasta_RNA2pAs template_median69pA.model ../controls/enolase.refMrna.fna ""
```
