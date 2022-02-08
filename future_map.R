library(tidyverse)
library(future)
library(furrr)
library(gapminder)
library(rnaturalearth)
library(sf)

map <- rnaturalearth::countries110 %>% 
  st_as_sf() %>% 
  select(sovereignt) %>% 
  filter(sovereignt != "Antarctica")

df <- gapminder::gapminder

table(df$year)

map <- map %>% 
  left_join(.,
            df,
            by = c("sovereignt" = "country"))

map <- map %>% 
  st_drop_geometry()

map_list <- map %>% 
  split(., f = .$year)


test_fun <- function(my_dat, output) {
  
  output <- my_dat %>% 
    group_by(continent) %>% 
    summarise(life_exp = mean(lifeExp, na.rm = TRUE))
  
}

no_cores <- availableCores() - 3
no_cores


future::plan(multisession, workers = no_cores)

output_list <- future_map(.x = map_list,
                          .f = test_fun,
                          .progress = TRUE)

future::plan(sequential)


output <- bind_rows(output_list, .id = "id")

output


