# Compute MANGO tree scores for a single case

Single-condition version of `MANGO_COMPARE`. Produces a one-column
comparison table for the single case.

## Usage

``` r
MANGO_COMPARE_SINGLE(
  input_TERMLISTING,
  filepath,
  fileTABLE_path,
  DEG_list_name,
  GOTABLE_path,
  PASSED_NUM,
  outputPATH
)
```

## Arguments

- input_TERMLISTING:

  Path to the tree/subtree table produced by term listing.

- filepath:

  Base directory containing `DEG_list_name`.

- fileTABLE_path:

  Path to a table listing a single MANGO preprocessing file.

- DEG_list_name:

  DEG list filename under `filepath`.

- GOTABLE_path:

  Path to the GO list table written by preprocessing.

- PASSED_NUM:

  Threshold on passed dependency count (column 3).

- outputPATH:

  Output path to write the comparison table.

## Value

Writes `outputPATH`. Returns `NULL` invisibly.

## Examples

``` r
stopifnot(is.function(MANGO_COMPARE_SINGLE))
```
