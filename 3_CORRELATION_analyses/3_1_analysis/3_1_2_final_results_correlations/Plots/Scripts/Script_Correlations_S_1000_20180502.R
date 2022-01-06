#----------------------------
# Date 02-06-2017
# Andrea Cabrera
# Description:  Linear regression among variables. 
#The porpuse is to determine if there is a relationship described by linear regression model. 

install.packages("corrplot")


library(readr)
require(ggplot2)
library(Hmisc) # library for correlations with significance levels
library(corrplot) # to plot nice correlation plots


#root_dir = "D:/RUG/Migration Antarctic/"
setwd("D:/RUG/Migration Antarctic/Correlations/Plots/Plots")
getwd() 

# check the working directory####################
# Scritp to do the Linear Regression

#Read the file 
Antarctic.Data.LR<- read_csv("D:/RUG/Migration Antarctic/Correlations/Plots/Data/Southern_AllApprox_LR_1000_Mod_20180501.csv")


#Give a new name
colnames(Antarctic.Data.LR) <- c("Year","Temperature", "B. acutorostrata","B. bonaerensis","B. musculus", "B. physalus", "E. superba", "E. australis", "M. novaeangliae", "P. abdominalis") # Give easier names to the columns


#Create a new data frame without missing data
Antarctic.O.LR<- na.omit(Antarctic.Data.LR) #If na.omit removes cases, the row numbers of the cases form the "na.action" attribute of the result, of class "omit".


#Reorder data frame
Antarctic.OO.LR <-Antarctic.O.LR[,c(3,5,6,8,9,4,7,10,2,1)]

attach(Antarctic.OO.LR)

plot(Antarctic.OO.LR)

#calculate Pearson's correlation among variables
SouthCor <- rcorr(as.matrix(Antarctic.OO.LR), type="pearson") # type can be pearson or spearman

rcorr(as.matrix(Antarctic.OO.LR), type="spearman") # type can be pearson or spearman



res <- cor(Antarctic.OO.LR, method="pearson") # only correlation values



# This function will calculate the p-values of the data again. It is needed for the plot
# mat : is a matrix of data
# ... : further arguments to pass to the native R cor.test function
cor.mtest <- function(mat, ...) {
  mat <- as.matrix(mat)
  n <- ncol(mat)
  p.mat<- matrix(NA, n, n)
  diag(p.mat) <- 0
  for (i in 1:(n - 1)) {
    for (j in (i + 1):n) {
      tmp <- cor.test(mat[, i], mat[, j], ...)
      p.mat[i, j] <- p.mat[j, i] <- tmp$p.value
    }
  }
  colnames(p.mat) <- rownames(p.mat) <- colnames(mat)
  p.mat
}
#------------------------------------

# matrix of the p-value of the correlation
p.mat <- cor.mtest(Arctic.OO.LR)
head(p.mat[, 1:5])



#----------------------------------
# Plot

col <- colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))



#tiff("SouthernCorrelations_1000.tiff", width = 25, height = 25, units = 'cm', res = 300, compression = 'lzw')

corrplot(res, method="color", col=col(200),  
         type="upper", order="original", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.col="black", tl.srt=45, tl.cex=1, #Text label color and rotation
         # Combine with significance
         #p.mat = p.mat, sig.level = 0.05, insig= "blank", # insig = "pch", pch.col="lightblue", pch= stars,  
         # hide correlation coefficient on the principal diagonal
         diag=FALSE 
)


#dev.off()



#tiff("SouthernCorrelationsLowerNoLabels_1000.tiff", width = 11, height = 11, units = 'cm', res = 400, compression = 'lzw')

corrplot(res, method="color", col=col(200),  
         type="lower", order="original", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.pos= "n",  #tl.col="black", tl.srt=0, tl.cex=0.75, #Text label color and rotation
         # Combine with significance
         #p.mat = p.mat, sig.level = 0.05, insig= "blank", # insig = "pch", pch.col="lightblue", pch= stars,  
         # hide correlation coefficient on the principal diagonal
         diag=FALSE 
)


#dev.off()




tiff("SouthernCorrelationsLowerLabels_1000.tiff", width = 18.3, height = 18.3, units = 'cm', res = 400, compression = 'lzw')

corrplot(res, method="color", col=col(200),  
         type="lower", order="original", 
         addCoef.col = "black", # Add coefficient of correlation
         tl.pos= "ld",  tl.col="black", #tl.srt=0, tl.cex=0.75, #Text label color and rotation
         # Combine with significance
         #p.mat = p.mat, sig.level = 0.05, insig= "blank", # insig = "pch", pch.col="lightblue", pch= stars,  
         # hide correlation coefficient on the principal diagonal
         diag=FALSE 
)


dev.off()






#--------------
#Other option of plot that shows the significant values as stars 


library(corrgram)
col.corrgram <- function(ncol){   
 colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))(ncol)} 

panel.shadeNtext <- function (x, y, corr = NULL, ...) 
{
  corr <- cor(x, y, use = "pair")
  results <- cor.test(x, y, alternative = "two.sided")
  est <- results$p.value
  stars <- ifelse(est < 5e-4, "***", 
                  ifelse(est < 5e-3, "**", 
                         ifelse(est < 5e-2, "*", "")))
 ncol <- 200
 pal <- col.corrgram(ncol)
  col.ind <- as.numeric(cut(corr, breaks = seq(from = -1, to = 1, 
                                               length = ncol + 1), include.lowest = TRUE))
  usr <- par("usr")
  rect(usr[1], usr[3], usr[2], usr[4], col = pal[col.ind],
       border = NA)
  box(col = "lightgrey")
  on.exit(par(usr))
  par(usr = c(0, 1, 0, 1))
  r <- formatC(corr, digits = 2, format = "f") # number of digits of the correlations
  cex.cor <- .9/strwidth("-X.xx") # size of the numbers inside 
  fonts <- ifelse(stars != "", 2,1)
  # option 1: stars:
  text(0.5, 0.5, paste0(r,"\n", stars), cex = cex.cor, font= 2) # font = 2 makes the numbers inside bold
  # option 2: bolding:
  #text(0.5, 0.5, r, cex = cex.cor, font=fonts)
}

# Generate some sample data
sample.data <- Antarctic.OO.LR

# Call the corrgram function with the new panel functions
# NB: call on the data, not the correlation matrix



tiff("SouthernCorrelations_Sig_1000_NEW_NLabel.tiff", width = 18.3, height = 18.3, units = 'cm', res = 400, compression = 'lzw')

corrgram(sample.data, type="data", lower.panel=panel.shadeNtext, 
         upper.panel=NULL, labels = NULL )

dev.off()






