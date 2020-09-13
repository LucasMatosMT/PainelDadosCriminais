library(readr)
library(tidyverse)
library(lubridate)
library(stringr)

base <- read_delim("DADOS PARA PESQUISA_HOMICIDIO E ROUBO (2017-2019) - FONTE_SINESP.csv",";", escape_double = FALSE, trim_ws = TRUE)


base %>% 
  mutate(tempo = paste("01",MES,ANO,sep = "-") %>% lubridate::dmy(),)



