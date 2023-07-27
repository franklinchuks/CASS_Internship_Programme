## ---------------------------
##
## Script name: Automated Survey Analyzer
##
## Purpose of script: Universal utility for analyzing survey data and outputting usable results and visulaizations
##
## Author: Martin Hayford
##
## Date Created: 27.07.2023 (version 2.0)
##
## Copyright (c) University of Tartu Centre for Applied Social Sciences, 2023
## Email: martin.hayford@ut.ee
##
## ---------------------------
##
## Notes: Internship project code for CASS summer internship program 2023
##   
##
## ---------------------------

## set working directory for Mac and PC

# automatically set to local github repository

## ---------------------------

#clear all
rm(list=ls())

# Importing Packages
library(tidyverse)
library(forcats)
library(janitor)
library(scales)
library(officer)
library(flextable)

# Importing Raw Data
rawData <- read.csv("mobireSurvey.csv")

