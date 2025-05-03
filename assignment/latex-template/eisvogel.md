# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `eisvogel.latex` (File Template Utama)

File `eisvogel.latex` adalah file template LaTeX utama yang digunakan oleh Pandoc untuk menghasilkan dokumen PDF bergaya "Eisvogel". File ini berfungsi sebagai orkestrasi pusat, yang memanggil file-file template lainnya (`common.latex`, `eisvogel-added.latex`, `eisvogel-title-page.latex`, dll.) dan menyusun struktur dokumen secara keseluruhan. File ini mengatur *documentclass*, memuat *package*-*package* yang diperlukan, menetapkan metadata dokumen (judul, penulis, tanggal), mengontrol bagian-bagian utama dokumen seperti halaman judul, *table of contents*, *list of figures*, *list of tables*, abstrak, *frontmatter*, *mainmatter*, *backmatter*, bibliografi, dan *header*/*footer*. File ini adalah titik konfigurasi utama untuk template Eisvogel, tempat berbagai variabel Pandoc berinteraksi untuk menyesuaikan output PDF.

Berikut adalah isi file `eisvogel.latex` dan penjelasannya per bagian:

```latex
%%
% Copyright (c) 2017 - 2025, Pascal Wagler;
% Copyright (c) 2014 - 2025, John MacFarlane
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
%
% - Redistributions of source code must retain the above copyright
% notice, this list of conditions and the following disclaimer.
%
% - Redistributions in binary form must reproduce the above copyright
% notice, this list of conditions and the following disclaimer in the
% documentation and/or other materials provided with the distribution.
%
% - Neither the name of John MacFarlane nor the names of other
% contributors may be used to endorse or promote products derived
% from this software without specific prior written permission.
%
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
% "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
% LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
% FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
% COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
% INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING,
% BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
% LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
% CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
% LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN
% ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.
%%

%%
% This is the Eisvogel pandoc LaTeX template.
%
% For usage information and examples visit the official GitHub page:
% [https://github.com/Wandmalfarbe/pandoc-latex-template](https://github.com/Wandmalfarbe/pandoc-latex-template)
%%
$passoptions.latex()$
\documentclass[
$if(fontsize)$
  $fontsize$,
$endif$
$if(papersize)$
  $papersize$paper,
$else$
  paper=a4,
$endif$
$for(classoption)$
  $classoption$$sep$,
$endfor$
  ,captions=tableheading
]{$if(book)$scrbook$else$scrartcl$endif$}
$if(beamerarticle)$
\usepackage{beamerarticle} % needs to be loaded first
$endif$
\usepackage{xcolor}
$if(footnotes-pretty)$
% load footmisc in order to customize footnotes (footmisc has to be loaded before hyperref, cf. [https://tex.stackexchange.com/a/169124/144087](https://tex.stackexchange.com/a/169124/144087))
\usepackage[hang,flushmargin,bottom,multiple]{footmisc}
\setlength{\footnotemargin}{0.8em} % set space between footnote nr and text
\setlength{\footnotesep}{\baselineskip} % set space between multiple footnotes
\setlength{\skip\footins}{0.3cm} % set space between page content and footnote
\setlength{\footskip}{0.9cm} % set space between footnote and page bottom
$endif$
$if(geometry)$
\usepackage[$for(geometry)$$geometry$$sep$,$endfor$]{geometry}
$else$
\usepackage[margin=2.5cm,includehead=true,includefoot=true,centering,$for(geometry)$$geometry$$sep$,$endfor$]{geometry}
$endif$
\usepackage{amsmath,amssymb}

$if(titlepage-logo)$
\usepackage[export]{adjustbox}
\usepackage{graphicx}
$endif$

% add backlinks to footnote references, cf. [https://tex.stackexchange.com/questions/302266/make-footnote-clickable-both-ways](https://tex.stackexchange.com/questions/302266/make-footnote-clickable-both-ways)
$if(footnotes-disable-backlinks)$
$else$
\usepackage{footnotebackref}
$endif$
$--
$-- section numbering
$--
$if(numbersections)$
\setcounter{secnumdepth}{$if(secnumdepth)$$secnumdepth$$else$5$endif$}
$else$
\setcounter{secnumdepth}{-\maxdimen} % remove section numbering
$endif$
$fonts.latex()$
$font-settings.latex()$
$common.latex()$
$for(header-includes)$
$header-includes$
$endfor$
$after-header-includes.latex()$
$hypersetup.latex()$

$if(title)$
\title{$title$$if(thanks)$\thanks{$thanks$}$endif$}
$endif$
$if(subtitle)$
\usepackage{etoolbox}
\makeatletter
\providecommand{\subtitle}[1]{% add subtitle to \maketitle
  \apptocmd{\@title}{\par {\large #1 \par}}{}{}
}
\makeatother
\subtitle{$subtitle$}
$endif$
\author{$for(author)$$author$$sep$ \and $endfor$}
\date{$date$}

$eisvogel-added.latex()$

\begin{document}

$eisvogel-title-page.latex()$

$if(has-frontmatter)$
\frontmatter
$endif$
$if(title)$
% don't generate the default title
% \maketitle
$if(abstract)$
\begin{abstract}
$abstract$
\end{abstract}
$endif$
$endif$

$if(first-chapter)$
\setcounter{chapter}{$first-chapter$}
\addtocounter{chapter}{-1}
$endif$

$for(include-before)$
$include-before$

$endfor$
$if(toc)$
$if(toc-title)$
\renewcommand*\contentsname{$toc-title$}
$endif$
{
$if(colorlinks)$
\hypersetup{linkcolor=$if(toccolor)$$toccolor$$else$$endif$}
$endif$
\setcounter{tocdepth}{$toc-depth$}
\tableofcontents
$if(toc-own-page)$
\newpage
$endif$
}
$endif$
$if(lof)$
$if(lof-title)$
\renewcommand*\listfigurename{$lof-title$}
$endif$
\listoffigures
$endif$
$if(lot)$
$if(lot-title)$
\renewcommand*\listtablename{$lot-title$}
$endif$
\listoftables
$endif$
$if(linestretch)$
\setstretch{$linestretch$}
$endif$
$if(has-frontmatter)$
\mainmatter
$endif$
$body$

$if(has-frontmatter)$
\backmatter
$endif$
$if(nocite-ids)$
\nocite{$for(nocite-ids)$$it$$sep$, $endfor$}
$endif$
$if(natbib)$
$if(bibliography)$
$if(biblio-title)$
$if(has-chapters)$
\renewcommand\bibname{$biblio-title$}
$else$
\renewcommand\refname{$biblio-title$}
$endif$
$endif$
\bibliography{$for(bibliography)$$bibliography$$sep$,$endfor$}

$endif$
$endif$
$if(biblatex)$
\printbibliography$if(biblio-title)$[title=$biblio-title$]$endif$

$endif$
$for(include-after)$
$include-after$

$endfor$
\end{document}
```

#### Penjelasan per Bagian dari `eisvogel.latex`:

##### 1. Copyright and Template Description Comments (Komentar Hak Cipta dan Deskripsi Template)

```latex
%%
% Copyright (c) 2017 - 2025, Pascal Wagler;
% Copyright (c) 2014 - 2025, John MacFarlane
%
% All rights reserved.
%
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions
% are met:
% ... (Lisensi BSD 2-Clause) ...
%%

%%
% This is the Eisvogel pandoc LaTeX template.
%
% For usage information and examples visit the official GitHub page:
% [https://github.com/Wandmalfarbe/pandoc-latex-template](https://github.com/Wandmalfarbe/pandoc-latex-template)
%%
```

*   **Tujuan**: Menyediakan informasi hak cipta dan lisensi untuk template, serta deskripsi singkat dan tautan ke halaman GitHub template.
*   **Elemen**: Komentar LaTeX (`%%` dan `%`)
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang terlibat dalam bagian ini.
*   **Penjelasan**: Ini adalah komentar standar LaTeX yang berisi informasi lisensi (Lisensi BSD 2-Clause) dan tautan ke repositori GitHub resmi template Eisvogel. Bagian ini murni informatif dan tidak mempengaruhi fungsionalitas template secara langsung.

##### 2. `\documentclass` Definition and Class Options (Definisi `\documentclass` dan Opsi Kelas)

```latex
$passoptions.latex()$
\documentclass[
$if(fontsize)$
  $fontsize$,
$endif$
$if(papersize)$
  $papersize$paper,
$else$
  paper=a4,
$endif$
$for(classoption)$
  $classoption$$sep$,
$endfor$
  ,captions=tableheading
]{$if(book)$scrbook$else$scrartcl$endif$}
```

*   **Tujuan**: Mendefinisikan kelas dokumen LaTeX yang digunakan dan berbagai opsi kelas dokumen.
*   **Perintah LaTeX**: `\documentclass`
*   **Variabel Pandoc**: `fontsize`, `papersize`, `classoption`, `book`
    *   `$passoptions.latex()`: Ini adalah *placeholder* Pandoc yang mungkin berfungsi untuk meneruskan opsi *command line* Pandoc yang relevan ke LaTeX. Fungsi dan detail implementasinya mungkin bergantung pada versi Pandoc atau *filters* yang digunakan. *Namun, dalam konteks template ini, sepertinya ini tidak secara aktif digunakan atau tidak memiliki efek yang jelas pada output.*
    *   `\documentclass[...] {$if(book)scrbook$else$scrartcl$endif$}`: Mendefinisikan kelas dokumen menggunakan `\documentclass`. Kelas dokumen dipilih secara kondisional:
        *   **Jika `book` didefinisikan**: Menggunakan kelas `scrbook` (dari *KOMA-Script bundle*), yang cocok untuk dokumen seperti buku dengan *chapter*.
        *   **Jika `book` tidak didefinisikan**: Menggunakan kelas `scrartcl` (dari *KOMA-Script bundle*), yang merupakan kelas artikel yang lebih fleksibel dan cocok untuk dokumen yang lebih pendek seperti artikel, laporan, atau dokumen teknis.
    *   **Opsi Kelas Dokumen (di dalam kurung siku `[...]`)**:
        *   **`fontsize` (Kondisional)**: `$if(fontsize)$ $fontsize$, $endif$`. Jika variabel `fontsize` didefinisikan, nilai variabel ini (misalnya, `"10pt"`, `"11pt"`, `"12pt"`) digunakan sebagai opsi `fontsize` untuk kelas dokumen.
        *   **`papersize` (Kondisional)**: `$if(papersize)$ $papersize$paper, $else$ paper=a4, $endif$`. Jika variabel `papersize` didefinisikan, nilai variabel (misalnya, `"a4"`, `"letter"`, `"a5"`) digunakan diikuti dengan `paper` (misalnya, `"letterpaper"`). Jika `papersize` tidak didefinisikan, *default* ukuran kertas adalah `a4`.
        *   **`classoption` (Loop)**: `$for(classoption)$ $classoption$$sep$, $endfor$`. Menggunakan loop Pandoc untuk menambahkan opsi kelas dokumen tambahan yang diberikan dalam variabel daftar `$classoption`. `$sep$,` kemungkinan untuk menambahkan koma sebagai pemisah antar opsi.
        *   **`captions=tableheading`**: Opsi `captions=tableheading` diterapkan selalu. Opsi ini (dari kelas KOMA-Script) mengatur gaya *caption* tabel agar ditempatkan sebagai *heading* di atas tabel.
*   **Opsi Variabel `fontsize`**: *String* (ukuran *font* LaTeX, misalnya, `"10pt"`, `"11pt"`, `"12pt"`). Menentukan ukuran *font* *default* dokumen.
*   **Opsi Variabel `papersize`**: *String* (ukuran kertas, misalnya, `"a4"`, `"letter"`, `"a5"`). Menentukan ukuran kertas dokumen.
*   **Opsi Variabel `classoption`**: *List* *String*. Daftar opsi kelas dokumen LaTeX tambahan. Memungkinkan pengguna untuk meneruskan opsi kelas dokumen *custom*.
*   **Opsi Variabel `book`**: *Boolean*. Menentukan apakah dokumen adalah *book*. Memilih kelas dokumen antara `scrbook` (jika *true*) dan `scrartcl` (jika *false* atau tidak didefinisikan).

##### 3. Package Loading Section (Bagian Pemuatan *Package*)

```latex
$if(beamerarticle)$
\usepackage{beamerarticle} % needs to be loaded first
$endif$
\usepackage{xcolor}
$if(footnotes-pretty)$
% load footmisc in order to customize footnotes (footmisc has to be loaded before hyperref, cf. [https://tex.stackexchange.com/a/169124/144087](https://tex.stackexchange.com/a/169124/144087))
\usepackage[hang,flushmargin,bottom,multiple]{footmisc}
\setlength{\footnotemargin}{0.8em} % set space between footnote nr and text
\setlength{\footnotesep}{\baselineskip} % set space between multiple footnotes
\setlength{\skip\footins}{0.3cm} % set space between page content and footnote
\setlength{\footskip}{0.9cm} % set space between footnote and page bottom
$endif$
$if(geometry)$
\usepackage[$for(geometry)$$geometry$$sep$,$endfor$]{geometry}
$else$
\usepackage[margin=2.5cm,includehead=true,includefoot=true,centering,$for(geometry)$$geometry$$sep$,$endfor$]{geometry}
$endif$
\usepackage{amsmath,amssymb}

$if(titlepage-logo)$
\usepackage[export]{adjustbox}
\usepackage{graphicx}
$endif$

% add backlinks to footnote references, cf. [https://tex.stackexchange.com/questions/302266/make-footnote-clickable-both-ways](https://tex.stackexchange.com/questions/302266/make-footnote-clickable-both-ways)
$if(footnotes-disable-backlinks)$
$else$
\usepackage{footnotebackref}
$endif$
```

*   **Tujuan**: Memuat berbagai *package* LaTeX yang diperlukan untuk template, beberapa di antaranya dimuat secara kondisional berdasarkan variabel Pandoc.
*   **Perintah LaTeX**: `\usepackage`
*   **Packages Loaded and Conditional Loading**:
    *   **`beamerarticle` (Kondisional)**: `$if(beamerarticle)$ \usepackage{beamerarticle} $endif$`. Jika variabel `beamerarticle` didefinisikan, memuat *package* `beamerarticle`. Komentar menunjukkan bahwa *package* ini perlu dimuat pertama. *Package* `beamerarticle` memungkinkan penggunaan kelas *Beamer* (untuk presentasi) untuk menghasilkan artikel, mungkin digunakan untuk membuat *handout* dari presentasi.
    *   **`xcolor`**: `\usepackage{xcolor}`. Memuat *package* `xcolor`, yang menyediakan dukungan warna yang kaya di LaTeX.
    *   **`footmisc` (Kondisional `footnotes-pretty`)**: `$if(footnotes-pretty)$ ... $endif$`. Jika variabel `footnotes-pretty` didefinisikan, memuat *package* `footmisc` dengan opsi `[hang,flushmargin,bottom,multiple]` dan mengatur beberapa panjang terkait *footnote* (`\footnotemargin`, `\footnotesep`, `\skip\footins`, `\footskip`). *Package* `footmisc` digunakan untuk menyesuaikan tampilan *footnote*, dan opsi yang digunakan kemungkinan untuk menghasilkan tampilan *footnote* yang lebih "cantik" atau estetis. Komentar penting menunjukkan bahwa `footmisc` harus dimuat *sebelum* `hyperref` (meskipun `hyperref` tidak langsung dimuat di bagian kode ini, mungkin dimuat di `hypersetup.latex()` atau di tempat lain).
    *   **`geometry` (Kondisional `geometry`)**: `$if(geometry)$ ... $else$ ... $endif$`. Penanganan *package* `geometry` sudah dijelaskan di bagian "Title Page Background Color" pada `eisvogel-added.latex` dan sedikit redundan di sini. *Namun, melihat kode di sini, tampaknya logika untuk memuat `geometry` dan menerapkan margin default memang ada di `eisvogel.latex`, dan bagian di `eisvogel-added.latex` terkait halaman judul mungkin hanya merupakan fallback jika `geometry` belum diatur sebelumnya.*
        *   **Jika `geometry` didefinisikan**: `\usepackage[$for(geometry)$$geometry$$sep$,$endfor$]{geometry}`. Memuat *package* `geometry` dengan opsi yang diberikan dalam variabel daftar `$geometry`.
        *   **Jika `geometry` tidak didefinisikan**: `\usepackage[margin=2.5cm,includehead=true,includefoot=true,centering,$for(geometry)$$geometry$$sep$,$endfor$]{geometry}`. Memuat *package* `geometry` dengan *default* margin (2.5cm, include *header*/*footer*, centering) dan opsi tambahan dari variabel `$geometry`.
    *   **`amsmath,amssymb`**: `\usepackage{amsmath,amssymb}`. Memuat *package* `amsmath` dan `amssymb`, yang menyediakan fitur matematika dan simbol matematika tambahan di LaTeX.
    *   **`adjustbox, graphicx` (Kondisional `titlepage-logo`)**: `$if(titlepage-logo)$ \usepackage[export]{adjustbox} \usepackage{graphicx} $endif$`. Jika variabel `titlepage-logo` didefinisikan, memuat *package* `adjustbox` (dengan opsi `[export]`) dan *package* `graphicx`. *Package* `graphicx` adalah *package* utama untuk memasukkan gambar di LaTeX, dan `adjustbox` menyediakan fitur tambahan untuk menyesuaikan kotak pembatas (*bounding box*) gambar, mungkin berguna untuk memposisikan logo dengan tepat.
    *   **`footnotebackref` (Kondisional `footnotes-disable-backlinks`)**: `$if(footnotes-disable-backlinks)$ $else$ \usepackage{footnotebackref} $endif$`. Jika variabel `footnotes-disable-backlinks` *tidak* didefinisikan (atau *false*), memuat *package* `footnotebackref`. *Package* `footnotebackref` menambahkan *backlinks* (tautan balik) dari referensi *footnote* di teks ke teks *footnote* di bawah, dan sebaliknya, membuat navigasi *footnote* lebih mudah dalam dokumen PDF. Komentar dalam kode merujuk ke pertanyaan StackExchange yang menjelaskan tujuan *package* ini.
