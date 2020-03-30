# Download 1000G files (https://www.cog-genomics.org/plink/2.0/resources#1kg_phase3)
wget https://www.dropbox.com/s/asn2ehkkwh4vjhr/all_phase3_ns.pgen.zst?dl=1
wget https://www.dropbox.com/s/7ok88895fwnvpuf/all_phase3_ns.pvar.zst?dl=1
wget https://www.dropbox.com/s/yozrzsdrwqej63q/phase3_corrected.psam?dl=1
## manually remove strange suffix on filenames


# Perform Plink restructuring of data
module load plink2

# Decompress data
plink2 --zst-decompress all_phase3_ns.pgen.zst > all_phase3_ns.pgen
plink2 --zst-decompress all_phase3_ns.pvar.zst > all_phase3_ns.pvar
## manually rename sample file to all_phase3_ns.psam

# Perform data checks
plink2 --pfile all_phase3_ns --pgen-info --out info

# Subset variants
plink2 --pfile all_phase3_ns --extract inference_SNPs.txt --make-pgen --out all_phase3_sub
plink2 --pfile all_phase3_sub --pgen-info --out info_sub

# Calculate PCs
plink2 --pfile all_phase3_sub --pca 20
