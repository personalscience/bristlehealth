Morning vs Night
================
Richard Sprague
8/25/2022

What happens to my mouth microbiome throughout the day?

## Baseline

This sample was taken in June on a random, typical morning first thing
after waking.

``` r
baseline_sample <- read_bristle_table(filepath=file.path("data", "BristleHealthRaw.xlsx"))

baseline_sample %>% treemap::treemap(dtf=., index = c("genus","species"),
                 vSize="abundance",
                 type = "categorical",
                 vColor = "genus",
                 position.legend = "none",
                 title = "My Mouth Microbes (Baseline)")
```

![](bristle_day_files/figure-gfm/unnamed-chunk-1-1.png)<!-- -->

## Morning

This sample was collected a few minutes after waking up. I usually wear
an orthodontic retainer, so this is my oral microbiome *with* the
retainer.

``` r
am_sample <- read_bristle_table(filepath=file.path("data", "Bristle-2022-08-02-AM.xlsx"))


am_sample %>% 
treemap::treemap(dtf=., index = c("genus","species"),
                 vSize="abundance",
                 type = "categorical",
                 vColor = "genus",
                 position.legend = "none",
                 title = "My Mouth Microbes (Morning)")
```

![](bristle_day_files/figure-gfm/unnamed-chunk-2-1.png)<!-- -->

## Evening

I went the rest of the day as normal. This sample was collected at 10pm,
about three hours after my last meal, and before inserting the retainer
or brushing my teeth.

``` r
pm_sample <- read_bristle_table(filepath=file.path("data", "Bristle-2022-08-02-PM.xlsx"))

pm_sample %>% 
treemap::treemap(dtf=., index = c("genus","species"),
                 vSize="abundance",
                 type = "categorical",
                 vColor = "genus",
                 position.legend = "none",
                 title = "My Mouth Microbes (Evening)")
```

![](bristle_day_files/figure-gfm/unnamed-chunk-3-1.png)<!-- -->