*   **Opsi Variabel `beamerarticle`**: *Boolean*. Mengaktifkan dukungan untuk menghasilkan artikel dari *Beamer* presentasi (memuat *package* `beamerarticle`).
*   **Opsi Variabel `footnotes-pretty`**: *Boolean*. Mengaktifkan gaya *footnote* yang "cantik" atau estetis (memuat *package* `footmisc` dan mengatur *footnote* lengths).
*   **Opsi Variabel `geometry`**: *List* *String*. Daftar opsi *geometry* halaman. Memungkinkan pengguna untuk *override* atau menambahkan opsi *geometry default*.
*   **Opsi Variabel `titlepage-logo`**: *String* (path file gambar). Mengaktifkan penggunaan logo halaman judul (memuat *package* `adjustbox` dan `graphicx`).
*   **Opsi Variabel `footnotes-disable-backlinks`**: *Boolean*. Menonaktifkan *backlinks* *footnote* (tidak memuat *package* `footnotebackref`).

##### 4. Section Numbering Control (Kontrol Penomoran Bagian)

```latex
$--
$-- section numbering
$--
$if(numbersections)$
\setcounter{secnumdepth}{$if(secnumdepth)$$secnumdepth$$else$5$endif$}
$else$
\setcounter{secnumdepth}{-\maxdimen} % remove section numbering
$endif$
```

