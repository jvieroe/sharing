library(tidyverse)
library(future)
library(furrr)
library(gapminder)
library(svMisc)

# ------ create dummy dataset
df <- gapminder::gapminder

table(df$year)


# ----- get vector that the loop is defined by
unique_years <- unique(df$year)
unique_years


# ----- define length of vector, "how many i's?"
max_element <- length(unique_years) 

for (i in seq_along(unique_years)) {
  
  svMisc::progress(i, max_element)
  
  Sys.sleep(0.5)
  
}

