# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `common.latex`

File `common.latex` berisi serangkaian konfigurasi LaTeX umum yang diterapkan pada template. File ini mengatur berbagai aspek visual dan fungsional dari dokumen PDF, termasuk *line spacing*, format paragraf, dukungan untuk *verbatim* text, *highlighting* kode, tabel, grafik, dan fitur-fitur lainnya. File ini sangat modular dan menggunakan banyak variabel Pandoc untuk memungkinkan pengguna mengaktifkan atau menonaktifkan fitur-fitur tertentu sesuai kebutuhan.

Berikut adalah isi file `common.latex` dan penjelasannya per bagian:

```latex
$if(linestretch)$
\usepackage{setspace}
$else$
% Use setspace anyway because we change the default line spacing.
% The spacing is changed early to affect the titlepage and the TOC.
\usepackage{setspace}
\setstretch{1.2}
$endif$
$--
$-- paragraph formatting
$--
$if(indent)$
$else$
\makeatletter
\@ifundefined{KOMAClassName}{% if non-KOMA class
  \IfFileExists{parskip.sty}{%
    \usepackage{parskip}
  }{% else
    \setlength{\parindent}{0pt}
    \setlength{\parskip}{6pt plus 2pt minus 1pt}}
}{% if KOMA class
  \KOMAoptions{parskip=half}}
\makeatother
$endif$
$if(beamer)$
$else$
$if(block-headings)$
% Make \paragraph and \subparagraph free-standing
\makeatletter
\ifx\paragraph\undefined\else
  \let\oldparagraph\paragraph
  \renewcommand{\paragraph}{
    \@ifstar
      \xxxParagraphStar
      \xxxParagraphStar
      \xxxParagraphNoStar
      \xxxParagraphNoStar
  }
  \newcommand{\xxxParagraphStar}[1]{\oldparagraph*{#1}\mbox{}}
  \newcommand{\xxxParagraphNoStar}[1]{\oldparagraph{#1}\mbox{}}
\fi
\ifx\subparagraph\undefined\else
  \let\oldsubparagraph\subparagraph
  \renewcommand{\subparagraph}{
    \@ifstar
      \xxxSubParagraphStar
      \xxxSubParagraphStar
      \xxxSubParagraphNoStar
      \xxxSubParagraphNoStar
  }
  \newcommand{\xxxSubParagraphStar}[1]{\oldsubparagraph*{#1}\mbox{}}
  \newcommand{\xxxSubParagraphNoStar}[1]{\oldsubparagraph{#1}\mbox{}}
\fi
\makeatother
$endif$
$endif$
$--
$-- verbatim in notes
$--
$if(verbatim-in-note)$
\usepackage{fancyvrb}
$endif$
$-- highlighting
$if(listings)$
\usepackage{listings}
\newcommand{\passthrough}[1]{#1}
\lstset{defaultdialect=[5.3]Lua}
\lstset{defaultdialect=[x86masm]Assembler}
$endif$
$if(listings-no-page-break)$
\usepackage{etoolbox}
\BeforeBeginEnvironment{lstlisting}{\par\noindent\begin{minipage}{\linewidth}}
\AfterEndEnvironment{lstlisting}{\end{minipage}\par\addvspace{\topskip}}
$endif$
$if(lhs)$
\lstnewenvironment{code}{\lstset{language=Haskell,basicstyle=\small\ttfamily}}{}
$endif$
$if(highlighting-macros)$
$highlighting-macros$

% Workaround/bugfix from jannick0.
% See [https://github.com/jgm/pandoc/issues/4302#issuecomment-360669013](https://github.com/jgm/pandoc/issues/4302#issuecomment-360669013))
% or [https://github.com/Wandmalfarbe/pandoc-latex-template/issues/2](https://github.com/Wandmalfarbe/pandoc-latex-template/issues/2)
%
% Redefine the verbatim environment 'Highlighting' to break long lines (with
% the help of fvextra). Redefinition is necessary because it is unlikely that
% pandoc includes fvextra in the default template.
\usepackage{fvextra}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,fontsize=$if(code-block-font-size)$$code-block-font-size$$else$\small$endif$,commandchars=\\\{\}}

$endif$
$--
$-- tables
$--
$if(tables)$
\usepackage{longtable,booktabs,array}
$if(multirow)$
\usepackage{multirow}
$endif$
\usepackage{calc} % for calculating minipage widths
$if(beamer)$
\usepackage{caption}
% Make caption package work with longtable
\makeatletter
\def\fnum@table{\tablename~\thetable}
\makeatother
$else$
% Correct order of tables after \paragraph or \subparagraph
\usepackage{etoolbox}
\makeatletter
\patchcmd\longtable{\par}{\if@noskipsec\mbox{}\fi\par}{}{}
\makeatother
% Allow footnotes in longtable head/foot
\IfFileExists{footnotehyper.sty}{\usepackage{footnotehyper}}{\usepackage{footnote}}
\makesavenoteenv{longtable}
$endif$
$endif$
$--
$-- graphics
$--
$if(graphics)$
\usepackage{graphicx}
\makeatletter
\newsavebox\pandoc@box
\newcommand*\pandocbounded[1]{% scales image to fit in text height/width
  \sbox\pandoc@box{#1}%
  \Gscale@div\@tempa{\textheight}{\dimexpr\ht\pandoc@box+\dp\pandoc@box\relax}%
  \Gscale@div\@tempb{\linewidth}{\wd\pandoc@box}%
  \ifdim\@tempb\p@<\@tempa\p@\let\@tempa\@tempb\fi% select the smaller of both
  \ifdim\@tempa\p@<\p@\scalebox{\@tempa}{\usebox\pandoc@box}%
  \else\usebox{\pandoc@box}%
  \fi%
}
% Set default figure placement to htbp
% Make use of float-package and set default placement for figures to H.
% The option H means 'PUT IT HERE' (as  opposed to the standard h option which means 'You may put it here if you like').
\usepackage{float}
\floatplacement{figure}{$if(float-placement-figure)$$float-placement-figure$$else$H$endif$}
\makeatother
$endif$
$if(svg)$
\usepackage{svg}
$endif$
$--
$-- strikeout/underline
$--
$if(strikeout)$
\ifLuaTeX
  \usepackage{luacolor}
  \usepackage[soul]{lua-ul}
\else
  \usepackage{soul}
$if(beamer)$
  \makeatletter
  \let\HL\hl
  \renewcommand\hl{% fix for beamer highlighting
    \let\set@color\beamerorig@set@color
    \let\reset@color\beamerorig@reset@color
    \HL}
  \makeatother
$endif$
$if(CJKmainfont)$
  \ifXeTeX
    % soul's \st doesn't work for CJK:
    \usepackage{xeCJKfntef}
    \renewcommand{\st}[1]{\sout{#1}}
  \fi
$endif$
\fi
$endif$
$--
$-- CSL citations
$--
$if(csl-refs)$
% definitions for citeproc citations
\NewDocumentCommand\citeproctext{}{}
\NewDocumentCommand\citeproc{mm}{%
  \begingroup\def\citeproctext{#2}\cite{#1}\endgroup}
\makeatletter
 % allow citations to break across lines
 \let\@cite@ofmt\@firstofone
 % avoid brackets around text for \cite:
 \def\@biblabel#1{}
 \def\@cite#1#2{{#1\if@tempswa , #2\fi}}
\makeatother
\newlength{\cslhangindent}
\setlength{\cslhangindent}{1.5em}
\newlength{\csllabelwidth}
\setlength{\csllabelwidth}{3em}
\newenvironment{CSLReferences}[2] % #1 hanging-indent, #2 entry-spacing
 {\begin{list}{}{%
  \setlength{\itemindent}{0pt}
  \setlength{\leftmargin}{0pt}
  \setlength{\parsep}{0pt}
  % turn on hanging indent if param 1 is 1
  \ifodd #1
   \setlength{\leftmargin}{\cslhangindent}
   \setlength{\itemindent}{-1\cslhangindent}
  \fi
  % set entry spacing
  \setlength{\itemsep}{#2\baselineskip}}}
 {\end{list}}
\usepackage{calc}
\newcommand{\CSLBlock}[1]{\hfill\break\parbox[t]{\linewidth}{\strut\ignorespaces#1\strut}}
\newcommand{\CSLLeftMargin}[1]{\parbox[t]{\csllabelwidth}{\strut#1\strut}}
\newcommand{\CSLRightInline}[1]{\parbox[t]{\linewidth - \csllabelwidth}{\strut#1\strut}}
\newcommand{\CSLIndent}[1]{\hspace{\cslhangindent}#1}
$endif$
$--
$-- Babel language support
$--
$if(lang)$
\ifLuaTeX
\usepackage[bidi=basic]{babel}
\else
\usepackage[bidi=default]{babel}
\fi
$if(babel-lang)$
\babelprovide[main,import]{$babel-lang$}
$if(mainfont)$
\ifPDFTeX
\else
\babelfont{rm}[$for(mainfontoptions)$$mainfontoptions$$sep$,$endfor$$if(mainfontfallback)$,RawFeature={fallback=mainfontfallback}$endif$]{$mainfont$}
\fi
$endif$
$endif$
$for(babel-otherlangs)$
\babelprovide[import]{$babel-otherlangs$}
$endfor$
$for(babelfonts/pairs)$
\babelfont[$babelfonts.key$]{rm}{$babelfonts.value$}
$endfor$
% get rid of language-specific shorthands (see #6817):
\let\LanguageShortHands\languageshorthands
\def\languageshorthands#1{}
$if(selnolig-langs)$
\ifLuaTeX
  \usepackage[$for(selnolig-langs)$$it$$sep$,$endfor$]{selnolig} % disable illegal ligatures
\fi
$endif$
$endif$
$--
$-- pagestyle
$--
$if(pagestyle)$
\pagestyle{$pagestyle$}
$endif$
$--
$-- prevent overfull lines
$--
\setlength{\emergencystretch}{3em} % prevent overfull lines
$--
$-- tight lists
$--
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
$--
$-- subfigure support
$--
$if(subfigure)$
\usepackage{subcaption}
$endif$
$--
$-- text direction support for pdftex
$--
$if(dir)$
\ifPDFTeX
  \TeXXeTstate=1
  \newcommand{\RL}[1]{\beginR #1\endR}
  \newcommand{\LR}[1]{\beginL #1\endL}
  \newenvironment{RTL}{\beginR}{\endR}
  \newenvironment{LTR}{\beginL}{\endL}
\fi
$endif$
$--
$-- bibliography support support for natbib and biblatex
$--
$if(natbib)$
\usepackage[$natbiboptions$]{natbib}
\bibliographystyle{$if(biblio-style)$$biblio-style$$else$plainnat$endif$}
$endif$
$if(biblatex)$
\usepackage[$if(biblio-style)$style=$biblio-style$,$endif$$for(biblatexoptions)$$biblatexoptions$$sep$,$endfor$]{biblatex}
$for(bibliography)$
\addbibresource{$bibliography$}
$endfor$
$endif$
$--
$-- csquotes
$--
$if(csquotes)$
\usepackage{csquotes}
$endif$
```

