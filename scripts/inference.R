# setup -------------------------------------------------------------------

# tables ------------------------------------------------------------------

tab_inf <- tbl_stack(
  list(
    analytical %>% tbl_cross(iv2, dv2),
    analytical %>% filter(dsex == "Male") %>% tbl_cross(iv2, dv2),
    analytical %>% filter(dsex == "Female") %>% tbl_cross(iv2, dv2)),
  c("Overall", "Males", "Females"))
