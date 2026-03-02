# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(stringi)
library(rebus.base)


# Data Import
citations <- stri_read_lines("../data/cites.txt")
citations_txt <- str_subset(citations, pattern = ANY_CHAR, negate = FALSE)
paste("The number of blank lines eliminated was", formatC(length(citations) - length(citations_txt)))
paste("The average number of characters/citation was", formatC(mean(str_length(citations_txt))))

# Data Cleaning
















# Analysis