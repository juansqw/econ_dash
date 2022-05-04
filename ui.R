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
      tabItem(tabName = 'inflacion',
              h2("Precios"),
              h4('Inflación total'),
              fluidRow(
                column(width = 6),
                column(width = 6,
                       radioButtons('variacion',
                                    label = 'Variación',
                                    inline = TRUE,
                                    choiceNames = c('Interanual',
                                                    'Mensual'),
                                    choiceValues = c('vi',
                                                     'vm'),
                                    selected = 'vi')),
                ),
              single_line_plot_ui('inf_endyear'),
              
              h4('Inflación por grupos'),
              fluidRow(
                column(width = 6,
                       selectInput("grupo", 
                                   label = "Seleccione grupo",
                                   choices = c('Alimentos y bebidas no alcoholicas' = 'alimentos_y_bebidas_no_alcoholicas_grupo_',
                                               'Bebidas alcohólicas y tabaco' = 'bebidas_alcoholicas_y_tabaco_grupo_',
                                               'Prendas de vestir y calzao' = 'prendas_de_vestir_y_calzado_grupo_',
                                               'Vivienda' = 'vivienda_grupo_',
                                               'Muebles y artículos para el hogar' = 'muebles_y_articulos_para_el_hogar_grupo_',
                                               'Salud' = 'salud_grupo_',
                                               'Transporte' = 'transporte_grupo_',
                                               'Comunicaciones' = 'comunicaciones_grupo_',
                                               'Recreación y cultura' = 'recreacion_y_cultura_grupo_',
                                               'Educación' = 'educacion_grupo_',
                                               'Restaurantes y hoteles' = 'restaurantes_y_hoteles_grupo_',
                                               'Bienes y servicios diversos' = 'bienes_y_servicios_diversos_grupo_'),
                                   selected = 'alimentos_y_bebidas_no_alcoholicas_grupo_')
                ),
                column(width = 6,
                       radioButtons('variacion_grupo',
                                    label = 'Variación',
                                    inline = TRUE,
                                    choiceNames = c('Interanual',
                                                    'Mensual'),
                                    choiceValues = c('vi',
                                                     'vm'),
                                    selected = 'vi'))
              ),
              single_line_plot_ui('inf_grupo'),
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
              single_line_plot_ui('imae_plot')
      )
    )
  )
)