library(tidyverse)
library(ggplot2)
library(scales)
library(forcats)

library(showtext)

showtext_auto()

data <- read.csv("out.csv", sep = ',')
data$theory <- factor(data$theory, levels = c("Core", "Ints", "Reals", "MixedIntReal", "Bitvectors", "BitvectorArrays", "FloatingPoints", "Strings", "Optimization", "Bags"))

data$theory <- gsub("FloatingPoints", "FP", data$theory)
data$theory <- gsub("BitvectorArrays", "Arrays", data$theory)
data$theory <- gsub("MixedIntReal", "RealInts", data$theory)

data$theory <- fct_relevel(data$theory, "Core", "Ints", "Reals", "RealInts", "Bitvectors", "Arrays", "FP", "Strings")

sol_levels <- c("z3-4.8.10", "z3-4.8.11")
data$solver <- factor(data$solver, levels = sol_levels)

custom_x_labels <- function(x) {
  labels <- c("0.015625", "0.03125", "0.0625", "0.125", "0.25", "0.5", "1", "2", "4", "8")
  labels[match(x, as.numeric(labels))]
}

# Create a new variable for the columns with desired labels
data$i_label <- factor(data$index, levels = c(1, 2, 3), labels = c("i = 1", "i = 2", "i = 3"))

plt <- ggplot(data, aes(y = count, x = timeout, label = count, color = solver))
plt <- plt + theme_minimal()
plt <- plt + labs(x = "timeout (s)", y = "# solved formulas")
plt <- plt + theme(legend.position = "top", legend.title = element_blank())
plt <- plt + theme(panel.grid.major = element_line(colour = alpha("gray", 0.1)),
                   panel.grid.minor = element_blank())
plt <- plt + theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Set the face to "bold" for facet labels

plt <- plt + theme(panel.spacing.y = unit(0.75, "lines"))
plt <- plt + theme(strip.text.x = element_text(size=10,face = "bold"),
                   strip.text.y = element_text(size=10,face = "bold"))

#plt <- plt + scale_y_continuous(labels = scales::comma)
plt <- plt + scale_y_continuous(labels = scales::comma, breaks = scales::pretty_breaks(n = 4))

plt <- plt + scale_x_continuous(trans = "log2", breaks = c(0.015625,0.03125, 0.0625, 0.125, 0.25, 0.5, 1, 2, 4, 8),
                                labels = custom_x_labels)

plt <- plt + geom_line(size = 0.25) + geom_point(size = 1.5, shape = 4)
plt <- plt + facet_grid(rows = vars(theory), cols = vars(i_label), scales = "free", space = 'free_x')
print(data)
#ggsave("plots/analysis-plot.pdf", width = 28, height = 18, units = "cm")
