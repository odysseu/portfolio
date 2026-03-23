#!/usr/bin/env python3

"""
Simple script to generate CV previews using ghostscript
Usage: python3 generate_cv_previews.py
"""

import os
import subprocess
import sys
from PIL import Image

def create_pdf_preview_gs(pdf_file, preview_file, width=200):
    """Create a preview image from the first page of a PDF using ghostscript"""
    if not os.path.exists(pdf_file):
        print(f"  ⚠ {pdf_file} not found, skipping preview")
        return False
    
    print(f"  - Creating {preview_file} using ghostscript...")
    try:
        # Use ghostscript to convert first page to PNG
        temp_png = f"temp_{preview_file}"
        subprocess.run([
            'gs', '-dNOPAUSE', '-dBATCH', '-sDEVICE=png16m', 
            '-r150', f'-sOutputFile={temp_png}', pdf_file
        ], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL, check=True)
        
        # Resize the image to desired dimensions
        img = Image.open(temp_png)
        aspect_ratio = img.height / img.width
        new_height = int(width * aspect_ratio)
        img = img.resize((width, new_height), Image.LANCZOS)
        img.save(preview_file, 'PNG')
        
        # Clean up temporary file
        os.remove(temp_png)
        
        print(f"  ✓ {preview_file} created")
        return True
        
    except Exception as e:
        print(f"  ✗ Failed to create {preview_file}: {e}")
        return False

def main():
    print("=== Creating CV Previews ===")
    
    # Create previews for both CVs
    create_pdf_preview_gs('cv.pdf', 'english_cv_preview.png')
    create_pdf_preview_gs('cv_french.pdf', 'french_cv_preview.png')
    
    print("=== Preview Generation Complete ===")

if __name__ == "__main__":
    main()