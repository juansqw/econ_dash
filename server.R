# Server

server <- function(input, output) {
  
  # Waterfall
  output$waterfall <- renderPlotly({
    waterfall_data %>% 
      plot_ly(type = "waterfall", 
              orientation = 'h',
              measure = ~measure,
              x = ~variacion, 
              y= ~grupo) %>% 
      layout(yaxis = list(title = ''),
             xaxis = list(title = 'Incidencia'))
  })
  
  # Inflacion total
  total_df <- reactive({
    articulos %>% 
      select(fecha, starts_with('indice_general_inflacion'), ends_with(input$variacion_total)) %>% 
      filter(fecha >= as.Date('2010-01-01'))
  }) 
  
  output$inf_total <- renderPlotly({
    total_df() %>% 
      plot_ly(x = ~fecha) %>% 
      add_trace(y = ~.data[[paste0('indice_general_inflacion', input$variacion_total)]], 
                name = 'Variación', 
                type = 'scatter', 
                mode = 'lines',
                line = list(width = 4)) %>% 
      layout(xaxis = list(title = "",
                          dtick = "M1", 
                          tickformat="%b\n%Y",
                          ticklabelmode="period",
                          range = c('2020-03-01','2022-03-01'),
                          rangeslider = list(type = "date")),
             yaxis = list(title = 'Variación'),
             hovermode = 'x',
             showlegend = FALSE)
  })
  
  # Inflacion por grupos
  grupos_df <- reactive({
    articulos %>% 
      select(fecha, starts_with(input$grupo), ends_with(input$variacion_grupo)) %>% 
      filter(fecha >= as.Date('2010-01-01'))
  }) 
  
  output$inf_grupo <- renderPlotly({
    grupos_df() %>% 
      plot_ly(x = ~fecha) %>% 
      add_trace(y = ~.data[[paste0(input$grupo, input$variacion_grupo)]], 
                name = 'Variación', 
                type = 'scatter', 
                mode = 'lines',
                line = list(width = 4)) %>% 
      layout(xaxis = list(title = "",
                          dtick = "M1", 
                          tickformat="%b\n%Y",
                          ticklabelmode="period",
                          range = c('2020-03-01','2022-03-01'),
                          rangeslider = list(type = "date")),
             yaxis = list(title = 'Variación'),
             hovermode = 'x',
             showlegend = FALSE)
  })
  
  # Inflacion por agregado
  agregado_ipc <- reactive({
    articulos %>% 
      select(fecha, (contains(input$agregado) & ends_with(input$variacion_agregado))) 
  })
  
  # Plot
  output$inf_agregado <- renderPlotly({
    agregado_ipc() %>% 
      filter(fecha >= as.Date('2010-01-01')) %>% 
      plot_ly(x = ~fecha) %>% 
      add_trace(y = ~.data[[paste0(input$agregado, input$variacion_agregado)]], 
                name = str_to_title(input$agregado), 
                type = 'scatter', 
                mode = 'lines',
                line = list(width = 4)) %>% 
      add_trace(y = ~.data[[paste0('no_',input$agregado, input$variacion_agregado)]], 
                name = str_to_title(paste0('No ',input$agregado)), 
                type = 'scatter', 
                mode = 'lines',
                line = list(width = 4)) %>% 
      layout(xaxis = list(title = "",
                          dtick = "M1", 
                          tickformat="%b\n%Y",
                          ticklabelmode="period",
                          range = c('2020-03-01','2022-03-01'),
                          rangeslider = list(type = "date")),
             yaxis = list(title = 'Variación'),
             hovermode = 'x',
             showlegend = FALSE)
  })
  
  # IMAE
  output$imae_plot <- renderPlotly({
    imae %>% 
      plot_ly(x = ~fecha) %>% 
      add_trace(y = ~.data[[paste0('imae_', input$variacion_imae)]], 
                name = 'Variación', 
                type = 'scatter', 
                mode = 'lines',
                line = list(width = 4)) %>% 
      layout(xaxis = list(title = "",
                          dtick = "M1", 
                          tickformat="%b\n%Y",
                          ticklabelmode="period",
                          range = c('2020-03-01','2022-03-01'),
                          rangeslider = list(type = "date")),
             yaxis = list(title = 'Variación'),
             hovermode = 'x',
             showlegend = FALSE)
  })
  
  # PIB por sectores
  var_incidencias_server(id = 'pib_sectores',
                         df = pib,
                         var = 'pib',
                         incidencia = c('agro', 'indu', 'serv', 'taxes'))
  
  # PIB por gasto
  var_incidencias_server(id = 'pib_gasto',
                         df = pib,
                         var = 'pib',
                         incidencia = c('consumo', 'inversion', 'exports', 'imports'))

  
}
