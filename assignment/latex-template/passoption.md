# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `passoptions.latex`

File `passoptions.latex` digunakan untuk **meneruskan opsi global ke *package*-*package* LaTeX tertentu** yang dimuat di tempat lain dalam template (seperti di `eisvogel.latex` atau `fonts.latex`). File ini menggunakan perintah `\PassOptionsToPackage` untuk menetapkan opsi *default* untuk *package* `hyperref`, `url`, `xcolor`, dan `xeCJK`. Ini memungkinkan konfigurasi terpusat dari opsi *package*, memastikan konsistensi dan menghindari pengulangan. Misalnya, ia mengatur opsi untuk menangani *unicode* dalam *hyperref*, *hyphenation* dalam `url`, set warna untuk `xcolor`, dan spasi untuk `xeCJK`. File ini berfungsi sebagai mekanisme konfigurasi *pre-loading*, memungkinkan opsi *package* *default* ditetapkan sebelum *package* itu sendiri dimuat.

Berikut adalah isi file `passoptions.latex` dan penjelasannya per bagian:

```latex
% Options for packages loaded elsewhere
\PassOptionsToPackage{unicode$for(hyperrefoptions)$,$hyperrefoptions$$endfor$}{hyperref}
\PassOptionsToPackage{hyphens}{url}
\PassOptionsToPackage{dvipsnames,svgnames,x11names,table}{xcolor}
$if(CJKmainfont)$
\PassOptionsToPackage{space}{xeCJK}
$endif$
```

#### Penjelasan per Bagian dari `passoptions.latex`:

##### 1. `hyperref` Package Options (Opsi *Package* `hyperref`)

```latex
\PassOptionsToPackage{unicode$for(hyperrefoptions)$,$hyperrefoptions$$endfor$}{hyperref}
```

*   **Tujuan**: Meneruskan opsi ke *package* `hyperref`. Perintah ini memastikan bahwa *package* `hyperref`, ketika dimuat nanti, akan menggunakan opsi-opsi ini sebagai *default*.
*   **Perintah LaTeX**: `\PassOptionsToPackage`
    *   `\PassOptionsToPackage{options}{package-name}`: Perintah `\PassOptionsToPackage` digunakan untuk menetapkan opsi *default* untuk *package*. Argumen pertama adalah daftar opsi (dipisahkan koma), dan argumen kedua adalah nama *package*.
    *   `{unicode$for(hyperrefoptions)$,$hyperrefoptions$$endfor$}`: Daftar opsi yang diteruskan ke `hyperref`.
        *   `unicode`: Opsi `unicode` adalah opsi standar untuk *package* `hyperref`. Mengaktifkan dukungan Unicode di `hyperref`, memungkinkan *hyperref* untuk menangani karakter Unicode dengan benar dalam *metadata* PDF dan *bookmarks*.
        *   `$for(hyperrefoptions)$,$hyperrefoptions$$endfor$`: Loop Pandoc `$for(hyperrefoptions)...$ $endfor$` menghasilkan daftar opsi tambahan yang dipisahkan koma yang diambil dari variabel daftar `$hyperrefoptions`. Ini memungkinkan pengguna untuk meneruskan opsi *custom* tambahan ke *package* `hyperref` melalui variabel YAML.
    *   `{hyperref}`: Nama *package* yang menjadi target opsi, yaitu `hyperref`.

*   **Opsi Variabel `hyperrefoptions`**: *List* *String*. Daftar opsi tambahan untuk *package* `hyperref`. Memungkinkan pengguna untuk menyesuaikan perilaku `hyperref` lebih lanjut. (e.g., `["colorlinks=true", "linkcolor=red"]`).

##### 2. `url` Package Options (Opsi *Package* `url`)

```latex
\PassOptionsToPackage{hyphens}{url}
```

*   **Tujuan**: Meneruskan opsi `hyphens` ke *package* `url`.
*   **Perintah LaTeX**: `\PassOptionsToPackage`
    *   `\PassOptionsToPackage{hyphens}{url}`: Meneruskan opsi `{hyphens}` ke *package* `{url}`.
        *   `{hyphens}`: Opsi `hyphens` untuk *package* `url`. Opsi `hyphens` memungkinkan *package* `url` untuk memisahkan URL secara otomatis di titik *hyphen* jika URL terlalu panjang untuk muat dalam satu baris. Ini sangat penting untuk mencegah URL melampaui margin halaman dan meningkatkan keterbacaan dokumen.
        *   `{url}`: Nama *package* yang menjadi target opsi, yaitu `url`. *Package* `url` digunakan untuk menangani URL dan *hyperlink* dalam dokumen LaTeX, terutama dalam konteks bibliografi atau ketika URL panjang dimasukkan dalam teks.

*   **Tidak ada Variabel Pandoc khusus untuk opsi `url` ini secara langsung dalam kode ini**. Opsi `hyphens` secara *hardcode* diteruskan ke *package* `url`. Namun, perilaku *hyphenation* URL mungkin secara tidak langsung dipengaruhi oleh *locale* bahasa dokumen (diatur melalui variabel `lang` Pandoc, yang dapat mempengaruhi *hyphenation* LaTeX secara umum).

##### 3. `xcolor` Package Options (Opsi *Package* `xcolor`)

```latex
\PassOptionsToPackage{dvipsnames,svgnames,x11names,table}{xcolor}
```

