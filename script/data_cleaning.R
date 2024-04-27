library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)
library(shinydashboard)
library(readr)


## 1. Download the World Value Study (wave 6) from here: http://www.worldvaluessurvey.org/WVSDocumentationWV6.jsp.

# data
load("data/WV6_Data_R_v20201117.rdata")
wvs <- WV6_Data_R_v20201117[, c("V2", "V228A", "V228B", "V228C", "V228D", "V228E", "V228F", "V228G", "V228H", "V228I",
                                "V217", "V218", "V219", "V220", "V221", "V222", "V223", "V224",
                                "V192", "V193", "V194", "V195", "V196", "V197")]



# change country name
cleaned_wvs <- wvs
cleaned_wvs$country = factor(cleaned_wvs$V2,
                     levels = c(12, 31, 32, 36, 51, 76, 112, 152, 156, 158, 
                                170, 196, 218, 233, 268, 275, 276, 288, 332, 344, 
                                356, 368, 392, 398, 400, 410, 414, 417, 422, 434,
                                458, 484, 504, 528, 554, 566, 586, 604, 608, 616,
                                634, 642, 643, 646, 702, 705, 710, 716, 724, 752, 
                                764, 780, 788, 792, 804, 818, 840, 858, 860, 887
                                ),
                     labels = c("Algeria", "Azerbaijan", "Argentina", "Australia", "Armenia", "Brazil", "Belarus", "Chile", "China", "Taiwan",
                                "Colombia", "Cyprus", "Ecuador", "Estonia", "Georgia", "Palestine", "Germany", "Ghana", "Haiti", "Hong Kong",
                                "India", "Iraq", "Japan", "Kazakhstan", "Jordan", "South Korea", "Kuwait", "Kyrgyzstan", "Lebanon", "Libya",
                                "Malaysia", "Mexico", "Morocco", "Netherlands", "New Zealand", "Nigeria", "Pakistan", "Peru", "Philippines", "Poland",
                                "Qatar", "Romania", "Russia", "Rwanda", "Singapore", "Slovenia", "South Africa", "Zimbabwe", "Spain", "Sweden",
                                "Thailand", "Trinidad and Tobago", "Tunisia", "Turkey", "Ukraine", "Egypt", "United States", "Uruguay", "Uzbekistan", "Yemen"
                                ))

# recode variable names
colnames(cleaned_wvs) <- c("country_code", "Votes are counted fairly", "Opposition candidates prevented from running", "TV news favors the governing party", "Voters are bribed", "Journalists provide fair coverage of elections", "Election officials are fair", "Rich people buy elections", "Voters are threatened with violence at the polls", "Voters are offered a genuine choice in the elections", 
                   "Daily newspaper", "Printed magazines", "TV news", "Radio news", "Mobile phone", "Email", "Internet", "Talk with friends or colleagues",
                   "Science and technology are making our lives healthier, easier, and more comfortable", "There will be more opportunities for the next generation", "We depend too much on science and not enough on faith", "It breaks down people’s ideas of right and wrong", "It is not important for me to know about science in my daily life", "The world is better off, or worse off, because of science and technology", "country")

# recode value names
#for (i in 2:10){
  cleaned_wvs[,i] <- factor(cleaned_wvs[,i],
                   levels = c(1, 2, 3, 4),
                   labels = c("Very often", "Fairly often", "Not often", "Not at all often"))
}

#for (i in 11:18){
  cleaned_wvs[,i] <- factor(cleaned_wvs[,i],
                    levels = c(1, 2, 3, 4, 5),
                    labels = c("Daily", "Weekly", "Monthly", "Less than monthly", "Never"))
}

#save cleaned dataset
write_csv(cleaned_wvs, "cleaned_wvs.csv")