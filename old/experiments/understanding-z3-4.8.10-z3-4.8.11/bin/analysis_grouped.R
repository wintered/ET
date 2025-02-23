library(tidyverse)
library(ggplot2)
library(scales)
library(forcats)
library(showtext)
showtext_auto()

data <- read.csv("analysis.csv", sep = ',')
data$theory <- factor(data$theory, levels = c("Core", "Ints", "Reals", "BitvectorArrays", "Arrays", "FloatingPoints"))
sol_levels <- c("z3-before", "z3-after ")
data$solver <- factor(data$solver, levels = sol_levels)

custom_x_labels <- function(x) {
  labels <- c("0.015625", "0.03125", "0.0625", "0.125", "0.25", "0.5", "1", "2", "4", "8")
  labels[match(x, as.numeric(labels))]
}

# Create a new variable for the columns with desired labels
data$i_label <- factor(data$index, levels = c(1, 2, 3, 4, 5, 6), labels = c("i = 1", "i = 2", "i = 3", "i = 4", "i = 5","i = 6"))

# Sum the count across theories
summed_data <- data %>%
  group_by(solver, timeout, index, i_label) %>%
  summarise(sum_count = sum(count))

plt <- ggplot(summed_data, aes(y = sum_count, x = timeout, shape=solver, label = sum_count, color = solver))
plt <- plt + theme_minimal()
plt <- plt +  geom_line(size = 0.5)
plt <- plt +  geom_point(size = 2.0)
plt <- plt + labs(x = "timeouts", y = "# solved formulas")
plt <- plt + theme(legend.position = "top", legend.title = element_blank())
plt <- plt + theme(panel.grid.major = element_line(colour = alpha("gray", 0.3)),
                   panel.grid.minor = element_blank())
plt <- plt + theme(axis.text.x = element_text(angle = 45, hjust = 1))

plt <- plt + scale_y_continuous(labels = scales::comma, breaks = scales::pretty_breaks(n = 5))
plt <- plt + scale_x_continuous(trans = "log2", breaks = c(0.015625, 0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4, 8),
                                labels = custom_x_labels)
plt <- plt + theme(panel.spacing.y = unit(0.75, "lines"))
plt <- plt + theme(panel.spacing.x = unit(0.75, "lines"))

plt <- plt + geom_line(size = 0.5) + geom_point(size = 1.5, shape = 4)

# Specify the number of rows and columns for the facet arrangement
rows <- 2
cols <- 3

# Arrange facets in two rows with three columns each
plt <- plt + facet_wrap(~i_label, ncol = cols)
plt <- plt + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank())

# Customize the facet labels to make them bold and adjust the facet spacing
plt <- plt + theme(strip.text.x = element_text(face = "bold"))
plt <- plt + theme(panel.spacing.x = unit(2, "lines"))
# Save the plot with updated dimensions for two-row arrangement
ggsave("plots/grouped-analysis-plot.pdf", width = 28, height = 12, units = "cm")
