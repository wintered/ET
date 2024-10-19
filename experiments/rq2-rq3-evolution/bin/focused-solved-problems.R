library(dplyr)
library(forcats)
library(ggplot2)
library(showtext)
showtext_auto()
args = commandArgs(trailingOnly=TRUE)
data <- read.csv(args[1], sep = ',')
data <- na.omit(data)
data$result <- factor(data$result, levels = c("sat","unsat","unknown", "rejected", "crash", "invmodel", "unsoundness"))
data <- filter(data, result!= "unknown" & result != "rejected" & result != "crash" & result != "invmodel" & result != "unsoundness") 
sol_levels <- sapply(readLines("../solvers.cfg"), function(line) strsplit(line, " ")[[1]][1])
sol_levels <- rev(sol_levels[-c(1:3)])

data$solver =  factor(data$solver,levels = sol_levels)
data$result <- forcats::fct_collapse(data$result, solved = c("sat", "unsat"))
data$family <- factor(data$family, levels = c("Z3", "CVC4/5"))
data$theory <- factor(data$theory, levels = c("Core", "Ints", "Reals", "RealInts", "Bitvectors", "Arrays", "FP", "Strings"))
data <- data %>%
  group_by(solver, theory, family, result) %>% 
  summarize(count = sum(count), .groups = 'drop')

plt <- ggplot(data, aes( y = count, x = solver, label = count, shape = family, color = family, group = family)) +
    geom_line(size = 0.25,na.rm=TRUE) +                                                       
    geom_point(size = 0.75,na.rm=TRUE)                                                           

plt <- plt + facet_grid(rows = vars(theory), cols = vars(family), scales="free", space = "free_x")
plt <- plt + theme_minimal()
plt <- plt + theme(axis.text.x = element_text(angle = 60, hjust = 1))
plt <- plt + theme(legend.position="top",legend.title = element_blank()) 
plt <- plt + theme(panel.spacing.y = unit(0.75, "lines"))
plt <- plt + theme(strip.text.x = element_text(size = 11,face="bold"))
plt <- plt + scale_y_continuous(labels = scales::comma)
plt <- plt + theme(strip.text.y = element_text(size = 11,face="bold"))
plt <- plt  + theme(legend.position = "none")
plt <- plt +  labs(x = "solver", y = "# solved formulas", title = element_blank())
fn <- paste0("focused-",paste0(strsplit(args[1], "-")[[1]][[3]], ".pdf"))
ggsave(paste0("plots/",fn), plot = plt, width = 30, height = 22, units = "cm")
