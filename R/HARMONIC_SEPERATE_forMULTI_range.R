#' Select significant HARMONIC terms within a condition range
#'
#' Filters HARMONIC comparison results to terms present in all selected conditions
#' (\code{condition_A:condition_B}) and exceeding an \code{FC} ratio against
#' the remaining conditions.
#'
#' @param input_COMPARE Path to the HARMONIC comparison table.
#' @param fileTABLE_path Path to a table listing conditions (used to determine number of columns).
#' @param FC Fold-change ratio cutoff used for filtering.
#' @param outputPATH Output path to write the filtered table.
#' @param condition_A Start condition index (1-based, matching your code convention).
#' @param condition_B End condition index (1-based, matching your code convention).
#'
#' @return Writes \code{outputPATH}. Returns \code{NULL} invisibly.
#'
#' @examples
#' stopifnot(is.function(HARMONIC_SEPERATE_forMULTI_range))
#' @export


HARMONIC_SEPERATE_forMULTI_range = function(input_COMPARE,
                                         fileTABLE_path,
                                         FC,
                                         outputPATH,
                                         condition_A,
                                         condition_B){

    DOWN_HARMONIC_COMPARE = utils::read.table(input_COMPARE, sep="\t", header=T, fill=TRUE)
    DOWN_HARMONIC_COMPARE = unique(DOWN_HARMONIC_COMPARE)

    fileTABLE = utils::read.table(fileTABLE_path, sep="\t", header=T, fill=TRUE)

    DOWN_HARMONIC_SEPERATE_tmp = DOWN_HARMONIC_COMPARE

    for(i in condition_A:condition_B){
        DOWN_HARMONIC_SEPERATE_tmp = DOWN_HARMONIC_SEPERATE_tmp[which(DOWN_HARMONIC_SEPERATE_tmp[,(i+1)] > 0),]
    }

    real_condition_A_pos = condition_A+1
    real_condition_B_pos = condition_B+1

    DOWN_HARMONIC_SEPERATE_tmp1 = DOWN_HARMONIC_SEPERATE_tmp[,c(1,real_condition_A_pos:real_condition_B_pos)]
    DOWN_HARMONIC_SEPERATE_tmp2 = DOWN_HARMONIC_SEPERATE_tmp[,c(-real_condition_A_pos:-real_condition_B_pos)]

    DOWN_HARMONIC_SEPERATE_sig_term = DOWN_HARMONIC_COMPARE[,1]
    DOWN_HARMONIC_SEPERATE_sig_term = as.data.frame(DOWN_HARMONIC_SEPERATE_sig_term)
    colnames(DOWN_HARMONIC_SEPERATE_sig_term) = "HARMONIC_TERM"

    finnum1 = ncol(DOWN_HARMONIC_SEPERATE_tmp1)-1

    DOWN_HARMONIC_SEPERATE_tmp2_tmp = DOWN_HARMONIC_SEPERATE_tmp2
    
    finnum2 = ncol(DOWN_HARMONIC_SEPERATE_tmp2_tmp)-1

    for(m in 1:finnum1){

        DOWN_HARMONIC_SEPERATE_tmp2_tmp = DOWN_HARMONIC_SEPERATE_tmp2
    
        for(n in 1:finnum2){
            DOWN_HARMONIC_SEPERATE_tmp2_tmp[,(n+1)] = DOWN_HARMONIC_SEPERATE_tmp1[,(m+1)]/(DOWN_HARMONIC_SEPERATE_tmp2_tmp[,(n+1)]+0.0000000001)
        }

        for(n in 1:finnum2){
            DOWN_HARMONIC_SEPERATE_tmp2_tmp = DOWN_HARMONIC_SEPERATE_tmp2_tmp[which(DOWN_HARMONIC_SEPERATE_tmp2_tmp[,(n+1)] >= FC),]
        }

    DOWN_HARMONIC_SEPERATE_sig_term_frag = DOWN_HARMONIC_SEPERATE_tmp2_tmp[,1]
    DOWN_HARMONIC_SEPERATE_sig_term_frag = as.data.frame(DOWN_HARMONIC_SEPERATE_sig_term_frag)
    colnames(DOWN_HARMONIC_SEPERATE_sig_term_frag) = "HARMONIC_TERM"

    DOWN_HARMONIC_SEPERATE_sig_term = dplyr::inner_join(DOWN_HARMONIC_SEPERATE_sig_term,
                                              DOWN_HARMONIC_SEPERATE_sig_term_frag,
                                              by = "HARMONIC_TERM")
        }

    DOWN_HARMONIC_SEPERATE_sig = dplyr::inner_join(DOWN_HARMONIC_SEPERATE_sig_term,DOWN_HARMONIC_COMPARE,by = "HARMONIC_TERM")

    utils::write.table(DOWN_HARMONIC_SEPERATE_sig,
                file = outputPATH, col.names=T, row.names=F, quote=F,sep="\t")
    }

