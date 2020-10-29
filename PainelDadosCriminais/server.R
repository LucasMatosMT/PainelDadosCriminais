library(ggplot2)
library(lubridate)
library(stringr)
library(forecast)
library(DT)

server <- function(input, output) {
  
  dados <- read.csv("~/PainelDadosCriminais/dados209-2020p.csv")
  
  
  colnames(dados)[1] <- 'bo'
  # Cria fator para os municípios.
  dados$Municipio.Fato <- factor(dados$Municipio.Fato)
  dados$Data <- as.Date(parse_date_time(dados[["Data.Fato"]], '%Y-%m-%d'))
  dados$mes_data <- format(dados$Data, "%Y-%m")
  
  
  n_municipio_dados <- aggregate(bo ~ Municipio.Fato + Natureza.Ocorrencia + mes_data, 
                                 data=dados, 
                                 FUN=length)
  
  arima_shiny = function(cid,nat,per){
    municipio <- cid
    naturezas <- nat
    periodo <- per
    
    n_municipio <- n_municipio_dados %>% 
      filter(Municipio.Fato %in% municipio & Natureza.Ocorrencia %in% naturezas) %>%
      aggregate(bo ~ mes_data,.,sum)
    
    n_municipio <- n_municipio %>% 
      mutate(ano = str_sub(mes_data,end = 4) %>% as.integer()) %>%
      filter(ano > periodo) %>% 
      select(-ano)
    
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
                         start = c(input$inputPeriodo,
                                   month(n_municipio[1, 'mes_data'])),
                         frequency = 12)
    
    l <- BoxCox.lambda(ts_n_municipio)
    ajuste <- auto.arima(ts_n_municipio, lambda = l)
    f <- forecast(ajuste, h = 5)
    return(f)
    
  }
  
  output$plot1 = renderPlot({
    plot(arima_shiny(input$inputCidade,input$inputNatureza,input$inputPeriodo))
  })
  
  output$table1 = DT::renderDataTable({DT::datatable(arima_shiny(input$inputCidade,input$inputNatureza,input$inputPeriodo) %>%
                                                       as.data.frame() %>% 
                                                       round(2),
                                                    extensions = 'Buttons',
                                                    options = list(
                                                      paging = TRUE,
                                                      searching = TRUE,
                                                      fixedColumns = TRUE,
                                                      autoWidth = TRUE,
                                                      ordering = TRUE,
                                                      dom = 'Bfrtip',
                                                      buttons = c('copy', 'excel')
                                                    ),
                                                    
                                                    class = "display")})
}



