#Monster Manual Stats Extraction

# Load necessary libraries
library(pdftools)
library(stringr)
library(dplyr)
library(readr)
library(officer)
# Define the path to your PDF file
pdf_path <- "ADnD_1e_Monster_Manual.pdf"  # Change if needed

# Extract text from the PDF
pdf_text <- pdf_text(pdf_path)

#Making pdf pretty 
pdf_text <- cat(pdf_text)

#Defining Keywords 
keywords <- c("FREQUENCY:", "NO. APPEARING:", "AROMOR CLASS:",
              "MOVE:", "HIT DICE:", "% IN LAIR:", "TREASURE TYPE:",
              "NO. OF ATTACKS:", "DAMAGE/ATTACK:", "SPECIAL ATTACKS:",
              "SPECIAL DEFENSES:", "MAGIC RESISTANCE:", "INTELLIGENCE:",
              "ALIGNMENT:", "SIZE:", "PSIONIC ABILITY:")





writeLines(full_text, "monster_manual_text.txt")

# Save as a .docx file
doc <- read_docx()
doc <- body_add_par(doc, full_text)
print(doc, target = "monster_manual.docx")

# Print success message
print("PDF text has been converted and saved as 'monster_manual_text.txt' and 'monster_manual.docx'")

