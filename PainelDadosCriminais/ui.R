library(shiny)
library(shinydashboard)
library(dashboardthemes)
library(readr)
library(tidyverse)

base <- read_delim("DADOS PARA PESQUISA_HOMICIDIO E ROUBO (2017-2019) - FONTE_SINESP.csv",";", escape_double = FALSE, trim_ws = TRUE)

customTheme <- shinyDashboardThemeDIY(
  ### general
  appFontFamily = "Segoe UI"
  ,appFontColor = "#FFFFFF"
  ,primaryFontColor = "#101678"
  ,infoFontColor = "#101678"
  ,successFontColor = "#EDEDED"
  ,warningFontColor = "#51D6D6"
  ,dangerFontColor = "#EDEDED"
  ,bodyBackColor = "#FFFFFF"
  
  ### header
  ,logoBackColor = "#101678"
  
  ,headerButtonBackColor = "#101678"
  ,headerButtonIconColor = "#51D6D6"
  ,headerButtonBackColorHover = "#51D6D6"
  ,headerButtonIconColorHover = "#101678"
  
  ,headerBackColor = "#101678"
  ,headerBoxShadowColor = "#aaaaaa"
  ,headerBoxShadowSize = "2px 2px 2px"
  
  ### sidebar
  ,sidebarBackColor = cssGradientThreeColors(
    direction = "down"
    ,colorStart = "#101678"
    ,colorMiddle = 	"#0000CD"
    ,colorEnd = "#101678"
    ,colorStartPos = 0
    ,colorMiddlePos = 80
    ,colorEndPos = 100
  )
  ,sidebarPadding = "0"
  
  ,sidebarMenuBackColor = "transparent"
  ,sidebarMenuPadding = "0"
  ,sidebarMenuBorderRadius = 0
  
  ,sidebarShadowRadius = "3px 5px 5px"
  ,sidebarShadowColor = "#aaaaaa"
  
  ,sidebarUserTextColor = "#171616"
  
  ,sidebarSearchBackColor = "#0A0E52"
  ,sidebarSearchIconColor = "#51D6D6"
  ,sidebarSearchBorderColor = "#51D6D6"
  
  ,sidebarTabTextColor = "#51D6D6"
  ,sidebarTabTextSize = "14"
  ,sidebarTabBorderStyle = "none"
  ,sidebarTabBorderColor = "none"
  ,sidebarTabBorderWidth = "0"
  
  ,sidebarTabBackColorSelected = "#51D6D6"
  ,sidebarTabTextColorSelected = "#101678"
  ,sidebarTabRadiusSelected = "0px"
  
  ,sidebarTabBackColorHover = "#51D6D6"
  ,sidebarTabTextColorHover = "#101678"
  ,sidebarTabBorderStyleHover = "none solid none none"
  ,sidebarTabBorderColorHover = "#F0F0F0"
  ,sidebarTabBorderWidthHover = "4"
  ,sidebarTabRadiusHover = "0px"
  
  ### boxes
  ,boxBackColor = "#EBEBEB"
  ,boxBorderRadius = "0"
  ,boxShadowSize = "none"
  ,boxShadowColor = ""
  ,boxTitleSize = "18"
  ,boxDefaultColor = "#E1E1E1"
  ,boxPrimaryColor = "#EBEBEB"
  ,boxInfoColor = "#51D6D6"
  ,boxSuccessColor = "#196616"
  ,boxWarningColor = "#101678"
  ,boxDangerColor = "#9E1303"
  
  ,tabBoxTabColor = "#F5F5F5"
  ,tabBoxTabTextSize = "14"
  ,tabBoxTabTextColor = "#101678"
  ,tabBoxTabTextColorSelected = "#101678"
  ,tabBoxBackColor = "#F5F5F5"
  ,tabBoxHighlightColor = "#101678"
  ,tabBoxBorderRadius = "0"
  
  ### inputs
  ,buttonBackColor = "#CCCCCC"
  ,buttonTextColor = "#101678"
  ,buttonBorderColor = "#101678"
  ,buttonBorderRadius = "0"
  
  ,buttonBackColorHover = "#101678"
  ,buttonTextColorHover = "#51D6D6"
  ,buttonBorderColorHover = "#51D6D6"
  
  ,textboxBackColor = "#1C1C54"
  ,textboxBorderColor = "#51D6D6"
  ,textboxBorderRadius = "0"
  ,textboxBackColorSelect = "#F5F5F5"
  ,textboxBorderColorSelect = "#101678"
  
  ### tables
  ,tableBackColor = "#E0E0E0"
  ,tableBorderColor = "#D1D1D1"
  ,tableBorderTopSize = "1"
  ,tableBorderRowSize = "1"
)

customLogo <- shinyDashboardLogoDIY(
  
  boldText = "Dados"
  ,mainText = "Criminais"
  ,textSize = 16
  ,badgeText = "beta"
  ,badgeTextColor = "#101678"
  ,badgeTextSize = 3
  ,badgeBackColor = "#40E0D0"
  ,badgeBorderRadius = 3
  
)

ui <- dashboardPage(
  dashboardHeader(title = customLogo,titleWidth = "350px"),
  dashboardSidebar(
    sliderInput("slider", "Number of observations:", 1, 100, 50),
    selectInput("inputCidade",label =  "Cidades de Mato Grosso:",
                    choices = base$MUNICIPIO %>% unique %>% sort(),
                    multiple=FALSE,
                    selectize=TRUE,
                    width = '95%'),
    selectInput("inputNatureza",label =  "Natureza:",
                choices = base$NATUREZA %>% unique %>% sort(),
                multiple=FALSE,
                selectize=TRUE,
                width = '95%'),
    width = "350px"
  ),
  dashboardBody(
    customTheme,
    fluidRow(
    box(plotOutput("plot1",height = "500px"),width = 12,status = "primary",title = "Serie Temporal")
    )
  )
)

