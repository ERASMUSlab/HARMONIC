# Select significant HARMONIC terms within a condition range

Filters HARMONIC comparison results to terms present in all selected
conditions (`condition_A:condition_B`) and exceeding an `FC` ratio
against the remaining conditions.

## Usage

``` r
HARMONIC_SEPERATE_forMULTI_range(
  input_COMPARE,
  fileTABLE_path,
  FC,
  outputPATH,
  condition_A,
  condition_B
)
```

## Arguments

- input_COMPARE:

  Path to the HARMONIC comparison table.

- fileTABLE_path:

  Path to a table listing conditions (used to determine number of
  columns).

- FC:

  Fold-change ratio cutoff used for filtering.

- outputPATH:

  Output path to write the filtered table.

- condition_A:

  Start condition index (1-based, matching your code convention).

- condition_B:

  End condition index (1-based, matching your code convention).

## Value

Writes `outputPATH`. Returns `NULL` invisibly.

## Examples

``` r
stopifnot(is.function(HARMONIC_SEPERATE_forMULTI_range))
```
