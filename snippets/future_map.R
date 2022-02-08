library(tidyverse)
library(future)
library(furrr)
library(gapminder)

# ------ create dummy dataset
df <- gapminder::gapminder

table(df$year)

# ----- split dataset into a list with elements based on the f variable
map_list <- df %>% 
  split(., f = .$year)


# ----- define a function to be applied to each list element
test_fun <- function(my_dat, output) {
  
  output <- my_dat %>% 
    group_by(continent) %>% 
    summarise(life_exp = mean(lifeExp, na.rm = TRUE))
  
}

# ----- define no. of cores to use, here I use all cores minus 3
no_cores <- availableCores() - 3
no_cores


# ----- start parallel processing session
future::plan(multisession, workers = no_cores)


# ----- apply function to each list element
output_list <- future_map(.x = map_list,
                          .f = test_fun,
                          .progress = TRUE)


# ----- stop parallel processing
future::plan(sequential)


# ----- unpack your data
output <- bind_rows(output_list, .id = "id")

output


