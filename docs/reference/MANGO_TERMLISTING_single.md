# Build the HARMONIC term tree list for a single case

Same as `HARMONIC_TERMLISTING` but operates on a single preprocessing file.

## Usage

``` r
HARMONIC_TERMLISTING_single(
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

  Path to a table listing a single HARMONIC preprocessing file.

- outputPATH:

  Output path to write the final tree/subtree table.

## Value

Writes `outputPATH`. Returns `NULL` invisibly.

## Examples

``` r
stopifnot(is.function(HARMONIC_TERMLISTING_single))
```
