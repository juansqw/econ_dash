# Waterfall
waterfall_data <- articulos %>% 
  filter(fecha == max(fecha)) %>% 
  select(ends_with('_grupo_inc_vi'),indice_general_inflacion_vi) %>% 
  pivot_longer(cols = everything(),
               names_to = 'grupo',
               values_to = 'variacion') %>% 
  mutate(measure = ifelse(grupo == 'indice_general_inflacion_vi', "total","relative"),
         grupo = str_replace_all(grupo, (c('_grupo_inc_vi' = '',
                                           '_' = ' ',
                                           'indice general inflacion vi' = 'Inflación'))),
         grupo = str_to_title(grupo),
         grupo = factor(grupo,
                        levels = c("Alimentos Y Bebidas No Alcoholicas", 
                                   "Bebidas Alcoholicas Y Tabaco",
                                   "Prendas De Vestir Y Calzado",
                                   "Vivienda",
                                   "Muebles Y Articulos Para El Hogar",
                                   "Salud",
                                   "Transporte",
                                   "Comunicaciones",
                                   "Recreacion Y Cultura",
                                   "Educacion",
                                   "Restaurantes Y Hoteles",
                                   "Bienes Y Servicios Diversos",
                                   'Inflación')))


waterfall_data %>% 
  plot_ly(type = "waterfall", 
        orientation = 'h',
        measure = ~measure,
        x = ~variacion, 
        y= ~grupo) %>% 
  layout(yaxis = list(title = ''),
         xaxis = list(title = 'Incidencia'))



fig <- plot_ly(waterfall_data, x = ~variacion, y = ~grupo, measure = ~measure, type = "waterfall", name = "2018",
               orientation = "h", connector = list(mode = "between", line = list(width = 4, color = "rgb(0, 0, 0)", dash = 0)))
fig <- fig %>%
  layout(title = "Profit and loss statement 2018<br>waterfall chart displaying positive and negative",
         xaxis = list(title = "", tickfont = "16", ticks = "outside"),
         yaxis = list(title = "", type = "category", autorange = "reversed"),
         xaxis = list(title ="", type = "linear"),
         margin = c(l = 150),
         showlegend = TRUE)


fig






