# Aplikasi Sawarga (SID) level Desa

# Shiny-related
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyalert)
library(shinyjs)
library(DT)
library(waiter)

# Databases
library(RPostgreSQL)
library(data.table)
library(stringr)
library(lubridate)

# Map
library(leaflet)

ui <- dashboardPagePlus(skin = "purple", title = sprintf("Sawarga - %s", "Desa Hegarmanah"), 
                    header = dashboardHeaderPlus(title = span("S  a  w  a  r  g  a", style="font-weight:bold;color:#fff;"), 
                                                 left_menu = tagList(dropdownMenu(type = "messages", badgeStatus = "success",
                                                                                    messageItem("Support Team",
                                                                                                "This is the content of a message.",
                                                                                                time = "5 mins"
                                                                                    ),
                                                                                    messageItem("Support Team",
                                                                                                "This is the content of another message.",
                                                                                                time = "2 hours"
                                                                                    ),
                                                                                    messageItem("New User",
                                                                                                "Can I get some help?",
                                                                                                time = "Today"
                                                                                    )
                                                                                  ),
                                                                     # Dropdown menu for notifications
                                                                     dropdownMenu(type = "notifications", badgeStatus = "info",
                                                                                  notificationItem(icon = icon("users"), status = "info",
                                                                                                   "5 new members joined today"
                                                                                  ),
                                                                                  notificationItem(icon = icon("warning"), status = "danger",
                                                                                                   "Resource usage near limit."
                                                                                  ),
                                                                                  notificationItem(icon = icon("shopping-cart", lib = "glyphicon"),
                                                                                                   status = "success", "25 sales made"
                                                                                  ),
                                                                                  notificationItem(icon = icon("user", lib = "glyphicon"),
                                                                                                   status = "danger", "You changed your username"
                                                                                  )
                                                                     ),
                                                                     # img(src = "img/sawarga.png", width = "4%"),
                                                                     div("Sistem dan Aplikasi Warga Sejahtera dan Bahagia", style="font-weight:bold;color:#fff;font-size:18px;margin-left:auto;margin-right:auto;text-align:right;")
                                                                     
                                                 ), enable_rightsidebar = FALSE
                    ),
                    sidebar = dashboardSidebar(
                      # sidebarUserPanel("Desa Hegarmanah",
                      #                  subtitle = "Cikarang Timur, Bekasi"#,
                      #                  # Image file should be in www/ subdir
                      #                  # image = "img/sawarga.png"
                      # ),
                           sidebarMenu(id = "mysidemenu", 
                                       div(style="display: block;margin-left: auto;margin-right: auto;margin-top:10px;width: 75%;", 
                                           img(src = "img/sawarga.png", width = "100%")#,
                                           # h4("Desa Hegarmanah", style="text-align:center;"),
                                           # p("Kec. Cikarang Timur, Bekasi", style="text-align:center;")
                                           ),
                                       menuItem(tabName = "dashboard", text = "Dashboard", icon = icon("home")),
                                       menuItem(tabName = "infopenting", text = "Informasi Penting", icon = icon("exclamation-triangle"), selected = TRUE),
                                       menuItem(tabName = "desa", text = "Profil Desa", icon = icon("palette"),
                                                menuSubItem(tabName = "wiladmin", text = "Wilayah Administratif"),
                                                menuSubItem(tabName = "strukturpemerintahan", text = "Struktur Pemerintahan Desa")),
                                       menuItem(tabName = "kependudukan", text = "Kependudukan", icon = icon("users"),
                                                menuSubItem(tabName = "datapenduduk", text = "Data Penduduk"),
                                                menuSubItem(tabName = "datakk", text = "Data Kepala Keluarga"),
                                                menuSubItem(tabName = "datakelompok", text = "Data Kelompok"),
                                                menuSubItem(tabName = "datapemilih", text = "Data Pemilih")),
                                       menuItem(tabName = "statistik", text = "Statistik", icon = icon("chart-bar"),
                                                menuSubItem(tabName = "statpenduduk", text = "Statistik Kependudukan"),
                                                menuSubItem(tabName = "laporanbulanan", text = "Laporan Bulanan")),
                                       menuItem(tabName = "sekretariat", text = "Sekretariat", icon = icon("mail-bulk"),
                                                menuSubItem(tabName = "suratmasuk", text = "Surat Masuk"),
                                                menuSubItem(tabName = "suratkeluar", text = "Surat Keluar")),
                                       menuItem(tabName = "keuangan", text = "Keuangan", icon = icon("money-bill-wave"), 
                                                menuSubItem(tabName = "inputdatakeuangan", text = "Input Data"),
                                                menuSubItem(tabName = "laporankeuangan", text = "Laporan Keuangan"))
                                          )),
                    body = dashboardBody(
                      tags$head(
                        tags$link(rel = "shortcut icon", href = "img/sawarga.png")
                        ),
                      useShinyjs(),
                      # waiter_show_on_load(),
                      useShinyalert(),
                      tabItems(
                        tabItem(tabName = "dashboard",
                                fluidRow(
                        
                        # valueBoxes
                        box(status = "primary", width = 8,
                          valueBox(width = 6,
                            uiOutput("orderNum"), "New Orders", icon = icon("credit-card"),
                            href = "http://google.com"
                          ),
                          valueBox(width = 6,
                            tagList("60", tags$sup(style="font-size: 20px", "%")),
                            "Approval Rating", icon = icon("line-chart"), color = "green"
                          ),
                          valueBox(width = 12,
                            htmlOutput("progress"), "Progress", icon = icon("users"), 
                            color = "olive"
                          )
                        ),

                        # Boxes with solid color, using `background`
                        fluidRow(
                          # Box with textOutput
                          box(
                            title = "Status summary",
                            background = "green",
                            width = 4,
                            textOutput("status")
                          ),
                          
                          # Box with HTML output, when finer control over appearance is needed
                          box(
                            title = "Status summary 2",
                            width = 4,
                            background = "red",
                            uiOutput("status2")
                          ),
                          
                          box(
                            width = 4,
                            background = "light-blue",
                            p("This is content. The background color is set to light-blue")
                          )
                      
                      )
                    )),
                      tabItem(tabName = "infopenting",
                              fluidRow(
                                box(
                                title = "Timeline",
                                status = "info",
                                timelineBlock(
                                  timelineEnd(color = "danger"),
                                  timelineLabel(2018, color = "teal"),
                                  timelineItem(
                                    title = "Item 1",
                                    icon = "gears",
                                    color = "olive",
                                    time = "now",
                                    footer = "Here is the footer",
                                    "This is the body"
                                  ),
                                  timelineItem(
                                    title = "Item 2",
                                    border = FALSE
                                  ),
                                  timelineLabel(2015, color = "orange"),
                                  timelineItem(
                                    title = "Item 3",
                                    icon = "paint-brush",
                                    color = "maroon",
                                    timelineItemMedia(src = "https://placehold.it/150x100"),
                                    timelineItemMedia(src = "https://placehold.it/150x100")
                                  ),
                                  timelineStart(color = "gray")
                                )
                              ),
                              
                              box(
                                width = 6,
                                h3("When Reversed = FALSE, can be displayed out of a box"),
                                timelineBlock(
                                  reversed = TRUE,
                                  timelineStart(color = "gray"),
                                  br(),
                                  timelineLabel(format(Sys.Date()-2, "%A %d %b %Y"), color = "teal"),
                                  timelineItem(
                                    title = "Item 1",
                                    color = "olive",
                                    time = "now",
                                    footer = "Here is the footer",
                                    "This is the body"
                                  ),
                                  timelineLabel(format(Sys.Date()-1, "%A %d %b %Y"), color = "teal"),
                                  timelineItem(
                                    title = "Item 2",
                                    border = FALSE
                                  ),
                                  timelineLabel(format(Sys.Date(), "%A %d %b %Y"), color = "teal"),
                                  timelineItem(
                                    title = "Item 3",
                                    icon = "paint-brush",
                                    color = "maroon",
                                    timelineItemMedia(src = "https://placehold.it/150x100"),
                                    timelineItemMedia(src = "https://placehold.it/150x100")
                                  ),
                                  timelineEnd(color = "danger")
                                )
                              )
                              )
                              ),
                    tabItem(tabName = "wiladmin", 
                            fluidRow(
                              box(div(img(src = "https://2.bp.blogspot.com/-dKElaqm0DOY/XEbinjLHHKI/AAAAAAAAAdI/CLei_YAvR9snuoEuNqZJDuGGeJ7foJgaACLcBGAs/w1200-h630-p-k-no-nu/20190122_162844.jpg", 
                                      width = "100%"),
                                      style = "display:block;margin-left:auto;margin-right:auto:width:75%;"),
                                  DT::dataTableOutput("infodesa")
                                  ),
                              box(leafletOutput("kantordesa", height = 550))
                            )
                            )
                    )
                    )
)


