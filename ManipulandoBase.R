library(tidyverse)
library(readr)
library(stringi)


dados <- read.csv("~/PainelDadosCriminais/dados209-2020p.csv")


colnames(dados)[1] <- 'bo'
# Cria fator para os municípios.
dados$Municipio.Fato <- factor(dados$Municipio.Fato)

# Converte campo de data do fato.
# install.packages('lubridate')
library(lubridate)

dados$Data <- as.Date(parse_date_time(dados[["Data.Fato"]], '%Y-%m-%d'))

dados$mes_data <- format(dados$Data, "%Y-%m")
dados %>% nrow()
dados %>% ncol()


n_municipio_dados <- aggregate(bo ~ Municipio.Fato + Natureza.Ocorrencia + mes_data, 
                               data=dados, 
                               FUN=length)


# trabalhanco com bairros

n_bairros = aggregate(bo ~ Municipio.Fato + Natureza.Ocorrencia + mes_data + Bairro.Fato,data = dados %>% filter(Municipio.Fato == "CUIABA"), FUN = length)

n_bairros %>% count(Bairro.Fato) %>% arrange(desc(n)) %>% select(Bairro.Fato) %>% pull() %>% unique() %>% length()



# Seleciona município e natureza.
municipio <- 'CUIABA'
natureza <- 'ROUBO'

n_municipio <-
  n_municipio_dados[n_municipio_dados$Municipio.Fato == municipio &
                      n_municipio_dados$Natureza.Ocorrencia == natureza, ]


n_municipio$mes_data <- as.Date(parse_date_time(n_municipio[["mes_data"]], '%Y-%m'))

aux <- data.frame(seq.Date(
  from = min(n_municipio$mes_data) ,
  to = max(n_municipio$mes_data),
  by = 'month'
))


colnames(aux) <- 'mes_data'



n_municipio <-
  merge(x = aux,
        y = n_municipio,
        by = 'mes_data',
        all.x = TRUE)


n_municipio$Municipio.Fato <- municipio
n_municipio$Natureza.Ocorrencia <- natureza
n_municipio[is.na(n_municipio$bo), 'bo'] <- 0

ts_n_municipio <- ts(n_municipio[, 'bo'],
                     start = c(year(n_municipio[1, 'mes_data']),
                               month(n_municipio[1, 'mes_data'])),
                     frequency = 12)

plot(ts_n_municipio)


#install.packages('forecast')
library(forecast)

l <- BoxCox.lambda(ts_n_municipio)
ajuste <- auto.arima(ts_n_municipio, lambda = l)
f <- forecast(ajuste, h = 5)

plot(f)
