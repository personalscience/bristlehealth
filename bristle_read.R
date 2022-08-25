# bristle_read.R


#' @return tidy data frame of Bristle data in canonical form
#' @param filepath path to XLSX file
read_bristle_table <- function(filepath=file.path("data","BristleHealthRaw.xlsx")) {

  raw_bristle_data <- readxl::read_xlsx(file.path("data/BristleHealthRaw.xlsx"))

  r <- raw_bristle_data %>%  transmute(genus,species,abundance=`relative abundance`/100)



  return(r)

}

plot_bristle_freq <- function(r_table) {

  r_table %>% # summarize(total=sum(sum))# %>%
    ggplot(aes(x=reorder(genus,-sum), y=sum)) +
    geom_col() +
    theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
    labs(y="Abundance (%)", x = "Genus", title = "Bristle Health Result")
}
