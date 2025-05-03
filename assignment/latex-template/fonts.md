# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `fonts.latex`

File `fonts.latex` ini bertugas untuk memuat *package*-*package* LaTeX dasar yang diperlukan untuk penanganan *font*, *encoding*, dan simbol. File ini secara kondisional memuat *package* berdasarkan *engine* LaTeX yang digunakan (PDFTeX, XeTeX, LuaTeX) dan variabel Pandoc. File ini mengelola *font encoding*, *input encoding*, *textcomp* untuk simbol tambahan, *unicode-math* dan *mathspec* untuk *math fonts* (terutama untuk XeTeX/LuaTeX), dan juga menetapkan *default font features* untuk XeTeX/LuaTeX. Selain itu, ia menetapkan *Latin Modern* sebagai *default font* jika tidak ada *font family* yang ditentukan oleh pengguna. File ini adalah fondasi untuk konfigurasi *font* template, memastikan bahwa *font* dan *encoding* yang tepat diaktifkan untuk pemrosesan dokumen yang benar.

Berikut adalah isi file `fonts.latex` dan penjelasannya per bagian:

```latex
\usepackage{iftex}
\ifPDFTeX
  \usepackage[$if(fontenc)$$fontenc$$else$T1$endif$]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{textcomp} % provide euro and other symbols
\else % if luatex or xetex
$if(mathspec)$
  \ifXeTeX
    \usepackage{mathspec} % this also loads fontspec
  \else
    \usepackage{unicode-math} % this also loads fontspec
  \fi
$else$
  \usepackage{unicode-math} % this also loads fontspec
$endif$
  \defaultfontfeatures{Scale=MatchLowercase}$-- must come before Beamer theme
  \defaultfontfeatures[\rmfamily]{Ligatures=TeX,Scale=1}
\fi
$if(fontfamily)$
$else$
$-- Set default font before Beamer theme so the theme can override it
\usepackage{lmodern}
$endif$
```

#### Penjelasan per Bagian dari `fonts.latex`:

##### 1. Engine Detection and Basic Font Packages (Deteksi *Engine* dan *Package Font* Dasar)

```latex
\usepackage{iftex}
\ifPDFTeX
  \usepackage[$if(fontenc)$$fontenc$$else$T1$endif$]{fontenc}
  \usepackage[utf8]{inputenc}
  \usepackage{textcomp} % provide euro and other symbols
\else % if luatex or xetex
  ... (XeTeX/LuaTeX specific packages and settings) ...
\fi
```

*   **Tujuan**: Memuat *package*-*package* LaTeX dasar yang diperlukan untuk penanganan *font* dan *encoding*, dengan mempertimbangkan *engine* LaTeX yang digunakan (PDFTeX vs. XeTeX/LuaTeX).
*   **Package**: `iftex`, `fontenc`, `inputenc`, `textcomp`
*   **Perintah LaTeX**: `\usepackage`, `\ifPDFTeX`, `\else`, `\fi`
    *   `\usepackage{iftex}`: Memuat *package* `iftex`. *Package* `iftex` menyediakan *conditionals* LaTeX untuk mendeteksi *engine* LaTeX yang sedang digunakan (PDFTeX, XeTeX, LuaTeX).
    *   `\ifPDFTeX ... \else ... \fi`: *Conditional* yang disediakan oleh *package* `iftex`. Kode di dalam `\ifPDFTeX` akan dieksekusi jika *engine* adalah PDFTeX; kode di dalam `\else` akan dieksekusi jika *engine* **bukan** PDFTeX (yaitu, XeTeX atau LuaTeX).
        *   **PDFTeX Branch (`\ifPDFTeX`):**
            *   `\usepackage[$if(fontenc)$$fontenc$$else$T1$endif$]{fontenc}`: Memuat *package* `fontenc`. *Package* `fontenc` digunakan untuk konfigurasi *font encoding* di PDFTeX.
                *   `[$if(fontenc)$$fontenc$$else$T1$endif$]`: Opsi untuk *package* `fontenc` diambil dari variabel Pandoc `$fontenc`. Jika `$fontenc` didefinisikan, nilainya digunakan sebagai opsi *encoding*. Jika `$fontenc` tidak didefinisikan, *default* opsi `T1` digunakan. `T1` *encoding* mendukung karakter Latin-based Eropa dengan baik.
            *   `\usepackage[utf8]{inputenc}`: Memuat *package* `inputenc` dengan opsi `[utf8]`. *Package* `inputenc` digunakan untuk mengatur *input encoding* dokumen di PDFTeX, memungkinkan penggunaan karakter UTF-8 dalam file input.
            *   `\usepackage{textcomp} % provide euro and other symbols`: Memuat *package* `textcomp`. *Package* `textcomp` menyediakan simbol teks tambahan, termasuk simbol Euro (€), *copyright* (©), dan lain-lain, yang mungkin tidak tersedia secara *default* dalam semua *font encoding*. Komentar menjelaskan tujuannya.
        *   **Non-PDFTeX Branch (`\else` - for XeTeX/LuaTeX):**
            *   *Packages and settings specific to XeTeX/LuaTeX are configured in the following sections within the `\else` branch.*

