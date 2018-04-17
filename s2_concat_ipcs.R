
library(tidyverse)
library(R.matlab)

# Concatenate data on yearly patents --------------------------------------
ipc_df <- list() # Initialize empty data frame

for (tper in 1976:2014) {
  
  cat(paste0('Start ', tper, ' ... ')); tic = proc.time()[3]
  matlabFile <- readMat(paste0("ipcs/ipcs_", tper,".mat"))

  varNames <- names(matlabFile$ipcs[,,1])
  datList = matlabFile$ipcs
  datList = lapply(datList, unlist, use.names=FALSE)
  year_df <- as.data.frame(datList)
  names(year_df) <- varNames
  
  # R likes to replace . with _ in variable names, so revert that
  names(year_df) <- gsub("\\.", "_", names(year_df))
  
  year_df$year <- tper
  
  # Append
  ipc_df <- bind_rows(ipc_df, year_df)
  
  cat(paste0("done. [", round(proc.time()[3] - tic, digits = 1), "s]\n"))
}

ipc_df <- ipc_df %>% 
  as.tibble()

write_rds(ipc_df, "output/ipc_df.rds", compress = "gz")
