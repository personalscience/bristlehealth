Bristle and Phyloseq
================
Richard Sprague
2022-09-05

## Read Bristle sample data

``` r
bristle_data <-bristler::read_bristle_table(filepath=file.path("data/BristleHealthRaw.xlsx"))
```

## Create a mapfile

Experiment dataframe with the following exact column names (additional
columns are okay but will be ignored):

- “ssr”: sequencing revision, aka sample ID number (e.g. 42578). Your
  column probably repeats many SSRs.

- “tax_name”: (e.g. “Bifidobacterium”).

- “count” : reads for that taxa at that SSR (e.g. 2137)

- Mapping file: a dataframe that contains: “ssr”: exact same SSRs as
  experiment dataframe above attributes columns: as many as you like.
  (e.g. “yogurteater”, “geo”, “kefireater”, “gender”)

``` r
bristle_data$ssr <- 1234
mapfile <- tibble(ssr=1234,label="baseline")
```

## Make the Phyloseq object

``` r
e.ps <- bristler::phyloseqize(bristle_data, mapfile = mapfile)
```

``` r
plot_bar(e.ps, fill = "Genus")
```

![](bristle_phyloseq_files/figure-gfm/unnamed-chunk-4-1.png)<!-- -->

``` r
plot_heatmap(e.ps, method = "CCA", distance = "none",fill = "Genus")
```

    ## Warning in plot_heatmap(e.ps, method = "CCA", distance = "none", fill = "Genus"): Attempt to access ordination coordinates for sample ordering failed.
    ## Using default sample ordering.

    ## Warning in plot_heatmap(e.ps, method = "CCA", distance = "none", fill = "Genus"): Attempt to access ordination coordinates for feature/species/taxa/OTU ordering failed.
    ## Using default feature/species/taxa/OTU ordering.

![](bristle_phyloseq_files/figure-gfm/unnamed-chunk-4-2.png)<!-- -->

Now attempt other Phyloseq operations.

``` r
estimate_richness(e.ps, measures = c("InvSimpson","Shannon"))
```

    ## Warning in estimate_richness(e.ps, measures = c("InvSimpson", "Shannon")): The data you have provided does not have
    ## any singletons. This is highly suspicious. Results of richness
    ## estimates (for example) are probably unreliable, or wrong, if you have already
    ## trimmed low-abundance taxa from the data.
    ## 
    ## We recommended that you find the un-trimmed data and retry.

    ##    Shannon InvSimpson
    ## 1 2.249027   5.802677

``` r
plot_richness(e.ps, measures = c("InvSimpson","Shannon"))
```

    ## Warning in estimate_richness(physeq, split = TRUE, measures = measures): The data you have provided does not have
    ## any singletons. This is highly suspicious. Results of richness
    ## estimates (for example) are probably unreliable, or wrong, if you have already
    ## trimmed low-abundance taxa from the data.
    ## 
    ## We recommended that you find the un-trimmed data and retry.

![](bristle_phyloseq_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->
