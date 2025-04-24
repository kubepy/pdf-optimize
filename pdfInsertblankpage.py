#!/bin/python
import sys
from PyPDF2 import PdfWriter, PdfReader

output_pdf = PdfWriter()

with open(sys.argv[1], 'rb') as readfile:
    input_pdf = PdfReader(readfile)

    for page in (input_pdf.pages):
        output_pdf.add_page(page)

    output_pdf.insert_blank_page(index=173)
    output_pdf.insert_blank_page(index=237)
#    output_pdf.add_blank_page()
    
    output_file_name = "modify-" + sys.argv[1]
    with open(output_file_name, "wb") as writefile:
        output_pdf.write(writefile)

