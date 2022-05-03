# Modules

# ---- Single line plots ----
# UI
single_line_plot_ui <- function(id){
  plotlyOutput(NS(id,'sl_plot'))
}

# Server
single_line_plot_server <- function(id, df, grupo, variacion){
  moduleServer(id, function(input, output, session){
    reacted_df <- reactive({
      articulos %>% 
        select(fecha, starts_with(grupo), ends_with(variacion)) %>% 
        filter(fecha >= as.Date('2010-01-01'))
    }) 
    
    output$sl_plot <- renderPlotly({
      reacted_df() %>% 
        plot_ly(x = ~fecha) %>% 
        add_trace(y = ~.data[[paste0(grupo, variacion)]], 
                  name = 'Variación', 
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
  })
}

