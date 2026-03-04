# Plot MANGO trees for a single condition

Visualize tree-level summaries from `MANGO_SEPERATE` output for a
single-case analysis. Supports bar plot and circular (polar) plot
styles.

## Usage

``` r
MANGO_TREE_PLOT_forSINGLE(filepath, trends, width, height, plot, DEG_list_name)
```

## Arguments

- filepath:

  Working directory path.

- trends:

  One of "UP", "DOWN", "SIG" (controls color palette).

- width:

  Plot width (for notebook display options).

- height:

  Plot height (for notebook display options).

- plot:

  Plot type: "bar" or "cir".

- DEG_list_name:

  DEG list filename under `filepath`.

## Value

A ggplot object.

## Examples

``` r
stopifnot(is.function(MANGO_TREE_PLOT_forSINGLE))
# \donttest{
# MANGO_TREE_PLOT_forSINGLE(
#   filepath = ".",
#   trends = "UP",
#   width = 10,
#   height = 6,
#   plot = "bar",
#   DEG_list_name = "input_DEG_list.txt"
# )
# }
```
