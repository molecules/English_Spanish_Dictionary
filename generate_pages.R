#!/bin/env Rscript
library(dplyr)
library(glue)
library(rmarkdown)

words <- read.csv("dictionary.tsv", sep="\t")

sounds <- unique(words$sound)

sink("dictionary.md")

surround_join <- function(row, joiner) {
    paste0(joiner,
       paste0(row, collapse=joiner),
       joiner,
       "\n"
    )
}

links_and_join <- function(row, joiner) {
    paste0(joiner,
       paste0(
          c(
	    row[1],
	    row[2],
	    glue('<a href="https://en.wiktionary.org/wiki/{row[3]}#Pronunciation">{row[3]}</a>'),
	    row[4],
	    row[5],
	    glue('<a href="https://translate.google.com/?sl=en&tl=es&text=',
		 gsub(" ", "%20",row[6]),
		 '&op=translate">',
		 row[6],
		 '</a>'
	    ),
	    row[7]
	  ),
          collapse=joiner),
       joiner,
       "\n"
    )
}

print_md_table_row <- function(row) {
    cat(links_and_join(row, "|"))
}

cat(
    surround_join(
        c("vowel sound",
	  "vowel spelling",
	  "word",
          "IPA",
          "some translations (algunos traducciones)",
          "example in English",
          "ejemplo en español"
        ),
        "|"
    )
)

cat(surround_join(rep("----", 7),"|"))

# Print all the rows
# (and capture result of apply so it doesn't print to the document)
apply_result <- apply(words, 1, print_md_table_row)

# # Separate by sound
# for (sound in sounds) {
#    #print(glue("{sound} as in ")) 
#    sound_subset <- words[ words$sound == sound, ]
# 
#    apply(sound_subset[-1], 1, print_md_table_row)
# }

sink()


render(input = "dictionary.md", output_format = "html_document")
