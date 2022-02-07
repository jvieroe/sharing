library(tidyverse)
library(future)
library(furrr)
library(svMisc)

df <- mtcars

string_length <- length(LETTERS)

df <- tibble(
  mpg = rnorm(mean = 0, sd = 1, n = string_length*10^6),
  group = factor(rep(LETTERS, 10^6))
)

nrow(df)

letter_seq <- unique(df$group)

for (i in seq_along(letter_seq)) {
  
  progress(i)
  
  print(letter_seq[i])
  
}


for (i in 0:131) {
  progress(i, 131)
  Sys.sleep(0.02)
  if (i == 131) message("Done!")
}


df_list <- df %>% 
  split(., f = .$group)

test_fun <- function(data, output) {
  
  Sys.sleep(20)
  
  output <- mtcars %>% 
    group_by(am) %>% 
    summarise(mean_mpg = mean(mpg, na.rm = TRUE))
  
}

output_list <- future_map(.x = df_list,
                          .f = test_fun,
                          .progress = TRUE)

output <- bind_rows(output_list, .id = "id")

output


# https://stackoverflow.com/questions/26919787/r-text-progress-bar-in-for-loop