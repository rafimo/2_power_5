## cerner_2tothe5th_2021
## plotting with R
library(ggplot2)
library(dbplyr)

## all current extensions in the contest
extensions <- data.frame(extension = c("html", "ml", "jl", "rs", "r", "nut", "d", "wren", "dart", "hs", "go", "java", "lsp", "pike", "fs", "py", "f90", "nim", "cob", "pl", "cpp", "lab", "cr", "js", "foo", "sh", "ex", "scala", "odin", "applescript", "rb", "spl", "php", "elm", "emojic", "c", "bit", "ps1", "chef", "lua", "groovy", "gs", "vb", "pony", "lisp", "ws", "bf", "exs", "kt", "cs", "rkt"))

## read a kaggle dataset containing Hello World programs in different languages
df = read.csv("index.csv")

## intersect the dataset to only those languages in the contest
df <- df[is.element(df$extension, intersect(df$extension, extensions$extension)),]

## filter some stuff!
df <- filter(df, !grepl("ck$", language_name))

## add number of characters in each language as a column to dataframe
df <- mutate(df, characters = nchar(program))

## finds the language with max chars
df[which.max(df$characters),]['language_name']

## do some plotting!
ggplot(df, aes(language_name, characters )) + 
  geom_point()
