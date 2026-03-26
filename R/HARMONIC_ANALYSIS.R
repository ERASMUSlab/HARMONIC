#' Run the HARMONIC analysis pipeline
#'
#' Orchestrates preprocessing (optional), term listing, comparison, and separation.
#' Supports both single- and multi-condition workflows.
#'
#' @param filepath Working directory path.
#' @param type DEG calling mode. One of \code{"standard"} or \code{"broad"}.
#'   \code{"standard"} uses \code{adjp=0.05} and \code{FC=2}; \code{"broad"} uses
#'   \code{adjp=0.05} and \code{FC=1.5}.
#' @param full_condition Character vector of condition names (must match sample condition labels).
#' @param number_of_rep Integer vector of replicate counts for each condition in \code{full_condition}.
#' @param mango_design Character vector specifying contrasts and direction to export.
#' @param DEG_list_name DEG list filename under \code{filepath}.
#' @param ref_genome Reference genome code (\code{"mm"} or \code{"hs"}).
#' @param core Number of cores.
#' @param PASSED_RATIO Passed dependency ratio threshold.
#' @param PASSED_NUM Passed dependency count threshold.
#' @param similarity Similarity cutoff (%).
#' @param FC Fold-change ratio cutoff.
#' @param condition condition index for dynamic analysis.
#' @param dynamic_analyisis \code{"T"} or \code{"F"} to enable multi-range filtering.
#' @param preprocessing \code{"T"} or \code{"F"} to run preprocessing inside this function.
#'
#' @return Writes output files to disk. Returns \code{NULL} invisibly.
#'
#' @examples
#' stopifnot(is.function(HARMONIC_ANALYSIS))
#' \dontrun{
#' HARMONIC_ANALYSIS(
#'   filepath=".",
#'   DEG_list_name="input_DEG_list.txt",
#'   ref_genome="mm",
#'   core=1,
#'   PASSED_RATIO=15,
#'   PASSED_NUM=4,
#'   similarity=70,
#'   type = "broad",
#'   full_condition = c("DAY0","DAY4","DAY7","DAY10","DAY14","DAY21"),
#'   number_of_rep = c(3,3,3,6,3,3),
#'   mango_design = c("DAY4_DAY0_UP","DAY7_DAY0_UP","DAY10_DAY0_UP","DAY14_DAY0_UP","DAY21_DAY0_UP")
#' )
#' }
#' @export


