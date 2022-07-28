



library(actino)
library(phyloseq)
library(psmr)  # use library function instead.
library(treemap)
if(!require("ggfittext")) install.packages("ggfittext")


options(scipen = 999)

mouth.genus <- subset_samples(sprague.genus.norm, Site == "mouth")

mouth_df <- mhg_df_just_taxa(mouth.genus,"Streptococcus") %>% select(Date,Label,abundance)

raw_bristle_data <- readxl::read_xlsx(file.path("BristleHealthRaw.xlsx"))
bristle_genus <- raw_bristle_data %>% select(genus) %>% pull(genus) %>% unique()

ub_labels <- mhg_df_just_taxa(mouth.genus,"Streptococcus") %>% pull(Label)

ub_mouth_genus_df_abundances <- sapply(bristle_genus[c(1:16,18:31,34,37)],function(x) {mhg_df_just_taxa(mouth.genus,x) %>% pull(abundance)/1000000}) %>% as.data.frame()

ub_mouth_genus_df <- cbind(ub_labels,ub_mouth_genus_df_abundances)



## Plot 16S Data


#' Return data table of a specific sample number
#' @param sample_number integer value of sample number
#' @param genus_df dataframe of all mouth genus
ub_mouth_genus_of_sample <- function(sample_number = 1, genus_df=ub_mouth_genus_df) {
  .rownames <- genus_df[sample_number,-1] %>% t() %>% as.data.frame() %>% rownames()
  df <- tibble(genus = .rownames,abundance = genus_df[sample_number,-1] %>% t() %>% as.vector() )
  return(df %>% mutate(sample = sample_number, label=ub_mouth_genus_df[sample_number,1]))
}

ub_mouth_genus_of_sample(1)  %>%
  slice_max(order_by=abundance, prop=.5) %>% # summarize(total=sum(sum))# %>%
  ggplot(aes(x=reorder(genus,-abundance), y=abundance)) + geom_col() +
  theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
  labs(y="Abundance (%)", x = "Genus", title = "16S Sample Result")


g_df <- NULL
for (i in 1:87) {
  g_df <- rbind(g_df, ub_mouth_genus_of_sample(i))
}
g_df


# inspired by https://yjunechoe.github.io/posts/2020-06-30-treemap-with-ggplot/
treemap_of_sample <- function(sample_number = 1)
{
  tm <- ub_mouth_genus_of_sample(sample_number) %>%
    treemap::treemap(dtf=., index = c("genus"),
                     vSize="abundance")
  tm_ <- tm[["tm"]] %>%
    # # calculate end coordinates with height and width
    mutate(x1 = x0 + w,
           y1 = y0 + h) %>%
    # get center coordinates for labels
    mutate(x = (x0+x1)/2,
           y = (y0+y1)/2) %>%
    mutate(primary_group = 1.2)

  return(tm_)
}

all_tm <- NULL
for (i in 1:87) {
  all_tm <- rbind(all_tm, treemap_of_sample(i) %>% mutate(sample = i))
}

save(all_tm, ub_mouth_genus_df, file="mouth_microbes")

plot_sample_number <- function(sample_number=1) {
  tm <- treemap_of_sample(sample_number)
  ggplot(tm, aes(xmin = x0, ymin = y0, xmax = x1, ymax = y1)) +
    # add fill and borders for groups and subgroups
    geom_rect(aes(fill = color, size = primary_group),
              show.legend = FALSE, color = "black", alpha = .3) +
    scale_fill_identity() +
    # set thicker lines for group borders
    scale_size(range = range(tm$primary_group)) +
    # add labels
    ggfittext::geom_fit_text(aes(label = genus), min.size = 1) +
    # options
    scale_x_continuous(expand = c(0, 0)) +
    scale_y_continuous(expand = c(0, 0)) +
    theme_void()
}



