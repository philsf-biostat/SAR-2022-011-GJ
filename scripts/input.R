# setup -------------------------------------------------------------------
library(philsfmisc)
library(tidyverse)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
data.raw <- read_csv("dataset/FEVS_2020_PRDF_NASA.csv") %>%
  janitor::clean_names()

Nvar_orig <- data.raw %>% ncol
Nobs_orig <- data.raw %>% nrow

# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
  # select() %>%
  rename(id = random_id) %>%
  mutate() %>%
  filter()

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  # only use complete cases
  drop_na()

N_incomplete <- Nobs_orig - nrow(data.raw)

# drop answer 3
data.raw <- data.raw %>%
  mutate(
    q29 = ifelse(q29 == 3, NA, q29),
    q58 = ifelse(q58 == 3, NA, q58),
    q21 = ifelse(q21 == 3, NA, q21),
    q1 = ifelse(q1 == 3, NA, q1),
  ) %>%
  drop_na()

N_drop3 <- Nobs_orig - N_incomplete - nrow(data.raw)

data.raw <- data.raw %>%
  mutate(
    id = factor(id), # or as.character
    dsex = factor(dsex, labels = c("Male", "Female")),
    q29 = factor(q29), # IV/RQ1
    q58 = factor(q58), # DV/RQ1
    q21 = factor(q21), # IV/RQ2
    q1 = factor(q1),   # DV/RQ2
  )

# labels ------------------------------------------------------------------

# factor labels
responses <- c("Strongly disagree", "Disagree", "Agree", "Strongly Agree")
data.raw <- data.raw %>%
  mutate(across(starts_with("q"), ~ factor(.x, labels = responses)))

data.raw <- data.raw %>%
  set_variable_labels(
    dsex = "Sex",
    q1 = "I am given a real opportunity to improve my skills in my organization.",
    q21 = "Supervisors in my work unit support employee development.",
    q29 = "Managers promote communication among different work units.",
    q58 = "How satisfied are you with the Telework program in your agency?",
  )

# analytical dataset ------------------------------------------------------

dv <- "q1 -- I am given a real opportunity to improve my skills in my organization"
iv <- "q21 -- Supervisors in my work unit support employee development"

analytical <- data.raw %>%
  # select analytic variables
  mutate(
    dv = q1,  # DV
    iv = q21, # IV
    dv2 = fct_collapse(dv, Disagreement=responses[1:2], Agreement=responses[3:4]),
    iv2 = fct_collapse(iv, Disagreement=responses[1:2], Agreement=responses[3:4]),
  ) %>%
  select(
    id,
    dsex,
    dv,
    iv,
    dv2,
    iv2,
    # postwt,
  )

Nvar_final <- analytical %>% ncol
Nobs_final <- analytical %>% nrow

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( id = c( "1", "2", "3", "...", "N") ) %>%
  # analytical_mockup <- tibble( id = c( "1", "2", "3", "...", as.character(Nobs_final) ) ) %>%
  left_join(analytical %>% head(0), by = "id") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
