# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `hypersetup.latex`

File `hypersetup.latex` bertanggung jawab untuk mengkonfigurasi *package* `hyperref`, yang meningkatkan dokumen PDF dengan menambahkan *metadata* dan *hyperlinks*. File ini menetapkan warna *default* untuk berbagai jenis *hyperlinks* (tautan internal, file, kutipan, URL) dan mengkonfigurasi opsi `\hypersetup` untuk mengatur perilaku *hyperlinks* dan *metadata* PDF. *Metadata* PDF seperti judul, penulis, bahasa, subjek, dan kata kunci diambil dari variabel Pandoc, memungkinkan integrasi *metadata* dokumen ke dalam file PDF akhir. File ini juga mengontrol apakah *hyperlinks* berwarna, di-*underline*, atau tersembunyi, dan memastikan bahwa *hyperlinks* yang panjang dapat dipecah di baris baru. File ini penting untuk meningkatkan navigasi dan aksesibilitas dokumen PDF.

Berikut adalah isi file `hypersetup.latex` dan penjelasannya per bagian:

```latex
\definecolor{default-linkcolor}{HTML}{A50000}
\definecolor{default-filecolor}{HTML}{A50000}
\definecolor{default-citecolor}{HTML}{4077C0}
\definecolor{default-urlcolor}{HTML}{4077C0}

\hypersetup{
$if(title-meta)$
  pdftitle={$title-meta$},
$endif$
$if(author-meta)$
  pdfauthor={$author-meta$},
$endif$
$if(lang)$
  pdflang={$lang$},
$endif$
$if(subject)$
  pdfsubject={$subject$},
$endif$
$if(keywords)$
  pdfkeywords={$for(keywords)$$keywords$$sep$, $endfor$},
$endif$
$if(colorlinks)$
  colorlinks=true,
  linkcolor={$if(linkcolor)$$linkcolor$$else$default-linkcolor$endif$},
  filecolor={$if(filecolor)$$filecolor$$else$default-filecolor$endif$},
  citecolor={$if(citecolor)$$citecolor$$else$default-citecolor$endif$},
  urlcolor={$if(urlcolor)$$urlcolor$$else$default-urlcolor$endif$},
$else$
$if(boxlinks)$
$else$
  hidelinks,
$endif$
$endif$
  breaklinks=true,
  pdfcreator={LaTeX via pandoc with the Eisvogel template}}
```

#### Penjelasan per Bagian dari `hypersetup.latex`:

##### 1. Default Link Color Definitions (Definisi Warna Tautan *Default*)

```latex
\definecolor{default-linkcolor}{HTML}{A50000}
\definecolor{default-filecolor}{HTML}{A50000}
\definecolor{default-citecolor}{HTML}{4077C0}
\definecolor{default-urlcolor}{HTML}{4077C0}
```

*   **Tujuan**: Mendefinisikan warna *default* menggunakan perintah `\definecolor` dari *package* `xcolor` (yang dimuat di `eisvogel.latex`). Warna-warna ini digunakan sebagai *fallback* jika warna tautan *custom* tidak ditentukan melalui variabel Pandoc.
*   **Perintah LaTeX**: `\definecolor`
*   **Warna yang Didefinisikan**:
    *   `default-linkcolor`: `#A50000` (Merah tua). Digunakan sebagai *default* untuk tautan internal dalam dokumen (misalnya, tautan ke bagian, gambar, tabel).
    *   `default-filecolor`: `#A50000` (Merah tua). Digunakan sebagai *default* untuk tautan ke file eksternal (meskipun jenis tautan ini mungkin kurang umum dalam dokumen PDF yang dihasilkan Pandoc dari *markdown*).
    *   `default-citecolor`: `#4077C0` (Biru sedang). Digunakan sebagai *default* untuk tautan kutipan (tautan ke entri bibliografi).
    *   `default-urlcolor`: `#4077C0` (Biru sedang). Digunakan sebagai *default* untuk tautan URL eksternal.
*   **Format Warna**: Warna didefinisikan menggunakan format `HTML` dan kode warna *hexadecimal*.

##### 2. `\hypersetup` Configuration (Konfigurasi `\hypersetup`)

