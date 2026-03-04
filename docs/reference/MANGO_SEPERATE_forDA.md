# Differential-activity (DA) tree filtering for selected conditions

Given a MANGO_COMPARE table across multiple conditions, this function
selects trees that are active in all specified `condition` indices and
satisfy a fold-change separation criterion versus the remaining
conditions.

## Usage

``` r
MANGO_SEPERATE_forDA(input_COMPARE, fileTABLE_path, FC, outputPATH, condition)
```

## Arguments

- input_COMPARE:

  Path to MANGO_COMPARE result file (tab-delimited).

- fileTABLE_path:

  Path to MANGO_PREPROCESSING_list file (tab-delimited).

- FC:

  Fold-change threshold for DA criterion.

- outputPATH:

  Output file path to write DA-filtered result (tab-delimited).

- condition:

  Integer vector of 1-based condition indices to define the POS set.

## Value

Writes a table to `outputPATH`. Returns NULL invisibly.

## Examples

``` r
stopifnot(is.function(MANGO_SEPERATE_forDA))
# \donttest{
# MANGO_SEPERATE_forDA(
#   input_COMPARE = "MANGO_COMPARE.txt",
#   fileTABLE_path = "MANGO_PREPROCESSING_list.txt",
#   filepath = ".",
#   DEG_list_name = "input_DEG_list.txt",
#   FC = 2,
#   outputPATH = "MANGO_SEPERATE_forDA.txt",
#   condition = c(1, 2)
# )
# }
```