*   **Tujuan**: Mengontrol penomoran bagian (section, subsection, dll.) dalam dokumen.
*   **Perintah LaTeX**: `\setcounter{secnumdepth}{...}`
*   **Variabel Pandoc**: `numbersections`, `secnumdepth`
    *   **Kondisi `numbersections`**: `$if(numbersections)$ ... $else$ ... $endif$`. Jika variabel `numbersections` didefinisikan (biasanya *true* untuk mengaktifkan penomoran bagian).
        *   **Jika `numbersections` didefinisikan**: `\setcounter{secnumdepth}{$if(secnumdepth)$$secnumdepth$$else$5$endif$}`. Mengatur *counter* `secnumdepth`. *Counter* `secnumdepth` menentukan level *heading* terendah yang akan diberi nomor.
            *   `$if(secnumdepth)$$secnumdepth$$else$5$endif$`: Jika variabel `secnumdepth` didefinisikan, nilainya digunakan. Jika tidak, *default* adalah 5. Dalam kelas *KOMA-Script* (seperti `scrartcl` dan `scrbook`), level 5 sesuai dengan `\paragraph`. Jadi, secara *default*, bagian hingga level `\paragraph` akan diberi nomor.
        *   **Jika `numbersections` tidak didefinisikan**: `\setcounter{secnumdepth}{-\maxdimen} % remove section numbering`. Mengatur `secnumdepth` ke `-\maxdimen`. Nilai negatif yang sangat besar ini secara efektif menonaktifkan penomoran bagian untuk semua level *heading*.