```latex
\hypersetup{
$if(title-meta)$
  pdftitle={$title-meta$},
$endif$
$if(author-meta)$
  pdfauthor={$author-meta$},
$endif$
$if(lang)$
  pdflang={$lang$},
$endif$
$if(subject)$
  pdfsubject={$subject$},
$endif$
$if(keywords)$
  pdfkeywords={$for(keywords)$$keywords$$sep$, $endfor$},
$endif$
$if(colorlinks)$
  colorlinks=true,
  linkcolor={$if(linkcolor)$$linkcolor$$else$default-linkcolor$endif$},
  filecolor={$if(filecolor)$$filecolor$$else$default-filecolor$endif$},
  citecolor={$if(citecolor)$$citecolor$$else$default-citecolor$endif$},
  urlcolor={$if(urlcolor)$$urlcolor$$else$default-urlcolor$endif$},
$else$
$if(boxlinks)$
$else$
  hidelinks,
$endif$
$endif$
  breaklinks=true,
  pdfcreator={LaTeX via pandoc with the Eisvogel template}}
```

*   **Tujuan**: Mengkonfigurasi *package* `hyperref` menggunakan perintah `\hypersetup`. Konfigurasi ini mencakup *metadata* PDF dan tampilan *hyperlink*.
*   **Perintah LaTeX**: `\hypersetup`
*   **Variabel Pandoc**: `title-meta`, `author-meta`, `lang`, `subject`, `keywords`, `colorlinks`, `linkcolor`, `filecolor`, `citecolor`, `urlcolor`, `boxlinks`
    *   **PDF Metadata**: Opsi-opsi berikut mengatur *metadata* PDF yang tertanam dalam file PDF. *Metadata* ini dapat dilihat di properti dokumen PDF dan digunakan oleh *search engine* dan perangkat lunak manajemen dokumen.
        *   **`pdftitle` (Kondisional `title-meta`)**: `$if(title-meta)$ pdftitle={$title-meta$}, $endif$`. Jika variabel `title-meta` didefinisikan, mengatur judul PDF *metadata* ke nilai variabel ini.
        *   **`pdfauthor` (Kondisional `author-meta`)**: `$if(author-meta)$ pdfauthor={$author-meta$}, $endif$`. Jika variabel `author-meta` didefinisikan, mengatur penulis PDF *metadata* ke nilai variabel ini.
        *   **`pdflang` (Kondisional `lang`)**: `$if(lang)$ pdflang={$lang$}, $endif$`. Jika variabel `lang` didefinisikan, mengatur bahasa PDF *metadata* ke nilai variabel ini. Nilai ini harus berupa kode bahasa BCP 47 (misalnya, `"en-US"`, `"de-DE"`).
        *   **`pdfsubject` (Kondisional `subject`)**: `$if(subject)$ pdfsubject={$subject$}, $endif$`. Jika variabel `subject` didefinisikan, mengatur subjek PDF *metadata* ke nilai variabel ini.
        *   **`pdfkeywords` (Kondisional `keywords`)**: `$if(keywords)$ pdfkeywords={$for(keywords)$$keywords$$sep$, $endfor$}, $endif$`. Jika variabel `keywords` didefinisikan, mengatur kata kunci PDF *metadata* ke daftar kata kunci yang diambil dari variabel daftar `$keywords`. Loop Pandoc `$for(keywords)...$ $endfor$` menghasilkan daftar kata kunci yang dipisahkan koma.
    *   **Hyperlink Appearance (Kondisional `colorlinks`, `linkcolor`, `filecolor`, `citecolor`, `urlcolor`, `boxlinks`)**: Opsi-opsi ini mengontrol tampilan *hyperlink* dalam dokumen PDF.
        *   **`colorlinks` Condition (`$if(colorlinks)$`)**: `$if(colorlinks)$ ... $else$ ... $endif$`. Jika variabel `colorlinks` didefinisikan, mengaktifkan *hyperlinks* berwarna.
            *   **Jika `colorlinks` didefinisikan**:
                *   `colorlinks=true,`: Mengaktifkan *hyperlinks* berwarna.
                *   `linkcolor={$if(linkcolor)$$linkcolor$$else$default-linkcolor$endif$},`: Mengatur warna tautan internal ke nilai variabel `$linkcolor` jika didefinisikan, jika tidak menggunakan warna *default* `default-linkcolor` (merah tua) yang didefinisikan sebelumnya.
                *   `filecolor={$if(filecolor)$$filecolor$$else$default-filecolor$endif$},`: Mengatur warna tautan file ke nilai variabel `$filecolor` jika didefinisikan, jika tidak menggunakan warna *default* `default-filecolor` (merah tua).
                *   `citecolor={$if(citecolor)$$citecolor$$else$default-citecolor$endif$},`: Mengatur warna tautan kutipan ke nilai variabel `$citecolor` jika didefinisikan, jika tidak menggunakan warna *default* `default-citecolor` (biru sedang).
                *   `urlcolor={$if(urlcolor)$$urlcolor$$else$default-urlcolor$endif$},`: Mengatur warna tautan URL ke nilai variabel `$urlcolor` jika didefinisikan, jika tidak menggunakan warna *default* `default-urlcolor` (biru sedang).
            *   **Jika `colorlinks` tidak didefinisikan (`\else` branch)**:
                *   **`boxlinks` Condition (Kondisional `$if(boxlinks)$`)**: `$if(boxlinks)$ $else$ hidelinks, $endif$`. Jika variabel `boxlinks` didefinisikan, **tidak melakukan apa pun**. *This condition seems to be incomplete or intended for future use, as it does nothing if `boxlinks` is true. If `boxlinks` is not defined (or false)*.
                *   `hidelinks,`: Jika `colorlinks` tidak didefinisikan dan `boxlinks` tidak didefinisikan (atau *false*), menggunakan opsi `hidelinks`. Opsi `hidelinks` **menghilangkan semua indikasi visual *hyperlink*** (warna dan kotak), membuat *hyperlink* tidak terlihat secara visual tetapi masih berfungsi dalam dokumen PDF.
    *   **Other `hyperref` Options (Opsi `hyperref` lainnya)**:
        *   `breaklinks=true,`: Mengaktifkan opsi `breaklinks`. Opsi `breaklinks` memungkinkan *hyperlink* yang panjang untuk dipecah di akhir baris, mencegah *hyperlink* melampaui margin halaman.
        *   `pdfcreator={LaTeX via pandoc with the Eisvogel template}`: Mengatur *creator* PDF *metadata* ke string `"LaTeX via pandoc with the Eisvogel template"`. Informasi ini menunjukkan bagaimana dokumen PDF dihasilkan.

