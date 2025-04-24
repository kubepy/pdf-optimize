import fitz  # PyMuPDF
import sys
import os

pdf_path = sys.argv[1]
file_name = os.path.basename(pdf_path)

def count_blank_pages(pdf_path):
    blank_page_count = 0

    with fitz.open(pdf_path) as pdf:
        for page_number in range(len(pdf)):
            page = pdf[page_number]
            text = page.get_text()

            if not text.strip() and not page.get_images(full=True):
                blank_page_count += 1

    return blank_page_count

empty_page_count = count_blank_pages(pdf_path)

print(f"文件名字: {file_name} \t空白页面数量: {empty_page_count}")
