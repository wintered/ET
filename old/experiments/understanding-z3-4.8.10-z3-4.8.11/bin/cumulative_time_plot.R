library(tidyverse)
library(ggplot2)

data<- read.csv("csv/cumulative_time.csv", sep = ',')
data$family<- factor(data$family,levels = c("Z3", "CVC4/5"))
#data$type<- factor(data$type,levels = c("soundness", "invalid model","crash"))
data$theory<- factor(data$theory,levels = c("Core", "Ints", "Reals","RealIntsIntVars", "RealIntsRealVars", "MixedIntReal", "Bitvectors", "BitvectorArrays", "FloatingPoints", "Strings","Optimization", "Bags"))

sol_levels <- c("cvc4-1.5", "cvc4-1.6", "cvc4-1.7", "cvc4-1.8", "cvc5-0.0.2", "cvc5-0.0.3", "cvc5-0.0.4", "cvc5-0.0.5", "cvc5-0.0.6", "cvc5-0.0.7", "cvc5-0.0.8", "cvc5-0.0.10", "cvc5-0.0.11", "cvc5-0.0.12", "cvc5-1.0.0", "cvc5-1.0.1", "cvc5-1.0.2", "cvc5-1.0.3", "cvc5-1.0.4", "cvc5-1.0.5", "z3-4.5.0", "z3-4.6.0", "z3-4.7.1", "z3-4.8.1", "z3-4.8.3", "z3-4.8.4", "z3-4.8.5", "z3-4.8.6", "z3-4.8.7", "z3-4.8.8", "z3-4.8.9", "z3-4.8.10", "z3-4.8.11", "z3-4.8.12", "z3-4.8.13", "z3-4.8.14", "z3-4.8.15", "z3-4.8.16", "z3-4.8.17", "z3-4.9.0", "z3-4.9.1", "z3-4.10.0", "z3-4.10.1", "z3-4.10.2", "z3-4.11.0", "z3-4.11.2", "z3-4.12.0", "z3-4.12.1")
data <- filter(data,theory != "MixedIntReal" & theory != "RealIntsIntVars" & theory != "RealIntsRealVars") 

data$solver =  factor(data$solver,levels = sol_levels)
data <- na.omit(data)

plt <- ggplot(data, aes(y=cumulative_time,x=solver,label=cumulative_time,ymin=0)) 
plt <- plt + theme_minimal()
plt <- plt + geom_bar(stat="identity")
plt <- plt + theme(axis.text.x=element_text(angle=60, hjust=1))
plt <- plt + facet_grid(rows = vars(theory), cols= vars(family), scales="free",space = "free_x")
plt <- plt + theme(axis.title.x=element_blank(), axis.title.y=element_blank())
plt <- plt + theme(strip.text.y = element_text(size = 9))
plt <- plt + scale_fill_hue(c=45, l=80)
plt <- plt + theme(panel.grid.major.x = element_blank(),panel.grid.minor.x = element_blank())
plt <- plt + theme(legend.position="top",legend.title = element_blank()) 
ggsave("plots/cumulative-time-plot.pdf", width=25, height=23, units = "cm")

