# CV Website Build System

This directory contains a build system for generating a CV download website with preview functionality.

## Files Generated

- `cv.pdf` - English CV (compiled from `cv.tex`)
- `cv_french.pdf` - French CV (compiled from `cv_french.tex`)
- `english_cv_preview.png` - Preview image of English CV
- `french_cv_preview.png` - Preview image of French CV
- `index.html` - Web interface with download buttons

## Build Scripts

### Main Build Script
```bash
./build_cv_website.sh
```

This script performs all steps:
1. Compiles LaTeX files to PDF (if source .tex files exist)
2. Generates preview images from PDFs
3. Creates the HTML interface

### Preview Generation Only
```bash
python3 generate_cv_previews.py
```

Regenerates just the preview images from existing PDFs.

## Requirements

- `pdflatex` - For LaTeX compilation
- `ghostscript` - For PDF to image conversion
- `Python 3` with `Pillow` library - For image processing

## Usage

### Quick Start

1. **Make scripts executable** (first time only):
   ```bash
   chmod +x build_cv_website.sh
   ```

2. **Run the full build**:
   ```bash
   ./build_cv_website.sh
   ```

3. **Open the result**:
   ```bash
   # Option 1: Use Python's built-in HTTP server
   python3 -m http.server 8000
   # Then open http://localhost:8000 in your browser
   
   # Option 2: Open directly in browser
   xdg-open index.html  # Linux
   open index.html      # Mac
   start index.html     # Windows
   ```

### Advanced Usage

**Update previews only** (if you only modified PDFs, not LaTeX sources):
```bash
python3 generate_cv_previews.py
```

**Force recompile LaTeX** (if you modified .tex files):
```bash
# Remove existing PDFs to force recompilation
rm -f cv.pdf cv_french.pdf
./build_cv_website.sh
```

**Check generated files**:
```bash
ls -lh cv.pdf cv_french.pdf english_cv_preview.png french_cv_preview.png index.html
```
=======

## HTML Features

- Responsive design that works on mobile and desktop
- Clickable preview images that trigger PDF downloads
- Clean, modern interface with hover effects
- Automatic download with proper filenames

## Notes

- If LaTeX compilation fails (e.g., missing packages), the script will use existing PDF files
- Preview images are generated at 200px width with proper aspect ratio
- The HTML interface is self-contained with no external dependencies