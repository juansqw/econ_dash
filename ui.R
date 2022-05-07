# UI

ui <- dashboardPage(
  dashboardHeader(title = 'ECON_DASH'),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Inflación", 
               tabName = "inflacion", 
               icon = icon('money-bill')),
      menuItem("Actividad Económica", 
               tabName = "actividad", 
               icon = icon('chart-line'))
    )
    
  ),
  dashboardBody(
    tabItems(
# ---- Inflacion ----
      tabItem(tabName = 'inflacion',
              h2("Precios"),
              h4('Incidencias de grupos sobre la inflación interanual'),
              p('Último mes observado.'),
              plotlyOutput('waterfall'),
              h4('Inflación total'),
              fluidRow(
                column(width = 6),
                column(width = 6,
                       radioButtons('variacion_total',
                                    label = 'Variación',
                                    inline = TRUE,
                                    choiceNames = c('Interanual',
                                                    'Mensual'),
                                    choiceValues = c('_vi',
                                                     '_vm'),
                                    selected = '_vi'))
              ),
              plotlyOutput('inf_total'),
              
              h4('Inflación por grupos'),
              fluidRow(
                column(width = 6,
                       selectInput("grupo", 
                                   label = "Seleccione grupo",
                                   choices = groups,
                                   selected = 'alimentos_y_bebidas_no_alcoholicas_grupo')
                ),
                column(width = 6,
                       radioButtons('variacion_grupo',
                                    label = 'Variación',
                                    inline = TRUE,
                                    choiceNames = c('Interanual',
                                                    'Mensual'),
                                    choiceValues = c('_vi',
                                                     '_vm'),
                                    selected = '_vi'))
              ),
              plotlyOutput('inf_grupo'),
              
              h4('Inflación por agregados'),
              fluidRow(
                column(width = 6,
                       selectInput("agregado", 
                                   label = "Seleccione agregado",
                                   choices = c('Subyacente - No subyacente' = 'subyacente',
                                               'Transable - No transable' = 'transables'),
                                   selected = 'subyacente')
                ),
                column(width = 6,
                       radioButtons('variacion_agregado',
                                    label = 'Variación',
                                    inline = TRUE,
                                    choiceNames = c('Interanual',
                                                    'Mensual'),
                                    choiceValues = c('_vi',
                                                     '_vm'),
                                    selected = '_vi'))
              ),
              plotlyOutput('inf_agregado')
              ),
# ---- Actividad ----
      tabItem(tabName = 'actividad',
              h2('Actividad Económica'),
              h4('Indice Mensual de Actividad Económica'),
              fluidRow(
                column(width = 6),
                column(width = 6,
                       radioButtons('variacion_imae',
                                    label = 'Variación',
                                    inline = TRUE,
                                    choiceNames = c('Interanual',
                                                    'Mensual'),
                                    choiceValues = c('vi',
                                                     'vm'),
                                    selected = 'vi')),
              ),
              plotlyOutput('imae_plot'),
              h4('PIB por sectores de origen'),
              var_incidencias_ui('pib_sectores'),
              h4('PIB por el enfoque del gasto'),
              var_incidencias_ui('pib_gasto')
              )
    )
  )
)