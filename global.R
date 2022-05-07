# Global

# ---- Paquetes ----
library(tidyverse)
library(readxl)
library(scales)
library(shiny)
library(shinydashboard)
library(plotly)


# ---- Data ----
# info
info <- read_excel("./data/info_ipc.xlsx", 
                   sheet = "info") %>% 
  select(name, Ponderacion)

# Indices
articulos <- read_excel("./data/info_ipc.xlsx", 
                        sheet = "articulos") 

# Actividad
imae <- read_excel('./data/actividad.xlsx',
                   sheet = 'mensual')

pib <- read_excel('./data/actividad.xlsx',
                   sheet = 'trimestral')

# ---- Transformations ----

# General
articulos <- articulos %>% 
  mutate(across(!fecha,
                .fns = list(vm = ~(./lag(., n = 1))*100-100,
                            vi = ~(./lag(.,n = 12))*100-100,
                            inc_vi = ~info$Ponderacion[[which(info$name == cur_column())]] *
                              ((./lag(.,n = 12))*100-100) *
                              (lag(.,n = 12) / lag(indice_general_inflacion,n = 12)))))

group_names <- articulos %>% 
  select(ends_with('_grupo')) %>%
  pivot_longer(everything(),
               names_to = 'grupo',
               values_to = 'variacion') %>% 
  mutate(grupo = str_replace_all(grupo, (c('grupo' = '',
                                           '_' = ' '))),
         grupo = str_to_sentence(grupo)) %>% 
  select(grupo) %>% 
  unique() %>% 
  pull()

groups <- articulos %>% 
  select(ends_with('_grupo')) %>%
  pivot_longer(everything(),
               names_to = 'grupo',
               values_to = 'variacion') %>% 
  select(grupo) %>% 
  unique() %>% 
  pull(grupo)

names(groups) <- group_names

# Intro
inf_actual <- articulos %>% 
  filter(fecha == max(fecha)) %>% 
  select(fecha, starts_with('indice'))

top_grupos <- articulos %>% 
  filter(fecha == max(fecha)) %>% 
  select(fecha, 
         #(starts_with("indice") & contains('inflacion_v')),
         ends_with("grupo_vi"), 
         ends_with("grupo_inc_vi")) %>%
  pivot_longer(!fecha,
               names_to = c("grupo",".var"),
               names_sep = "grupo_") %>% 
  mutate(grupo = str_replace_all(grupo, (c('_grupo' = '',
                                           '_' = ' '))),
         grupo = str_to_title(grupo)) %>% 
  pivot_wider(names_from = ".var",
              values_from = "value") %>% 
  arrange(desc(inc_vi))

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

# IMAE
imae <- imae %>% 
  mutate(across(!fecha,
                .fns = list(vm = ~(./lag(., n = 1))*100-100,
                            vi = ~(./lag(.,n = 12))*100-100)))

# ---- Shiny ----
source('./R/modules.R')
source('ui.R')
source('server.R')

shinyApp(ui = ui, server = server)