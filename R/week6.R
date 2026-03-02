# Script Settings and Resources
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
library(tidyverse)
library(stringi)
library(rebus)


# Data Import
citations <- stri_read_lines("../data/cites.txt")
citations_txt <- str_subset(citations, pattern = ANY_CHAR, negate = FALSE)
str_c("The number of blank lines eliminated was ", length(citations) - length(citations_txt))
str_c("The average number of characters/citation was ", mean(str_length(citations_txt)))

# Data Cleaning
slice_sample(citations_tbl, n = 20) %>%
  View()
citations_tbl <- tibble(line = seq_along(citations_txt), cite = citations_txt) %>%
  mutate(
    authors = str_extract(cite, pattern = "^\\*?([^(]+)"),
    year = str_extract(cite, pattern = "(?<=\\()\\d{4}"),
    title = str_extract(cite, pattern = "(?<=\\)\\.\\s).*?(?=[.?!]\\s)"),
    journal_title = str_extract(cite, pattern = "(?<=\\.\\s).*?(?=,\\s*\\d)"),
    book_title = str_extract(cite, pattern = "(?<=\\)\\.\\s).*?(?=\\.\\s)"),
    journal_page_start = str_match(cite, ",\\s*\\d+(?:\\([^)]*\\))?,\\s*(\\d+)")[,2],
    journal_page_end = str_match(cite, ",\\s*\\d+(?:\\([^)]*\\))?,\\s*\\d+\\D(\\d+)")[,2],
    book_page_start = str_match(cite, "\\(p{1,2}\\.\\s*(\\d+)\\D\\d+\\")[,2],
    book_page_end   = str_match(cite, "\\(p{1,2}\\.\\s*\\d+\\D(\\d+)\\)")[,2],
    doi = str_extract(cite, "(?i)(?:doi:\\s*)?10\\.\\d{4,9}/[-._;()/:A-Za-z0-9]+"),
    perf_ref = str_detect(title, regex("performance", ignore_case = TRUE)),
    first_author = str_extract(authors, pattern = "^[^,\\s]+,?\\s*[A-Z]\\.?(?:[A-Z]\\.?)*")
  )
# Analysis
citations_tbl %>% 
  summarize(
    cites = n(),
    first_authors = sum(!is.na(first_author)),
    articles = sum(!is.na(journal_title)),
    chapters = sum(!is.na(book_title))
  )


citations_tbl %>%
  filter(perf_ref, !is.na(journal_title)) %>%
  count(journal_name = journal_title, name = "frequency", sort = TRUE) %>%
  head(10)



citations_tbl %>%
  count(citation = cite, name = "frequency", sort = TRUE) %>%
  head(10)