*   **Opsi Variabel `fontenc`**: *String*. Opsi *font encoding* untuk *package* `fontenc` (PDFTeX only). (e.g., `"T1"`, `"OT1"`)

##### 2. Math Font Packages for XeTeX/LuaTeX (Paket *Math Font* untuk XeTeX/LuaTeX)

```latex
\else % if luatex or xetex
$if(mathspec)$
  \ifXeTeX
    \usepackage{mathspec} % this also loads fontspec
  \else
    \usepackage{unicode-math} % this also loads fontspec
  \fi
$else$
  \usepackage{unicode-math} % this also loads fontspec
$endif$
  ... (Default font features for XeTeX/LuaTeX follow) ...
\fi
```

*   **Tujuan**: Memuat *package* untuk *math font* di XeTeX dan LuaTeX, secara kondisional memilih antara `mathspec` (untuk XeTeX jika diaktifkan) dan `unicode-math` (untuk LuaTeX atau sebagai *default* untuk XeTeX jika `mathspec` tidak diaktifkan).
*   **Packages**: `mathspec`, `unicode-math`
*   **Perintah LaTeX**: `\usepackage`, `\ifXeTeX`, `\else`, `\fi`
    *   **Conditional Math Package Loading (inside `\else` branch):**
        *   `$if(mathspec)$ ... $else$ ... $endif$`. Jika variabel `mathspec` didefinisikan, memilih antara `mathspec` (XeTeX) dan `unicode-math` (LuaTeX).
            *   **`mathspec` Condition (`$if(mathspec)$`)**:
                *   `\ifXeTeX ... \else ... \fi`. Memeriksa apakah *engine* adalah XeTeX.
                    *   **XeTeX Branch (`\ifXeTeX`)**: `\usepackage{mathspec} % this also loads fontspec`. Jika *engine* adalah XeTeX dan `mathspec` diaktifkan, memuat *package* `mathspec`. Komentar penting menunjukkan bahwa `mathspec` **juga memuat *package* `fontspec`**. *Package* `mathspec` menyediakan cara untuk menggunakan *system fonts* untuk matematika di XeTeX, tetapi mungkin kurang fleksibel dan kurang direkomendasikan daripada `unicode-math` untuk LuaTeX dan XeTeX modern.
                    *   **Non-XeTeX Branch (`\else` - LuaTeX assumed)**: `\usepackage{unicode-math} % this also loads fontspec`. Jika *engine* bukan XeTeX (LuaTeX diasumsikan) dan `mathspec` diaktifkan, memuat *package* `unicode-math`. Komentar juga menunjukkan bahwa `unicode-math` **juga memuat *package* `fontspec`**. *Package* `unicode-math` adalah *package* *math font* modern dan direkomendasikan untuk XeTeX dan LuaTeX, menyediakan dukungan Unicode *math fonts* yang komprehensif dan fleksibel.
            *   **`mathspec` Not Defined (`\else` branch of `$if(mathspec)$`)**: `\usepackage{unicode-math} % this also loads fontspec`. Jika variabel `mathspec` *tidak* didefinisikan, *default*-nya adalah memuat *package* `unicode-math` (untuk kedua XeTeX dan LuaTeX), yang merupakan pilihan yang lebih modern dan direkomendasikan untuk *math font* konfigurasi.
*   **Opsi Variabel `mathspec`**: *Boolean*. Mengaktifkan penggunaan *package* `mathspec` untuk *math font* di XeTeX (jika *true*). Jika *false* atau tidak didefinisikan, `unicode-math` digunakan.

##### 3. Default Font Features for XeTeX/LuaTeX (Fitur *Font Default* untuk XeTeX/LuaTeX)

```latex
\else % if luatex or xetex
  ... (Math font packages - previous section) ...
  \defaultfontfeatures{Scale=MatchLowercase}$-- must come before Beamer theme
  \defaultfontfeatures[\rmfamily]{Ligatures=TeX,Scale=1}
\fi
```

