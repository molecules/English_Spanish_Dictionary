#!/bin/env Rscript
library(dplyr)
library(glue)

words <- read.csv("dictionary.tsv", sep="\t")

sounds <- unique(words$sound)

sink("dict.md")

surround_join <- function(row, joiner) {
    paste0(joiner,
       paste0(row, collapse=joiner),
       joiner,
       "\n"
    )
}

pronounce_link_and_join <- function(row, joiner) {
    paste0(joiner,
       paste0(
          c(glue('<a href="https://en.wiktionary.org/wiki/{row[1]}#Pronunciation">{row[1]}</a>'),
	  row[2],
	  row[3],
	  glue('<a href="https://translate.google.com/?sl=en&tl=es&text=',
		 gsub(" ", "%20",row[4]),
		 '&op=translate">',
		 row[4],
		 '</a>'
	  ),
	  row[5],
	  row[6]
	  ),
          collapse=joiner),
       joiner,
       "\n"
    )
}

print_md_table_row <- function(row) {
    cat(pronounce_link_and_join(row, "|"))
}

cat(surround_join(c("English",
                "IPA",
                "Spanish",
                "example in English",
                "ejemplo en español", 
                "Rule breaker"),
              "|"
    )
)

cat(surround_join(rep("----", 6),"|"))

apply(words[-1], 1, print_md_table_row)

# # Separate by sound
# for (sound in sounds) {
#    #print(glue("{sound} as in ")) 
#    sound_subset <- words[ words$sound == sound, ]
# 
#    apply(sound_subset[-1], 1, print_md_table_row)
# }

sink()
