x= list("Sales", "Consulting", "Net revenue", "Purchases", "Other expenses", "Profit before tax")
measure= c("relative", "relative", "total", "relative", "relative", "total")
text= c("+60", "+80", "", "-40", "-20", "Total")
y= c(60, 80, 0, -40, -20, 0)
data = data.frame(x=factor(x,levels=x),measure,text,y)

# Colocar indice_general al final para que se calcule la suma.

dataa <- articulos %>% 
  filter(fecha == max(fecha)) %>% 
  select(ends_with('_grupo_inc_vi'),indice_general_inflacion_vi) %>% 
  mutate(resto = indice_general_inflacion_vi - alimentos_y_bebidas_no_alcoholicas_grupo_inc_vi - vivienda_grupo_inc_vi - transporte_grupo_inc_vi) %>% 
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
                                   'Resto',
                                   'Inflación'))) %>% 
  filter(grupo != 'Resto')








plot_ly(
  dataa, name = "20", type = "waterfall", measure = ~measure,
  x = ~grupo,  y= ~variacion,
  connector = list(line = list(color= "rgb(63, 63, 63)"))) 


x= list("Sales", "Consulting", "Net revenue", "Purchases", "Other expenses", "Profit before tax")
measure= c("relative", "relative", "total", "relative", "relative", "total")
text= c("+60", "+80", "", "-40", "-20", "Total")
y= c(60, 80, 0, -40, -20, 0)
data = data.frame(x=factor(x,levels=x),measure,text,y)

fig <- plot_ly(
  data, name = "20", type = "waterfall", measure = ~measure,
  x = ~x, textposition = "outside", y= ~y, text =~text,
  connector = list(line = list(color= "rgb(63, 63, 63)"))) 
fig <- fig %>%
  layout(title = "Profit and loss statement 2018",
         xaxis = list(title = ""),
         yaxis = list(title = ""),
         autosize = TRUE,
         showlegend = TRUE)

fig

select(fecha, starts_with(input$grupo), ends_with(input$variacion_grupo))