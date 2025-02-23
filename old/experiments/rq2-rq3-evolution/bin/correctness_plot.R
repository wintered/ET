library(tidyverse)
library(ggplot2)
library(scales)
library(graphics)
library(showtext)

sol_levels <- sapply(readLines("../solvers.cfg"), function(line) strsplit(line, " ")[[1]][1])
sol_levels <- rev(sol_levels[-c(1:3)])

showtext_auto()

create_correctness_plot <- function(data, plt_title) {

  data <- data %>%
    mutate(
      family = factor(family, levels = c("Z3", "CVC4/5")),
      type = factor(type, levels = c("unsoundness", "invalid model", "crash")),

      theory = factor(theory, levels = c(
        "Core", "Ints", "Reals", "Bitvectors", "Arrays","RealInts","FP", "Strings"
      )),
      solver = factor(solver, levels = sol_levels)
    ) %>%
    filter(
      theory != "RealIntsIntVars",
      theory != "RealIntsRealVars"
    )

  # Remove rows with constant zero values
#  data <- data %>%
    #group_by(solver, theory, type) %>%
    #filter(!all(num_triggers == 0))
  data <- data %>%
    group_by(solver, theory, type) %>%
    mutate(num_triggers = ifelse(num_triggers == 0, NA, num_triggers))

  plt <- ggplot(data, aes(color = type, shape = type, y = num_triggers, x = solver, label = num_triggers, group = type)) +
    geom_line(size = 0.25) +  # Adjust line thickness
    geom_point(size = 2) +  # Use cross shape for points and adjust point size
    scale_y_log10(limits = c(1, 1e6), labels = scales::comma) +  # Adjust y-axis to show log-transformed values in decimal format with commas
    labs(y = "# bug triggers", x = "solvers") +  # Adjust axis labels
    theme_minimal() +
    facet_grid(rows = vars(theory), cols = vars(family), scales = "free", space = "free_x") +
    theme(
      strip.text.y = element_text(size = 11, face = "bold"),  # Set y-axis labels to bold
      strip.text.x = element_text(size = 12, face = "bold"),  # Set x-axis labels in the facet grid to bold
      #panel.grid.major.x = element_blank(),
      #panel.grid.minor.x = element_blank(),
      legend.position = "top",
      legend.text = element_text(size = 12),
      legend.title = element_blank(),
      axis.text.x = element_text(angle = 60, hjust = 1),
      #panel.grid = element_line(color = rgb(235, 235, 235, 250, maxColorValue = 255)),
      panel.grid.major = element_line(colour = alpha("gray", 0.3)),
      strip.background = element_blank(),
      axis.text = element_text(size = 10),
      legend.key.size = unit(0.5, "cm")
    ) 
    
  custom_colors <- c(
    "crash" = "darkblue",
    "invalid model" = "darkgreen",  # Corrected the color mapping
    "unsoundness" = "darkred"
  )
  col_grid <- rgb(235, 235, 235, 50, maxColorValue = 255)
  plt <- plt + theme(panel.grid = element_line(color = col_grid))
  plt <- plt + scale_fill_manual(values = custom_colors)

  return(plt)
}

args <- commandArgs(trailingOnly = TRUE)

if (length(args) < 1) {
  stop("Usage: bin/correctness_plot.R <csv_file> [<plot_name>]")
}

csv_file <- args[1]
plt_name <- args[2]

data <- read.csv(csv_file)
plt <- create_correctness_plot(data, plt_name)
plt_width <- 35 
plt_height <- 30 
fn <- paste(paste("plots/", plt_name, sep = ""), "-plot.pdf", sep = "")
ggsave(fn, plot = plt, width = plt_width, height = plt_height, units = "cm")
