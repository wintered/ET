library(tidyverse)
library(ggplot2)
library(scales)
library(graphics)

library(grDevices)
library(showtext)

data <- na.omit(data)
showtext_auto()

args = commandArgs(trailingOnly=TRUE)
data<- read.csv(args[1], sep = ',')
data <- na.omit(data)

data$family<- factor(data$family,levels = c("Z3", "CVC4/5"))
data$theory<- factor(data$theory,levels = c("Core", "Ints", "Reals", "RealInts","Bitvectors", "Arrays", "FP", "Strings","Optimization", "Bags"))

sol_levels <- sapply(readLines("../solvers.cfg"), function(line) strsplit(line, " ")[[1]][1])
sol_levels <- rev(sol_levels[-c(1:3)])

data$count <- data$count #/ strtoi(args[3])
data$solver =  factor(data$solver,levels = sol_levels)
data$result = factor(data$result, levels = c("sat","unsat","unknown", "rejected", "crash", "invmodel", "unsoundness"))
data$result <- forcats::fct_collapse(data$result, solved = c("sat", "unsat"))
data$result<- forcats::fct_collapse(data$result, bug = c("crash", "invmodel","unsoundness"))

data <- na.omit(data)
plt <- ggplot(data, aes(fill=result,y=count,x=solver,label=count,ymin=0)) 
plt <- plt + geom_bar(stat="identity")
plt <- plt + theme_minimal()
plt <- plt + theme(axis.text.x=element_text(angle=60, hjust=1))
plt <- plt + facet_grid(rows = vars(theory), cols= vars(family), scales="free",space = "free_x")
plt <- plt + labs(x = "solver", y = "#formulas")
plt <- plt + theme(strip.text.y = element_text(size = 8),panel.spacing = unit(1.2, "lines"))
plt <- plt + theme(panel.grid.major = element_line(colour = alpha("gray", 0.25)),
                   panel.grid.minor = element_blank())
plt <- plt + theme(panel.grid.major.x = element_blank(),panel.grid.minor.x = element_blank())
plt <- plt + theme(legend.position="top",legend.title = element_blank()) 
#plt <- plt + scale_y_continuous(labels=scales::percent,limits = c(0, 1))
plt <- plt + scale_y_continuous(labels = scales::comma)
plt <- plt + theme(panel.spacing.y = unit(0.75, "lines"))
plt <- plt + theme(strip.text.x = element_text(size = 11,face="bold"))
plt <- plt + theme(strip.text.y = element_text(size = 11,face="bold"))

alpha_val <- 0.5
custom_colors <- c(
  "solved" = adjustcolor("darkgreen",alpha.f = alpha_val),    # Change green to darkgreen
  "unknown" = adjustcolor("darkblue", alpha.f = alpha_val),     # Change grey to a darker shade (gray60)
  "rejected" = adjustcolor("gray",  alpha.f = alpha_val),       # Change blue to darkblue
  "bug" = adjustcolor("darkred", alpha.f = alpha_val)    # Change red to darkred
)
col_grid <- rgb(235, 235, 235, 50, maxColorValue=255)
plt <- plt + theme(panel.grid=element_line(color=col_grid))
plt <- plt + scale_fill_manual(values=custom_colors)
ggsave(args[2], width=30, height=22, units = "cm")
