
library(tidyverse)
library(R.matlab)

df <- list() # Initialize empty data frame

for (tper in 1976:2014) {
  
  cat(paste0('Start ', tper, ' ... ')); tic = proc.time()[3]

  matlabFile <- readMat(paste0("patent_info/patsearch_results_", tper,".mat"))
  
  varNames <- names(matlabFile$patent.info[,,1])
  datList = matlabFile$patent.info
  datList = lapply(datList, unlist, use.names=FALSE)
  patent_df <- as.data.frame(datList)
  names(patent_df) <- varNames
  
  # R likes to replace . with _ in variable names, so revert that
  names(patent_df) <- gsub("\\.", "_", names(patent_df))
  
  patent_df$year <- tper
  
  # Append
  df <- bind_rows(df, patent_df) 
  
  cat(paste0("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n"))
}

df <- df %>% 
  select(year, 
         week, 
         patentnr, 
         automat = is_nbAutomat, 
         excl = indic_exclclassnr, 
         uspc_primary = classnr_uspc, 
         overcat_classnr, 
         length_pattext) 

df$overcat_classnr[(df$overcat_classnr == "NaN")] <- NA

df <- df %>% 
  mutate(overcat_classnr = as.numeric(overcat_classnr),
         patentnr = as.character(patentnr),
         uspc_primary = as.character(uspc_primary))

# Save --------------------------------------------------------------------
write_rds(df, "output/patent_df.rds")

