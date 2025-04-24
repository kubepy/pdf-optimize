#!/bin/python
import fitz  # PyMuPDF
import sys
import os

def is_page_empty(page):
    """Check if a page is empty (no text or images)."""
    return page.get_text().strip() == "" and page.get_images(full=True) == []

def merge_pages_to_one(pdf_path, output_path):
    # Open the PDF file
    pdf_document = fitz.open(pdf_path)
    num_pages = pdf_document.page_count

    # Set new page dimensions (1x2 grid for 2 pages)
    page_width = pdf_document[0].rect.width
    page_height = pdf_document[0].rect.height
    new_page_width = page_width * 2  # Width for two pages
    new_page_height = page_height      # Height remains the same

    # Create a new PDF document for the output
    new_pdf_document = fitz.open()

    # Process each group of 2 pages
    for i in range(0, num_pages, 2):
        # Create a new page in the output PDF
        new_page = new_pdf_document.new_page(width=new_page_width, height=new_page_height)

        # Copy up to 2 pages into the new page
        for j in range(2):
            page_index = i + j
            if page_index < num_pages:
                page = pdf_document[page_index]

                # Check if the page is empty
                if is_page_empty(page):
                    print(f"Adding empty page: {page_index}")
                    # If the page is empty, we can just add a blank rectangle
                    # This will create a blank space in the output
                    # You can also add a message or watermark if needed
                    continue  # We will handle this after the loop

                # Calculate position on the new page
                if j == 1:  # Second page (Right side)
                    x = page_width  # Position at the right
                    y = 0          # Top of the page
                else:  # First page (Left side)
                    x = 0          # Position at the left
                    y = 0          # Top of the page

                # Copy the original page to the new page at the calculated position
                new_page.show_pdf_page(fitz.Rect(x, y, x + page_width, y + page_height), pdf_document, page_index)

            else:
                # If there is no page to copy, we can add an empty space
                print(f"Adding empty page for missing page index: {page_index}")
                # Create a blank rectangle on the new page
                if j == 1:  # Second page (Right side)
                    x = page_width  # Position at the right
                    y = 0          # Top of the page
                else:  # First page (Left side)
                    x = 0          # Position at the left
                    y = 0          # Top of the page

                # Draw a blank rectangle (optional, you can customize this)
                new_page.draw_rect(fitz.Rect(x, y, x + page_width, y + page_height), color=(1, 1, 1), fill=(1, 1, 1))

    # Save the new PDF document
    new_pdf_document.save(output_path)
    new_pdf_document.close()
    pdf_document.close()

    print(f"Merged PDF saved to: {output_path}")

# Example usage
if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python merge_pdfs.py <input PDF path>")
        sys.exit(1)

    input_pdf_path = sys.argv[1]  # Input PDF file path
    output_pdf_path = "2-in-1_" + os.path.basename(input_pdf_path)  # Output PDF file path
    merge_pages_to_one(input_pdf_path, output_pdf_path)
