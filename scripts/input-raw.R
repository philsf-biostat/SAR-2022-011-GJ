# setup -------------------------------------------------------------------
library(philsfmisc)
library(data.table)
library(tidyverse)
library(naniar)

# data loading ------------------------------------------------------------
set.seed(42)
# data gathered from https://www.opm.gov/fevs/public-data-file/
data.raw <- fread("dataset/FEVS_2020_PRDF.csv") %>%
  janitor::clean_names()

# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
  select(random_id, agency, q1, q21, q29, q58, dsex, postwt) %>%
  filter(agency == "NN") %>%
  replace_with_na_all(condition = ~.x == "X") %>%
  mutate(
  )

# save dataset ------------------------------------------------------------

write_csv(data.raw, "dataset/FEVS_2020_PRDF_NASA.csv")
