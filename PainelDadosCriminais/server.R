library(ggplot2)
library(lubridate)
library(stringr)
library(forecast)

server <- function(input, output) {
  
  base <- read_delim("DADOS PARA PESQUISA_HOMICIDIO E ROUBO (2017-2019) - FONTE_SINESP.csv",";", escape_double = FALSE, trim_ws = TRUE)
  
  base %>% 
    mutate(tempo = paste("01",MES,ANO,sep = "-") %>% lubridate::dmy(),)
  
  output$plot1 <- renderPlot({
    fit2 = forecast::auto.arima(base %>% filter(MUNICIPIO == input$inputCidade & NATUREZA == input$inputNatureza) %>% select(TOTAL))
    autoplot(forecast::forecast(fit2,h = 6))+
      theme(text = element_text(size=22))
  })
}

