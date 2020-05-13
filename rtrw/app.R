library(shiny)
library(bs4Dash)
library(shinymanager)
library(shinyalert)
library(shinyjs)
library(waiter)

# Databases
library(RSQLite)
library(RPostgreSQL)
library(dplyr)
library(stringr)
library(lubridate)

ui <- bs4DashPage(
  title = "SAMARGA",
  sidebar_collapsed = TRUE, sidebar_mini = TRUE, 
  navbar = bs4DashNavbar(skin = "light", status = "white", 
                         leftUi = fluidRow(img(src = "img/logo-desa.png", width = "6%"))), 
  sidebar = bs4DashSidebar(skin = "light", inputId = "myside", 
                           # src = "img/logo-desa.png",
                           title = HTML("<strong>RT 01/01</strong>")),
  body = bs4DashBody(
    tags$head(
      tags$link(rel = "shortcut icon", href = "img/logo-kab-bekasi.png")
    ),
    use_waiter(),
    waiter_show_on_load(),
    useShinyalert()
  )
)

server <- function(input, output, session){
  waiter_show( # show the waiter
    # spin_fading_circles() # use a spinner
    spin_dual_circle()
  )
  Sys.sleep(3)
  waiter_hide() # hide the waiter
  
  shinyalert(title = "S A M A R G A", text = "Sistem dan Aplikasi Masyarakat Sejahtera dan Bahagia")
}

shinyApp(ui, server)