#### Penjelasan per Bagian dari `common.latex`:

##### 1. Pengaturan `linestretch` (Line Spacing/Jarak Baris)

```latex
$if(linestretch)$
\usepackage{setspace}
$else$
% Use setspace anyway because we change the default line spacing.
% The spacing is changed early to affect the titlepage and the TOC.
\usepackage{setspace}
\setstretch{1.2}
$endif$
```

*   **Tujuan**: Mengatur jarak antar baris dalam dokumen.
*   **Package**: `setspace`
*   **Variabel Pandoc**: `linestretch`
    *   **Jika `linestretch` didefinisikan**: Memuat package `setspace` saja, asumsinya pengaturan *linestretch* akan dikontrol lebih lanjut (mungkin di file lain atau melalui variabel lain).
    *   **Jika `linestretch` tidak didefinisikan**: Tetap memuat `setspace` dan secara *default* mengatur jarak baris menjadi 1.2 spasi menggunakan `\setstretch{1.2}`. Pengaturan ini dilakukan sejak awal agar mempengaruhi seluruh dokumen, termasuk halaman judul dan daftar isi.
*   **Opsi Variabel `linestretch`**: Tidak secara langsung mengontrol opsi *package*. Kehadiran variabel ini (true/false atau nilai numerik) hanya menentukan apakah `\usepackage{setspace}` saja yang dipanggil atau `\setstretch` juga diterapkan. Untuk mengatur nilai *linestretch* secara spesifik, variabel lain atau konfigurasi LaTeX tambahan mungkin diperlukan.

##### 2. Format Paragraf (`paragraph formatting`)

```latex
$if(indent)$
$else$
\makeatletter
\@ifundefined{KOMAClassName}{% if non-KOMA class
  \IfFileExists{parskip.sty}{%
    \usepackage{parskip}
  }{% else
    \setlength{\parindent}{0pt}
    \setlength{\parskip}{6pt plus 2pt minus 1pt}}
}{% if KOMA class
  \KOMAoptions{parskip=half}}
\makeatother
$endif$
```

*   **Tujuan**: Mengontrol format paragraf, khususnya indentasi dan jarak antar paragraf.
*   **Package**: `parskip` (opsional)
*   **Variabel Pandoc**: `indent`
    *   **Jika `indent` didefinisikan (dianggap *true*)**: Tidak melakukan apa pun. Diasumsikan indentasi paragraf akan digunakan (perilaku *default* LaTeX).
    *   **Jika `indent` tidak didefinisikan (dianggap *false*)**: Menghilangkan indentasi dan menambahkan jarak antar paragraf. Logika di dalamnya lebih kompleks:
        *   **Cek Kelas Dokumen KOMA**: Menggunakan `\@ifundefined{KOMAClassName}` untuk memeriksa apakah kelas dokumen yang digunakan adalah kelas KOMA-Script (seperti `scrartcl`, `scrreprt`, `scrbook`). Kelas KOMA-Script memiliki cara pengaturan paragraf sendiri.
        *   **Jika bukan Kelas KOMA**:
            *   **Cek *Package* `parskip.sty`**: Memeriksa apakah file `parskip.sty` ada. Jika ada, memuat package `parskip` (`\usepackage{parskip}`). Package ini secara otomatis menghilangkan indentasi dan menambahkan jarak antar paragraf.
            *   **Jika `parskip.sty` tidak ada**: Mengatur indentasi paragraf menjadi 0pt (`\setlength{\parindent}{0pt}`) dan jarak antar paragraf menjadi 6pt (dengan sedikit *stretch* dan *shrink*) secara manual menggunakan `\setlength{\parskip}{6pt plus 2pt minus 1pt}`.
        *   **Jika Kelas KOMA**: Menggunakan `\KOMAoptions{parskip=half}` untuk mengaktifkan opsi `parskip=half` pada kelas KOMA-Script. Ini biasanya menghasilkan format paragraf tanpa indentasi dengan jarak antar paragraf.
*   **Opsi Variabel `indent`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Menentukan antara menggunakan indentasi paragraf *default* atau menghilangkan indentasi dan menambahkan jarak antar paragraf.

##### 3. Judul Bagian "Block Headings" (`block-headings`)

```latex
$if(beamer)$
$else$
$if(block-headings)$
% Make \paragraph and \subparagraph free-standing
\makeatletter
\ifx\paragraph\undefined\else
  \let\oldparagraph\paragraph
  \renewcommand{\paragraph}{
    \@ifstar
      \xxxParagraphStar
      \xxxParagraphNoStar
  }
  \newcommand{\xxxParagraphStar}[1]{\oldparagraph*{#1}\mbox{}}
  \newcommand{\xxxParagraphNoStar}[1]{\oldparagraph{#1}\mbox{}}
\fi
\ifx\subparagraph\undefined\else
  \let\oldsubparagraph\subparagraph
  \renewcommand{\subparagraph}{
    \@ifstar
      \xxxSubParagraphStar
      \xxxSubParagraphNoStar
  }
  \newcommand{\xxxSubParagraphStar}[1]{\oldsubparagraph*{#1}\mbox{}}
  \newcommand{\xxxSubParagraphNoStar}[1]{\oldsubparagraph{#1}\mbox{}}
\fi
\makeatother
$endif$
$endif$
```

*   **Tujuan**: Memastikan heading level `\paragraph` dan `\subparagraph` selalu berdiri sendiri (free-standing), bukan inline (menyatu dengan teks paragraf). Ini relevan untuk kelas dokumen yang mungkin memperlakukan heading level rendah sebagai inline secara *default*.
*   **Variabel Pandoc**: `block-headings`, `beamer`
    *   **Kondisi *Beamer***: `$if(beamer)$`... `$endif$`. Jika dokumen adalah presentasi Beamer (`beamer` diaktifkan), bagian ini dilewati. Konfigurasi *block headings* mungkin tidak relevan atau sudah diurus oleh *theme* Beamer.
    *   **Kondisi `block-headings`**: `$if(block-headings)$`... `$endif$`. Jika `block-headings` diaktifkan, kode di dalamnya dijalankan.
    *   **Redefinisi `\paragraph` dan `\subparagraph`**: Menggunakan `\makeatletter` dan `\makeatother` untuk mengakses perintah internal LaTeX. Memeriksa apakah `\paragraph` dan `\subparagraph` terdefinisi (`\ifx\paragraph\undefined\else` ... `\fi`). Jika terdefinisi, perintah asli disimpan (`\let\oldparagraph\paragraph`), lalu `\paragraph` dan `\subparagraph` didefinisikan ulang.
        *   **Definisi Ulang**: Definisi ulang menggunakan `\@ifstar` untuk menangani versi berbintang (`\paragraph*`) dan tidak berbintang (`\paragraph`). Baik versi berbintang maupun tidak berbintang, perintah yang baru didefinisikan (`\xxxParagraphStar`, `\xxxParagraphNoStar`, dan serupa untuk `\subparagraph`) memanggil perintah asli (`\oldparagraph` atau `\oldsubparagraph`) dan menambahkan `\mbox{}` setelahnya. `\mbox{}` memastikan bahwa heading selalu dianggap sebagai *box* dan tidak inline.
*   **Opsi Variabel `block-headings`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengontrol apakah *block headings* untuk `\paragraph` dan `\subparagraph` diaktifkan.

##### 4. Verbatim dalam Catatan Kaki (`verbatim in notes`)

