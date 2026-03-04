# Run GO enrichment preprocessing for MANGO

Reads DEG lists, runs
[`clusterProfiler::enrichGO`](https://rdrr.io/pkg/clusterProfiler/man/enrichGO.html)
(BP), writes per-case GO tables, then calls the preprocessing shell
script and writes the resulting preprocessing list.

## Usage

``` r
MANGO_PREPROCESSING(
  DEG_list_path,
  GO_list_path,
  MANGO_PREPROCESSING_list_path,
  ref_genome,
  core,
  filepath
)
```

## Arguments

- DEG_list_path:

  Path to a table listing DEG files (one file per row).

- GO_list_path:

  Output path to write the list of generated GO result files.

- MANGO_PREPROCESSING_list_path:

  Output path to write the list of generated MANGO preprocessing result
  files.

- ref_genome:

  Reference genome code. Use `"mm"` for mouse or `"hs"` for human.

- core:

  Number of cores to pass to the preprocessing shell script.

- filepath:

  Base directory where `CODE/init_MANGO_PREPROCESSING.sh` exists.

## Value

Writes output files to disk. Returns `NULL` invisibly.

## Examples

``` r
stopifnot(is.function(MANGO_PREPROCESSING))
if (FALSE) { # \dontrun{
MANGO_PREPROCESSING(
  DEG_list_path = "input_DEG_list.txt",
  GO_list_path = "input_DEG_GO_list.txt",
  MANGO_PREPROCESSING_list_path = "MANGO_PREPROCESSING_list.txt",
  ref_genome = "mm",
  core = 1,
  filepath = "."
)
} # }
```
