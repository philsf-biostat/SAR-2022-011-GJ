# setup -------------------------------------------------------------------

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

scale_color_discrete <- function(...) scale_color_brewer(palette = ff.pal, ...)
scale_fill_discrete <- function(...) scale_fill_brewer(palette = ff.pal, ...)

gg <- analytical %>%
  ggplot() +
  theme_ff()

# plots -------------------------------------------------------------------

gg.outcome <- gg +
  geom_bar(aes(dv2, fill = dsex), position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::label_percent()) +
  labs(fill = "Sex") +
  xlab(attr(analytical$dv, "label")) +
  ylab("")

gg.outcome.raw <- gg +
  geom_bar(aes(dv, fill = dsex), position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::label_percent()) +
  labs(fill = "Sex") +
  xlab(attr(analytical$dv, "label")) +
  ylab("")

gg +
  geom_bar(aes(dv2, fill = iv2), position = "fill") +
  coord_flip() +
  scale_y_continuous(labels = scales::label_percent()) +
  labs(fill = "Perceived leadership commitment") +
  xlab(attr(analytical$dv2, "label")) +
  ylab("")
