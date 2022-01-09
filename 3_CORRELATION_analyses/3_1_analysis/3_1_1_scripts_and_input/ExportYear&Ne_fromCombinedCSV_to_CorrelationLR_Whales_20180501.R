#-------------------------------------------------------------------------------------------------------------------------------------------
# Date 09-06-2017
# Andrea Cabrera
# Description: this script reads the combined csv files  
# It containes the poolSD and poolMean of the three replicates and the time in years
# It will export the files to be used for the correlation analysis


# IMPORTANT
#Check that the folder directories are correct 

#-------------------------------------------------------------------------------------------------------------------------------------------



root_dir = "[Add root directory here]/Correlations/Analysis"
setwd("[Add working directory here]/Correlations/Analysis/Whales")

library(readr) # The goal of readr is to provide a fast and friendly way to read rectangular data (like csv, tsv, and fwf)
library(data.table) # extension of data frames


folder <- "[Add root directory here]/Correlations/Species_Combined_CSV/Whales/"     # path to folder that holds multiple .csv files
file_list <- list.files(path=folder, pattern="*.csv") # create list of all .csv files in folder

# read in each .csv file in file_list and create a data frame with the same name as the .csv file

for (i in 1:length(file_list)){
  assign(file_list[i], 
         read.csv(paste(folder, file_list[i], sep=''))
  )}

# Put all the data frames in a list
Spp_DFs = mget(ls(pattern = ".csv")) 
names(Spp_DFs) = gsub(pattern= ".csv", replacement = "", x = names(Spp_DFs))


# Mutation rate to adjust the 
mu=1.12466E-6 #subst/site/generation Minke whale Control region Alter & Palumbi (2009) Li method corrected. Generation time of 21.22, average Pacifini y Taylor



#Export file for Linear Regression


for (i in 1:length(Spp_DFs))
{
  dataname <- as.data.frame(Spp_DFs[[i]])
  Year <- dataname$Age / mu
  Ne.Mean <- dataname$PoolMean
  SD <- dataname$PoolSD
  n.Total <- dataname$Total.n
  Lower <- dataname$Lower
  Upper <- dataname$Upper
  
  LR.Table <- data.frame(Year, Ne.Mean, SD, n.Total, Lower, Upper)
  
  assign(paste0(names(Spp_DFs)[i],"_LR"), LR.Table) # assign the name of the data frame
}


# Put all the data frames of the species in a list
DFs_LR = mget(ls(pattern = "_LR")) 
names(DFs_LR) = gsub(pattern= "_skyline", replacement = "", x = names(Spp_DFs))


#Export file that have been approximated for Linear Regression


for (i in 1:length(DFs_LR))
{
  
  # filename<-paste0(names(DFs_LR)[i])
  write.csv(DFs_LR[[i]], file = paste0(names(DFs_LR)[i],"_LR.csv") , row.names=FALSE, na="") # export individual files
  

}



