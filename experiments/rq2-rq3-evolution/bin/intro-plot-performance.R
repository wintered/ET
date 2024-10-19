library(dplyr)
library(tidyverse)
library(ggplot2)
library(scales)

# Read data from two datasets
df1 <- read.csv("csv/solved-problems-0.015625.csv.avg", sep = ',')
df2 <- read.csv("csv/solved-problems-8.csv.avg", sep = ',')

# Add a new column to differentiate datasets
df1$Time <- "0.015625s"
df2$Time <- "8s"

# Combine datasets
df <- rbind(df1, df2)

# Process data
df$family <- factor(df$family, levels = c("Z3", "CVC4/5"))
sol_levels <- sapply(readLines("../solvers.cfg"), function(line) strsplit(line, " ")[[1]][1])
sol_levels <- rev(sol_levels[-c(1:3)])

df <- filter(df, theory != "RealIntsIntVars" & theory != "RealIntsRealVars")
df$solver <- factor(df$solver, levels = sol_levels)
df <- df %>%
  group_by(solver, family, Time) %>%
  summarise(count = sum(count), .groups = 'drop')

# Plot
plot <- ggplot(df, aes(y = count, x = solver, label = count, color = family, linetype=family, shape=family, group = family)) +
  geom_line(size = 0.7) +
  geom_point(size = 1.6) +
  scale_y_continuous(labels = comma_format()) +
  labs(x = "solver", y = "# solved formulas", title = "Number of Solved formulas") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  coord_cartesian(clip = "off") +
  theme_minimal() +
  facet_grid(rows = vars(Time), cols = vars(family), scales = "free", space = 'free_x') +
  theme(
    panel.grid.major = element_line(colour = alpha("gray", 0.3)),
    #panel.grid.minor = element_blank(),
    axis.text.x = element_text(angle = 60, hjust = 1, size=7),
    legend.position = "none",
    strip.background = element_rect(fill = "white", colour = "white", size = 1.5),
    strip.placement = "outside",
    axis.title.y = element_text(vjust = 3)
  )

#plot <- plot + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())
plot <- plot + theme(panel.spacing.y = unit(1.8, "lines"))
plot <- plot + scale_fill_hue(c = 45, l = 80)

ggsave("plots/intro-plot-performance.pdf", plot, width = 32, height = 10, units = "cm")

