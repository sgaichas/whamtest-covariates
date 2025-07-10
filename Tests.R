# Compare herring models with and without covariates and NAA RE
# For ICES ASC talk
# based on Jon's script SG_9July2025.R and my WHAMfits_larvalTemp_NAA_REoff.R
# In OriginalCode folder

# What models have we got outputs for?

# Haddock predation covariate

# this is NAA RE on with haddock ecov on
mm205 <- readRDS(here::here("WHAMfits/mm205/mm205.rds"))

mm205$input$data$Ecov_how_R

# mm204 same model with haddock ecov off, I don't have it but will recreate

# this is NAA RE off with haddock ecov off
mm207 <- readRDS(here::here("WHAMfits/mm207/mm207.rds"))

mm207$input$data$Ecov_how_R

# need NAA RE off with haddock ecov on
# run haddock models modifying Jon's code
library(wham)
library(dplyr)
library(tidyr)
library(ggplot2)
library(purrr)
##############

#read in the mm192.
#runs=c("mm192_meanrecpar_4Feb2025") 
#mod.list <- file.path(paste(paste("C:/Herring/2025 Assessment RT/Assessments/WHAM",runs,sep="/"),paste0(runs,".rds"),sep="/"))
#mm192 <- lapply(mod.list, readRDS)
mm192 <- readRDS(here::here("WHAMfits/mm192_meanrecpar_4Feb25/mm192_meanrecpar_4Feb25.rds"))
#names(mm192)="mm192"

# read covariate data
hadd.data <- read.csv(here::here("covdata/haddock_eat_herring_eggs_index.csv"), header=T)

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
mod.dir="mm205-test"
write.dir <- here::here(sprintf("WHAMfits/%s/", mod.dir))
#write.dir <- paste("C:/Herring/2025 Assessment RT/Assessments/WHAM",mod.dir,sep="/")
dir.create(write.dir)
#setwd(write.dir)
input205 <- set_ecov(mm192$input, ecov)

mod <- fit_wham(input205, do.proj=FALSE,do.osa = TRUE,do.retro = TRUE,do.check = T,do.sdrep = TRUE)
saveRDS(mod,file=file.path(write.dir,paste0(mod.dir,".rds")))
plot_wham_output(mod, dir.main=file.path(write.dir),out.type="png")
mm205=mod
##So this had essentially identical AIC and improved NLL by ~1. Did almost nothing
#to reduce recruitment variance or observation variance. So not doing much.


#############I can't find the code for mm207 at the moment, but something like below should be close to functional

# this does sub in the ecov settings from mm205 so model mm207-ecovon is what we want 
input207=mm205$input
newNAA=list(sigma="rec")
input207=set_NAA(input207,newNAA)
mod.dir="mm207-ecovon"
write.dir <- here::here(sprintf("WHAMfits/%s/", mod.dir))
dir.create(write.dir)
#setwd(write.dir)
mm207 <- fit_wham(input207, do.proj=FALSE,do.osa = TRUE,do.retro = TRUE,do.check = T,do.sdrep = TRUE)
saveRDS(mm207,file=file.path(write.dir,paste0(mod.dir,".rds")))
plot_wham_output(mm207,dir.main=file.path(write.dir),out.type="png")


### also maybe do an ecov off run with NAA RE on for completeness to compare the stats

mod.dir="mm204-ecovoff"
write.dir <- here::here(sprintf("WHAMfits/%s/", mod.dir))
#write.dir <- paste("C:/Herring/2025 Assessment RT/Assessments/WHAM",mod.dir,sep="/")
dir.create(write.dir)
#setwd(write.dir)
ecov$recruitment_how <- matrix("none")
input204 <- set_ecov(mm192$input, ecov)

mod <- fit_wham(input204, do.proj=FALSE,do.osa = TRUE,do.retro = TRUE,do.check = T,do.sdrep = TRUE)
saveRDS(mod,file=file.path(write.dir,paste0(mod.dir,".rds")))
plot_wham_output(mod, dir.main=file.path(write.dir),out.type="png")




#################################################################################

# Temperature duration covariate if we want it for comparison

# this is NAA RE on with temperature ecov off
m3RE <- readRDS(here::here("WHAMfits/mm192_LarvalTempDuration/m3.rds"))

m3RE$input$data$Ecov_how_R

# this is NAA RE on with temperature ecov on
m4RE <- readRDS(here::here("WHAMfits/mm192_LarvalTempDuration/m4.rds"))

m4RE$input$data$Ecov_how_R

# this is NAA RE off with temperature ecov off
m3 <- readRDS(here::here("WHAMfits/mm192_LarvalTempDuration_NAA_REoff/m3.rds"))

m3$input$data$Ecov_how_R


# this is NAA RE off with temperature ecov on
m4 <- readRDS(here::here("WHAMfits/mm192_LarvalTempDuration_NAA_REoff/m4.rds"))

m4$input$data$Ecov_how_R
