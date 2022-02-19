# setup -------------------------------------------------------------------
library(broom)
library(epitools)

# pretty format of OR + CI
format_or <- function(or, digits = 2) {
  paste0(
    "OR: ",
    format.float(or[1], digits),
    ", ",
    "95% CI: ",
    format.interval(or[2:3], digits),
    ", ",
    style_pvalue(or[4], digits = digits+1, prepend_p = TRUE)
  )
}

# OR ----------------------------------------------------------------------

or_o_un <- analytical %>%
  filter() %>%
  select(iv2, dv2) %>%
  table() %>%
  oddsratio()
or_o_un <- c(or_o_un$measure[2, ], or_o_un$p.value[2, "chi.square"]) %>% as.numeric()

or_m_un <- analytical %>%
  filter(dsex == "Male") %>%
  select(iv2, dv2) %>%
  table() %>%
  oddsratio()
or_m_un <- c(or_m_un$measure[2, ], or_m_un$p.value[2, "chi.square"]) %>% as.numeric()

or_f_un <- analytical %>%
  filter(dsex == "Female") %>%
  select(iv2, dv2) %>%
  table() %>%
  oddsratio()
or_f_un <- c(or_f_un$measure[2, ], or_f_un$p.value[2, "chi.square"]) %>% as.numeric()

cmh_un <- analytical %>%
  select(iv2, dv2, dsex) %>%
  table() %>%
  mantelhaen.test() %>%
  suppressWarnings() %>%
  tidy()
cmh_p_un <- cmh_un %>% pull(p.value)
or_cmh_un <- cmh_un[c("estimate", "conf.low", "conf.high", "p.value")] %>% as.numeric()

# difference between crude and adjusted
or_diff_o_adj_un <- all.equal(or_cmh_un[1], or_o_un[1]) %>% parse_number()
# difference between men and women
or_diff_sex_adj_un <- all.equal(or_f_un[1], or_m_un[1]) %>% parse_number()
