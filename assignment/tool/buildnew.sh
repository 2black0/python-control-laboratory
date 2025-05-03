#!/bin/bash

# Definisikan variabel untuk direktori sumber
SRC_DIR="src"
MARKDOWN_DIR="$SRC_DIR/markdown"
OUTPUT_FILE="$SRC_DIR/result/buku-skc.pdf"
TEMP_MD_FILE="$SRC_DIR/temp_combined.md" # File markdown sementara

# Fungsi untuk mencetak pesan log dengan timestamp
log() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

log "Memulai proses build..."

# Hapus file PDF lama dan file sementara
rm -f "$OUTPUT_FILE" "$TEMP_MD_FILE"
log "File lama dan file sementara dihapus (jika ada)."

# Gabungkan file Markdown
log "Menggabungkan file Markdown..."

# 1. Dapatkan daftar file menggunakan tree
file_list=$(tree -L 1 -n -P '*.md' --noreport "$MARKDOWN_DIR")

# 2. Periksa apakah ada file Markdown
if [ -z "$file_list" ]; then
  log "Tidak ada file Markdown yang ditemukan di $MARKDOWN_DIR. Proses dihentikan."
  exit 1
fi

# 3. Buat array 'files' dan cetak daftar file (hanya nama file)
files=()
while read -r line; do
  # Hapus karakter tree dan spasi di awal DAN akhir
  file=$(echo "$line" | tr -d '├──│└── ' | xargs)
  if [[ "$file" == *.md ]]; then
      log "  - Menggabungkan: $file"  # Cetak HANYA nama file
      files+=("$MARKDOWN_DIR/$file")    # Tambahkan path lengkap ke array
  fi
done < <(echo "$file_list")

# 4. Gabungkan file (menggunakan path lengkap dari array)
cat "${files[@]}" > "$TEMP_MD_FILE"

if [ $? -eq 0 ]; then
  log "File Markdown berhasil digabungkan ke: $TEMP_MD_FILE"
else
  log "Gagal menggabungkan file Markdown."
  exit 1
fi

# Jalankan Pandoc (sama seperti sebelumnya)
log "Menjalankan Pandoc..."
pandoc "$TEMP_MD_FILE" -o "$OUTPUT_FILE" \
    --lua-filter "$SRC_DIR/template/diagram.lua" \
    --filter pandoc-latex-environment \
    --from markdown \
    --template "$SRC_DIR/template/eisvogel.latex" \
    --listings \
    --top-level-division="chapter" \
    --highlight-style haddock \
    --pdf-engine=lualatex

if [ $? -eq 0 ]; then
  log "Pandoc selesai dengan sukses. File PDF dibuat di: $OUTPUT_FILE"
else
  log "Pandoc mengalami kesalahan. Periksa log Pandoc untuk detail lebih lanjut."
  exit 1
fi

# Hapus file sementara
rm "$TEMP_MD_FILE"
log "File Markdown sementara dihapus."

log "Proses build selesai."