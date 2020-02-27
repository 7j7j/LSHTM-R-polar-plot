### 0.  Load required packages  ###

# install.packages(c('tidyverse', 'forecast', 'here'))

library(tidyverse) 
library(forecast)
library(here)

### 1. Set filepath and load required data with reformatted dates  ###

set_here() # sets filepath to folder currently containing this script

data_orig <- read.csv(here::here("polar-plot-death-DTOC.csv")) 
# load example data
data_use <- data_orig %>% 
  mutate(ï..month=as.character(ï..month)) %>%  # change factor var to a string
  mutate(date=paste0('24', ï..month, year, sep = "", collapse = NULL)) %>% #combine strings
  mutate(date=as.Date(date, "%d%B%Y")) # convert string to date

data_use <- data_use %>% 
  select(-ï..month, -year) %>%  #drop month and year
  filter(!is.na(ONS_pop_est))   #drop 9 missing observations

### 2. Create some analysis variables and look at summary descriptives ###

data_use <- data_use %>%   
  mutate(annual_mort = out_deaths_total * 1000 / ONS_pop_est,  
         dtoc_days_rate = exp_days_dtoc * 1000 / ONS_pop_est)
         
### 3. Create some analysis vars and time series objects in R for variables of interest  ###
#... Specify a monthly time series for DTOC days and deaths, starting from August 2010
ts_dtocdays_all <- ts(data_use$exp_days_dtoc, frequency=12, start=c(2010, 8))
ts_deaths_all <- ts(data_use$out_deaths_total, frequency=12, start=c(2010, 8))


### 4. Draw your polar seasonal plots of deaths and days of DTOC in England from 2010-18  ###
ggseasonplot(ts_deaths_all, polar=TRUE) +
  ylab("Count of deaths") + ggtitle("Polar seasonal plot: deaths in England")
# ggsave("deaths-England-polar.jpg")

ggseasonplot(ts_dtocdays_all, polar=TRUE) +
  ylab("Count of days delayed in transfers of care") + ggtitle("Polar seasonal plot: days of DTOCs in England")
# ggsave("DTOCs-England-polar.jpg")
