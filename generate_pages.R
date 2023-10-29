#!/bin/env Rscript
library(dplyr)
library(glue)

words <- read.csv("dictionary.tsv", sep="\t")

sounds <- unique(words$sound)

for (sound in sounds) {
   print(glue("{sound} as in ")) 
   sound_subset <- words[ words$sound == sound, ]
   print(sound_subset) 
}
