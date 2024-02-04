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
            row[6],
            translation_link(row[7]),
            row[8]
          ),
          collapse=joiner),
       joiner,
       "\n"
    )
}

print_md_table_row <- function(row) {
    cat(dict_md_line(row, "|"))
}

print_md_table_no_links <- function(row) {
    cat(surround_join(row[3:8], "|"))
}

process <- function(base_in, base_out, line_printer) {
    # Input
    words <- read.csv(paste0(base_in, ".tsv"), sep="\t")
    
    #sounds <- unique(words$sound)
    
    sink(paste0(base_out,".md"))
    
    cat(
        surround_join(
            c("word",
              "pronunciation<BR>(AHD)",
              "pronunciation<BR>(IPA)",
              "some translations<BR>(algunos traducciones)",
              "example in English",
              "ejemplo en español"
            ),
            "|"
        )
    )
    
    cat(surround_join(rep("----", 6),"|"))
    
    # Print all the rows
    # (and capture result of apply so it doesn't print to the document)
    apply_result <- apply(words, 1, line_printer)
    
    sink()
    
    
    render(input = paste0(base_out,".md"), output_format = "html_document")
}

names_to_process <- c("dictionary", "sound_dict")

for (name in names_to_process) {
    process(name, name, print_md_table_row)
    process(name, paste0(name, "_no_links"), print_md_table_no_links)
}

render(input = "../documents/sounds_no_links.md", output_format = "html_document")
render(input = "../class/Phrases_Lesson_01.md", output_format = "html_document")
