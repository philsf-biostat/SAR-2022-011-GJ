# setup -------------------------------------------------------------------
library(philsfmisc)
library(tidyverse)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
data.raw <- read_csv("dataset/FEVS_2020_PRDF_NASA.csv") %>%
  janitor::clean_names()

# data cleaning -----------------------------------------------------------

# observations before cleaning procedures
N_raw <- nrow(data.raw)
# source population size
N <- data.raw %>% summarise(N_hat = sum(postwt)) %>% pull(N_hat) %>% round

data.raw <- data.raw %>%
  # select() %>%
  rename(id = random_id) %>%
  mutate() %>%
  filter()

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  mutate(
    id = factor(id), # or as.character
    dsex = factor(dsex, labels = c("Male", "Female")),
    q29 = factor(q29), # IV/RQ1
    q58 = factor(q58), # DV/RQ1
    q21 = factor(q21), # IV/RQ2
    q1 = factor(q1),   # DV/RQ2
  ) %>%
  # only use complete cases
  drop_na()

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    dsex = "Sex",
    q1 = "I am given a real opportunity to improve my skills in my organization.",
    q21 = "Supervisors in my work unit support employee development.",
    q29 = "Managers promote communication among different work units.",
    q58 = "How satisfied are you with the Telework program in your agency?",
  )

# analytical dataset ------------------------------------------------------

analytical <- data.raw %>%
  # select analytic variables
  mutate(
    dv = q1,  # DV
    iv = q21, # IV
    dv2 = fct_collapse(dv, Disagreement=as.character(1:3), Agreement=as.character(4:5)),
    iv2 = fct_collapse(iv, Disagreement=as.character(1:3), Agreement=as.character(4:5)),
  ) %>%
  select(
    id,
    dsex,
    dv,
    iv,
    dv2,
    iv2,
    postwt,
  )

# source population size (cleaned)
N_hat <- analytical %>% summarise(N_hat = sum(postwt)) %>% pull(N_hat) %>% round

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( id = c( "1", "2", "3", "...", as.character(nrow(analytical)) ) ) %>%
  left_join(analytical %>% head(0), by = "id") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
