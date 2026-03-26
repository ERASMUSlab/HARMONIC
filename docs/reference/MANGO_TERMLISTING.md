# Build the HARMONIC term tree list across multiple cases

Aggregates `total_Dependency` strings across preprocessing outputs,
computes pairwise overlap ratio, and creates a tree/subtree mapping
based on a similarity threshold.

## Usage

``` r
HARMONIC_TERMLISTING(
  PASSED_RATIO,
  PASSED_NUM,
  similarity,
  fileTABLE_path,
  outputPATH
)
```

## Arguments

- PASSED_RATIO:

  Threshold on `Ratio_of_passed_Dependency` (column 4).

- PASSED_NUM:

  Threshold on passed dependency count (column 3).

- similarity:

  Similarity cutoff (%) used to define similar trees.

- fileTABLE_path:

  Path to a table listing HARMONIC preprocessing files (one per row).

- outputPATH:

  Output path to write the final tree/subtree table.

## Value

Writes `outputPATH`. Returns `NULL` invisibly.

## Examples

``` r
stopifnot(is.function(HARMONIC_TERMLISTING))
```
