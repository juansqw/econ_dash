# Server

server <- function(input, output) {
  
  # Inflacion total
  single_line_plot_server('inf_endyear', 
                          df = articulos, 
                          grupo ="indice_general_inflacion_",
                          variacion = input$variacion)
  
  # Inflacion por grupos
  single_line_plot_server('inf_grupo', 
                          df = articulos, 
                          grupo = input$grupo,
                          variacion = input$variacion_grupo)
  
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
                          range = c('2020-03-01','2022-03-01'),
                          dtick = "M1", 
                          tickformat="%b\n%Y",
                          ticklabelmode="period"),
             yaxis = list(title = 'Variación'),
             hovermode = 'x',
             showlegend = FALSE)
  })
  
  # IMAE
  single_line_plot_server('imae_plot', 
                          df = imae, 
                          grupo = 'imae_',
                          variacion = input$variacion_imae)
  
}
