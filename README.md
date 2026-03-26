# HARMONIC: Hierarchy-based Active-tree Redundancy-Minimized ONtology Integrative Comparator
HARMONIC is an R package for Gene Ontology (GO) Biological Process enrichment analysis that reduces redundancy in top-ranked results by restructuring enriched terms into ontology-guided term trees based on the GO DAG. It defines and filters active trees using coverage/consistency criteria to suppress structurally driven false positives arising from hierarchical dependencies. HARMONIC supports single- and multiple- case study designs by integrating enrichment outputs across conditions, providing scoring options and visualization utilities to summarize common and condition-specific biological processes. Optional features include ORA-style soft filtering and fold-change-aware weighting for tree and term prioritization.

![Alt text](./FIG/HARMONIC_F1.jpg "HARMONIC")
>- **Problem:** GO Biological Process enrichment results are often dominated by biologically similar top terms, and GO’s hierarchical DAG + gene sharing can create **structural false positives**, reducing interpretability and confidence.
>- **Solution (HARMONIC):** An analytical framework that reorganizes GO outputs into **ontology-informed term trees** and applies **structural filtering** based on **within-tree consistency**.
>- **Key idea 1 — Tree organizing:** HARMONIC groups similar terms into trees to reduce redundancy and compress results into interpretable units.
>- **Key idea 2 — Active-tree filtering:** HARMONIC suppresses isolated, single-term–driven signals using an **active-tree criterion**.
>- **Multiple-case support:** HARMONIC aligns results from multiple comparisons into a **shared tree structure** and classifies **common vs condition-specific** trees using **HWES** and relative signal strength across conditions.
>- **Parameter recommendations:** A parameter search provides **input-size–specific recommended settings**.
>- **Benchmarking:** Evaluated across **31 single-case analyses** against **ORA** and **GSEA** using **adjusted p-values**, **fraction of terms assigned**, and **rich factors** to assess interpretability.
>- **Validation:** Demonstrated reproduction of reported signals across public datasets spanning **knockout**, **cancer**, **differentiation**, **dose–response**, and **cohort** designs.
>- **Usability:** Provides **R-based visualization functions** for both single- and multiple-case settings to aid interpretation.
>- **Take-home:** HARMONIC reduces redundancy and structural false positives driven by the GO DAG, enabling **reproducible term-pattern summarization** for multi-comparison studies.

## Installation

### Linux / macOS (Using conda OR micromamba at terminal)

```bash
micromamba create -n HARMONIC
micromamba activate HARMONIC

micromamba install -c conda-forge -c r -c bioconda -y \
jupyter_core jupyter_client jupyterlab_pygments jupyter_server r-irkernel jupyterlab r=4.3.1

micromamba install -c conda-forge -c r -c bioconda -y \
r-png r-data.table r-systemfonts r-gdtools r-ggforce r-ggiraph bioconductor-xvector bioconductor-sparsearray \
bioconductor-biostrings bioconductor-delayedarray bioconductor-summarizedexperiment bioconductor-annotationdbi \
bioconductor-go.db bioconductor-keggrest bioconductor-fgsea bioconductor-deseq2 bioconductor-gosemsim pigz \
bioconductor-dose bioconductor-enrichplot bioconductor-clusterprofiler bioconductor-ggtree \
bioconductor-org.mm.eg.db bioconductor-org.hs.eg.db

mkdir path_to_HARMONICanalysis
wget -P path_to_HARMONICanalysis https://github.com/user-attachments/files/25776389/HARMONIC_FORMAT.tar.gz
### ex) wget -P /home/RNA/gitHARMONIC/ https://github.com/user-attachments/files/25776389/HARMONIC_FORMAT.tar.gz

cd path_to_HARMONICanalysis
pigz -dc -p 4 HARMONIC_FORMAT.tar.gz | tar -xf -

mv HARMONIC_FORMAT HARMONIC_project_name
### ex) mv HARMONIC_FORMAT HARMONIC_DIFF

cd HARMONIC_project_name/HARMONIC
pwd
### result of pwd is filepath we use in R

cd count
cp path_to_input_countMATRIX RAWcount.txt
### ex) cp RAWcount_DIFF.txt RAWcount.txt
```

### R


```r
# install.packages("remotes")
remotes::install_github("ERASMUSlab/HARMONIC")

HARMONIC_ANALYSIS(filepath = "/home/RNA/gitHARMONIC/HARMONIC_DIFF/HARMONIC",
               type = "broad",
               full_condition = c("DAY0","DAY4","DAY7","DAY10","DAY14","DAY21"),
               number_of_rep = c(3,3,3,6,3,3),
               DEG_list_name = "input_DEG_list.txt",
               mango_design = c("DAY4_DAY0_UP","DAY7_DAY0_UP","DAY10_DAY0_UP","DAY14_DAY0_UP","DAY21_DAY0_UP"),
               core = 5,
               ref_genome = "mm",
               PASSED_RATIO = 15,
               PASSED_NUM = 3,
               similarity = 80,
               FC = 2, 
               condition = c(1,3), 
               dynamic_analyisis = "T",
               preprocessing = "T")
```

## Documentation

Full documentation and tutorials:
https://erasmuslab.github.io/HARMONIC


## Citation

If you use HARMONIC in your research, please cite:
https://erasmuslab.github.io/HARMONIC/authors.html#citation