*   **Opsi Variabel terkait `\hypersetup`**:
    *   **`title-meta`**: *String*. Judul PDF *metadata*.
    *   **`author-meta`**: *String*. Penulis PDF *metadata*.
    *   **`lang`**: *String*. Bahasa PDF *metadata* (kode bahasa BCP 47). (e.g., `"en-US"`, `"de-DE"`)
    *   **`subject`**: *String*. Subjek PDF *metadata*.
    *   **`keywords`**: *List* *String*. Daftar kata kunci PDF *metadata*.
    *   **`colorlinks`**: *Boolean*. Mengaktifkan *hyperlinks* berwarna.
    *   **`linkcolor`**: *String*. Warna untuk tautan internal (jika `colorlinks` *true*). (e.g., `"red"`, `"blue"`, `"default-linkcolor"`)
    *   **`filecolor`**: *String*. Warna untuk tautan file (jika `colorlinks` *true*). (e.g., `"green"`, `"orange"`, `"default-filecolor"`)
    *   **`citecolor`**: *String*. Warna untuk tautan kutipan (jika `colorlinks` *true*). (e.g., `"cyan"`, `"purple"`, `"default-citecolor"`)
    *   **`urlcolor`**: *String*. Warna untuk tautan URL (jika `colorlinks` *true*). (e.g., `"magenta"`, `"brown"`, `"default-urlcolor"`)
    *   **`boxlinks`**: *Boolean*.  *Sepertinya tidak berpengaruh dalam konfigurasi ini, mungkin placeholder untuk konfigurasi *boxlinks* di masa mendatang*. Jika *false* dan `colorlinks` *false*, `hidelinks` diaktifkan.

---