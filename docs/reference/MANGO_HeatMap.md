# Draw a heatmap of HARMONIC results

Create a heatmap from HARMONIC output tables (HARMONIC_SEPERATE or
HARMONIC_SEPERATE_forMULTI_range).

## Usage

``` r
HARMONIC_HeatMap(
  filepath,
  DEG_list_name,
  trends,
  condition = "ALL",
  width,
  height,
  max,
  dynamic_analyisis = "F"
)
```

## Arguments

- filepath:

  Working directory path.

- DEG_list_name:

  DEG list filename under `filepath`.

- trends:

  One of "UP", "DOWN", "SIG" (controls color palette).

- condition:

  "ALL", "SIG", or a specific condition index/value used in the last
  column of HARMONIC_SEPERATE output.

- width:

  Plot width (for notebook display options).

- height:

  Plot height (for notebook display options).

- max:

  Maximum value for heatmap color scale (used in breaks).

- dynamic_analyisis:

  "F" for single/multi heatmap using HARMONIC_SEPERATE, "T" for dynamic
  analysis heatmap using HARMONIC_SEPERATE_forMULTI_range.

## Value

A `pheatmap` object.

## Examples

``` r
stopifnot(is.function(HARMONIC_HeatMap))
# \donttest{
# HARMONIC_HeatMap(
#   filepath = ".",
#   DEG_list_name = "input_DEG_list.txt",
#   trends = "UP",
#   condition = "ALL",
#   width = 10,
#   height = 6,
#   max = 5,
#   dynamic_analyisis = "F"
# )
# }
```
