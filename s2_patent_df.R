library(tidyverse)
library(R.matlab)

# Concatenate data on yearly patents --------------------------------------
patent_df <- list() # Initialize empty data frame

for (tper in 1976:2014) {
  
  cat(paste0('Start ', tper, ' ... ')); tic = proc.time()[3]
  
  matlabFile <- readMat(paste0("patent_info/patsearch_results_", tper,".mat"))
  
  varNames <- names(matlabFile$patent.info[,,1])
  datList = matlabFile$patent.info
  datList = lapply(datList, unlist, use.names=FALSE)
  year_df <- as.data.frame(datList)
  names(year_df) <- varNames
  
  # R likes to replace . with _ in variable names, so revert that
  names(year_df) <- gsub("\\.", "_", names(year_df))
  
  year_df$year <- tper
  
  # Append
  patent_df <- bind_rows(patent_df, year_df)
  
  cat(paste0("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n"))
}

patent_df <- patent_df %>% 
  select(year, 
         week, 
         patentnr, 
         automat = is_nbAutomat, 
         excl = indic_exclclassnr, 
         uspc_primary = classnr_uspc, 
         overcat_classnr, 
         length_pattext) %>% 
  mutate(overcat_classnr = ifelse(overcat_classnr == "NaN", NA, 
                                  overcat_classnr)) %>% 
  as.tibble()

patent_df <- patent_df %>% 
  mutate(overcat_classnr = as.numeric(overcat_classnr),
         patentnr = as.character(patentnr),
         uspc_primary = as.character(uspc_primary))

write_rds(patent_df, "output/patent_df.rds", compress = "gz")