*   **Tujuan**: Mengatur *default font features* untuk XeTeX dan LuaTeX menggunakan perintah `\defaultfontfeatures` dari *package* `fontspec` (yang dimuat oleh `mathspec` atau `unicode-math`). Pengaturan ini diterapkan **hanya untuk XeTeX dan LuaTeX** (di dalam `\else` branch dari `\ifPDFTeX`).
*   **Perintah LaTeX**: `\defaultfontfeatures`
    *   **`\defaultfontfeatures{Scale=MatchLowercase}`**: Mengatur fitur *default font* untuk **semua *font*** (tanpa menentukan *font family*). Opsi `Scale=MatchLowercase` memastikan bahwa semua *font* akan di-skala agar *x-height* (tinggi huruf kecil) sesuai dengan *x-height* *font* utama dokumen. Komentar penting menunjukkan bahwa perintah ini **harus datang sebelum *Beamer theme*** dimuat. Ini karena *Beamer themes* mungkin *override* pengaturan *font default*.
    *   **`\defaultfontfeatures[\rmfamily]{Ligatures=TeX,Scale=1}`**: Mengatur fitur *default font* **khusus untuk *font family* `\rmfamily`** (yang biasanya digunakan untuk *serif font* utama).
        *   `\rmfamily`: Menentukan bahwa pengaturan ini hanya berlaku untuk *font family* `\rmfamily`.
        *   `Ligatures=TeX`: Mengaktifkan *ligatures* TeX *default* (seperti "ff", "fi", "fl", "ffi", "ffl") untuk *font family* `\rmfamily`. *Ligatures* adalah karakter gabungan tipografi untuk pasangan atau triplet karakter tertentu yang terlihat lebih baik bersama.
        *   `Scale=1`: Mengatur *scaling* *font* menjadi 1 (100%), yang berarti tidak ada *scaling* tambahan yang diterapkan ke *font* `\rmfamily` (selain dari `MatchLowercase` yang diatur sebelumnya untuk semua *font*).

##### 4. Default Font Loading for PDFTeX (Pemuatan *Font Default* untuk PDFTeX)

```latex
$if(fontfamily)$
$else$
$-- Set default font before Beamer theme so the theme can override it
\usepackage{lmodern}
$endif$
```

*   **Tujuan**: Memuat *package* *font* *default* `lmodern` untuk PDFTeX, **jika variabel `fontfamily` tidak didefinisikan**. Ini memastikan bahwa ada *font* *default* yang wajar yang digunakan dalam dokumen PDFTeX jika pengguna tidak secara eksplisit memilih *font family* lain.
*   **Package**: `lmodern`
*   **Perintah LaTeX**: `\usepackage`, `$if`, `\else`, `\endif`
    *   **Conditional Default Font Loading**:
        *   `$if(fontfamily)$ ... $else$ ... $endif$`. Jika variabel `fontfamily` **didefinisikan**, berarti pengguna telah memilih *font family* *custom*, sehingga **tidak perlu memuat *font* *default* `lmodern`**. Blok kode di dalam `$if(fontfamily)$` kosong.
        *   **Jika `fontfamily` tidak didefinisikan (`\else` branch)**:
            *   `\usepackage{lmodern}`: Memuat *package* `lmodern`. *Package* `lmodern` menyediakan versi vektor (*scalable*) dari *Computer Modern fonts*, *font* *default* LaTeX. *Latin Modern fonts* adalah pengganti modern dan lengkap untuk *Computer Modern* dan direkomendasikan sebagai *default* yang baik untuk dokumen LaTeX.
            *   `-- Set default font before Beamer theme so the theme can override it`: Komentar menjelaskan bahwa *font default* diatur **sebelum *Beamer theme*** dimuat (meskipun *Beamer theme* tidak dimuat dalam file `fonts.latex` ini, tetapi mungkin di file template lain yang disertakan nanti). Ini adalah praktik yang baik karena *themes* dapat *override* pengaturan *font*, dan pengaturan *default* harus dilakukan terlebih dahulu.
*   **Opsi Variabel `fontfamily`**: *String*. Nama *package* *font family* LaTeX. Jika didefinisikan, *custom font family* akan digunakan, dan *default font* `lmodern` tidak akan dimuat. Jika tidak didefinisikan, `lmodern` akan digunakan sebagai *font* *default*.

---

**Variabel Pandoc yang Dapat Digunakan (YAML) untuk `fonts.latex`:**

Berikut adalah daftar variabel Pandoc yang relevan dari file `fonts.latex` dan opsi yang mungkin (sudah termasuk yang dijelaskan di atas dan diringkas):

*   **`fontenc`**: *String*. Opsi *font encoding* untuk *package* `fontenc` (PDFTeX only). (e.g., `"T1"`, `"OT1"`)
*   **`mathspec`**: *Boolean*. Mengaktifkan penggunaan *package* `mathspec` untuk *math font* di XeTeX (if *true*). If *false* or unset, `unicode-math` is used.
*   **`fontfamily`**: *String*. Nama *package* *font family* LaTeX. (e.g., `"mathptmx"`, `"helvet"`, `"courier"`). If set, the default `lmodern` font is not loaded for PDFTeX.

---