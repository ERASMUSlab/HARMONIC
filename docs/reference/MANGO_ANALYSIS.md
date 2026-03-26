# Run the HARMONIC analysis pipeline

Orchestrates preprocessing (optional), term listing, comparison, and
separation. Supports both single- and multi-condition workflows.

## Usage

``` r
HARMONIC_ANALYSIS(
  filepath,
  DEG_list_name,
  ref_genome,
  core = 1,
  PASSED_RATIO,
  PASSED_NUM,
  similarity,
  FC = 2,
  condition = 1,
  dynamic_analyisis = "F",
  preprocessing = "F"
)
```

## Arguments

- filepath:

  Working directory path.

- DEG_list_name:

  DEG list filename under `filepath`.

- ref_genome:

  Reference genome code (`"mm"` or `"hs"`).

- core:

  Number of cores.

- PASSED_RATIO:

  Passed dependency ratio threshold.

- PASSED_NUM:

  Passed dependency count threshold.

- similarity:

  Similarity cutoff (%).

- FC:

  Fold-change ratio cutoff.

- condition:

  condition index for dynamic analysis.

- dynamic_analyisis:

  `"T"` or `"F"` to enable multi-range filtering.

- preprocessing:

  `"T"` or `"F"` to run preprocessing inside this function.

## Value

Writes output files to disk. Returns `NULL` invisibly.

## Examples

``` r
stopifnot(is.function(HARMONIC_ANALYSIS))
if (FALSE) { # \dontrun{
HARMONIC_ANALYSIS(
  filepath=".",
  DEG_list_name="input_DEG_list.txt",
  ref_genome="mm",
  core=1,
  PASSED_RATIO=15,
  PASSED_NUM=4,
  similarity=70
)
} # }
```
