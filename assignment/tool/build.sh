#!/bin/bash

# 1. Menerima nama berkas sebagai argumen
input_md="$1"

# 2. Periksa apakah berkas masukan ada
if [ ! -f "$input_md" ]; then
  echo "Error: File input '$input_md' tidak ditemukan." >&2
  exit 1
fi

# 3. Menghitung nama berkas keluaran
base_name=$(basename "$input_md" .md)
output_dir=$(dirname "$input_md") # Dapatkan direktori dari berkas input
output_pdf="$output_dir/$base_name.pdf" # Gabungkan direktori, nama dasar, dan ekstensi .pdf

# 4. Perintah Pandoc
pandoc "$input_md" -o "$output_pdf" \
  -V geometry:a4paper \
  -V geometry:left=2cm,top=2cm,right=2cm,bottom=2cm \
  --filter pandoc-latex-environment \
  --from markdown \
  --template "template/eisvogel.latex" \
  --listings \
  --top-level-division="chapter" \
  --highlight-style haddock \
  --pdf-engine=xelatex

# 5. Periksa apakah konversi berhasil
if [ $? -eq 0 ]; then
  echo "Konversi berhasil: $input_md -> $output_pdf"
else
  echo "Error: Konversi Pandoc gagal." >&2
  exit 1
fi

exit 0