*   **Opsi Variabel `numbersections`**: *Boolean*. Mengaktifkan atau menonaktifkan penomoran bagian.
*   **Opsi Variabel `secnumdepth`**: *Number* (integer). Menentukan kedalaman penomoran bagian (level *heading* terendah yang diberi nomor). Jika tidak didefinisikan, *default* adalah 5 (paragraph level untuk kelas KOMA-Script).

##### 5. Template File Inclusions (Penyertaan File Template)

```latex
$fonts.latex()$
$font-settings.latex()$
$common.latex()$
$for(header-includes)$
$header-includes$
$endfor$
$after-header-includes.latex()$
$hypersetup.latex()$
$eisvogel-added.latex()$
$eisvogel-title-page.latex()$
```

*   **Tujuan**: Menyertakan isi dari file-file template LaTeX lainnya yang berisi konfigurasi dan gaya template Eisvogel.
*   **Perintah Pandoc Template**: `$fonts.latex()`, `$font-settings.latex()`, `$common.latex()`, `$after-header-includes.latex()`, `$hypersetup.latex()`, `$eisvogel-added.latex()`, `$eisvogel-title-page.latex()`, dan loop `$for(header-includes)$`.
*   **File dan Konten yang Disertakan**:
    *   `$fonts.latex()`: Menyertakan konten dari file `fonts.latex`. *Kemungkinan besar menangani pengaturan font dasar template (walaupun pengaturan font yang lebih detail ada di `eisvogel-added.latex`).*
    *   `$font-settings.latex()`: Menyertakan konten dari file `font-settings.latex`. *Mungkin berisi pengaturan font yang lebih spesifik atau konfigurasi terkait font lainnya.*
    *   `$common.latex()`: Menyertakan konten dari file `common.latex`. *Berisi konfigurasi LaTeX umum yang berlaku untuk berbagai aspek dokumen, seperti yang telah kita analisis sebelumnya.*
    *   `$for(header-includes)$ $header-includes$ $endfor$`: Loop ini menyertakan konten dari variabel daftar `$header-includes`. Variabel `$header-includes` memungkinkan pengguna untuk menyertakan *header* LaTeX *custom* dari *command line* atau YAML *metadata*.
    *   `$after-header-includes.latex()`: Menyertakan konten dari file `after-header-includes.latex`. *Menyediakan tempat untuk menyertakan perintah LaTeX tambahan setelah *header* utama dan sebelum konten, seperti yang telah kita analisis sebelumnya.*
    *   `$hypersetup.latex()`: Menyertakan konten dari file `hypersetup.latex`. *Kemungkinan besar berisi konfigurasi untuk *package* `hyperref`, yang menangani *hyperlinks* dan *metadata* PDF.*
    *   `$eisvogel-added.latex()`: Menyertakan konten dari file `eisvogel-added.latex`. *Berisi konfigurasi LaTeX tambahan khusus untuk template Eisvogel, seperti gaya *blockquote*, *caption*, *listing*, *header*/*footer*, dll., seperti yang telah kita analisis sebelumnya.*
    *   `$eisvogel-title-page.latex()`: Menyertakan konten dari file `eisvogel-title-page.latex`. *Berisi kode LaTeX untuk menghasilkan halaman judul, seperti yang telah kita analisis sebelumnya.*
*   **Opsi Variabel `header-includes`**: *List* *String*. Daftar *header* LaTeX *custom* yang akan disertakan dalam dokumen.

##### 6. Title, Subtitle, Author, and Date Metadata (Metadata Judul, Subjudul, Penulis, dan Tanggal)

```latex
$if(title)$
\title{$title$$if(thanks)$\thanks{$thanks$}$endif$}
$endif$
$if(subtitle)$
\usepackage{etoolbox}
\makeatletter
\providecommand{\subtitle}[1]{% add subtitle to \maketitle
  \apptocmd{\@title}{\par {\large #1 \par}}{}{}
}
\makeatother
\subtitle{$subtitle$}
$endif$
\author{$for(author)$$author$$sep$ \and $endfor$}
\date{$date$}
```

*   **Tujuan**: Mengatur metadata dokumen: judul, *subtitle*, penulis, dan tanggal.
*   **Perintah LaTeX**: `\title`, `\thanks`, `\subtitle` (didefinisikan *custom*), `\author`, `\date`
*   **Packages**: `etoolbox` (untuk definisi `\subtitle`)
*   **Variabel Pandoc**: `title`, `thanks`, `subtitle`, `author`, `date`
    *   **`title` (Kondisional)**: `$if(title)$ \title{$title$$if(thanks)$\thanks{$thanks$}$endif$} $endif$`. Jika variabel `title` didefinisikan, menggunakan perintah `\title` untuk mengatur judul dokumen.
        *   **`thanks` (Kondisional di dalam `title`)**: `$if(thanks)$\thanks{$thanks$}$endif$`. Jika variabel `thanks` didefinisikan, menambahkan *footnote* ke judul menggunakan perintah `\thanks` dan nilai dari variabel `$thanks`. Biasanya digunakan untuk *acknowledgements* atau informasi afiliasi yang terkait dengan judul.
    *   **`subtitle` (Kondisional)**: `$if(subtitle)$ ... $endif$`. Jika variabel `subtitle` didefinisikan.
        *   **Definisi Perintah `\subtitle`**: Bagian kode di dalam `$if(subtitle)$`... `$endif$` mendefinisikan perintah LaTeX baru bernama `\subtitle` menggunakan *package* `etoolbox` dan perintah LaTeX tingkat rendah `\makeatletter` dan `\makeatother`. Perintah `\subtitle` ini dirancang untuk menambahkan *subtitle* ke judul dokumen (yang sudah diatur oleh `\title`).
        *   `\providecommand{\subtitle}[1]{...}`: Mendefinisikan perintah `\subtitle` yang menerima satu argumen (`[1]`). `\providecommand` memastikan bahwa perintah hanya didefinisikan jika belum ada definisi sebelumnya.
        *   `\apptocmd{\@title}{\par {\large #1 \par}}{}{}`: Menggunakan `\apptocmd` (dari *package* `etoolbox`) untuk menambahkan kode ke akhir perintah internal LaTeX `\@title` (yang digunakan oleh `\maketitle` untuk menampilkan judul). Kode yang ditambahkan adalah `\par {\large #1 \par}`, yang akan membuat paragraf baru (`\par`), mengatur ukuran *font* menjadi `\large`, menampilkan *subtitle* (argumen `#1` dari `\subtitle`), dan membuat paragraf baru lagi (`\par`).
        *   `\subtitle{$subtitle$}`: Setelah definisi perintah `\subtitle`, perintah ini dipanggil dengan nilai dari variabel Pandoc `$subtitle` sebagai argumen, yang akan menambahkan *subtitle* ke judul.
    *   **`author`**: `\author{$for(author)$$author$$sep$ \and $endfor$}`. Menggunakan perintah `\author` untuk mengatur penulis dokumen. Jika ada lebih dari satu penulis (daftar dalam `$author`), loop Pandoc `$for(author)...$ $endfor$` menghasilkan daftar penulis yang dipisahkan dengan " \and ".
    *   **`date`**: `\date{$date$}`. Menggunakan perintah `\date` untuk mengatur tanggal dokumen.
*   **Opsi Variabel `title`**: *String*. Judul dokumen.
*   **Opsi Variabel `thanks`**: *String*. Teks *acknowledgements* atau *footnote* untuk judul dokumen.
*   **Opsi Variabel `subtitle`**: *String*. *Subtitle* dokumen.
*   **Opsi Variabel `author`**: *String* atau *List* *String*. Nama penulis atau daftar nama penulis.
*   **Opsi Variabel `date`**: *String*. Tanggal dokumen.

##### 7. Eisvogel-Added Template Inclusion (Penyertaan Template Eisvogel-Added)

```latex
$eisvogel-added.latex()$
```

*   **Tujuan**: Menyertakan konten dari file template `eisvogel-added.latex`.
*   **Perintah Pandoc Template**: `$eisvogel-added.latex()`
*   **File yang Disertakan**: `eisvogel-added.latex`. *File ini berisi konfigurasi tambahan khusus untuk template Eisvogel, seperti gaya *blockquote*, *caption*, *listing*, *header*/*footer*, dll., seperti yang telah kita analisis sebelumnya.*
*   **Opsi Variabel**: Tidak ada variabel Pandoc yang langsung mengontrol penyertaan file ini. File `eisvogel-added.latex` selalu disertakan.

