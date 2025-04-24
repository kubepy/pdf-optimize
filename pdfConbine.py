#!/bin/python
import re
import os
import img2pdf

path = os.path.dirname(os.path.abspath(__file__))
os.chdir(path)

all_files = os.listdir(os.getcwd())
images = [i for i in all_files if i.lower().endswith((".jpg", ".jpeg", ".png"))]

images = [
    i for i in all_files
    if i.lower().endswith((".jpg", ".jpeg", ".png")) and not re.match(r'^[a-zA-Z]+\.jpg$|^[a-zA-Z]+\.jpeg$|^[a-zA-Z]+\.png$', i.lower())
]

def natural_sort_key(s):
    underscore_priority = 0 if s.startswith('_') else 1
    return (underscore_priority, [int(text) if text.isdigit() else text for text in re.split('([0-9]+)', s)])

images.sort(key=natural_sort_key)

path_base_name = os.path.basename(path)
output_file_name = path_base_name + ".pdf"
# output_file_name = "output.pdf"

with open(output_file_name, "wb") as f:
    f.write(img2pdf.convert(images))
