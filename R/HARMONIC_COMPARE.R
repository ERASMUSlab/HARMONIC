#' Compute HARMONIC tree scores across multiple cases
#'
#' For each HARMONIC tree (term dependency string), maps to GO descriptions and
#' calculates a per-condition score using rich factor and DEG fold-change
#' information, producing a comparison matrix.
#'
#' @param input_TERMLISTING Path to the tree/subtree table produced by term listing.
#' @param filepath Base directory containing \code{DEG_list_name}.
#' @param fileTABLE_path Path to a table listing HARMONIC preprocessing files (one per row).
#' @param DEG_list_name DEG list filename under \code{filepath}.
#' @param GOTABLE_path Path to the GO list table written by preprocessing.
#' @param outputPATH Output path to write the comparison table.
#'
#' @return Writes \code{outputPATH}. Returns \code{NULL} invisibly.
#'
#' @examples
#' stopifnot(is.function(HARMONIC_COMPARE))
#' @export


HARMONIC_COMPARE = function(input_TERMLISTING,
                                filepath,
                                fileTABLE_path,
                                DEG_list_name,
                                GOTABLE_path,
                                outputPATH){

    DEG_list_path = paste0(filepath,"/",DEG_list_name)
    DEG_list_pathDF = as.data.frame(DEG_list_path)

    HARMONIC_TERMLISTING = utils::read.table(input_TERMLISTING, sep="\t", header=T, fill=TRUE)
    HARMONIC_TERMLISTING = unique(HARMONIC_TERMLISTING)

    fileTABLE = utils::read.table(fileTABLE_path, sep="\t", header=T, fill=TRUE)
    GOTABLE = utils::read.table(GOTABLE_path, sep="\t", header=T, fill=TRUE)

    i = 1

    GO_RAW = utils::read.delim(GOTABLE[i,1], sep = "\t", header = TRUE, quote = "", comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
    ####GO_RAW = read.table(GOTABLE[i,1], sep="\t", header=T, fill=TRUE)
    GO_DF = GO_RAW[,c(2,5)]
    colnames(GO_DF)[2] = paste0("RF_",i)

    for(i in 2:nrow(GOTABLE)){
        GO_RAW = utils::read.delim(GOTABLE[i,1], sep = "\t", header = TRUE, quote = "", comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
        ####GO_RAW = read.table(GOTABLE[i,1], sep="\t", header=T, fill=TRUE)
        GO_DF_frag = GO_RAW[,c(2,5)]
        colnames(GO_DF_frag)[2] = paste0("RF_",i)

        GO_DF = dplyr::full_join(GO_DF,GO_DF_frag,by="Description")
    }

    GO_DF[is.na(GO_DF)] = 0

    HARMONIC_TERM = HARMONIC_TERMLISTING[,1]
    HARMONIC_TERM = as.data.frame(HARMONIC_TERM)
    HARMONIC_TERM = unique(HARMONIC_TERM)
    HARMONIC_TERM = as.data.frame(HARMONIC_TERM)
    colnames(HARMONIC_TERM) = "HARMONIC_TERM"

    HARMONIC_TERM_EX = HARMONIC_TERMLISTING[,2]
    HARMONIC_TERM_EX = as.data.frame(HARMONIC_TERM_EX)
    HARMONIC_TERM_EX = unique(HARMONIC_TERM_EX)
    HARMONIC_TERM_EX = as.data.frame(HARMONIC_TERM_EX)
    colnames(HARMONIC_TERM_EX) = "HARMONIC_TERM"

    HARMONIC_TERM = dplyr::anti_join(HARMONIC_TERM,HARMONIC_TERM_EX,by="HARMONIC_TERM")
    HARMONIC_TERM = unique(HARMONIC_TERM)

    for(i in 1:nrow(fileTABLE)){
        HARMONIC_TERM = cbind(HARMONIC_TERM,0)
        colnames(HARMONIC_TERM)[i+1] = paste0("RF_",i)
    }

    for(i in 1:nrow(HARMONIC_TERM)){
        TREEset = as.data.frame(strsplit(HARMONIC_TERM[i,1], split = "//"))
        colnames(TREEset) = "Description"

    ratio_mom = nrow(TREEset)

    for(s in 1:nrow(TREEset)){
            TREEset[s,1] = gsub("_", " ", TREEset[s,1])
        }
    
    TREEset = dplyr::left_join(TREEset,GO_DF,by="Description")
    TREEset[is.na(TREEset)] = 0

    TREEset_cal = dplyr::inner_join(TREEset,GO_DF,by="Description")
        TREEset_cal[is.na(TREEset_cal)] = 0

        ratio_son = nrow(TREEset_cal)

        ratio_hit = ratio_son/ratio_mom*100
        ratio_hit = log2(ratio_hit)

    for(e in 1:nrow(GOTABLE)){
        
    GO_RAW = utils::read.delim(GOTABLE[e,1], sep = "\t", header = TRUE, quote = "", comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
    ####GO_RAW = read.table(GOTABLE[e,1], sep="\t", header=T, fill=TRUE)
    DEG_list = utils::read.table(DEG_list_pathDF[1,1], sep="\t", header=F, fill=TRUE)
    DEG_RAW = utils::read.table(DEG_list[e,1], sep="\t", header=T, fill=TRUE)

    for(w in 1:nrow(TREEset)){

    Description_genelist = as.data.frame(strsplit(GO_RAW[which(GO_RAW$Description == TREEset[w,1]),11], split = "/"))

    if(nrow(Description_genelist)>0){
        colnames(Description_genelist) = "gene"
        Description_genelist = dplyr::inner_join(Description_genelist,DEG_RAW,by="gene")
        TREEset[w,(e+1)] = 1/(log10(TREEset[w,(e+1)])*(-1))*median(abs(Description_genelist[,3]))
        }
        }

    }

    for(z in 1:nrow(fileTABLE)){
            HARMONIC_TERM[i,(z+1)] = mean(TREEset[[z+1]][TREEset[[z+1]] != 0])*ratio_hit
        }
    }

    HARMONIC_TERM[is.na(HARMONIC_TERM)] = 0

    utils::write.table(HARMONIC_TERM,
                file = outputPATH, col.names=T, row.names=F, quote=F,sep="\t")
    }

