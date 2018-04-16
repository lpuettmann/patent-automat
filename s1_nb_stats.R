library(tidyverse)

df <- read_csv("output/nb_stats_patentnr.csv", 
               col_names = c("p1", "p2", "p3", "p4", "p5", "p6", "p7")) %>% 
  mutate(patent = as.numeric(paste0(p1, p2, p3, p4, p5, p6, p7))) %>% 
  select(patent) %>% 
  bind_cols(read_csv("output/nb_stats_post_yes.csv", col_names = "post_yes")) %>% 
  bind_cols(read_csv("output/nb_stats_post_no.csv", col_names = "post_no")) %>% 
  bind_cols(read_csv("output/nb_stats_year.csv", col_names = "year"))

df %>% 
  gather(posterior, val, -year, -patent) %>% 
  ggplot(aes(val, group = year, color = year)) +
  geom_line(stat="density") +
  facet_wrap(~posterior)





