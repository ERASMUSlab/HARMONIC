# Separate HARMONIC terms by condition specificity (with PASS/FAIL filtering)

This function separates HARMONIC terms by condition using the comparison
matrix, then applies additional filtering based on the number of matched
GO terms per tree (\>= PASSED_NUM) for each condition and for
non-separated terms.

## Usage

``` r
HARMONIC_SEPERATE(
  input_COMPARE,
  fileTABLE_path,
  GOTABLE_path,
  FC,
  PASSED_NUM,
  outputPATH
)
```

## Arguments

- input_COMPARE:

  Path to HARMONIC_COMPARE output file.

- fileTABLE_path:

  Path to HARMONIC_PREPROCESSING_list file (condition table).

- GOTABLE_path:

  Path to GO result list table (GO_list_path).

- FC:

  Fold-change ratio cutoff used for separating condition-specific terms.

- PASSED_NUM:

  Minimum number of matched GO terms required to keep a tree.

- outputPATH:

  Output path to write the separated table.

## Value

Writes a tab-delimited file to `outputPATH`. Returns NULL invisibly.

## Examples

``` r
stopifnot(is.function(HARMONIC_SEPERATE))
# \donttest{
# HARMONIC_SEPERATE(
#   input_COMPARE = "HARMONIC_COMPARE.txt",
#   fileTABLE_path = "HARMONIC_PREPROCESSING_list.txt",
#   GOTABLE_path = "input_DEG_GO_list.txt",
#   FC = 2,
#   PASSED_NUM = 4,
#   outputPATH = "HARMONIC_SEPERATE.txt"
# )
# }
```
