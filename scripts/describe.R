# setup -------------------------------------------------------------------

# library(Hmisc) # describe
# library(skimr) # skim
# library(gmodels) # CrossTable
library(gtsummary)
library(gt)
# library(effectsize)
# library(finalfit) # missing_compare

# setup gtsummary theme
lst_theme <- list(`pkgwide-str:theme_name` = "FF gtsummary theme",
                  `pkgwide-fn:pvalue_fun` = function(x) style_pvalue(x,  digits = 3),
                  `pkgwide-fn:prependpvalue_fun` = function(x) style_pvalue(x, digits = 3, prepend_p = TRUE),
                  `tbl_summary-str:continuous_stat` = "{mean} ({sd})",
                  `add_p.tbl_summary-attr:test.continuous_by2` = "t.test",
                  `add_p.tbl_summary-attr:test.continuous` = "aov",
                  `add_p.tbl_svysummary-attr:test.continuous` = "svy.t.test",
                  `add_p.tbl_svysummary-attr:test.categorical` = "svy.adj.chisq.test",
                  `style_number-arg:decimal.mark` = ".",
                  `style_number-arg:big.mark` = ",",
                  `tbl_summary-fn:addnl-fn-to-run` = function(x) add_stat_label(x),
                  # `tbl_summary-str:categorical_stat` = "{n} ({p}%)",
                  `tbl_svysummary-fn:addnl-fn-to-run` = function(x) add_stat_label(x),
                  `pkgwide-str:ci.sep` = " to ")

set_gtsummary_theme(lst_theme)
theme_gtsummary_compact()
# theme_gtsummary_language(language = "pt") # traduzir

# exploratory -------------------------------------------------------------

# overall description
# analytical %>%
#   skimr::skim()

# minimum detectable effect size
# interpret_d(0.5)

# tables ------------------------------------------------------------------

tab_desc <- analytical %>%
  tbl_summary(
    include = c(group, outcome),
    # by = group,
  ) %>%
  # modify_caption(caption = "**Tabela 1** Características demográficas") %>%
  # modify_header(label ~ "**Características dos pacientes**") %>%
  bold_labels() %>%
  modify_table_styling(columns = "label", align = "c")
