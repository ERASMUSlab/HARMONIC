# Compute MANGO tree scores across multiple cases

For each MANGO tree (term dependency string), maps to GO descriptions
and calculates a per-condition score using rich factor and DEG
fold-change information, producing a comparison matrix.

## Usage

``` r
MANGO_COMPARE(
  input_TERMLISTING,
  filepath,
  fileTABLE_path,
  DEG_list_name,
  GOTABLE_path,
  outputPATH
)
```

## Arguments

- input_TERMLISTING:

  Path to the tree/subtree table produced by term listing.

- filepath:

  Base directory containing `DEG_list_name`.

- fileTABLE_path:

  Path to a table listing MANGO preprocessing files (one per row).

- DEG_list_name:

  DEG list filename under `filepath`.

- GOTABLE_path:

  Path to the GO list table written by preprocessing.

- outputPATH:

  Output path to write the comparison table.

## Value

Writes `outputPATH`. Returns `NULL` invisibly.

## Examples

``` r
stopifnot(is.function(MANGO_COMPARE))
```
