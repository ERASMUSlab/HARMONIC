#' Build the HARMONIC term tree list across multiple cases
#'
#' Aggregates \code{total_Dependency} strings across preprocessing outputs,
#' computes pairwise overlap ratio, and creates a tree/subtree mapping based on
#' a similarity threshold.
#'
#' @param PASSED_RATIO Threshold on \code{Ratio_of_passed_Dependency} (column 4).
#' @param PASSED_NUM Threshold on passed dependency count (column 3).
#' @param similarity Similarity cutoff (%) used to define similar trees.
#' @param fileTABLE_path Path to a table listing HARMONIC preprocessing files (one per row).
#' @param outputPATH Output path to write the final tree/subtree table.
#'
#' @return Writes \code{outputPATH}. Returns \code{NULL} invisibly.
#'
#' @examples
#' stopifnot(is.function(HARMONIC_TERMLISTING))
#' @export


HARMONIC_TERMLISTING = function(PASSED_RATIO,
                             PASSED_NUM,
                             similarity,
                             fileTABLE_path,
                             outputPATH){

    fileTABLE = utils::read.table(fileTABLE_path, sep="\t", header=T, fill=TRUE)

    HARMONIC_PREPROCESSING = utils::read.table(fileTABLE[1,1], sep="\t", header=T, fill=TRUE)
    HARMONIC_PREPROCESSING = HARMONIC_PREPROCESSING[which(HARMONIC_PREPROCESSING[,4] >= PASSED_RATIO),]
    HARMONIC_PREPROCESSING = HARMONIC_PREPROCESSING[which(HARMONIC_PREPROCESSING[,3] >= PASSED_NUM),]
    HARMONIC_PREPROCESSING = HARMONIC_PREPROCESSING[order(-HARMONIC_PREPROCESSING$Ratio_of_passed_Dependency),]

    HARMONIC_TREE = HARMONIC_PREPROCESSING[,6]
    HARMONIC_TREE = as.data.frame(HARMONIC_TREE)
    colnames(HARMONIC_TREE) = "total_Dependency"

    for(i in 2:nrow(fileTABLE)){
        HARMONIC_PREPROCESSING = utils::read.table(fileTABLE[i,1], sep="\t", header=T, fill=TRUE)
        HARMONIC_PREPROCESSING = HARMONIC_PREPROCESSING[which(HARMONIC_PREPROCESSING[,4] >= PASSED_RATIO),]
        HARMONIC_PREPROCESSING = HARMONIC_PREPROCESSING[which(HARMONIC_PREPROCESSING[,3] >= PASSED_NUM),] 
        HARMONIC_PREPROCESSING = HARMONIC_PREPROCESSING[order(-HARMONIC_PREPROCESSING$Ratio_of_passed_Dependency),]
    
        HARMONIC_TREE_frag = HARMONIC_PREPROCESSING[,6]
        HARMONIC_TREE_frag = as.data.frame(HARMONIC_TREE_frag)
        colnames(HARMONIC_TREE_frag) = "total_Dependency"

        HARMONIC_TREE = rbind(HARMONIC_TREE,HARMONIC_TREE_frag)
    }

    HARMONIC_TREE = unique(HARMONIC_TREE)

    HARMONIC_TREE_BB = HARMONIC_TREE

    HARMONIC_TREE_COMPARE = cbind(HARMONIC_TREE_BB[1,1],HARMONIC_TREE_BB)
    colnames(HARMONIC_TREE_COMPARE) = c("T1","T2")

    for(i in 2:nrow(HARMONIC_TREE_BB)){
        HARMONIC_TREE_COMPARE_frag = cbind(HARMONIC_TREE_BB[i,1],HARMONIC_TREE_BB)
        colnames(HARMONIC_TREE_COMPARE_frag) = c("T1","T2")
        HARMONIC_TREE_COMPARE = rbind(HARMONIC_TREE_COMPARE,HARMONIC_TREE_COMPARE_frag)
        }

    HARMONIC_TREE_COMPARE$RATIO = 0

    for(i in 1:nrow(HARMONIC_TREE_COMPARE)){
        T1 = as.data.frame(strsplit(HARMONIC_TREE_COMPARE[i,1], split = "//"))
        T2 = as.data.frame(strsplit(HARMONIC_TREE_COMPARE[i,2], split = "//"))
    
        colnames(T1) = "Term"
        colnames(T2) = "Term"
    
        inter = nrow(dplyr::inner_join(T1,T2,by = "Term"))
        nT1 = nrow(T1)
        nT2 = nrow(T2)
    
        if(nT1>=nT2){mom = nT1}
        if(nT1<nT2){mom = nT2}
    
    HARMONIC_TREE_COMPARE[i,3] = round((inter/mom)*100,3)
    }

    HARMONIC_TREE_COMPARE_SIM = HARMONIC_TREE_COMPARE[which(HARMONIC_TREE_COMPARE[,3] >= similarity),]
    HARMONIC_TREE_COMPARE_DIFF = HARMONIC_TREE_COMPARE[which(HARMONIC_TREE_COMPARE[,3] < similarity),]

    HARMONIC_TREE_COMPARE_SIM_NOT100 = HARMONIC_TREE_COMPARE_SIM[which(HARMONIC_TREE_COMPARE_SIM[,3] < 100),]

    if(nrow(HARMONIC_TREE_COMPARE_SIM_NOT100) == 0){
        HARMONIC_TREE_simlist = as.data.frame(matrix(ncol=2, nrow=0))
        colnames(HARMONIC_TREE_simlist) = c("tree","subtree")
    
        HARMONIC_TREE_simlist_frag = as.data.frame(matrix(ncol=2, nrow=0))
        colnames(HARMONIC_TREE_simlist_frag) = c("tree","subtree")
    } 
    else {

        i = 1
        T1 = nrow(as.data.frame(strsplit(HARMONIC_TREE_COMPARE_SIM_NOT100[i,1], split = "//")))
        T2 = nrow(as.data.frame(strsplit(HARMONIC_TREE_COMPARE_SIM_NOT100[i,2], split = "//")))

        if(T1>=T2){
            HARMONIC_TREE_simlist = cbind(HARMONIC_TREE_COMPARE_SIM_NOT100[i,1],HARMONIC_TREE_COMPARE_SIM_NOT100[i,2])
            HARMONIC_TREE_simlist = as.data.frame(HARMONIC_TREE_simlist)
            colnames(HARMONIC_TREE_simlist) = c("tree","subtree")
            }

        if(T1<T2){
            HARMONIC_TREE_simlist = cbind(HARMONIC_TREE_COMPARE_SIM_NOT100[i,2],HARMONIC_TREE_COMPARE_SIM_NOT100[i,1])
            HARMONIC_TREE_simlist = as.data.frame(HARMONIC_TREE_simlist)
            colnames(HARMONIC_TREE_simlist) = c("tree","subtree")
            }

        for(i in 2:nrow(HARMONIC_TREE_COMPARE_SIM_NOT100)){
            T1 = nrow(as.data.frame(strsplit(HARMONIC_TREE_COMPARE_SIM_NOT100[i,1], split = "//")))
            T2 = nrow(as.data.frame(strsplit(HARMONIC_TREE_COMPARE_SIM_NOT100[i,2], split = "//")))
        
            if(T1>=T2){
                HARMONIC_TREE_simlist_frag = cbind(HARMONIC_TREE_COMPARE_SIM_NOT100[i,1],HARMONIC_TREE_COMPARE_SIM_NOT100[i,2])
                HARMONIC_TREE_simlist_frag = as.data.frame(HARMONIC_TREE_simlist_frag)
                colnames(HARMONIC_TREE_simlist_frag) = c("tree","subtree")
                }

            if(T1<T2){
                HARMONIC_TREE_simlist_frag = cbind(HARMONIC_TREE_COMPARE_SIM_NOT100[i,2],HARMONIC_TREE_COMPARE_SIM_NOT100[i,1])
                HARMONIC_TREE_simlist_frag = as.data.frame(HARMONIC_TREE_simlist_frag)
                colnames(HARMONIC_TREE_simlist_frag) = c("tree","subtree")
                }

            HARMONIC_TREE_simlist = rbind(HARMONIC_TREE_simlist,HARMONIC_TREE_simlist_frag)
            HARMONIC_TREE_simlist = unique(HARMONIC_TREE_simlist)
            }
        } 

    HARMONIC_TREE_simlist_tree_1 = HARMONIC_TREE_simlist[,1]
    HARMONIC_TREE_simlist_tree_1 = as.data.frame(HARMONIC_TREE_simlist_tree_1)
    HARMONIC_TREE_simlist_tree_1 = unique(HARMONIC_TREE_simlist_tree_1)
    HARMONIC_TREE_simlist_tree_1 = as.data.frame(HARMONIC_TREE_simlist_tree_1)
    colnames(HARMONIC_TREE_simlist_tree_1) = "tree"

    HARMONIC_TREE_simlist_tree_2 = HARMONIC_TREE_simlist[,2]
    HARMONIC_TREE_simlist_tree_2 = as.data.frame(HARMONIC_TREE_simlist_tree_2)
    HARMONIC_TREE_simlist_tree_2 = unique(HARMONIC_TREE_simlist_tree_2)
    HARMONIC_TREE_simlist_tree_2 = as.data.frame(HARMONIC_TREE_simlist_tree_2)
    colnames(HARMONIC_TREE_simlist_tree_2) = "tree"

    HARMONIC_TREE_simlist_1 = rbind(HARMONIC_TREE_simlist_tree_1,HARMONIC_TREE_simlist_tree_2)
    HARMONIC_TREE_simlist_1 = unique(HARMONIC_TREE_simlist_1)
    HARMONIC_TREE_simlist_1 = as.data.frame(HARMONIC_TREE_simlist_1)
    colnames(HARMONIC_TREE_simlist_1) = "tree"

    HARMONIC_TREE_COMPARE_SIM_100 = HARMONIC_TREE_COMPARE_SIM[which(HARMONIC_TREE_COMPARE_SIM[,3] == 100),]

    HARMONIC_TREE_simlist_2 = as.data.frame(HARMONIC_TREE_COMPARE_SIM_100[,1])
    HARMONIC_TREE_simlist_2 = unique(HARMONIC_TREE_simlist_2)
    HARMONIC_TREE_simlist_2 = as.data.frame(HARMONIC_TREE_simlist_2)
    colnames(HARMONIC_TREE_simlist_2) = "tree"

    HARMONIC_TREE_simlist_tree = rbind(HARMONIC_TREE_simlist_tree_1,HARMONIC_TREE_simlist_tree_2)

    HARMONIC_TREE_simlist_tree = unique(HARMONIC_TREE_simlist_tree)
    HARMONIC_TREE_simlist_tree = as.data.frame(HARMONIC_TREE_simlist_tree)
    colnames(HARMONIC_TREE_simlist_tree) = "tree"

    HARMONIC_TREE_simlist_tree$tree <- as.character(HARMONIC_TREE_simlist_tree$tree)

    HARMONIC_TREE_simlist_2 = as.data.frame(HARMONIC_TREE_COMPARE_SIM_100[,1])
    HARMONIC_TREE_simlist_2 = unique(HARMONIC_TREE_simlist_2)
    HARMONIC_TREE_simlist_2 = as.data.frame(HARMONIC_TREE_simlist_2)
    colnames(HARMONIC_TREE_simlist_2) = "tree"
    HARMONIC_TREE_simlist_2$subtree = "NOT"

    HARMONIC_TREE_simlist = rbind(HARMONIC_TREE_simlist,HARMONIC_TREE_simlist_2)
    HARMONIC_TREE_simlist = unique(HARMONIC_TREE_simlist)

    HARMONIC_TREE_simlist_REST = as.data.frame(HARMONIC_TREE_COMPARE_DIFF[,1])
    HARMONIC_TREE_simlist_REST = unique(HARMONIC_TREE_simlist_REST)
    HARMONIC_TREE_simlist_REST = as.data.frame(HARMONIC_TREE_simlist_REST)
    colnames(HARMONIC_TREE_simlist_REST) = "tree"
    HARMONIC_TREE_simlist_REST = dplyr::anti_join(HARMONIC_TREE_simlist_REST,HARMONIC_TREE_simlist_tree,by = "tree")
    HARMONIC_TREE_simlist_REST$subtree = "NOT"

    HARMONIC_TREE = rbind(HARMONIC_TREE_simlist,HARMONIC_TREE_simlist_REST)

    utils::write.table(HARMONIC_TREE,
                file = outputPATH, col.names=T, row.names=F, quote=F,sep="\t")
    }
