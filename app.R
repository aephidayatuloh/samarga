library(shiny)
library(bs4Dash)
library(shinymanager)
library(waiter)

# Databases
library(RSQLite)
library(RPostgreSQL)
library(dplyr)
library(stringr)
library(lubridate)

# credentials <- data.frame(
#   user = c("shiny", "shinymanager"),
#   password = c("12345", "12345"),
#   applications = c("rtrw", "desa"),
#   stringsAsFactors = FALSE
# )
# 
# create_db(credentials, "data/database.sqlite")

ui <- fluidPage(
  title = "SAWARGA",
  tags$head(
    tags$link(rel = "shortcut icon", href = "img/sawarga.png")
  ),
  use_waiter(),
  waiter_show_on_load(),
  useShinyalert()
  
)

set_labels(language = "en", 
           "Please authenticate" = "", 
           "Username:" = "Username", 
           "Password:" = "Password"
           )

ui <- secure_app(ui, enable_admin = TRUE, 
                 tags_top = tags$img(src = "img/sawarga.png", width = "30%"),
                 # change auth ui background ?
                 background  = "url('img/sawarga.png')  no-repeat left;",
                 tags_bottom = tags$img(src = "img/desaonline.png", width = "20%"),

                 theme = shinythemes::shinytheme("cerulean"))

server <- function(input, output, session){
  waiter_show( # show the waiter
    # spin_fading_circles() # use a spinner
    spin_dual_circle()
  )
  Sys.sleep(3)
  auth <- secure_server(
    check_credentials = check_credentials("data/database.sqlite")
  )
  waiter_hide() # hide the waiter
  
  # shinyAppDir("rtrw")
  shinyalert(title = "SAWARGA", text = "Sistem dan Aplikasi Warga Sejahtera dan Bahagia")
}

shinyApp(ui, server)
