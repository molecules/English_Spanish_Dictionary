#!/bin/env Rscript
library(dplyr)
library(glue)
library(rmarkdown)

# FUNCTIONS
surround_join <- function(row, joiner) {
    paste0(joiner,
       paste0(row, collapse=joiner),
       joiner,
       "\n"
    )
}

wikitionary_link <- function(word) {
    glue('<a href="https://en.wiktionary.org/wiki/{word}#Pronunciation">{word}</a>')
}

translation_link <- function(sentence) {
    glue('<a href="https://translate.google.com/?sl=en&tl=es&text=',
         gsub(" ", "%20",sentence),
         '&op=translate">',
         sentence,
         '</a>'
    )
}


dict_md_line <- function(row, joiner) {
    paste0(joiner,
       paste0(
          c(
            wikitionary_link(row[3]),
            row[4],
            row[5],
            translation_link(row[6]),
            row[7]
          ),
          collapse=joiner),
       joiner,
       "\n"
    )
}

print_md_table_row <- function(row) {
    cat(dict_md_line(row, "|"))
}


process <- function(base) {
    # Input
    words <- read.csv(paste0(base, ".tsv"), sep="\t")
    
    #sounds <- unique(words$sound)
    
    sink(paste0(base,".md"))
    
    
    cat(
        surround_join(
            c("word",
              "pronunciation (IPA)",
              "some translations (algunos traducciones)",
              "example in English",
              "ejemplo en español"
            ),
            "|"
        )
    )
    
    cat(surround_join(rep("----", 5),"|"))
    
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
    
    
    render(input = paste0(base,".md"), output_format = "html_document")
}

names_to_process <- c("dictionary")

for (name in names_to_process) {
    process(name)
}
