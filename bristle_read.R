# bristle_read.R


#' @return tidy data frame of Bristle data in canonical form
#' @param filepath path to XLSX file
read_bristle_table <- function(filepath=file.path("data","BristleHealthRaw.xlsx")) {

  raw_bristle_data <- readxl::read_xlsx(filepath)

  r <- raw_bristle_data %>%  transmute(genus,species,abundance=`relative abundance`/100)



  return(r)

}

#' @description Generate a ggplot of an ordered frequency of the genus in the sample
#' @param r_table Bristle canonical raw dataframe
#' @return ggplot object
plot_bristle_freq <- function(r_table) {

  r_table %>% # summarize(total=sum(sum))# %>%
    ggplot(aes(x=reorder(genus,-sum), y=sum)) +
    geom_col() +
    theme(axis.text.x=element_text(angle = 90, vjust = 0.5)) +
    labs(y="Abundance (%)", x = "Genus", title = "Bristle Health Result")
}


#' @param table1 dataframe in Bristle canonical form
#' @param table2 dataframe in Bristle canonical form
combine_bristle_table <- function(table1, table2, label1, label2) {

  t1 <- table1 %>% cbind(label = label1)
  t2 <- table2 %>% cbind(label = label2)

  return(rbind(t1,t2))

}

