#devtools::install_github("timjmiller/wham", dependencies=TRUE)
#devtools::install_github("timjmiller/wham", dependencies=TRUE,ref="devel")
#pak::pkg_install("timjmiller/wham@devel")

library(wham)
library(dplyr)
library(tidyr)
library(ggplot2)
library(purrr)
##############
#read in the mm192.
runs=c("mm192_meanrecpar_4Feb2025") 
mod.list <- file.path(paste(paste("C:/Herring/2025 Assessment RT/Assessments/WHAM",runs,sep="/"),paste0(runs,".rds"),sep="/"))
mm192 <- lapply(mod.list, readRDS)
names(mm192)="mm192"

#########mm205 Try linear controlling; Everything should be lag-1 in all these fits.
#controlling is only thing available with random about mean and it basically changes
#the underlying mean each year with the ecov and should reduce rec sd and obs sd
#need to add bh if you want other options.
# setup the wham ecov
ecov <- list(label = c("Haddock Predation on Eggs"))
ecov$mean <- matrix(hadd.data$log_est)
ecov$logsigma <- "est_1"
ecov$year <- hadd.data$YEAR
hadd.data$use_obs=TRUE
ecov$use_obs <- matrix(hadd.data$use_obs)
ecov$process_model <- "rw"
ecov$recruitment_how <- matrix("controlling-lag-1-linear")

#
mod.dir="mm205"
write.dir <- paste("C:/Herring/2025 Assessment RT/Assessments/WHAM",mod.dir,sep="/")
dir.create(write.dir)
setwd(write.dir)
input205 <- set_ecov(mm192$mm192$input, ecov)

mod <- fit_wham(input205, do.proj=FALSE,do.osa = TRUE,do.retro = TRUE,do.check = T,do.sdrep = TRUE)
saveRDS(mod,file=file.path(write.dir,paste0(mod.dir,".rds")))
plot_wham_output(mod,out.type="png")
mm205=mod
##So this had essentially identical AIC and improved NLL by ~1. Did almost nothing
#to reduce recruitment variance or observation variance. So not doing much.


#############I can't find the code for mm207 at the moment, but something like below should be close to functional
input207=mm205$input
newNAA=list(sigma="rec")
input207=set_NAA(input207,newNAA)
mod.dir="mm207"
write.dir <- paste("C:/Herring/2025 Assessment RT/Assessments/WHAM",mod.dir,sep="/")
dir.create(write.dir)
setwd(write.dir)
mm207 <- fit_wham(input207, do.proj=FALSE,do.osa = TRUE,do.retro = TRUE,do.check = T,do.sdrep = TRUE)
saveRDS(mm207,file=file.path(write.dir,paste0(mod.dir,".rds")))
plot_wham_output(mm207,out.type="png")



