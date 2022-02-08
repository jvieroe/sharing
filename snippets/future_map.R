library(tidyverse)
library(future)
library(furrr)
library(gapminder)
library(rnaturalearth)
library(sf)

# ------ create dummy dataset
df <- gapminder::gapminder

table(df$year)

map_list <- df %>% 
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