server <- function(input, output, session){
  # waiter_show( # show the waiter
  #   # spin_fading_circles() # use a spinner
  #   spin_dual_circle()
  # )
  # Sys.sleep(3)
  output$user <- renderUser({
    dashboardUser(
      name = "Divad Nojnarg", 
      src = "https://adminlte.io/themes/AdminLTE/dist/img/user2-160x160.jpg", 
      title = "shinydashboardPlus",
      subtitle = "Author", 
      footer = p("The footer", class = "text-center"),
      fluidRow(
        dashboardUserItem(
          width = 6,
          socialButton(
            url = "https://dropbox.com",
            type = "dropbox"
          )
        ),
        dashboardUserItem(
          width = 6,
          socialButton(
            url = "https://github.com",
            type = "github"
          )
        )
      )
    )
  })
  # auth <- secure_server(
  #   check_credentials = check_credentials(db = "data/database.sqlite")
  # )
  waiter_hide() # hide the waiter
  
  output$orderNum <- renderText({
    prettyNum(67272, big.mark=",")
  })
  
  output$orderNum2 <- renderText({
    prettyNum(83854, big.mark=",")
  })
  
  output$progress <- renderUI({
    tagList(76, tags$sup(style="font-size: 20px", "%"))
  })
  
  output$progress2 <- renderUI({
    paste0(76, "%")
  })
  
  output$status <- renderText({
    paste0("There are ", 84586,
           " orders, and so the current progress is ", 76, "%.")
  })
  
  output$infodesa <- DT::renderDataTable({
    datatable(data.frame(Data = c("Kecamatan", "Kabupaten", "Nama Kepala Desa/Lurah", "Luas Wilayah", "Jumlah Penduduk", "Kepadatan Penduduk"),
               Keterangan = c("Cikarang Timur", "Bekasi", "H. Amid Hendra F, A.Md", "613.60 Ha", "8.736 jiwa", "1.439 jiwa/km²")), 
              rownames = FALSE, options = list(dom = "t")
    )
  })
  
  output$kantordesa <- renderLeaflet({
    data.frame(lng = c(107.1971, 107.19833), 
               lat = c(-6.31946, -6.32724), 
               label_text = c("Kantor Kepala Desa Hegarmanah", "Ketua RT 002/004"), 
               popup_text = c("", "Bapak Tatang")) %>% 
      leaflet() %>%
      addTiles() %>%
      addMarkers(lng = ~lng, lat = ~lat, 
                 label = ~paste0(label_text, ": ", popup_text)) %>%
      # addMarkers(lng = 107.19833, lat = -6.32724, label = HTML(paste0("Ketua RT 002/004<br/>Bapak Tatang"))) %>% 
      # addMiniMap() %>% 
      setView(lng = 107.1971, lat = -6.31946, zoom = 15)
  })
  
  # shinyAppDir("rtrw")
  # shinyalert(title = "", text = "Sistem dan Aplikasi Warga Sejahtera dan Bahagia", imageUrl = "img/sawarga.png", imageWidth = 270, imageHeight = 270)
}

shinyApp(ui, server)
