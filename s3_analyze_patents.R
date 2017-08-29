
library(tidyverse)

df <- read_rds("output/patent_df.rds")

df_yrly <- df %>% 
  group_by(year) %>% 
  summarize(nr_patents = n(),
            nr_automat = sum(automat))



