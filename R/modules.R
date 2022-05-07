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
      df %>% 
        select(fecha, starts_with(grupo()), ends_with(variacion())) %>% 
        filter(fecha >= as.Date('2010-01-01'))
    }) 
    
    output$sl_plot <- renderPlotly({
      reacted_df() %>% 
        plot_ly(x = ~fecha) %>% 
        add_trace(y = ~.data[[paste0(grupo(), variacion())]], 
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

# ---- var+incidencias ----
# UI
var_incidencias_ui <- function(id){
  plotlyOutput(NS(id,'var_incidencias_plot'))
}

# Server
var_incidencias_server <- function(id, df, var, incidencia) {
  moduleServer(id, function(input, output, session) {
    output$var_incidencias_plot <- renderPlotly({
      
      p <- plot_ly(df, x = ~fecha) %>% 
        add_trace(y = as.formula(paste0("~`", var, "`")),
                  type = 'scatter', 
                  mode = 'lines',
                  name = 'PIB',
                  line = list(color = 'rgb(0, 0, 0)', 
                              width = 3)) 
      
      for(trace in incidencia){
        p <- p %>% plotly::add_trace(y = as.formula(paste0("~`", trace, "`")), 
                                     name = trace,
                                     type = 'bar')
      }
      
      p %>% 
        layout(xaxis = list(title = "",
                            dtick = "M1", 
                            tickformat="%b-%Y",
                            ticklabelmode="period",
                            range = c('2019-03-01','2021-12-01'),
                            rangeslider = list(type = "date")),
               yaxis = list(title = 'Variación Interanual'), 
               barmode = 'stack',
               showlegend = FALSE)
    })
  })
}


  
    