*   **Tujuan**: Meneruskan beberapa opsi terkait set warna bernama ke *package* `xcolor`.
*   **Perintah LaTeX**: `\PassOptionsToPackage`
    *   `\PassOptionsToPackage{dvipsnames,svgnames,x11names,table}{xcolor}`: Meneruskan opsi `{dvipsnames,svgnames,x11names,table}` ke *package* `{xcolor}`.
        *   `{dvipsnames,svgnames,x11names,table}`: Daftar opsi yang diteruskan ke `xcolor`. Opsi-opsi ini adalah *color list options* untuk *package* `xcolor`:
            *   `dvipsnames`: Memuat *set* warna bernama *dvipsnames*. *Set* ini menyediakan daftar warna bernama yang sesuai dengan nama warna *dvips* (format *device-independent* *PostScript*).
            *   `svgnames`: Memuat *set* warna bernama *svgnames*. *Set* ini menyediakan daftar warna bernama yang sesuai dengan nama warna SVG (Scalable Vector Graphics).
            *   `x11names`: Memuat *set* warna bernama *x11names*. *Set* ini menyediakan daftar warna bernama yang sesuai dengan nama warna X11 (sistem jendela X). Ini adalah daftar warna yang sangat luas.
            *   `table`: Opsi `table` untuk *package* `xcolor` (berbeda dengan *color list*). Opsi `table` meningkatkan dukungan *package* `xcolor` untuk warna dalam tabel, terutama untuk warna *cell* dan *row*.
        *   `{xcolor}`: Nama *package* yang menjadi target opsi, yaitu `xcolor`. *Package* `xcolor` adalah *package* LaTeX yang kuat dan fleksibel untuk penanganan warna, menyediakan cara yang diperluas untuk mendefinisikan dan menggunakan warna dalam dokumen LaTeX.

*   **Tidak ada Variabel Pandoc khusus untuk opsi `xcolor` ini secara langsung dalam kode ini**. Set warna yang ditentukan (`dvipsnames`, `svgnames`, `x11names`) dan opsi `table` secara *hardcode* diteruskan ke *package* `xcolor`. Pengguna dapat menggunakan warna-warna bernama ini di seluruh template (misalnya, dalam variabel YAML seperti `titlepage-color`, `heading-color`, atau secara langsung dalam konten dokumen jika didukung).

##### 4. `xeCJK` Package Options (Opsi *Package* `xeCJK`)

```latex
$if(CJKmainfont)$
\PassOptionsToPackage{space}{xeCJK}
$endif$
```

*   **Tujuan**: Secara kondisional meneruskan opsi `space` ke *package* `xeCJK`, tetapi **hanya jika variabel `CJKmainfont` didefinisikan**.
*   **Perintah LaTeX**: `\PassOptionsToPackage`, `$if`
    *   **Conditional Option Passing**: `$if(CJKmainfont)$ ... $endif$`. Jika variabel `CJKmainfont` didefinisikan, blok kode di dalamnya akan diproses. Ini berarti opsi untuk `xeCJK` hanya akan diteruskan jika *main CJK font* (Chinese, Japanese, Korean) ditentukan, yang mengindikasikan bahwa dukungan CJK sedang digunakan.
    *   `\PassOptionsToPackage{space}{xeCJK}`: Meneruskan opsi `{space}` ke *package* `{xeCJK}`.
        *   `{space}`: Opsi `space` untuk *package* `xeCJK`. Opsi `space` untuk *package* `xeCJK` mengontrol bagaimana spasi (karakter spasi) ditangani di sekitar karakter CJK. Secara khusus, opsi `space` biasanya memastikan bahwa spasi disisipkan dengan benar antara karakter CJK dan karakter non-CJK. Ini penting untuk tipografi CJK karena spasi mungkin tidak selalu diperlukan atau ditangani dengan cara yang sama seperti dalam bahasa Latin.
        *   `{xeCJK}`: Nama *package* yang menjadi target opsi, yaitu `xeCJK`. *Package* `xeCJK` adalah *package* LaTeX yang digunakan untuk dukungan bahasa Cina, Jepang, dan Korea di XeLaTeX.

*   **Kondisional Variabel `CJKmainfont`**: *String*. Nama *main CJK font*. Kehadiran variabel `CJKmainfont` mengaktifkan penerusan opsi `space` ke *package* `xeCJK`. Ini berarti dukungan spasi CJK diaktifkan secara *default* jika *CJK main font* ditentukan.

---

**Variabel Pandoc yang Dapat Digunakan (YAML) untuk `passoptions.latex`:**

Berikut adalah daftar variabel Pandoc yang relevan dari file `passoptions.latex` dan opsi yang mungkin (sudah termasuk yang dijelaskan di atas dan diringkas):

*   **`hyperrefoptions`**: *List* *String*. Daftar opsi tambahan untuk *package* `hyperref`. (e.g., `["colorlinks=true", "bookmarks=false"]`)
*   **`CJKmainfont`**: *String*. Nama *main CJK font* sistem. Jika variabel ini didefinisikan, opsi `space` akan diteruskan ke *package* `xeCJK`.

**Catatan Penting:**

*   File `passoptions.latex` tidak secara langsung menggunakan variabel Pandoc untuk mengontrol opsi `url` dan `xcolor`. Opsi-opsi untuk *package*-*package* ini secara *hardcode* ditetapkan dalam file. Namun, *set* warna yang diaktifkan oleh opsi `xcolor` dan perilaku *hyphenation* URL yang dikonfigurasi untuk *package* `url` dapat dimanfaatkan dan dipengaruhi secara tidak langsung melalui konfigurasi template dan konten dokumen.

---