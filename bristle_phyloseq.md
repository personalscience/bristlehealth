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
columns are okay but will be ignored): “ssr”: sequencing revision
(e.g. 42578). Your column probably repeats many SSRs. “tax_name”:
(e.g. “Bifidobacterium”). “count” : reads for that taxa at that SSR
(e.g. 2137)

Mapping file: a dataframe that contains: “ssr”: exact same SSRs as
experiment dataframe above attributes columns: as many as you like.
(e.g. “yogurteater”, “geo”, “kefireater”, “gender”)

``` r
bristle_data$ssr <- 1234
mapfile <- tibble(ssr=1234,label="baseline")
```

## Create an experiment file

``` r
bristle_experiment <- bristle_data %>% transmute(ssr,
                                                 tax_name = genus,
                                                 count = abundance * 10000,
                                                 tax_rank = "genus")
```

## Make the Phyloseq object

``` r
e <- bristle_experiment %>% select(tax_name, 1, count) %>% pivot_wider(names_from = ssr, values_from = count, values_fn = {sum})
ssrs <- unique(bristle_experiment$ssr)
e.map <- mapfile[match(ssrs,mapfile$ssr),]
#row.names(e.map)<-e.map$ssr
qiime_tax_names<-sapply(e[1],function (x) paste("g__",x,sep=""))
e.taxtable<-build_tax_table(lapply(qiime_tax_names,parse_taxonomy_qiime))
dimnames(e.taxtable)[[1]]<-qiime_tax_names
e.matrix<-as.matrix(e[,2:ncol(e)])
 colnames(e.matrix)<-ssrs
  rownames(e.matrix)<-qiime_tax_names

  e.ps <-phyloseq(otu_table(e.matrix,taxa_are_rows=TRUE),
                  #sample_data(e.map)) #,
                  tax_table(e.taxtable))
```

``` r
plot_bar(e.ps, fill = "Genus")
```

![](bristle_phyloseq_files/figure-gfm/unnamed-chunk-5-1.png)<!-- -->

``` r
plot_heatmap(e.ps, method = "CCA", distance = "none",fill = "Genus")
```

    ## Warning in plot_heatmap(e.ps, method = "CCA", distance = "none", fill = "Genus"): Attempt to access ordination coordinates for sample ordering failed.
    ## Using default sample ordering.

    ## Warning in plot_heatmap(e.ps, method = "CCA", distance = "none", fill = "Genus"): Attempt to access ordination coordinates for feature/species/taxa/OTU ordering failed.
    ## Using default feature/species/taxa/OTU ordering.

![](bristle_phyloseq_files/figure-gfm/unnamed-chunk-5-2.png)<!-- -->

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

![](bristle_phyloseq_files/figure-gfm/unnamed-chunk-6-1.png)<!-- -->
