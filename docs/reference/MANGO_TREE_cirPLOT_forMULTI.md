# HARMONIC multi-case circular plot (tree-level)

Draw a circular (polar) summary plot of HARMONIC trees across multiple
cases.

## Usage

``` r
HARMONIC_TREE_cirPLOT_forMULTI(
  filepath,
  DEG_list_name,
  status,
  trends,
  LABEL,
  project = "plot\nname",
  condition = 1,
  tree_size,
  label_size,
  project_size,
  width,
  height
)
```

## Arguments

- filepath:

  Directory path containing input files.

- DEG_list_name:

  DEG list table filename under `filepath`.

- status:

  One of `"common"`, `"specific"`, `"DA"`.

- trends:

  One of `"UP"`, `"DOWN"`, `"SIG"`.

- LABEL:

  Character vector of case labels.

- project:

  Project label shown on the plot.

- condition:

  Condition index (used in `"specific"`).

- tree_size:

  Text size for tree labels.

- label_size:

  Text size for individual labels.

- project_size:

  Text size for project label.

- width:

  Plot width (used by repr.plot.width option in notebooks).

- height:

  Plot height (used by repr.plot.height option in notebooks).

## Value

A ggplot object.