##### 8. Document Environment and Structure (Lingkungan dan Struktur Dokumen)

```latex
\begin{document}

$eisvogel-title-page.latex()$

$if(has-frontmatter)$
\frontmatter
$endif$
$if(title)$
% don't generate the default title
% \maketitle
$if(abstract)$
\begin{abstract}
$abstract$
\end{abstract}
$endif$
$endif$

$if(first-chapter)$
\setcounter{chapter}{$first-chapter$}
\addtocounter{chapter}{-1}
$endif$

$for(include-before)$
$include-before$

$endfor$
$if(toc)$
$if(toc-title)$
\renewcommand*\contentsname{$toc-title$}
$endif$
{
$if(colorlinks)$
\hypersetup{linkcolor=$if(toccolor)$$toccolor$$else$$endif$}
$endif$
\setcounter{tocdepth}{$toc-depth$}
\tableofcontents
$if(toc-own-page)$
\newpage
$endif$
}
$endif$
$if(lof)$
$if(lof-title)$
\renewcommand*\listfigurename{$lof-title$}
$endif$
\listoffigures
$endif$
$if(lot)$
$if(lot-title)$
\renewcommand*\listtablename{$lot-title$}
$endif$
\listoftables
$endif$
$if(linestretch)$
\setstretch{$linestretch$}
$endif$
$if(has-frontmatter)$
\mainmatter
$endif$
$body$

$if(has-frontmatter)$
\backmatter
$endif$
$if(nocite-ids)$
\nocite{$for(nocite-ids)$$it$$sep$, $endfor$}
$endif$
$if(natbib)$
$if(bibliography)$
$if(biblio-title)$
$if(has-chapters)$
\renewcommand\bibname{$biblio-title$}
$else$
\renewcommand\refname{$biblio-title$}
$endif$
$endif$
\bibliography{$for(bibliography)$$bibliography$$sep$,$endfor$}

$endif$
$endif$
$if(biblatex)$
\printbibliography$if(biblio-title)$[title=$biblio-title$]$endif$

$endif$
$for(include-after)$
$include-after$

$endfor$
\end{document}
```

