#!/bin/bash

# Comprehensive script to build CV website
# Usage: ./build_cv_website.sh

# Check if texlive-full is installed, if not install it
echo "=== Checking LaTeX Installation ==="
if ! command -v pdflatex &> /dev/null; then
    echo "LaTeX not found. Installing texlive-full..."
    sudo apt update
    sudo apt install -y texlive-full
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install texlive-full. Please install it manually with: sudo apt install texlive-full"
        exit 1
    fi
    echo "✓ texlive-full installed successfully"
else
    echo "✓ LaTeX is already installed"
fi

echo "=== Building CV Website ==="

# Step 1: Compile LaTeX files to PDF (if source files exist)
echo "1. Compiling LaTeX files..."

if [ -f "cv_english.tex" ]; then
    echo "  - Compiling cv_english.tex..."
    echo "    Running pdflatex (first pass)..."
    if pdflatex -interaction=nonstopmode cv_english.tex; then
        echo "    Running pdflatex (second pass for references)..."
        if pdflatex -interaction=nonstopmode cv_english.tex; then
            echo "  ✓ cv_english.pdf generated successfully"
        else
            echo "  ⚠ cv_english.tex second pass failed, but first pass succeeded"
        fi
    else
        echo "  ✗ cv_english.tex compilation failed"
        if [ -f "cv_english.pdf" ]; then
            echo "  ℹ Using existing cv_english.pdf file"
        else
            echo "  ⚠ No cv_english.pdf available"
        fi
    fi
else
    echo "  ⚠ cv_english.tex not found, using existing cv_english.pdf if available"
fi

if [ -f "cv_french.tex" ]; then
    echo "  - Compiling cv_french.tex..."
    echo "    Running pdflatex (first pass)..."
    if pdflatex -interaction=nonstopmode cv_french.tex; then
        echo "    Running pdflatex (second pass for references)..."
        if pdflatex -interaction=nonstopmode cv_french.tex; then
            echo "  ✓ cv_french.pdf generated successfully"
        else
            echo "  ⚠ cv_french.tex second pass failed, but first pass succeeded"
        fi
    else
        echo "  ✗ cv_french.tex compilation failed"
        if [ -f "cv_french.pdf" ]; then
            echo "  ℹ Using existing cv_french.pdf file"
        else
            echo "  ⚠ No cv_french.pdf available"
        fi
    fi
else
    echo "  ⚠ cv_french.tex not found, using existing cv_french.pdf if available"
fi

# Step 2: Generate preview images from PDFs (if PDFs exist)
echo "2. Generating preview images..."
if [ -f "cv.pdf" ] || [ -f "cv_french.pdf" ]; then
    python3 generate_cv_previews.py
else
    echo "  ⚠ No PDF files found, skipping preview generation"
fi

# Step 3: Create/update HTML file
echo "3. Creating HTML interface..."

cat > index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ulysse Boucherie - CV Download</title>
    <link rel="icon" href="favicon.ico" type="image/x-icon">
    <style>
        body {
            font-family: 'Arial', sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 20px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
        }
        .container {
            background-color: white;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
            padding: 30px;
            text-align: center;
            max-width: 800px;
            width: 100%;
        }
        h1 {
            color: #333;
            margin-bottom: 30px;
        }
        .cv-options {
            display: flex;
            justify-content: center;
            gap: 30px;
            margin-bottom: 30px;
            flex-wrap: wrap;
        }
        .cv-option {
            cursor: pointer;
            transition: transform 0.2s;
            text-align: center;
        }
        .cv-option:hover {
            transform: scale(1.05);
        }
        .cv-option img {
            width: 200px;
            height: 280px;
            border: 1px solid #ddd;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            object-fit: contain;
            background-color: white;
        }
        .cv-option p {
            margin-top: 10px;
            font-weight: bold;
            color: #555;
        }
        .note {
            margin-top: 30px;
            color: #777;
            font-size: 14px;
        }
        @media (max-width: 600px) {
            .cv-options {
                flex-direction: column;
                gap: 20px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Download My CV</h1>
        <div class="cv-options">
            <div class="cv-option" onclick="downloadCV('english')">
                <img src="english_cv_preview.png" alt="English CV Preview">
                <p>English Version</p>
            </div>
            <div class="cv-option" onclick="downloadCV('french')">
                <img src="french_cv_preview.png" alt="French CV Preview">
                <p>French Version</p>
            </div>
        </div>
        <div class="note">
            <p>Click on the preview images above to download the respective CV version.</p>
        </div>
    </div>
    
    <script>
        function downloadCV(language) {
            const link = document.createElement('a');
            
            if (language === 'english') {
                link.href = 'cv_english.pdf';
                link.download = 'Ulysse_Boucherie_CV_English.pdf';
            } else {
                link.href = 'cv_french.pdf';
                link.download = 'Ulysse_Boucherie_CV_French.pdf';
            }
            
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
        }
    </script>
</body>
</html>
EOF

echo "  ✓ index.html created"

echo "=== Build Complete ==="
echo "Generated files:"
for file in cv.pdf cv_french.pdf english_cv_preview.png french_cv_preview.png index.html; do
    if [ -f "$file" ]; then
        size=$(du -h "$file" | cut -f1)
        echo "  ✓ $file ($size)"
    else
        echo "  ⚠ $file (missing)"
    fi
done

echo ""
echo "You can now open index.html in a browser to see the CV download page with preview buttons."
