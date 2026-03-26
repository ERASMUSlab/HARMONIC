# Plot HARMONIC terms for a single tree (bar or chord)

Generate a bar plot (term scores) or a chord diagram (term–gene links)
for a selected tree from HARMONIC single-case outputs.

## Usage

``` r
HARMONIC_TERM_PLOT_forSINGLE(
  filepath,
  DEG_list_name,
  plot,
  trends,
  clusternum,
  width,
  height,
  LABEL = "text for result",
  lfc_leng = 2
)
```

## Arguments

- filepath:

  Working directory path.

- DEG_list_name:

  DEG list filename under `filepath`.

- plot:

  Plot type: "bar" or "cir".

- trends:

  One of "UP", "DOWN", "SIG".

- clusternum:

  Tree (cluster) index to plot.

- width:

  Plot width (for notebook display options).

- height:

  Plot height (for notebook display options).

- LABEL:

  Title label for the plot.

- lfc_leng:

  Max abs LFC used for chord color scaling.

## Value

For `plot="bar"`, returns a ggplot object (and prints it). For
`plot="cir"`, returns `NULL` invisibly (circos draws to device).
