library(dplyr)
library(tidyverse)
library(ggplot2)
library(scales)
df <- read.csv("csv/correctness_results.csv.avg", sep = ',')
df$family <- factor(df$family, levels = c("Z3", "CVC4/5"))

sol_levels <- sapply(readLines("../solvers.cfg"), function(line) strsplit(line, " ")[[1]][1])
sol_levels <- rev(sol_levels[-c(1:3)])

df$solver <- factor(df$solver, levels = sol_levels)
df <- df %>%
  group_by(solver, family) %>%
  summarise(num_triggers = sum(num_triggers))


plot <- ggplot(df, aes(y = num_triggers, x = solver, label = num_triggers, color = family, shape=family, group = family)) +
  geom_line(size = 0.7) +
  geom_point(size = 1.6) +
  scale_y_log10(labels = comma_format()) +
  labs(x = "solver", y = "# bug triggers", title = "Number of bug triggers by solver") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_cartesian(clip = "off") +
  theme_minimal() +
  facet_grid(cols = vars(family), scales = "free", space = 'free') +
  theme(panel.grid.major = element_line(colour = alpha("gray", 0.3)),
        panel.grid.minor = element_blank(),
        axis.text.x = element_text(angle = 60, hjust = 1, size=7),
        legend.position = "none")

plot <- plot + scale_fill_hue(c = 45, l = 80)
ggsave("plots/intro-plot-correctness.pdf", width = 32, height = 7.0, units = "cm")