HARMONIC_ANALYSIS = function(filepath,
                          DEG_list_name,
                          ref_genome,
                          core = 1,
                          PASSED_RATIO,
                          PASSED_NUM,
                          similarity,
			  type = "standard",
                          full_condition,
                          number_of_rep,
                          mango_design,
                          FC = 2,
                          condition = 1,
			  dynamic_analyisis = "F",
                          preprocessing = "F"){

    print("Fixed path is")
    print(filepath)
    setwd(filepath)

    DEG_list_path = paste0(filepath,"/",DEG_list_name)
    DEG_list_pathDF = as.data.frame(DEG_list_path)

    TXTbased = nrow(as.data.frame(DEG_list_pathDF[grepl("txt", DEG_list_pathDF[,1]),]))
    CSVbased = nrow(as.data.frame(DEG_list_pathDF[grepl("csv", DEG_list_pathDF[,1]),]))
    BEDbased = nrow(as.data.frame(DEG_list_pathDF[grepl("bed", DEG_list_pathDF[,1]),]))

    if(TXTbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(DEG_list_pathDF[,1], split = "_list.txt"))[1,1],"_GO_list.txt")}
    if(CSVbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(DEG_list_pathDF[,1], split = "_list.csv"))[1,1],"_GO_list.csv")}
    if(BEDbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(DEG_list_pathDF[,1], split = "_list.bed"))[1,1],"_GO_list.bed")}

    GO_list_path = OUTPUTpath

    if(TXTbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(DEG_list_pathDF[,1], split = "input_DEG_list.txt"))[1,1],"HARMONIC_PREPROCESSING_list.txt")}
    if(CSVbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(DEG_list_pathDF[,1], split = "input_DEG_list.csv"))[1,1],"HARMONIC_PREPROCESSING_list.csv")}
    if(BEDbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(DEG_list_pathDF[,1], split = "input_DEG_list.bed"))[1,1],"HARMONIC_PREPROCESSING_list.bed")}

    HARMONIC_PREPROCESSING_list_path = OUTPUTpath
    HARMONIC_PREPROCESSING_list_pathDF = as.data.frame(HARMONIC_PREPROCESSING_list_path)

    if(TXTbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.txt"))[1,1],"HARMONIC_TERMLISTING.txt")}
    if(CSVbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.csv"))[1,1],"HARMONIC_TERMLISTING.csv")}
    if(BEDbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.bed"))[1,1],"HARMONIC_TERMLISTING.bed")}
    HARMONIC_TERMLISTING_path = OUTPUTpath

    if(TXTbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.txt"))[1,1],"HARMONIC_COMPARE.txt")}
    if(CSVbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.csv"))[1,1],"HARMONIC_COMPARE.csv")}
    if(BEDbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.bed"))[1,1],"HARMONIC_COMPARE.bed")}
    HARMONIC_COMPARE_path = OUTPUTpath

    if(TXTbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.txt"))[1,1],"HARMONIC_SEPERATE.txt")}
    if(CSVbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.csv"))[1,1],"HARMONIC_SEPERATE.csv")}
    if(BEDbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.bed"))[1,1],"HARMONIC_SEPERATE.bed")}
    HARMONIC_SEPERATE_path = OUTPUTpath

    if(TXTbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.txt"))[1,1],"HARMONIC_SEPERATE_forMULTI_range.txt")}
    if(CSVbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.csv"))[1,1],"HARMONIC_SEPERATE_forMULTI_range.csv")}
    if(BEDbased>0){OUTPUTpath = paste0(as.data.frame(strsplit(HARMONIC_PREPROCESSING_list_pathDF[,1], split = "HARMONIC_PREPROCESSING_list.bed"))[1,1],"HARMONIC_SEPERATE_forMULTI_range.bed")}
    HARMONIC_SEPERATE_forMULTI_range_path = OUTPUTpath

    if(preprocessing == "T"){

        HARMONIC_DEGcalling(filepath = filepath,
                         type = type,
                         full_condition = full_condition,
                         number_of_rep = number_of_rep,
                         mango_design = mango_design)

        HARMONIC_PREPROCESSING(DEG_list_path = DEG_list_path,
                            GO_list_path = GO_list_path,
                            HARMONIC_PREPROCESSING_list_path = HARMONIC_PREPROCESSING_list_path,
                            filepath = filepath,
                            ref_genome = ref_genome,
                            core = core)
        }

    fileTABLE = utils::read.table(HARMONIC_PREPROCESSING_list_path, sep="\t", header=T, fill=TRUE)

    if(nrow(fileTABLE) > 1){

    HARMONIC_TERMLISTING(fileTABLE_path = HARMONIC_PREPROCESSING_list_path,
                      outputPATH = HARMONIC_TERMLISTING_path,
                      PASSED_RATIO = PASSED_RATIO,
                      PASSED_NUM = PASSED_NUM,
                      similarity = similarity)

    HARMONIC_COMPARE(input_TERMLISTING = HARMONIC_TERMLISTING_path,
                  fileTABLE_path = HARMONIC_PREPROCESSING_list_path,
                  filepath = filepath,
                  DEG_list_name = DEG_list_name,
                  GOTABLE_path = GO_list_path,
                  outputPATH = HARMONIC_COMPARE_path)

    HARMONIC_SEPERATE(fileTABLE_path = HARMONIC_PREPROCESSING_list_path,
               GOTABLE_path  = GO_list_path,
               input_COMPARE = HARMONIC_COMPARE_path,
               outputPATH    = HARMONIC_SEPERATE_path,
               FC            = FC,
               PASSED_NUM    = PASSED_NUM)

    if(dynamic_analyisis == "T"){
	HARMONIC_SEPERATE_forDA(input_COMPARE = HARMONIC_COMPARE_path,
	                     fileTABLE_path = HARMONIC_PREPROCESSING_list_path,
                             FC = FC,
                             outputPATH = HARMONIC_SEPERATE_forMULTI_range_path,
                             condition = condition)
        }
        }


    if(nrow(fileTABLE) == 1){

        HARMONIC_TERMLISTING_single(PASSED_RATIO = PASSED_RATIO,
                                 PASSED_NUM = PASSED_NUM,
                                 similarity = similarity,
                                 fileTABLE_path = HARMONIC_PREPROCESSING_list_path,
                                 outputPATH = HARMONIC_TERMLISTING_path)
        
        HARMONIC_COMPARE_SINGLE(input_TERMLISTING = HARMONIC_TERMLISTING_path,
                             fileTABLE_path = HARMONIC_PREPROCESSING_list_path,
                             filepath = filepath,
                             DEG_list_name = DEG_list_name,
                             GOTABLE_path = GO_list_path,
			     PASSED_NUM = PASSED_NUM,
                             outputPATH = HARMONIC_SEPERATE_path)
        }

}

