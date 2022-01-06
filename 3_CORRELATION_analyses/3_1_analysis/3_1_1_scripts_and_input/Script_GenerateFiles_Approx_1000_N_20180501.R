#----------------------------
# Date 02-06-2017
# Andrea Cabrera
# Description: this script reads a csv file with the time, Demographic parameters mean  for all species 
# It also reads the csv file with the climate data
# It estimate linear regression among variables 



root_dir = "D:/RUG/Migration Antarctic/Correlations/Analysis"
setwd("D:/RUG/Migration Antarctic/Correlations/Analysis/Theta_N/Approx_LR_1000")


library(readr)

folder <- "D:/RUG/Migration Antarctic/Correlations/Analysis/Theta_N/"      # path to folder that holds multiple .csv files
file_list <- list.files(path=folder, pattern="*.csv") # create list of all .csv files in folder
# read in each .csv file in file_list and create a data frame with the same name as the .csv file

for (i in 1:length(file_list)){
  assign(file_list[i], 
         read.csv(paste(folder, file_list[i], sep=''))
  )}


# Put all the data frames of the species in a list
Spp_DFs = mget(ls(pattern = "LR.csv")) 
names(Spp_DFs) = gsub(pattern= "_LR.csv", replacement = "", x = names(Spp_DFs))

#Put the temperature in a variable
Arctic.Temp <- Arctic_Temperature.csv


# This will create a list of values from 0 to 150000 every 1000, which will be use as standard time intervals
# Transform the Temperature of the Antarctic by linear appoximation

ValuesTime <- seq(0, 30000, 1000)
Arctic.Temp.Approx <- data.frame(approx(x=Arctic.Temp$Arctic.Year, y= Arctic.Temp$Arctic.Temp, xout=ValuesTime, method = "linear"))
colnames(Arctic.Temp.Approx) <- c("Time.A","Temp.A")



#Approximate the demographic values of each species to the Temperature intervalas of the Arctic

for (i in 1:length(Spp_DFs))
{
  dataname <- as.data.frame(Spp_DFs[[i]])
  approxData <- data.frame(approx(x=dataname$Year, y=dataname$Ne.Mean, xout=Arctic.Temp.Approx$Time.A, method = "linear"))
  colnames(approxData) <- c("Time.A","Ne.A") # add the names of the columns
  assign(paste0(names(Spp_DFs)[i],"_Approx"), approxData) # assign the name of the data frame
}

# Put all the data frames of the species in a list
DFs_LR = mget(ls(pattern = "Approx")) 



#Export file that have been approximated for Correlation

filenameAllData="Northern_AllApprox_LR_1000.csv"

for (i in 1:length(DFs_LR))
{

  filename<-paste0(names(DFs_LR)[i], "_1000.csv")
  write.csv(DFs_LR[i], file = filename , row.names=FALSE, na="") # export individual files
  write.csv(DFs_LR, file = filenameAllData, row.names=FALSE, na="") # export all data together in one file
}



