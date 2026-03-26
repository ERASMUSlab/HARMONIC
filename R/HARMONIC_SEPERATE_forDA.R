#' Differential-activity (DA) tree filtering for selected conditions
#'
#' Given a HARMONIC_COMPARE table across multiple conditions, this function selects
#' trees that are active in all specified `condition` indices and satisfy a
#' fold-change separation criterion versus the remaining conditions.
#'
#' @param input_COMPARE Path to HARMONIC_COMPARE result file (tab-delimited).
#' @param fileTABLE_path Path to HARMONIC_PREPROCESSING_list file (tab-delimited).
#' @param FC Fold-change threshold for DA criterion.
#' @param outputPATH Output file path to write DA-filtered result (tab-delimited).
#' @param condition Integer vector of 1-based condition indices to define the POS set.
#'
#' @return Writes a table to `outputPATH`. Returns NULL invisibly.
#' @export
#'
#' @examples
#' stopifnot(is.function(HARMONIC_SEPERATE_forDA))
#' \donttest{
#' # HARMONIC_SEPERATE_forDA(
#' #   input_COMPARE = "HARMONIC_COMPARE.txt",
#' #   fileTABLE_path = "HARMONIC_PREPROCESSING_list.txt",
#' #   filepath = ".",
#' #   DEG_list_name = "input_DEG_list.txt",
#' #   FC = 2,
#' #   outputPATH = "HARMONIC_SEPERATE_forDA.txt",
#' #   condition = c(1, 2)
#' # )
#' }

HARMONIC_SEPERATE_forDA = function(input_COMPARE,
                                fileTABLE_path,
                                FC,
                                outputPATH,
                                condition){
    
    DOWN_HARMONIC_COMPARE = utils::read.table(input_COMPARE, sep="\t", header=TRUE, fill=TRUE)
    DOWN_HARMONIC_COMPARE = unique(DOWN_HARMONIC_COMPARE)
    fileTABLE = utils::read.table(fileTABLE_path, sep="\t", header=TRUE, fill=TRUE)

    DOWN_HARMONIC_SEPERATE_tmp = DOWN_HARMONIC_COMPARE

    condition_DF = as.data.frame(condition)
    colnames(condition_DF) = "condition"

    for(i in 1:nrow(condition_DF)){
        col = condition[i] + 1
        DOWN_HARMONIC_SEPERATE_tmp = DOWN_HARMONIC_SEPERATE_tmp[which(DOWN_HARMONIC_SEPERATE_tmp[,col] > 0),]
    }

    if(nrow(DOWN_HARMONIC_SEPERATE_tmp)==0){
        print("Number of DA result tree ls")
        print(nrow(DOWN_HARMONIC_SEPERATE_tmp))
    }

    if(nrow(DOWN_HARMONIC_SEPERATE_tmp)>0){

        ALLcondition = c(1:nrow(fileTABLE))
        ALLcondition_DF = as.data.frame(ALLcondition)
        colnames(ALLcondition_DF) = "condition"

        NEGAcondition_DF = dplyr::anti_join(ALLcondition_DF,condition_DF,by = "condition")
        NEGAcondition = NEGAcondition_DF[,1]

        HARMONIC_SEPERATE_condition = DOWN_HARMONIC_SEPERATE_tmp[,c(1,condition+1)]
        HARMONIC_SEPERATE_NEGAcondition = DOWN_HARMONIC_SEPERATE_tmp[,c(1,NEGAcondition+1)]

        HARMONIC_SEPERATE_condition$min = 0
        HARMONIC_SEPERATE_condition$mean = 0

        for(i in 1:nrow(HARMONIC_SEPERATE_condition)){
            HARMONIC_SEPERATE_condition[i,(ncol(HARMONIC_SEPERATE_condition)-1)] = min(t(HARMONIC_SEPERATE_condition[i,c(2:(1+nrow(condition_DF)))])[,1])
            HARMONIC_SEPERATE_condition[i,ncol(HARMONIC_SEPERATE_condition)] = mean(t(HARMONIC_SEPERATE_condition[i,c(2:(1+nrow(condition_DF)))])[,1])
        }

        HARMONIC_SEPERATE_NEGAcondition$max = 0
        HARMONIC_SEPERATE_NEGAcondition$mean = 0

        for(i in 1:nrow(HARMONIC_SEPERATE_NEGAcondition)){
            HARMONIC_SEPERATE_NEGAcondition[i,(ncol(HARMONIC_SEPERATE_NEGAcondition)-1)] = max(t(HARMONIC_SEPERATE_NEGAcondition[i,c(2:(1+nrow(NEGAcondition_DF)))])[,1])
            HARMONIC_SEPERATE_NEGAcondition[i,ncol(HARMONIC_SEPERATE_NEGAcondition)] = mean(t(HARMONIC_SEPERATE_NEGAcondition[i,c(2:(1+nrow(NEGAcondition_DF)))])[,1])
        }

        DOWN_HARMONIC_SEPERATE_tmp$DA = "F"

        for(i in 1:nrow(DOWN_HARMONIC_SEPERATE_tmp)){
        
            POS_MIN = HARMONIC_SEPERATE_condition[i,(ncol(HARMONIC_SEPERATE_condition)-1)]
            POS_MEAM = HARMONIC_SEPERATE_condition[i,ncol(HARMONIC_SEPERATE_condition)]
            NEGA_MAX = HARMONIC_SEPERATE_NEGAcondition[i,(ncol(HARMONIC_SEPERATE_NEGAcondition)-1)]
            NEGA_MEAM = HARMONIC_SEPERATE_NEGAcondition[i,ncol(HARMONIC_SEPERATE_NEGAcondition)]

            if(POS_MIN>NEGA_MAX*FC){
                if(POS_MEAM>NEGA_MEAM*FC){
                    DOWN_HARMONIC_SEPERATE_tmp[i,ncol(DOWN_HARMONIC_SEPERATE_tmp)] = "T"
                }
            }
        }

        DOWN_HARMONIC_SEPERATE = DOWN_HARMONIC_SEPERATE_tmp
        DOWN_HARMONIC_SEPERATE = DOWN_HARMONIC_SEPERATE[which(DOWN_HARMONIC_SEPERATE[,ncol(DOWN_HARMONIC_SEPERATE)] == "T"),-ncol(DOWN_HARMONIC_SEPERATE)]

        if(nrow(DOWN_HARMONIC_SEPERATE)==0){
            print("Number of DA result tree ls")
            print(nrow(DOWN_HARMONIC_SEPERATE))
        }

        if(nrow(DOWN_HARMONIC_SEPERATE)>0){
            cond_str <- paste0("c(", paste(condition, collapse = ","), ")")
            DOWN_HARMONIC_SEPERATE$label = cond_str

            print("Number of DA result tree ls")
            print(nrow(DOWN_HARMONIC_SEPERATE))
            
            utils::write.table(DOWN_HARMONIC_SEPERATE,
                               file = outputPATH,
                               col.names=TRUE, row.names=FALSE, quote=FALSE, sep="\t")
        }
    }
}
