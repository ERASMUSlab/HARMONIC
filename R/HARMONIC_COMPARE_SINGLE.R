#' Compute HARMONIC tree scores for a single case
#'
#' Single-condition version of \code{HARMONIC_COMPARE}. Produces a one-column
#' comparison table for the single case.
#'
#' @param input_TERMLISTING Path to the tree/subtree table produced by term listing.
#' @param filepath Base directory containing \code{DEG_list_name}.
#' @param fileTABLE_path Path to a table listing a single HARMONIC preprocessing file.
#' @param DEG_list_name DEG list filename under \code{filepath}.
#' @param GOTABLE_path Path to the GO list table written by preprocessing.
#' @param PASSED_NUM Threshold on passed dependency count (column 3).
#' @param outputPATH Output path to write the comparison table.
#'
#' @return Writes \code{outputPATH}. Returns \code{NULL} invisibly.
#'
#' @examples
#' stopifnot(is.function(HARMONIC_COMPARE_SINGLE))
#' @export


HARMONIC_COMPARE_SINGLE = function(input_TERMLISTING,
                                filepath,
                                fileTABLE_path,
                                DEG_list_name,
                                GOTABLE_path,
                                PASSED_NUM,
                                outputPATH){
    
    DEG_list_path = paste0(filepath,"/",DEG_list_name)
    DEG_list_pathDF = as.data.frame(DEG_list_path)

    HARMONIC_TERMLISTING = utils::read.table(input_TERMLISTING, sep="\t", header=T, fill=TRUE)
    HARMONIC_TERMLISTING = unique(HARMONIC_TERMLISTING)

    fileTABLE = utils::read.table(fileTABLE_path, sep="\t", header=T, fill=TRUE)
    GOTABLE = utils::read.table(GOTABLE_path, sep="\t", header=T, fill=TRUE)

    i = 1

    GO_RAW = utils::read.delim(GOTABLE[i,1], sep = "\t", header = TRUE, quote = "", comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
    GO_DF = GO_RAW[,c(2,5)]
    colnames(GO_DF)[2] = paste0("RF_",i)

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

    HARMONIC_TERM = cbind(HARMONIC_TERM,0)
    colnames(HARMONIC_TERM)[2] = paste0("RF_",1)

    HARMONIC_TERM$label = "PASS"

    for(i in 1:nrow(HARMONIC_TERM)){
        
        TREEset = as.data.frame(strsplit(HARMONIC_TERM[i,1], split = "//"))
        colnames(TREEset) = "Description"

    for(s in 1:nrow(TREEset)){
            TREEset[s,1] = gsub("_", " ", TREEset[s,1])
        }

    ratio_mom = nrow(TREEset)

    TREEset = dplyr::left_join(TREEset,GO_DF,by="Description")
    TREEset[is.na(TREEset)] = 0

    TREEset_pos = TREEset[which(TREEset[,2] > 0),]

    if(nrow(TREEset_pos)<PASSED_NUM){HARMONIC_TERM[i,ncol(HARMONIC_TERM)] = "FALSE"}

    ratio_son = nrow(TREEset)
    ratio_hit = ratio_son/ratio_mom

        e = 1

    GO_RAW = utils::read.delim(GOTABLE[e,1], sep = "\t", header = TRUE, quote = "", comment.char = "", stringsAsFactors = FALSE, fill = TRUE)
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
            HARMONIC_TERM[i,2] = mean(TREEset[[2]][TREEset[[2]] != 0])
            HARMONIC_TERM[i,2] = HARMONIC_TERM[i,2]*ratio_hit
                                 }

    HARMONIC_TERM[is.na(HARMONIC_TERM)] = 0
    HARMONIC_TERM = HARMONIC_TERM[which(HARMONIC_TERM[,3] == "PASS"),1:2]

    utils::write.table(HARMONIC_TERM,
                file = outputPATH, col.names=T, row.names=F, quote=F,sep="\t")
    }
