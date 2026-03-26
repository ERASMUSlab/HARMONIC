# HARMONIC multi-case term bar plot (term-level)

Draw a bar plot of GO terms within a selected HARMONIC tree for multi-case
results. The function supports three modes via `status`: `"common"`,
`"specific"`, and `"DA"`. Bars represent the term score (tscore-like),
dashed segments/points encode gene distribution ratio and median
fold-change of genes in each term (as implemented in the original
logic).

## Usage

``` r
HARMONIC_TERM_barPLOT_forMULTI(
  filepath,
  DEG_list_name,
  status,
  trends,
  LABEL,
  condition,
  clusternum,
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

  Character vector of case labels (used for titles).

- condition:

  Condition index (used to pick the case/contrast).

- clusternum:

  Tree(cluster) index to display.

- width:

  Plot width (used by repr.plot.width option in notebooks).

- height:

  Plot height (used by repr.plot.height option in notebooks).

## Value

A ggplot object.
