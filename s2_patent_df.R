
library(tidyverse)
library(R.matlab)
library(readstata13)

# Concatenate data on yearly patents --------------------------------------
patent_df <- list() # Initialize empty data frame

for (tper in 1976:2015) {
  
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
         length_pattext) 

patent_df$overcat_classnr[(patent_df$overcat_classnr == "NaN")] <- NA

patent_df <- patent_df %>% 
  mutate(overcat_classnr = as.numeric(overcat_classnr),
         patentnr = as.character(patentnr),
         uspc_primary = as.character(uspc_primary))

# Save --------------------------------------------------------------------
write_rds(patent_df, "output/patent_df.rds")
save.dta13(data = df, 
           file = "output/patent_data.dta",
           version = 13)