```latex
$-- verbatim in notes
$--
$if(verbatim-in-note)$
\usepackage{fancyvrb}
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk teks *verbatim* (seperti kode) dalam catatan kaki.
*   **Package**: `fancyvrb`
*   **Variabel Pandoc**: `verbatim-in-note`
    *   **Jika `verbatim-in-note` didefinisikan**: Memuat package `fancyvrb` (`\usepackage{fancyvrb}`). Package ini menyediakan lingkungan dan perintah yang lebih fleksibel untuk menampilkan teks *verbatim*.
    *   **Jika `verbatim-in-note` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan *verbatim* dalam catatan kaki tidak aktif.
*   **Opsi Variabel `verbatim-in-note`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan *verbatim* dalam catatan kaki. (Perhatikan bahwa `\VerbatimFootnotes` di `after-header-includes.latex` juga harus diaktifkan agar fitur ini berfungsi penuh).

##### 5. Highlighting (Penyorotan Kode)

Bagian ini memiliki beberapa sub-bagian terkait *highlighting* kode:

###### 5.1. Dasar Highlighting (`listings`)

```latex
$-- highlighting
$if(listings)$
\usepackage{listings}
\newcommand{\passthrough}[1]{#1}
\lstset{defaultdialect=[5.3]Lua}
\lstset{defaultdialect=[x86masm]Assembler}
$endif$
```

*   **Tujuan**: Menyediakan *highlighting* sintaks kode.
*   **Package**: `listings`
*   **Variabel Pandoc**: `listings`
    *   **Jika `listings` didefinisikan**: Memuat package `listings` (`\usepackage{listings}`). Mendefinisikan perintah kosong `\passthrough` (fungsinya tidak jelas dari potongan kode ini saja, mungkin digunakan di tempat lain dalam template). Mengatur *dialect* *default* untuk *listing* menjadi Lua 5.3 dan Assembler (x86masm) menggunakan `\lstset`.
    *   **Jika `listings` tidak didefinisikan**: Tidak melakukan apa pun. *Highlighting* kode dasar tidak aktif (kecuali mungkin ada mekanisme *highlighting* lain yang diaktifkan).
*   **Opsi Variabel `listings`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan *highlighting* kode dasar menggunakan *package* `listings`.

###### 5.2. Mencegah Patah Halaman di dalam Listing (`listings-no-page-break`)

```latex
$if(listings-no-page-break)$
\usepackage{etoolbox}
\BeforeBeginEnvironment{lstlisting}{\par\noindent\begin{minipage}{\linewidth}}
\AfterEndEnvironment{lstlisting}{\end{minipage}\par\addvspace{\topskip}}
$endif$
```

*   **Tujuan**: Mencegah *listing* kode (dari *package* `listings`) untuk patah di tengah halaman. Membuat *listing* selalu utuh dalam satu halaman atau berpindah ke halaman berikutnya jika tidak cukup ruang.
*   **Package**: `etoolbox`
*   **Variabel Pandoc**: `listings-no-page-break`
    *   **Jika `listings-no-page-break` didefinisikan**: Menggunakan *package* `etoolbox` untuk menyisipkan kode sebelum dan sesudah lingkungan `lstlisting` (lingkungan untuk *listing* kode dari *package* `listings`).
        *   `\BeforeBeginEnvironment{lstlisting}{\par\noindent\begin{minipage}{\linewidth}}`: Sebelum setiap lingkungan `lstlisting` dimulai, memulai paragraf baru (`\par`), menghilangkan indentasi (`\noindent`), dan memulai lingkungan `minipage` dengan lebar penuh baris (`\begin{minipage}{\linewidth}`). `minipage` membuat *box* yang tidak akan patah halaman.
        *   `\AfterEndEnvironment{lstlisting}{\end{minipage}\par\addvspace{\topskip}}`: Setelah setiap lingkungan `lstlisting` berakhir, menutup lingkungan `minipage` (`\end{minipage}`), memulai paragraf baru (`\par`), dan menambahkan ruang vertikal sebesar `\topskip` (`\addvspace{\topskip}`). `\topskip` adalah ruang vertikal di atas baris pertama paragraf.
    *   **Jika `listings-no-page-break` tidak didefinisikan**: Tidak melakukan apa pun. *Listing* kode mungkin patah halaman jika terlalu panjang.
*   **Opsi Variabel `listings-no-page-break`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan pencegahan patah halaman untuk *listing* kode.

###### 5.3. Lingkungan Kode Haskell (`lhs`)

```latex
$if(lhs)$
\lstnewenvironment{code}{\lstset{language=Haskell,basicstyle=\small\ttfamily}}{}
$endif$
```

*   **Tujuan**: Mendefinisikan lingkungan LaTeX khusus bernama `code` untuk menampilkan kode Haskell.
*   **Package**: `listings` (diasumsikan sudah dimuat oleh bagian *highlighting* dasar)
*   **Variabel Pandoc**: `lhs` (Likely "Literate Haskell Support")
    *   **Jika `lhs` didefinisikan**: Mendefinisikan lingkungan baru bernama `code` menggunakan `\lstnewenvironment{code}{...}{...}` dari *package* `listings`. Lingkungan `code` ini secara *default* akan:
        *   Menggunakan *language* `Haskell` untuk *syntax highlighting*.
        *   Menggunakan gaya teks kecil (*small*) dengan *font* *monospace* (*ttfamily*) sebagai gaya dasar (`basicstyle=\small\ttfamily`).
    *   **Jika `lhs` tidak didefinisikan**: Tidak melakukan apa pun. Lingkungan `code` untuk Haskell tidak didefinisikan.
*   **Opsi Variabel `lhs`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan lingkungan `code` khusus untuk kode Haskell.

###### 5.4. Makro Highlighting (`highlighting-macros`)

```latex
$if(highlighting-macros)$
$highlighting-macros$

% Workaround/bugfix from jannick0.
% See [https://github.com/jgm/pandoc/issues/4302#issuecomment-360669013](https://github.com/jgm/pandoc/issues/4302#issuecomment-360669013))
% or [https://github.com/Wandmalfarbe/pandoc-latex-template/issues/2](https://github.com/Wandmalfarbe/pandoc-latex-template/issues/2)
%
% Redefine the verbatim environment 'Highlighting' to break long lines (with
% the help of fvextra). Redefinition is necessary because it is unlikely that
% pandoc includes fvextra in the default template.
\usepackage{fvextra}
\DefineVerbatimEnvironment{Highlighting}{Verbatim}{breaklines,fontsize=$if(code-block-font-size)$$code-block-font-size$$else$\small$endif$,commandchars=\\\{\}}

$endif$
```

*   **Tujuan**: Menyediakan makro *highlighting* tambahan dan mengatasi masalah *line breaking* pada lingkungan *verbatim* `Highlighting` yang dihasilkan oleh Pandoc.
*   **Package**: `fvextra`
*   **Variabel Pandoc**: `highlighting-macros`, `code-block-font-size`
    *   **Jika `highlighting-macros` didefinisikan**:
        *   **Sertakan Konten Variabel `highlighting-macros`**: `$highlighting-macros$` akan digantikan dengan konten dari variabel Pandoc bernama `highlighting-macros`. Isi variabel ini diasumsikan berisi definisi makro LaTeX terkait *highlighting*.  (Isi makro tidak didefinisikan dalam potongan kode ini, harus dilihat dari file konfigurasi atau *command line* Pandoc).
        *   **Memuat *Package* `fvextra`**: Memuat *package* `fvextra` (`\usepackage{fvextra}`). Package ini adalah ekstensi dari *package* `fancyvrb` dan menyediakan fitur tambahan, termasuk *line breaking* untuk lingkungan *verbatim*.
        *   **Redefinisi Lingkungan `Highlighting`**: Mendefinisikan ulang lingkungan `Highlighting` (yang kemungkinan digunakan oleh Pandoc untuk menampilkan kode) menggunakan `\DefineVerbatimEnvironment{Highlighting}{Verbatim}{...}` dari *package* `fvextra`. Lingkungan `Highlighting` yang baru didefinisikan akan memiliki fitur:
            *   `Verbatim`: Berbasis pada lingkungan `Verbatim` dari *package* `fancyvrb`.
            *   `breaklines`: Mengaktifkan *line breaking* otomatis dalam *verbatim* (fitur dari `fvextra`).
            *   `fontsize=$if(code-block-font-size)$$code-block-font-size$$else$\small$endif$`: Mengatur ukuran *font* untuk kode. Jika variabel `code-block-font-size` didefinisikan, nilainya digunakan. Jika tidak, ukuran *font* *default* adalah `\small`.
            *   `commandchars=\\\{\}`: Mengatur karakter perintah untuk lingkungan *verbatim*. `\\\{\}` memungkinkan penggunaan karakter `\` `{` `}` sebagai karakter literal dalam *verbatim*.
    *   **Jika `highlighting-macros` tidak didefinisikan**: Tidak melakukan apa pun. *Highlighting* tingkat lanjut dan perbaikan *line breaking* untuk lingkungan `Highlighting` tidak aktif.
*   **Opsi Variabel `highlighting-macros`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan makro *highlighting* tambahan dan perbaikan *line breaking*.
*   **Opsi Variabel `code-block-font-size`**: Variabel *string* yang berisi ukuran *font* LaTeX (misalnya, `\footnotesize`, `\scriptsize`, `\tiny`, dll.). Menentukan ukuran *font* untuk blok kode yang menggunakan lingkungan `Highlighting`.

##### 6. Tabel (`tables`)

Bagian ini mengatur dukungan tabel, termasuk tabel panjang dan fitur terkait:

###### 6.1. Dukungan Tabel Dasar (`tables`)

```latex
$-- tables
$--
$if(tables)$
\usepackage{longtable,booktabs,array}
$if(multirow)$
\usepackage{multirow}
$endif$
\usepackage{calc} % for calculating minipage widths
$if(beamer)$
\usepackage{caption}
% Make caption package work with longtable
\makeatletter
\def\fnum@table{\tablename~\thetable}
\makeatother
$else$
% Correct order of tables after \paragraph or \subparagraph
\usepackage{etoolbox}
\makeatletter
\patchcmd\longtable{\par}{\if@noskipsec\mbox{}\fi\par}{}{}
\makeatother
% Allow footnotes in longtable head/foot
\IfFileExists{footnotehyper.sty}{\usepackage{footnotehyper}}{\usepackage{footnote}}
\makesavenoteenv{longtable}
$endif$
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk tabel, terutama tabel panjang yang bisa memakan lebih dari satu halaman, dan fitur-fitur terkait.
*   **Packages**: `longtable`, `booktabs`, `array`, `multirow` (opsional), `calc`, `caption` (opsional, untuk Beamer), `etoolbox` (opsional, untuk non-Beamer), `footnotehyper`/`footnote` (opsional, untuk *footnote* dalam tabel).
*   **Variabel Pandoc**: `tables`, `multirow`, `beamer`
    *   **Jika `tables` didefinisikan**: Mengaktifkan dukungan tabel.
        *   **Memuat *Package* Tabel**: Memuat *package*-*package* utama untuk tabel: `longtable` (untuk tabel panjang), `booktabs` (untuk garis tabel yang lebih baik), dan `array` (untuk kolom tabel yang lebih fleksibel).
        *   **Dukungan `multirow` (Kondisional)**: `$if(multirow)$`... `$endif$`. Jika variabel `multirow` juga didefinisikan, memuat *package* `multirow` (`\usepackage{multirow}`). Package ini memungkinkan sel tabel untuk menjangkau beberapa baris.
        *   **Memuat *Package* `calc`**: Memuat *package* `calc` (`\usepackage{calc}`). Package ini digunakan untuk melakukan perhitungan dalam LaTeX, termasuk perhitungan lebar `minipage` (yang mungkin digunakan dalam konteks tabel, meskipun tidak langsung terlihat di potongan kode ini).
        *   **Konfigurasi Khusus Beamer (Kondisional)**: `$if(beamer)$`... `$else$ ... `$endif$`.
            *   **Jika Dokumen Beamer**: Memuat *package* `caption` (`\usepackage{caption}`) untuk menangani *caption* tabel. Redefinisi perintah internal `\fnum@table` untuk memastikan *caption* tabel bekerja dengan `longtable` dalam konteks Beamer.
            *   **Jika Bukan Dokumen Beamer**:
                *   **Perbaikan Urutan Tabel**: Memuat *package* `etoolbox` (`\usepackage{etoolbox}`) dan menggunakan `\patchcmd\longtable{...}{...}{...}` untuk memodifikasi perintah `\longtable`. Patch ini bertujuan untuk memperbaiki urutan tabel yang mungkin terganggu jika tabel muncul setelah heading level rendah seperti `\paragraph` atau `\subparagraph`.
                *   **Dukungan *Footnote* dalam Tabel**: Memeriksa apakah file `footnotehyper.sty` ada (`\IfFileExists{footnotehyper.sty}{...}{...}`). Jika ada, memuat `footnotehyper`. Jika tidak, memuat `footnote`. Kemudian menggunakan `\makesavenoteenv{longtable}` untuk mengaktifkan dukungan *footnote* dalam lingkungan `longtable`. `footnotehyper` dan `footnote` menyediakan dukungan *footnote*. `footnotehyper` mungkin memberikan fitur tambahan terkait *hyperlink* *footnote*.
    *   **Jika `tables` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan tabel tidak aktif.
*   **Opsi Variabel `tables`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan tabel.
*   **Opsi Variabel `multirow`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan fitur `multirow` dalam tabel.

##### 7. Grafik (`graphics`)

Bagian ini mengatur dukungan untuk memasukkan dan menskalakan grafik:

```latex
$-- graphics
$--
$if(graphics)$
\usepackage{graphicx}
\makeatletter
\newsavebox\pandoc@box
\newcommand*\pandocbounded[1]{% scales image to fit in text height/width
  \sbox\pandoc@box{#1}%
  \Gscale@div\@tempa{\textheight}{\dimexpr\ht\pandoc@box+\dp\pandoc@box\relax}%
  \Gscale@div\@tempb{\linewidth}{\wd\pandoc@box}%
  \ifdim\@tempb\p@<\@tempa\p@\let\@tempa\@tempb\fi% select the smaller of both
  \ifdim\@tempa\p@<\p@\scalebox{\@tempa}{\usebox\pandoc@box}%
  \else\usebox{\pandoc@box}%
  \fi%
}
% Set default figure placement to htbp
% Make use of float-package and set default placement for figures to H.
% The option H means 'PUT IT HERE' (as  opposed to the standard h option which means 'You may put it here if you like').
\usepackage{float}
\floatplacement{figure}{$if(float-placement-figure)$$float-placement-figure$$else$H$endif$}
\makeatother
$endif$
$if(svg)$
\usepackage{svg}
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk memasukkan grafik (gambar) ke dalam dokumen dan mengatur penempatannya.
*   **Packages**: `graphicx`, `float`, `svg` (opsional)
*   **Variabel Pandoc**: `graphics`, `float-placement-figure`, `svg`
    *   **Jika `graphics` didefinisikan**: Mengaktifkan dukungan grafik.
        *   **Memuat *Package* `graphicx`**: Memuat *package* `graphicx` (`\usepackage{graphicx}`). Package ini adalah *package* utama untuk memasukkan dan memanipulasi grafik dalam LaTeX.
        *   **Definisi Perintah `\pandocbounded`**: Mendefinisikan perintah baru bernama `\pandocbounded` menggunakan `\newcommand*\pandocbounded[1]{...}`. Perintah ini bertujuan untuk menskalakan gambar agar sesuai dengan tinggi atau lebar teks yang tersedia.
            *   **Cara Kerja `\pandocbounded`**:
                *   Menyimpan konten (gambar) dalam *savebox* `\pandoc@box` (`\newsavebox\pandoc@box`, `\sbox\pandoc@box{#1}`).
                *   Menghitung faktor skala berdasarkan tinggi teks (`\textheight`) dan tinggi gambar, serta lebar baris (`\linewidth`) dan lebar gambar.
                *   Memilih faktor skala yang lebih kecil dari kedua faktor skala (tinggi dan lebar).
                *   Jika faktor skala lebih kecil dari 1 (gambar perlu diperkecil), menggunakan `\scalebox` untuk menskalakan gambar menggunakan faktor skala yang terpilih.
                *   Jika tidak perlu diperkecil, menampilkan gambar tanpa penskalaan.
        *   **Memuat *Package* `float`**: Memuat *package* `float` (`\usepackage{float}`). Package ini memberikan kontrol lebih baik atas penempatan *float* (seperti gambar dan tabel).
        *   **Pengaturan Penempatan *Float* Gambar**: Menggunakan `\floatplacement{figure}{$if(float-placement-figure)$$float-placement-figure$$else$H$endif$}` untuk mengatur penempatan *default* untuk lingkungan `figure`. Jika variabel `float-placement-figure` didefinisikan, nilainya digunakan sebagai opsi penempatan. Jika tidak, opsi `H` (PUT IT HERE - letakkan tepat di sini) digunakan sebagai *default*. Opsi penempatan LaTeX umum meliputi `h`, `t`, `b`, `p`, dan kombinasinya, serta `H` dari *package* `float`.
    *   **Jika `graphics` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan grafik dasar tidak aktif.
    *   **Dukungan SVG (Kondisional)**: `$if(svg)$`... `$endif$`. Jika variabel `svg` didefinisikan, memuat *package* `svg` (`\usepackage{svg}`). Package ini menyediakan dukungan untuk memasukkan file SVG (Scalable Vector Graphics) ke dalam dokumen LaTeX.
*   **Opsi Variabel `graphics`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan grafik dasar.
*   **Opsi Variabel `float-placement-figure`**: Variabel *string* yang berisi opsi penempatan *float* LaTeX (misalnya, `"htbp"`, `"t"`, `"H"`). Menentukan opsi penempatan *default* untuk lingkungan `figure`.
*   **Opsi Variabel `svg`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan untuk file SVG.

##### 8. Strikeout/Underline (Coret/Garis Bawah)

Bagian ini mengatur dukungan untuk teks coret dan garis bawah:

```latex
$-- strikeout/underline
$--
$if(strikeout)$
\ifLuaTeX
  \usepackage{luacolor}
  \usepackage[soul]{lua-ul}
\else
  \usepackage{soul}
$if(beamer)$
  \makeatletter
  \let\HL\hl
  \renewcommand\hl{% fix for beamer highlighting
    \let\set@color\beamerorig@set@color
    \let\reset@color\beamerorig@reset@color
    \HL}
  \makeatother
$endif$
$if(CJKmainfont)$
  \ifXeTeX
    % soul's \st doesn't work for CJK:
    \usepackage{xeCJKfntef}
    \renewcommand{\st}[1]{\sout{#1}}
  \fi
$endif$
\fi
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk efek teks coret (*strikeout*) dan (kemungkinan) garis bawah (*underline*, meskipun tidak eksplisit terlihat di kode ini, *package* `soul` juga menyediakan garis bawah).
*   **Packages**: `soul` (atau `lua-ul` dan `luacolor` untuk LuaTeX), `xeCJKfntef` (opsional, untuk XeTeX dengan font CJK)
*   **Variabel Pandoc**: `strikeout`, `beamer`, `CJKmainfont`
    *   **Jika `strikeout` didefinisikan**: Mengaktifkan dukungan *strikeout*.
        *   **Pemilihan *Package* `soul` atau `lua-ul` (Berdasarkan Engine TeX)**: `$ifLuaTeX`... `$else$ ... `\fi`. Memeriksa apakah *engine* TeX yang digunakan adalah LuaTeX.
            *   **Jika LuaTeX**: Memuat *package* `luacolor` dan `lua-ul` (`\usepackage{luacolor}`, `\usepackage[soul]{lua-ul}`). `lua-ul` adalah versi *package* `soul` yang didesain untuk bekerja lebih baik dengan LuaTeX dan mendukung *font feature* lanjutan. `luacolor` mungkin diperlukan untuk pewarnaan yang tepat dengan `lua-ul`.
            *   **Jika Bukan LuaTeX (PDFTeX atau XeTeX)**: Memuat *package* `soul` (`\usepackage{soul}`). *Package* `soul` adalah *package* *strikeout* dan *underline* tradisional.
        *   **Perbaikan untuk Beamer (Kondisional)**: `$if(beamer)$`... `$endif$`. Jika dokumen adalah presentasi Beamer (`beamer` diaktifkan).
            *   **Perbaikan *Highlighting* Beamer**: Redefinisi perintah `\hl` (perintah *highlight* dari *package* `soul` dan juga perintah *highlight* di Beamer). Kode ini menyimpan perintah `\hl` asli Beamer (`\let\HL\hl`) dan kemudian mendefinisikan ulang `\hl` agar bekerja dengan benar di lingkungan Beamer, mungkin terkait dengan penanganan warna di Beamer.
        *   **Perbaikan untuk Font CJK di XeTeX (Kondisional)**: `$if(CJKmainfont)$`... `$endif$`. Jika variabel `CJKmainfont` didefinisikan (menandakan penggunaan *font* utama CJK/Chinese-Japanese-Korean)
            *   **Perbaikan *Strikeout* CJK di XeTeX**: `$ifXeTeX`... `\fi`. Jika *engine* TeX yang digunakan adalah XeTeX.
                *   **Memuat *Package* `xeCJKfntef`**: Memuat *package* `xeCJKfntef` (`\usepackage{xeCJKfntef}`). Package ini menyediakan perbaikan untuk bekerja dengan *font* CJK di XeTeX, khususnya untuk perintah seperti *footnote*, *endnote*, dan mungkin juga *strikeout*.
                *   **Redefinisi `\st`**: Redefinisi perintah `\st` (perintah *strikeout* dari *package* `soul`) menjadi `\sout` (`\renewcommand{\st}[1]{\sout{#1}}`). Mungkin *package* `xeCJKfntef` menyediakan perintah `\sout` yang bekerja lebih baik dengan *font* CJK di XeTeX daripada `\st` dari *package* `soul` biasa.
    *   **Jika `strikeout` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan *strikeout* (dan *underline* secara implisit karena menggunakan *package* `soul` atau `lua-ul`) tidak aktif.
*   **Opsi Variabel `strikeout`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan *strikeout* dan *underline*.
*   **Opsi Variabel `beamer`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Menandakan dokumen adalah presentasi Beamer, yang memicu perbaikan khusus Beamer untuk *highlighting*.
*   **Opsi Variabel `CJKmainfont`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Menandakan penggunaan *font* utama CJK, yang memicu perbaikan khusus CJK di XeTeX untuk *strikeout*.

##### 9. CSL Citations (Sitasi CSL - Citation Style Language)

Bagian ini mengatur dukungan untuk sitasi menggunakan CSL dan *citeproc*:

```latex
$-- CSL citations
$--
$if(csl-refs)$
% definitions for citeproc citations
\NewDocumentCommand\citeproctext{}{}
\NewDocumentCommand\citeproc{mm}{%
  \begingroup\def\citeproctext{#2}\cite{#1}\endgroup}
\makeatletter
 % allow citations to break across lines
 \let\@cite@ofmt\@firstofone
 % avoid brackets around text for \cite:
 \def\@biblabel#1{}
 \def\@cite#1#2{{#1\if@tempswa , #2\fi}}
\makeatother
\newlength{\cslhangindent}
\setlength{\cslhangindent}{1.5em}
\newlength{\csllabelwidth}
\setlength{\csllabelwidth}{3em}
\newenvironment{CSLReferences}[2] % #1 hanging-indent, #2 entry-spacing
 {\begin{list}{}{%
  \setlength{\itemindent}{0pt}
  \setlength{\leftmargin}{0pt}
  \setlength{\parsep}{0pt}
  % turn on hanging indent if param 1 is 1
  \ifodd #1
   \setlength{\leftmargin}{\cslhangindent}
   \setlength{\itemindent}{-1\cslhangindent}
  \fi
  % set entry spacing
  \setlength{\itemsep}{#2\baselineskip}}}
 {\end{list}}
\usepackage{calc}
\newcommand{\CSLBlock}[1]{\hfill\break\parbox[t]{\linewidth}{\strut\ignorespaces#1\strut}}
\newcommand{\CSLLeftMargin}[1]{\parbox[t]{\csllabelwidth}{\strut#1\strut}}
\newcommand{\CSLRightInline}[1]{\parbox[t]{\linewidth - \csllabelwidth}{\strut#1\strut}}
\newcommand{\CSLIndent}[1]{\hspace{\cslhangindent}#1}
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk sitasi dan bibliografi menggunakan CSL (*Citation Style Language*) dan *citeproc*. Bagian kode ini mendefinisikan perintah dan lingkungan LaTeX yang diperlukan agar Pandoc dapat menghasilkan sitasi dan daftar pustaka yang diformat sesuai dengan gaya CSL yang dipilih.
*   **Packages**: `calc`
*   **Variabel Pandoc**: `csl-refs`
    *   **Jika `csl-refs` didefinisikan**: Mengaktifkan dukungan sitasi CSL.
        *   **Definisi Perintah `\citeproctext` dan `\citeproc`**: Mendefinisikan perintah baru:
            *   `\citeproctext`: Perintah kosong, fungsinya mungkin diisi oleh *citeproc* saat pemrosesan.
            *   `\citeproc`: Mengambil dua argumen (`#1` dan `#2`). Di dalamnya, mendefinisikan ulang `\citeproctext` dengan argumen kedua (`#2`), lalu memanggil perintah `\cite{#1}`. Ini kemungkinan merupakan cara untuk memasukkan teks tambahan ke dalam sitasi yang dihasilkan oleh *citeproc*.
        *   **Konfigurasi Perintah `\cite` (Menggunakan `\makeatletter`...)**: Memodifikasi perilaku perintah `\cite` (perintah dasar LaTeX untuk sitasi) untuk bekerja lebih baik dengan *citeproc*.
            *   `\let\@cite@ofmt\@firstofone`: Mengizinkan sitasi untuk patah baris.
            *   `\def\@biblabel#1{}`: Menghilangkan *label* bibliografi (biasanya nomor urut) dalam daftar pustaka. Ini mungkin karena *citeproc* mengurus format label pustaka.
            *   `\def\@cite#1#2{{#1\if@tempswa , #2\fi}}`: Mendefinisikan ulang perintah internal `\@cite` (yang dipanggil oleh `\cite`). Definisi ulang ini bertujuan untuk menghilangkan tanda kurung siku di sekitar sitasi dan menambahkan koma jika ada teks tambahan dalam sitasi.
        *   **Definisi Panjang dan Lingkungan untuk Daftar Pustaka CSL**:
            *   `\newlength{\cslhangindent}`, `\setlength{\cslhangindent}{1.5em}`: Mendefinisikan panjang `\cslhangindent` untuk indentasi gantung (hanging indent) dalam daftar pustaka CSL, diatur ke 1.5em.
            *   `\newlength{\csllabelwidth}`, `\setlength{\csllabelwidth}{3em}`: Mendefinisikan panjang `\csllabelwidth` untuk lebar *label* pustaka (jika ada), diatur ke 3em.
            *   `\newenvironment{CSLReferences}[2]{...}{...}`: Mendefinisikan lingkungan baru `CSLReferences` yang mengambil dua argumen: `#1` untuk indentasi gantung (0 atau 1 untuk mati/hidup), dan `#2` untuk jarak antar entri pustaka (dalam satuan *baselineskip*). Lingkungan ini berbasis pada lingkungan `list` LaTeX dan mengatur margin, indentasi, dan jarak antar item untuk daftar pustaka CSL.
        *   **Memuat *Package* `calc`**: Memuat *package* `calc` (`\usepackage{calc}`). Package ini mungkin digunakan untuk perhitungan lebar dalam definisi perintah-perintah CSL (misalnya, dalam `\CSLRightInline`).
        *   **Definisi Perintah `\CSLBlock`, `\CSLLeftMargin`, `\CSLRightInline`, `\CSLIndent`**: Mendefinisikan perintah-perintah baru yang kemungkinan digunakan dalam template CSL untuk memformat entri pustaka. Perintah-perintah ini menggunakan `\parbox` dan `\hspace` untuk mengatur *layout* entri pustaka, termasuk indentasi, margin kiri, dan tata letak blok.
    *   **Jika `csl-refs` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan sitasi CSL tidak aktif.
*   **Opsi Variabel `csl-refs`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan sitasi CSL.

##### 10. Babel Language Support (Dukungan Bahasa Babel)

Bagian ini mengatur dukungan untuk bahasa yang berbeda menggunakan *package* `babel`:

```latex
$-- Babel language support
$--
$if(lang)$
\ifLuaTeX
\usepackage[bidi=basic]{babel}
\else
\usepackage[bidi=default]{babel}
\fi
$if(babel-lang)$
\babelprovide[main,import]{$babel-lang$}
$if(mainfont)$
\ifPDFTeX
\else
\babelfont{rm}[$for(mainfontoptions)$$mainfontoptions$$sep$,$endfor$$if(mainfontfallback)$,RawFeature={fallback=mainfontfallback}$endif$]{$mainfont$}
\fi
$endif$
$endif$
$for(babel-otherlangs)$
\babelprovide[import]{$babel-otherlangs$}
$endfor$
$for(babelfonts/pairs)$
\babelfont[$babelfonts.key$]{rm}{$babelfonts.value$}
$endfor$
% get rid of language-specific shorthands (see #6817):
\let\LanguageShortHands\languageshorthands
\def\languageshorthands#1{}
$if(selnolig-langs)$
\ifLuaTeX
  \usepackage[$for(selnolig-langs)$$it$$sep$,$endfor$]{selnolig} % disable illegal ligatures
\fi
$endif$
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk berbagai bahasa dalam dokumen menggunakan *package* `babel`. *Package* `babel` memungkinkan LaTeX untuk menangani konvensi bahasa yang berbeda, seperti pemisahan kata, tanda baca, arah teks (untuk bahasa kanan-ke-kiri), dan font.
*   **Package**: `babel`, `selnolig` (opsional), font packages (tergantung konfigurasi)
*   **Variabel Pandoc**: `lang`, `babel-lang`, `mainfont`, `mainfontoptions`, `mainfontfallback`, `babel-otherlangs`, `babelfonts`, `selnolig-langs`
    *   **Jika `lang` didefinisikan**: Mengaktifkan dukungan bahasa Babel.
        *   **Pemilihan Opsi *bidi* Babel (Berdasarkan Engine TeX)**: `$ifLuaTeX`... `$else$ ... `\fi`. Memeriksa apakah *engine* TeX adalah LuaTeX.
            *   **Jika LuaTeX**: Memuat *package* `babel` dengan opsi `bidi=basic` (`\usepackage[bidi=basic]{babel}`). Opsi `bidi=basic` mengaktifkan dukungan *bidirectional* (kanan-ke-kiri dan kiri-ke-kanan) teks dasar yang mungkin diperlukan untuk bahasa seperti Arab atau Ibrani.
            *   **Jika Bukan LuaTeX**: Memuat *package* `babel` dengan opsi `bidi=default` (`\usepackage[bidi=default]{babel}`). Opsi `bidi=default` mengaktifkan dukungan *bidirectional* *default*.
        *   **Konfigurasi Bahasa Utama (`babel-lang`)**: `$if(babel-lang)$`... `$endif$`. Jika variabel `babel-lang` didefinisikan (berisi kode bahasa, misalnya "en" untuk English, "id" untuk Indonesia).
            *   **Menyediakan Bahasa Utama**: Menggunakan `\babelprovide[main,import]{$babel-lang$}` untuk menetapkan bahasa yang ditentukan oleh `babel-lang` sebagai bahasa utama dokumen dan untuk mengimpor dukungannya dari *package* `babel`.
            *   **Konfigurasi *Font* Utama (Kondisional `mainfont`)**: `$if(mainfont)$`... `$endif$`. Jika variabel `mainfont` didefinisikan (berisi nama *font* utama).
                *   **Pemilihan Engine TeX (Kondisional `PDFTeX`)**: `$ifPDFTeX`... `$else$ ... `\fi`. Memeriksa apakah *engine* TeX adalah PDFTeX.
                    *   **Jika Bukan PDFTeX (XeTeX atau LuaTeX)**: Menggunakan `\babelfont{rm}[...]{$mainfont$}` untuk mengatur *font* *roman* (teks utama) untuk bahasa utama. Opsi *font* (`$for(mainfontoptions)...$`, `$if(mainfontfallback)...$`) diambil dari variabel `mainfontoptions` (daftar opsi *font* seperti fitur OpenType) dan `mainfontfallback` (opsi *fallback font*). Konfigurasi *font* ini hanya dilakukan jika bukan PDFTeX karena PDFTeX memiliki cara yang berbeda dalam menangani *font*.
        *   **Konfigurasi Bahasa Lain (`babel-otherlangs`)**: `$for(babel-otherlangs)$`... `$endfor$`. Menggunakan loop untuk memproses daftar bahasa lain yang didefinisikan dalam variabel `babel-otherlangs`. Untuk setiap bahasa dalam daftar, menggunakan `\babelprovide[import]{$babel-otherlangs$}` untuk mengimpor dukungan bahasa tersebut dari *package* `babel`. Bahasa-bahasa ini akan menjadi bahasa sekunder yang bisa digunakan dalam dokumen.
        *   **Konfigurasi *Font* Babel (`babelfonts`)**: `$for(babelfonts/pairs)$`... `$endfor$`. Menggunakan loop untuk memproses pasangan bahasa-*font* yang didefinisikan dalam variabel `babelfonts`. Untuk setiap pasangan, menggunakan `\babelfont[$babelfonts.key$]{rm}{$babelfonts.value$}` untuk mengatur *font* *roman* khusus untuk bahasa yang ditentukan (`$babelfonts.key$`) dengan *font* yang diberikan (`$babelfonts.value$`). Ini memungkinkan penggunaan *font* berbeda untuk bahasa yang berbeda dalam dokumen.
        *   **Menghilangkan *Shorthands* Bahasa**: `\let\LanguageShortHands\languageshorthands`, `\def\languageshorthands#1{}`. Kode ini bertujuan untuk menonaktifkan *shorthands* bahasa dari *package* `babel`. *Shorthands* adalah pintasan ketik tertentu yang dapat dipengaruhi oleh pengaturan bahasa dan terkadang bisa menimbulkan masalah. Menonaktifkannya dapat meningkatkan kompatibilitas atau mencegah perilaku yang tidak diinginkan.
        *   **Dukungan `selnolig` (Kondisional `selnolig-langs`)**: `$if(selnolig-langs)$`... `$endif$`. Jika variabel `selnolig-langs` didefinisikan (berisi daftar kode bahasa).
            *   **Pemilihan Engine TeX (Kondisional `LuaTeX`)**: `$ifLuaTeX`... `\fi`. Jika *engine* TeX adalah LuaTeX.
                *   **Memuat *Package* `selnolig`**: Memuat *package* `selnolig` (`\usepackage[$for(selnolig-langs)...$]{selnolig}`). Package `selnolig` digunakan untuk menonaktifkan *ligatures* ilegal untuk bahasa-bahasa tertentu. Daftar bahasa yang terpengaruh diambil dari variabel `selnolig-langs`. *Ligatures* adalah penggabungan karakter tertentu menjadi satu simbol (misalnya, "ff", "fi", "fl"). Dalam beberapa bahasa, *ligatures* tertentu mungkin dianggap tidak benar atau tidak diinginkan. `selnolig` membantu mengontrol perilaku *ligature* sesuai dengan aturan bahasa.
    *   **Jika `lang` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan bahasa Babel tidak aktif. Dokumen akan menggunakan pengaturan bahasa LaTeX *default* (biasanya English).
*   **Opsi Variabel `lang`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan bahasa Babel. Mengaktifkan variabel ini akan memicu konfigurasi bahasa Babel berdasarkan variabel-variabel terkait lainnya.
*   **Opsi Variabel `babel-lang`**: Variabel *string* yang berisi kode bahasa utama (misalnya, `"en"`, `"de"`, `"es"`, `"id"`). Menentukan bahasa utama dokumen.
*   **Opsi Variabel `mainfont`**: Variabel *string* yang berisi nama *font* utama untuk bahasa utama. Menentukan *font* *roman* yang akan digunakan untuk bahasa utama (hanya berpengaruh jika bukan PDFTeX).
*   **Opsi Variabel `mainfontoptions`**: Variabel *list* atau *string* yang berisi opsi *font* OpenType untuk *font* utama (misalnya, `"Ligatures=TeX"`, `"Numbers=OldStyle"`). Memungkinkan konfigurasi fitur *font* lanjutan.
*   **Opsi Variabel `mainfontfallback`**: Variabel *string* yang berisi nama *fallback font* untuk *font* utama. Digunakan sebagai *fallback* jika karakter tertentu tidak tersedia di *font* utama.
*   **Opsi Variabel `babel-otherlangs`**: Variabel *list* yang berisi kode bahasa untuk bahasa sekunder. Menentukan bahasa sekunder yang dukungannya perlu diimpor.
*   **Opsi Variabel `babelfonts`**: Variabel *map* atau *dictionary* yang memetakan kode bahasa ke nama *font*. Memungkinkan pengaturan *font* *roman* khusus untuk bahasa-bahasa tertentu.
*   **Opsi Variabel `selnolig-langs`**: Variabel *list* yang berisi kode bahasa yang *ligatures* ilegalnya harus dinonaktifkan.

##### 11. Pagestyle (Gaya Halaman)

```latex
$-- pagestyle
$--
$if(pagestyle)$
\pagestyle{$pagestyle$}
$endif$
```

*   **Tujuan**: Mengatur gaya halaman dokumen. Gaya halaman menentukan elemen-elemen yang muncul di *header* dan *footer* setiap halaman (misalnya, nomor halaman, judul bab, dll.).
*   **Variabel Pandoc**: `pagestyle`
    *   **Jika `pagestyle` didefinisikan**: Menggunakan perintah `\pagestyle{$pagestyle$}` untuk mengatur gaya halaman dokumen. Nilai variabel `pagestyle` akan langsung dimasukkan sebagai argumen ke perintah `\pagestyle`.
    *   **Jika `pagestyle` tidak didefinisikan**: Tidak melakukan apa pun. Gaya halaman akan menggunakan gaya *default* kelas dokumen yang digunakan (biasanya `plain`).
*   **Opsi Variabel `pagestyle`**: Variabel *string* yang berisi nama gaya halaman LaTeX (misalnya, `"plain"`, `"empty"`, `"headings"`, `"myheadings"`). Menentukan gaya halaman dokumen.

##### 12. Prevent Overfull Lines (Mencegah Baris yang Terlalu Panjang)

```latex
$-- prevent overfull lines
$--
\setlength{\emergencystretch}{3em} % prevent overfull lines
```

*   **Tujuan**: Mencegah *overfull lines* (baris yang terlalu panjang dan keluar dari margin kanan halaman). *Overfull lines* sering terjadi ketika LaTeX tidak dapat memutus baris dengan baik, misalnya pada URL panjang atau teks tanpa spasi.
*   **Perintah LaTeX**: `\setlength{\emergencystretch}{3em}`
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Kode ini selalu diterapkan.
*   **Penjelasan**: Mengatur nilai `\emergencystretch` menjadi `3em`. `\emergencystretch` adalah jumlah tambahan *stretchability* (kemampuan untuk meregang) yang diperbolehkan LaTeX untuk spasi antar kata ketika mencoba menghindari *overfull lines*. Nilai `3em` memberikan LaTeX lebih banyak fleksibilitas untuk meregangkan spasi dan memutus baris dengan lebih baik, sehingga mengurangi kemungkinan terjadinya *overfull lines*.

##### 13. Tight Lists (Daftar Padat/Rapat)

```latex
$-- tight lists
$--
\providecommand{\tightlist}{%
  \setlength{\itemsep}{0pt}\setlength{\parskip}{0pt}}
```

*   **Tujuan**: Menyediakan perintah `\tightlist` untuk membuat daftar item yang lebih rapat/padat, mengurangi jarak vertikal antar item dan antar paragraf dalam item daftar. Fitur ini biasanya digunakan untuk daftar tanpa banyak teks dalam setiap item.
*   **Perintah LaTeX**: `\providecommand{\tightlist}{...}`
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Perintah `\tightlist` selalu didefinisikan.
*   **Penjelasan**: Mendefinisikan perintah baru bernama `\tightlist` menggunakan `\providecommand`. `\providecommand` memastikan bahwa perintah hanya didefinisikan jika belum didefinisikan sebelumnya. Definisi perintah `\tightlist` adalah:
    *   `\setlength{\itemsep}{0pt}`: Mengatur jarak vertikal antar item daftar menjadi 0pt.
    *   `\setlength{\parskip}{0pt}`: Mengatur jarak antar paragraf di dalam setiap item daftar menjadi 0pt.
    Untuk menggunakan *tight list*, perintah `\tightlist` harus dipanggil di awal lingkungan daftar (misalnya, `\begin{itemize}\tightlist ... \end{itemize}`).

##### 14. Subfigure Support (Dukungan Subfigure)

```latex
$-- subfigure support
$--
$if(subfigure)$
\usepackage{subcaption}
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk membuat *subfigure* atau *subcaption* (gambar atau *float* yang ditempatkan berdampingan dalam satu lingkungan `figure` utama dengan *caption* masing-masing).
*   **Package**: `subcaption`
*   **Variabel Pandoc**: `subfigure`
    *   **Jika `subfigure` didefinisikan**: Memuat *package* `subcaption` (`\usepackage{subcaption}`). Package ini menyediakan lingkungan dan perintah untuk membuat *subfigure*, seperti lingkungan `subfigure` dan perintah `\subcaptionbox`, `\subcaption`, dll.
    *   **Jika `subfigure` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan *subfigure* tidak aktif.
*   **Opsi Variabel `subfigure`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan *subfigure*.

##### 15. Text Direction Support for pdftex (Dukungan Arah Teks untuk pdftex)

```latex
$-- text direction support for pdftex
$--
$if(dir)$
\ifPDFTeX
  \TeXXeTstate=1
  \newcommand{\RL}[1]{\beginR #1\endR}
  \newcommand{\LR}[1]{\beginL #1\endL}
  \newenvironment{RTL}{\beginR}{\endR}
  \newenvironment{LTR}{\beginL}{\endL}
\fi
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk arah teks kanan-ke-kiri (RTL) dan kiri-ke-kanan (LTR) dalam dokumen yang dikompilasi dengan PDFTeX *engine*. Ini penting untuk bahasa seperti Arab atau Ibrani yang ditulis dari kanan ke kiri.
*   **Perintah LaTeX**: `\TeXXeTstate=1`, `\newcommand{\RL}[1]{\beginR #1\endR}`, `\newcommand{\LR}[1]{\beginL #1\endL}`, `\newenvironment{RTL}{...}{...}`, `\newenvironment{LTR}{...}{...}`
*   **Variabel Pandoc**: `dir`
    *   **Jika `dir` didefinisikan**: Mengaktifkan dukungan arah teks.
        *   **Kondisional PDFTeX**: `$ifPDFTeX`... `\fi`. Kode di dalamnya hanya dijalankan jika *engine* TeX adalah PDFTeX. Dukungan arah teks mungkin diurus secara berbeda atau tidak diperlukan untuk *engine* lain seperti XeTeX atau LuaTeX, yang memiliki dukungan *bidirectional* lebih baik secara *native*.
        *   `\TeXXeTstate=1`: Mengaktifkan ekstensi TeX-eT dalam PDFTeX. Ekstensi ini diperlukan untuk perintah-perintah arah teks (`\beginR`, `\endR`, `\beginL`, `\endL`).
        *   **Definisi Perintah `\RL` dan `\LR`**: Mendefinisikan perintah pendek untuk beralih arah teks:
            *   `\RL{...}`: Menampilkan teks di dalam kurung kurawal dalam arah kanan-ke-kiri.
            *   `\LR{...}`: Menampilkan teks di dalam kurung kurawal dalam arah kiri-ke-kanan.
        *   **Definisi Lingkungan `RTL` dan `LTR`**: Mendefinisikan lingkungan untuk mengubah arah teks untuk blok teks yang lebih besar:
            *   `\begin{RTL} ... \end{RTL}`: Menampilkan konten lingkungan dalam arah kanan-ke-kiri.
            *   `\begin{LTR} ... \end{LTR}`: Menampilkan konten lingkungan dalam arah kiri-ke-kanan.
    *   **Jika `dir` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan arah teks tidak aktif. Dokumen diasumsikan ditulis dalam arah kiri-ke-kanan.
*   **Opsi Variabel `dir`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan arah teks untuk PDFTeX.

##### 16. Bibliography Support for natbib and biblatex (Dukungan Bibliografi untuk natbib dan biblatex)

Bagian ini mengatur dukungan untuk bibliografi menggunakan *package*-*package* `natbib` dan `biblatex`:

```latex
$-- bibliography support support for natbib and biblatex
$--
$if(natbib)$
\usepackage[$natbiboptions$]{natbib}
\bibliographystyle{$if(biblio-style)$$biblio-style$$else$plainnat$endif$}
$endif$
$if(biblatex)$
\usepackage[$if(biblio-style)$style=$biblio-style$,$endif$$for(biblatexoptions)$$biblatexoptions$$sep$,$endfor$]{biblatex}
$for(bibliography)$
\addbibresource{$bibliography$}
$endfor$
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk mengelola bibliografi dan sitasi menggunakan dua *package* bibliografi LaTeX yang populer: `natbib` dan `biblatex`. Template memungkinkan penggunaan salah satu dari keduanya, tetapi tidak keduanya sekaligus (berdasarkan kode ini).
*   **Packages**: `natbib`, `biblatex`
*   **Variabel Pandoc**: `natbib`, `natbiboptions`, `biblio-style`, `biblatex`, `biblatexoptions`, `bibliography`
    *   **Dukungan `natbib` (Kondisional)**: `$if(natbib)$`... `$endif$`. Jika variabel `natbib` didefinisikan.
        *   **Memuat *Package* `natbib`**: Memuat *package* `natbib` dengan opsi yang diambil dari variabel `natbiboptions` (`\usepackage[$natbiboptions$]{natbib}`). Variabel `natbiboptions` bisa berisi daftar opsi untuk *package* `natbib` (misalnya, `numbers,compress`).
        *   **Mengatur Gaya Bibliografi `natbib`**: Menggunakan `\bibliographystyle{$if(biblio-style)$$biblio-style$$else$plainnat$endif$}` untuk mengatur gaya bibliografi yang akan digunakan. Jika variabel `biblio-style` didefinisikan, nilainya digunakan sebagai nama *style* bibliografi (misalnya, `"apalike"`, `"unsrt"`). Jika tidak, gaya *default* adalah `"plainnat"` (gaya *numeric* dengan sitasi *author-year*).
    *   **Dukungan `biblatex` (Kondisional)**: `$if(biblatex)$`... `$endif$`. Jika variabel `biblatex` didefinisikan.
        *   **Memuat *Package* `biblatex`**: Memuat *package* `biblatex` dengan opsi. Opsi *style* bibliografi diambil dari variabel `biblio-style` (`style=$biblio-style$`, hanya jika `biblio-style` didefinisikan). Opsi lain diambil dari variabel `biblatexoptions` (`$for(biblatexoptions)...$`). Variabel `biblatexoptions` bisa berisi daftar opsi *package* `biblatex` (misalnya, `backend=biber`, `sorting=ynt`).
        *   **Menambahkan Sumber Bibliografi**: `$for(bibliography)$`... `$endfor$`. Menggunakan loop untuk memproses daftar file bibliografi yang didefinisikan dalam variabel `bibliography`. Untuk setiap file bibliografi dalam daftar, menggunakan `\addbibresource{$bibliography$}` untuk memberitahu *package* `biblatex` untuk menggunakan file tersebut sebagai sumber data bibliografi. File-file bibliografi biasanya dalam format BibTeX (`.bib`) atau BibLaTeX (`.bib`).
    *   **Tidak Mungkin Menggunakan `natbib` dan `biblatex` Bersamaan**: Kode ini dirancang agar hanya salah satu dari `natbib` atau `biblatex` yang diaktifkan, berdasarkan apakah variabel `natbib` atau `biblatex` didefinisikan.
*   **Opsi Variabel `natbib`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan dukungan bibliografi menggunakan *package* `natbib`.
*   **Opsi Variabel `natbiboptions`**: Variabel *string* atau *list* yang berisi opsi untuk *package* `natbib` (misalnya, `"numbers,compress"`, `authoryear`).
*   **Opsi Variabel `biblio-style`**: Variabel *string* yang berisi nama gaya bibliografi (misalnya, `"plainnat"`, `"apalike"` untuk `natbib`, atau *style* `biblatex` seperti `"numeric"`, `"authoryear"`). Menentukan gaya sitasi dan daftar pustaka.
*   **Opsi Variabel `biblatex`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan dukungan bibliografi menggunakan *package* `biblatex`.
*   **Opsi Variabel `biblatexoptions`**: Variabel *string* atau *list* yang berisi opsi untuk *package* `biblatex` (misalnya, `"backend=biber"`, `"sorting=ynt"`, `"citestyle=authoryear"`).
*   **Opsi Variabel `bibliography`**: Variabel *list* yang berisi daftar nama file bibliografi (misalnya, `["references.bib"]`, `["sources.bib", "my_refs.bib"]`). Menentukan file-file yang berisi data bibliografi.

##### 17. csquotes

```latex
$-- csquotes
$--
$if(csquotes)$
\usepackage{csquotes}
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk *smart quotes* (tanda kutip cerdas) dan perintah terkait kutipan lainnya menggunakan *package* `csquotes`. *Smart quotes* secara otomatis menggunakan tanda kutip yang benar berdasarkan konteks dan bahasa (misalnya, tanda kutip tunggal/ganda, arah kutipan). *Package* ini juga menyediakan perintah untuk jenis kutipan lain, seperti *block quotes*.
*   **Package**: `csquotes`
*   **Variabel Pandoc**: `csquotes`
    *   **Jika `csquotes` didefinisikan**: Memuat *package* `csquotes` (`\usepackage{csquotes}`).
    *   **Jika `csquotes` tidak didefinisikan**: Tidak melakukan apa pun. Dukungan *smart quotes* dan perintah `csquotes` lainnya tidak aktif. Dokumen akan menggunakan tanda kutip LaTeX *default*.
*   **Opsi Variabel `csquotes`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan *smart quotes* dan *package* `csquotes`.

---

**Variabel Pandoc yang Dapat Digunakan (YAML) untuk `common.latex`:**

Berikut adalah daftar variabel Pandoc yang relevan dari file `common.latex` dan opsi yang mungkin (sudah termasuk yang dijelaskan di atas dan diringkas):

*   **`linestretch`**: *Boolean*. Mengontrol apakah `\setstretch{1.2}` diterapkan (*default* jika tidak didefinisikan).
*   **`indent`**: *Boolean*. Jika *false*, menghilangkan indentasi paragraf dan menambahkan jarak antar paragraf.
*   **`block-headings`**: *Boolean*. Membuat `\paragraph` dan `\subparagraph` selalu *block headings*.
*   **`verbatim-in-note`**: *Boolean*. Mengaktifkan dukungan *verbatim* dalam catatan kaki (memerlukan *package* `fancyvrb`).
*   **`listings`**: *Boolean*. Mengaktifkan *highlighting* kode dasar menggunakan *package* `listings`.
*   **`listings-no-page-break`**: *Boolean*. Mencegah patah halaman di dalam *listing* kode.
*   **`lhs`**: *Boolean*. Mendefinisikan lingkungan `code` khusus untuk kode Haskell.
*   **`highlighting-macros`**: *Boolean*. Mengaktifkan makro *highlighting* tambahan dan perbaikan *line breaking*.
*   **`code-block-font-size`**: *String* (ukuran *font* LaTeX). Menentukan ukuran *font* untuk blok kode dengan *highlighting-macros* aktif.
*   **`tables`**: *Boolean*. Mengaktifkan dukungan tabel (memuat *package* `longtable`, `booktabs`, `array`).
*   **`multirow`**: *Boolean*. Mengaktifkan dukungan `multirow` dalam tabel.
*   **`float-placement-figure`**: *String* (opsi penempatan *float* LaTeX). Menentukan penempatan *default* untuk `figure`.
*   **`svg`**: *Boolean*. Mengaktifkan dukungan file SVG.
*   **`strikeout`**: *Boolean*. Mengaktifkan dukungan *strikeout* (dan *underline*).
*   **`beamer`**: *Boolean*. Menandakan dokumen adalah presentasi Beamer (mempengaruhi format paragraf, tabel, *strikeout*).
*   **`CJKmainfont`**: *Boolean*. Menandakan penggunaan *font* utama CJK (mempengaruhi *strikeout* di XeTeX).
*   **`csl-refs`**: *Boolean*. Mengaktifkan dukungan sitasi CSL (*citeproc*).
*   **`lang`**: *Boolean*. Mengaktifkan dukungan bahasa Babel.
*   **`babel-lang`**: *String* (kode bahasa). Bahasa utama dokumen.
*   **`mainfont`**: *String* (nama *font*). *Font* utama untuk bahasa utama (non-PDFTeX).
*   **`mainfontoptions`**: *List*/*String* (opsi *font* OpenType). Opsi *font* untuk *font* utama.
*   **`mainfontfallback`**: *String* (nama *font*). *Fallback font* untuk *font* utama.
*   **`babel-otherlangs`**: *List* (kode bahasa). Bahasa sekunder.
*   **`babelfonts`**: *Map* (kode bahasa -> nama *font*). *Font* khusus bahasa.
*   **`selnolig-langs`**: *List* (kode bahasa). Bahasa yang *ligature* ilegalnya dinonaktifkan.
*   **`pagestyle`**: *String* (gaya halaman LaTeX). Gaya halaman dokumen.
*   **`dir`**: *Boolean*. Mengaktifkan dukungan arah teks (RTL/LTR) untuk PDFTeX.
*   **`natbib`**: *Boolean*. Mengaktifkan dukungan bibliografi `natbib`.
*   **`natbiboptions`**: *String*/*List* (opsi `natbib`). Opsi untuk *package* `natbib`.
*   **`biblio-style`**: *String* (nama gaya bibliografi). Gaya bibliografi (untuk `natbib` atau `biblatex`).
*   **`biblatex`**: *Boolean*. Mengaktifkan dukungan bibliografi `biblatex`.
*   **`biblatexoptions`**: *String*/*List* (opsi `biblatex`). Opsi untuk *package* `biblatex`.
*   **`bibliography`**: *List* (nama file bibliografi). File bibliografi.
*   **`csquotes`**: *Boolean*. Mengaktifkan dukungan *smart quotes* (*package* `csquotes`).

---