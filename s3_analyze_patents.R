
library(tidyverse)
library(ggthemes)
library(readstata13)

df <- read_rds("output/patent_df.rds")

df_yrly <- df %>% 
  group_by(year) %>% 
  summarize(nr_patents = n(),
            nr_automat = sum(automat)) %>% 
  mutate(sh_automat = nr_automat / nr_patents)

df_automat = subset(df, automat == 1)

ggplot() + 
  geom_hline(yintercept = 0, size = 0.3, color = "grey80") +
  geom_line(data = df, aes(log(length_pattext)), color = "#252525", stat="density") +
  geom_line(data = df_automat, aes(log(length_pattext)), color = "#969696", stat="density") +
  theme_tufte(base_family="Palatino", ticks=FALSE)
  
mean(log(df$length_pattext))
mean(log(df_automat$length_pattext))

save.dta13(data = df, 
           file = "output/patent_data.dta",
           version = 13)