*   **Tujuan**: Menyusun struktur utama dokumen LaTeX, termasuk lingkungan `document`, halaman judul, bagian *frontmatter*, *mainmatter*, *backmatter*, abstrak, daftar isi, daftar gambar, daftar tabel, bibliografi, dan *include-before*/*include-after* content.
*   **LaTeX Environments**: `document`, `titlepage`, `abstract`
*   **Perintah LaTeX**: `\frontmatter`, `\maketitle` (dikomentari), `\setcounter{chapter}`, `\addtocounter{chapter}`, `\tableofcontents`, `\listoffigures`, `\listoftables`, `\setstretch`, `\mainmatter`, `\backmatter`, `\nocite`, `\bibliography`, `\printbibliography`, `\renewcommand`
*   **Variabel Pandoc**: `has-frontmatter`, `title`, `abstract`, `first-chapter`, `include-before`, `toc`, `toc-title`, `colorlinks`, `toccolor`, `toc-depth`, `toc-own-page`, `lof`, `lof-title`, `lot`, `lot-title`, `linestretch`, `body`, `nocite-ids`, `natbib`, `bibliography`, `biblio-title`, `has-chapters`, `biblatex`, `include-after`
    *   **`\begin{document} ... \end{document}`**: Lingkungan `document` adalah lingkungan utama yang membungkus seluruh konten dokumen LaTeX.
    *   `$eisvogel-title-page.latex()`: Menyertakan halaman judul. Konten halaman judul didefinisikan dalam file `eisvogel-title-page.latex`, yang telah kita analisis sebelumnya.
    *   **`frontmatter` (Kondisional `has-frontmatter`)**: `$if(has-frontmatter)$ \frontmatter $endif$`. Jika variabel `has-frontmatter` didefinisikan (biasanya *true* untuk dokumen seperti buku atau laporan yang memiliki *frontmatter*), menggunakan perintah `\frontmatter`. Perintah `\frontmatter` biasanya digunakan dalam kelas dokumen *book* dan *report* untuk menandai awal bagian *frontmatter* (seperti kata pengantar, prakata, daftar isi, dll.). Penomoran halaman dalam *frontmatter* biasanya menggunakan angka Romawi kecil.
    *   **Title and Abstract (Kondisional `title` dan `abstract`)**:
        *   `$if(title)$ % don't generate the default title % \maketitle ... $endif$`. Jika variabel `title` didefinisikan.
            *   `% \maketitle`: Baris `\maketitle` dikomentari, menunjukkan bahwa template *tidak* menggunakan perintah `\maketitle` LaTeX *default* untuk membuat halaman judul. Halaman judul dibuat menggunakan file `eisvogel-title-page.latex` yang disertakan sebelumnya.
            *   **Abstract (Kondisional `abstract`)**: `$if(abstract)$ \begin{abstract} $abstract$ \end{abstract} $endif$`. Jika variabel `abstract` didefinisikan, lingkungan `abstract` akan dibuat dan konten abstrak diambil dari variabel `$abstract`. Lingkungan `abstract` biasanya digunakan dalam kelas dokumen artikel untuk menampilkan abstrak atau ringkasan dokumen di awal.
    *   **Chapter Numbering Adjustment (Kondisional `first-chapter`)**: `$if(first-chapter)$ \setcounter{chapter}{$first-chapter$} \addtocounter{chapter}{-1} $endif$`. Jika variabel `first-chapter` didefinisikan.
        *   `\setcounter{chapter}{$first-chapter$}`: Mengatur nilai *counter* `chapter` menjadi nilai dari variabel `$first-chapter`.
        *   `\addtocounter{chapter}{-1}`: Mengurangi nilai *counter* `chapter` sebanyak 1. Kombinasi ini mungkin digunakan untuk menyesuaikan penomoran *chapter*, misalnya, jika *chapter* pertama dokumen tidak dimulai dari nomor 1 tetapi dari nomor lain yang ditentukan oleh `$first-chapter`.
    *   **Include-Before Content (Loop `include-before`)**: `$for(include-before)$ $include-before$ $endfor$`. Loop ini menyertakan konten dari variabel daftar `$include-before`. Variabel `$include-before` memungkinkan pengguna untuk menyertakan konten LaTeX *custom* sebelum bagian utama dokumen (sebelum daftar isi, dll.).
    *   **Table of Contents (Kondisional `toc`)**: `$if(toc)$ ... $endif$`. Jika variabel `toc` didefinisikan (biasanya *true* untuk mengaktifkan daftar isi).
        *   **`toc-title` (Kondisional di dalam `toc`)**: `$if(toc-title)$ \renewcommand*\contentsname{$toc-title$} $endif$`. Jika variabel `toc-title` didefinisikan, mengubah nama *default* untuk daftar isi (biasanya "Contents") menjadi nilai dari variabel `$toc-title`.
        *   `{ ... \tableofcontents ... }`: Blok kurung kurawal `{...}` kemungkinan untuk mengelompokkan pengaturan *hyperref* yang terkait dengan daftar isi.
            *   **`colorlinks` and `toccolor` (Kondisional di dalam `toc` dan blok kurung kurawal)**: `$if(colorlinks)$ \hypersetup{linkcolor=$if(toccolor)$$toccolor$$else$$endif$} $endif$`. Jika variabel `colorlinks` didefinisikan, dan jika variabel `toccolor` juga didefinisikan, mengatur warna tautan untuk daftar isi menggunakan `\hypersetup{linkcolor=$toccolor$}`. Jika `toccolor` tidak didefinisikan, `\hypersetup{linkcolor=}` akan dijalankan, yang mungkin tidak berpengaruh atau menggunakan warna *default* dari `hyperref` (perlu dikonfirmasi perilaku `hyperref` jika *linkcolor* diatur ke kosong).
            *   `\setcounter{tocdepth}{$toc-depth$}`: Mengatur kedalaman daftar isi (level *heading* terendah yang ditampilkan dalam daftar isi) menggunakan *counter* `tocdepth` dan nilai dari variabel `$toc-depth`.
            *   `\tableofcontents`: Menyisipkan daftar isi di dokumen.
            *   **`toc-own-page` (Kondisional di dalam `toc` dan blok kurung kurawal)**: `$if(toc-own-page)$ \newpage $endif$`. Jika variabel `toc-own-page` didefinisikan, memulai halaman baru (`\newpage`) setelah daftar isi selesai.
    *   **List of Figures (Kondisional `lof`)**: `$if(lof)$ ... $endif$`. Jika variabel `lof` didefinisikan (biasanya *true* untuk mengaktifkan daftar gambar).
        *   **`lof-title` (Kondisional di dalam `lof`)**: `$if(lof-title)$ \renewcommand*\listfigurename{$lof-title$} $endif$`. Jika variabel `lof-title` didefinisikan, mengubah nama *default* untuk daftar gambar (biasanya "List of Figures") menjadi nilai dari variabel `$lof-title`.
        *   `\listoffigures`: Menyisipkan daftar gambar di dokumen.
    *   **List of Tables (Kondisional `lot`)**: `$if(lot)$ ... $endif$`. Jika variabel `lot` didefinisikan (biasanya *true* untuk mengaktifkan daftar tabel).
        *   **`lot-title` (Kondisional di dalam `lot`)**: `$if(lot-title)$ \renewcommand*\listtablename{$lot-title$} $endif$`. Jika variabel `lot-title` didefinisikan, mengubah nama *default* untuk daftar tabel (biasanya "List of Tables") menjadi nilai dari variabel `$lot-title`.
        *   `\listoftables`: Menyisipkan daftar tabel di dokumen.
    *   **Line Spacing Adjustment (Kondisional `linestretch`)**: `$if(linestretch)$ \setstretch{$linestretch$} $endif$`. Jika variabel `linestretch` didefinisikan, mengatur *line spacing* (jarak baris) menggunakan perintah `\setstretch` (dari *package* `setspace` atau serupa, diasumsikan dimuat di `common.latex`) dan nilai dari variabel `$linestretch`.
    *   **`mainmatter` (Kondisional `has-frontmatter`)**: `$if(has-frontmatter)$ \mainmatter $endif$`. Jika variabel `has-frontmatter` didefinisikan, menggunakan perintah `\mainmatter`. Perintah `\mainmatter` menandai awal bagian *mainmatter* dokumen (isi utama, *chapter*, bagian, dll.) dalam kelas dokumen *book* dan *report*. Penomoran halaman dalam *mainmatter* biasanya menggunakan angka Arab.
    *   `$body$`: *Placeholder* Pandoc `$body$` akan diganti dengan konten utama dokumen yang dikonversi dari Markdown atau format input lainnya.
    *   **`backmatter` (Kondisional `has-frontmatter`)**: `$if(has-frontmatter)$ \backmatter $endif$`. Jika variabel `has-frontmatter` didefinisikan, menggunakan perintah `\backmatter`. Perintah `\backmatter` menandai awal bagian *backmatter* dokumen (seperti apendiks, glosarium, indeks, dll.) dalam kelas dokumen *book* dan *report*. Penomoran halaman dalam *backmatter* biasanya melanjutkan angka Arab dari *mainmatter*.
    *   **`nocite` (Kondisional `nocite-ids`)**: `$if(nocite-ids)$ \nocite{$for(nocite-ids)$$it$$sep$, $endfor$} $endif$`. Jika variabel `nocite-ids` didefinisikan, menggunakan perintah `\nocite` untuk menyertakan entri bibliografi yang ditentukan oleh ID dalam variabel daftar `$nocite-ids` dalam bibliografi, bahkan jika entri tersebut tidak dikutip dalam teks dokumen.
    *   **Bibliography (Kondisional `natbib` atau `biblatex`)**: Template mendukung dua *package* bibliografi: `natbib` dan `biblatex`.
        *   **`natbib` (Kondisional `natbib` dan `bibliography`)**: `$if(natbib)$ $if(bibliography)$ ... $endif$ $endif$`. Jika variabel `natbib` *dan* `bibliography` didefinisikan (biasanya untuk mengaktifkan bibliografi menggunakan *package* `natbib` dan menentukan file bibliografi).
            *   **`biblio-title` (Kondisional di dalam `natbib` dan `bibliography`)**: `$if(biblio-title)$ $if(has-chapters)$ \renewcommand\bibname{$biblio-title$} $else$ \renewcommand\refname{$biblio-title$} $endif$ $endif$`. Jika variabel `biblio-title` didefinisikan, mengubah judul bibliografi *default*. Jika dokumen memiliki *chapter* (`has-chapters` didefinisikan), mengubah `\bibname` (yang digunakan oleh kelas *book* dan *report*), jika tidak, mengubah `\refname` (yang digunakan oleh kelas artikel).
            *   `\bibliography{$for(bibliography)$$bibliography$$sep$,$endfor$}`: Menyisipkan bibliografi menggunakan perintah `\bibliography` dan menentukan file bibliografi dari variabel daftar `$bibliography`. Loop Pandoc `$for(bibliography)...$ $endfor$` menghasilkan daftar file bibliografi yang dipisahkan koma.
        *   **`biblatex` (Kondisional `biblatex`)**: `$if(biblatex)$ \printbibliography$if(biblio-title)$[title=$biblio-title$]$endif$ $endif$`. Jika variabel `biblatex` didefinisikan (biasanya untuk mengaktifkan bibliografi menggunakan *package* `biblatex`).
            *   `\printbibliography$if(biblio-title)$[title=$biblio-title$]$endif$`: Menyisipkan bibliografi menggunakan perintah `\printbibliography` (dari *package* `biblatex`). Jika variabel `biblio-title` didefinisikan, opsi `[title=$biblio-title$]` akan diteruskan ke `\printbibliography` untuk mengatur judul bibliografi.
    *   **Include-After Content (Loop `include-after`)**: `$for(include-after)$ $include-after$ $endfor$`. Loop ini menyertakan konten dari variabel daftar `$include-after`. Variabel `$include-after` memungkinkan pengguna untuk menyertakan konten LaTeX *custom* setelah bagian utama dokumen (setelah bibliografi).
    *   `\end{document}`: Menutup lingkungan `document`, menandai akhir dokumen LaTeX.

##### 9. `\end{document}` (Akhir Dokumen)

```latex
\end{document}
```

*   **Tujuan**: Menandai akhir dokumen LaTeX.
*   **Perintah LaTeX**: `\end{document}`
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang terlibat dalam bagian ini.
*   **Penjelasan**: Ini adalah perintah LaTeX standar untuk menutup lingkungan `document` dan menandai akhir file dokumen LaTeX. Kode LaTeX setelah `\end{document}` biasanya diabaikan oleh *engine* LaTeX.

---

**Variabel Pandoc yang Dapat Digunakan (YAML) untuk `eisvogel.latex`:**

Berikut adalah daftar variabel Pandoc yang relevan dari file `eisvogel.latex` dan opsi yang mungkin (sudah termasuk yang dijelaskan di atas dan diringkas):

*   **`fontsize`**: *String* (ukuran *font* LaTeX, misalnya, `"10pt"`, `"11pt"`, `"12pt"`). Ukuran *font* *default* dokumen.
*   **`papersize`**: *String* (ukuran kertas, misalnya, `"a4"`, `"letter"`, `"a5"`). Ukuran kertas dokumen.
*   **`classoption`**: *List* *String*. Opsi kelas dokumen LaTeX tambahan.
*   **`book`**: *Boolean*. Menandakan dokumen adalah *book*. Memilih kelas dokumen `scrbook` atau `scrartcl`.
*   **`beamerarticle`**: *Boolean*. Mengaktifkan dukungan *beamerarticle*.
*   **`footnotes-pretty`**: *Boolean*. Mengaktifkan gaya *footnote* yang "cantik".
*   **`geometry`**: *List* *String*. Opsi *geometry* halaman.
*   **`titlepage-logo`**: *String* (path file gambar). Mengaktifkan logo halaman judul (juga di `eisvogel-added.latex` dan `eisvogel-title-page.latex`).
*   **`footnotes-disable-backlinks`**: *Boolean*. Menonaktifkan *backlinks* *footnote*.
*   **`numbersections`**: *Boolean*. Mengaktifkan penomoran bagian.
*   **`secnumdepth`**: *Number*. Kedalaman penomoran bagian.
*   **`header-includes`**: *List* *String*. *Header* LaTeX *custom* yang disertakan.
*   **`title`**: *String*. Judul dokumen (juga di `eisvogel-title-page.latex`).
*   **`thanks`**: *String*. *Footnote* untuk judul.
*   **`subtitle`**: *String*. *Subtitle* dokumen (juga di `eisvogel-title-page.latex`).
*   **`author`**: *String* atau *List* *String*. Penulis dokumen (juga di `eisvogel-title-page.latex`).
*   **`date`**: *String*. Tanggal dokumen (juga di `eisvogel-title-page.latex`).
*   **`has-frontmatter`**: *Boolean*. Mengaktifkan *frontmatter* dan *backmatter*.
*   **`abstract`**: *String*. Abstrak dokumen.
*   **`first-chapter`**: *Number*. Nomor *chapter* pertama (untuk penyesuaian penomoran *chapter*).
*   **`include-before`**: *List* *String*. Konten LaTeX *custom* yang disertakan sebelum bagian utama.
*   **`toc`**: *Boolean*. Mengaktifkan daftar isi.
*   **`toc-title`**: *String*. Judul daftar isi.
*   **`colorlinks`**: *Boolean*. Mengaktifkan warna tautan dalam daftar isi (dan dokumen, jika diatur di `hypersetup.latex`).
*   **`toccolor`**: *String*. Warna tautan daftar isi.
*   **`toc-depth`**: *Number*. Kedalaman daftar isi.
*   **`toc-own-page`**: *Boolean*. Daftar isi di halaman sendiri.
*   **`lof`**: *Boolean*. Mengaktifkan daftar gambar.
*   **`lof-title`**: *String*. Judul daftar gambar.
*   **`lot`**: *Boolean*. Mengaktifkan daftar tabel.
*   **`lot-title`**: *String*. Judul daftar tabel.
*   **`linestretch`**: *Number*. *Line spacing* dokumen.
*   **`body`**: *String* (Placeholder). Konten utama dokumen (dari file Markdown, dll.).
*   **`nocite-ids`**: *List* *String*. Daftar ID bibliografi untuk `\nocite`.
*   **`natbib`**: *Boolean*. Mengaktifkan bibliografi menggunakan *natbib*.
*   **`bibliography`**: *List* *String*. Daftar file bibliografi (untuk *natbib*).
*   **`biblio-title`**: *String*. Judul bibliografi.
*   **`has-chapters`**: *Boolean*. Menandakan dokumen memiliki *chapter* (mempengaruhi judul bibliografi dengan *natbib*).
*   **`biblatex`**: *Boolean*. Mengaktifkan bibliografi menggunakan *biblatex*.
*   **`include-after`**: *List* *String*. Konten LaTeX *custom* yang disertakan setelah bagian utama.

---