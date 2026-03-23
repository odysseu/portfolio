# CV Website Build System

This repository contains a complete build system for generating a CV download website with preview functionality.

## Quick Start

### 1. Make scripts executable (first time only)

```bash
chmod +x build_cv_website.sh
```

### 2. Run the full build

```bash
./build_cv_website.sh
```

### 3. View the result

```bash
# Option 1: Use Python's built-in HTTP server
python3 -m http.server 8000
# Then open http://localhost:8000 in your browser

# Option 2: Open directly in browser
xdg-open index.html  # Linux
explorer index.html  # Windows
open index.html      # Mac
```

## What This Build System Does

1. **Compiles LaTeX to PDF**
   - `cv.tex` → `cv.pdf` (English CV)
   - `cv_french.tex` → `cv_french.pdf` (French CV)

2. **Generates Preview Images**
   - Creates `english_cv_preview.png` from first page of English CV
   - Creates `french_cv_preview.png` from first page of French CV

3. **Builds Interactive HTML Interface**
   - Creates `index.html` with clickable preview buttons
   - Responsive design for mobile and desktop
   - Hover effects and clean modern interface

## Advanced Usage

### Update previews only (if PDFs already exist)

```bash
python3 generate_cv_previews.py
```

### Force recompile LaTeX (if you modified .tex files)

```bash
# Remove existing PDFs to force recompilation
rm -f cv.pdf cv_french.pdf
./build_cv_website.sh
```

### Check generated files

```bash
ls -lh cv.pdf cv_french.pdf english_cv_preview.png french_cv_preview.png index.html
```

## Requirements

- `pdflatex` - For LaTeX compilation (part of TeX Live)
- `ghostscript` - For PDF to image conversion
- `Python 3` with `Pillow` library - For image processing
- LaTeX packages: `fontawesome`, `latexsym` (required by the .tex files)

### Install Requirements

```bash
# Install LaTeX and required packages
sudo apt install texlive-latex-base texlive-fonts-recommended texlive-fonts-extra texlive-latex-extra

# Install ghostscript for PDF conversion
sudo apt install ghostscript

# Install Python Pillow for image processing
pip install Pillow
```
=======

## Files Generated

- `cv.pdf` - English CV
- `cv_french.pdf` - French CV
- `english_cv_preview.png` - English CV preview (200px width)
- `french_cv_preview.png` - French CV preview (200px width)
- `index.html` - Web interface with download buttons

## Technical Details

- Preview images are generated at 200px width with proper aspect ratio
- HTML interface is self-contained with no external dependencies
- Script handles errors gracefully (e.g., missing LaTeX packages)
- Uses ghostscript for reliable PDF to PNG conversion

## Troubleshooting

### LaTeX Compilation Issues

If you see errors like:
```
! LaTeX Error: File `fontawesome.sty' not found.
```

Install the required LaTeX packages:
```bash
sudo apt install texlive-latex-extra texlive-fonts-extra
```

The script will automatically fall back to existing PDF files if compilation fails, so your build will still complete successfully.

### PDF Preview Generation Issues

If preview generation fails:
```bash
sudo apt install ghostscript
pip install Pillow
```

### Common Errors and Solutions

**Error**: `! LaTeX Error: File 'fontawesome.sty' not found.`
**Solution**: Install missing LaTeX packages as shown above

**Error**: `gs: command not found`
**Solution**: Install ghostscript: `sudo apt install ghostscript`

**Error**: `ModuleNotFoundError: No module named 'PIL'`
**Solution**: Install Pillow: `pip install Pillow`

## Notes

- The script uses `-interaction=nonstopmode` flag with pdflatex to prevent hanging on errors
- Compilation is run twice to ensure all references are resolved
- Existing PDF files are used as fallback if compilation fails
- Preview images are generated at 200px width with proper aspect ratio
=======

## License

This build system is provided as-is for personal portfolio use.