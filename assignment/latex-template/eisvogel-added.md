# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `eisvogel-added.latex`

File `eisvogel-added.latex` berisi konfigurasi LaTeX tambahan yang spesifik untuk template "Eisvogel" ini. File ini mengatur aspek-aspek seperti *background* halaman, halaman judul, *geometry* halaman, gaya *caption*, *blockquote*, *font*, warna *heading*, variabel judul/penulis/tanggal, gaya tabel dan *listing*, serta *header* dan *footer* halaman. File ini secara signifikan memperluas kemampuan visual dan estetika template.

Berikut adalah isi file `eisvogel-added.latex` dan penjelasannya per bagian:

```latex
$if(page-background)$
\usepackage[pages=all]{background}
$endif$

%
% for the background color of the title page
%
$if(titlepage)$
\usepackage{pagecolor}
\usepackage{afterpage}
$if(titlepage-background)$
\usepackage{tikz}
$endif$
$if(geometry)$
$else$
\usepackage[margin=2.5cm,includehead=true,includefoot=true,centering]{geometry}
$endif$
$endif$

%
% break urls
%
\PassOptionsToPackage{hyphens}{url}

%
% When using babel or polyglossia with biblatex, loading csquotes is recommended
% to ensure that quoted texts are typeset according to the rules of your main language.
%
\usepackage{csquotes}

%
% captions
%
\definecolor{caption-color}{HTML}{777777}
\usepackage[font={stretch=1.2}, textfont={color=caption-color}, position=top, skip=4mm, labelfont=bf, singlelinecheck=false, justification=$if(caption-justification)$$caption-justification$$else$raggedright$endif$]{caption}
\setcapindent{0em}

%
% blockquote
%
\definecolor{blockquote-border}{RGB}{221,221,221}
\definecolor{blockquote-text}{RGB}{119,119,119}
\usepackage{mdframed}
\newmdenv[rightline=false,bottomline=false,topline=false,linewidth=3pt,linecolor=blockquote-border,skipabove=\parskip]{customblockquote}
\renewenvironment{quote}{\begin{customblockquote}\list{}{\rightmargin=0em\leftmargin=0em}%
\item\relax\color{blockquote-text}\ignorespaces}{\unskip\unskip\endlist\end{customblockquote}}

%
% Source Sans Pro as the default font family
% Source Code Pro for monospace text
%
% 'default' option sets the default
% font family to Source Sans Pro, not \sfdefault.
%
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  $if(fontfamily)$
  $else$
  \usepackage[default]{sourcesanspro}
  \usepackage{sourcecodepro}
  $endif$
\else % if not pdftex
  $if(mainfont)$
  $else$
  \usepackage[default]{sourcesanspro}
  \usepackage{sourcecodepro}

  % XeLaTeX specific adjustments for straight quotes: [https://tex.stackexchange.com/a/354887](https://tex.stackexchange.com/a/354887)
  % This issue is already fixed (see [https://github.com/silkeh/latex-sourcecodepro/pull/5](https://github.com/silkeh/latex-sourcecodepro/pull/5)) but the
  % fix is still unreleased.
  % TODO: Remove this workaround when the new version of sourcecodepro is released on CTAN.
  \ifxetex
    \makeatletter
    \defaultfontfeatures[\ttfamily]
      { Numbers    = \sourcecodepro@figurestyle,
        Scale      = \SourceCodePro@scale,
        Extension = .otf }
    \setmonofont
      [ UprightFont    = *-\sourcecodepro@regstyle,
        ItalicFont      = *-\sourcecodepro@regstyle It,
        BoldFont        = *-\sourcecodepro@boldstyle,
        BoldItalicFont = *-\sourcecodepro@boldstyle It ]
      {SourceCodePro}
    \makeatother
  \fi
  $endif$
\fi

%
% heading color
%
\definecolor{heading-color}{RGB}{40,40,40}
\addtokomafont{section}{\color{heading-color}}
% When using the classes report, scrreprt, book,
% scrbook or memoir, uncomment the following line.
%\addtokomafont{chapter}{\color{heading-color}}

%
% variables for title, author and date
%
\usepackage{titling}
\title{$title$}
\author{$for(author)$$author$$sep$, $endfor$}
\date{$date$}

%
% tables
%
$if(tables)$

\definecolor{table-row-color}{HTML}{F5F5F5}
\definecolor{table-rule-color}{HTML}{999999}

%\arrayrulecolor{black!40}
\arrayrulecolor{table-rule-color}     % color of \toprule, \midrule, \bottomrule
\setlength\heavyrulewidth{0.3ex}      % thickness of \toprule, \bottomrule
\renewcommand{\arraystretch}{1.3}      % spacing (padding)
\newcolumntype{P}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}}

$if(table-use-row-colors)$
% Unfortunately the colored cells extend beyond the edge of the
% table because pandoc uses @-expressions (@{}) like so:
%
% \begin{longtable}[]{@{}ll@{}}
% \end{longtable}
%
% [https://en.wikibooks.org/wiki/LaTeX/Tables#.40-expressions](https://en.wikibooks.org/wiki/LaTeX/Tables#.40-expressions)
\usepackage{etoolbox}
\AtBeginEnvironment{longtable}{\rowcolors{2}{}{table-row-color!100}}
\preto{\toprule}{\hiderowcolors}{}{}
\appto{\endhead}{\showrowcolors}{}{}
\appto{\endfirsthead}{\showrowcolors}{}{}
$endif$
$endif$

%
% remove paragraph indentation
%
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}
\setlength{\emergencystretch}{3em}  % prevent overfull lines

%
%
% Listings
%
%

$if(listings)$

%
% general listing colors
%
\definecolor{listing-background}{HTML}{F7F7F7}
\definecolor{listing-rule}{HTML}{B3B2B3}
\definecolor{listing-numbers}{HTML}{B3B2B3}
\definecolor{listing-text-color}{HTML}{000000}
\definecolor{listing-keyword}{HTML}{435489}
\definecolor{listing-keyword-2}{HTML}{1284CA} % additional keywords
\definecolor{listing-keyword-3}{HTML}{9137CB} % additional keywords
\definecolor{listing-identifier}{HTML}{435489}
\definecolor{listing-string}{HTML}{00999A}
\definecolor{listing-comment}{HTML}{8E8E8E}

\lstdefinestyle{eisvogel_listing_style}{
  language        = java,
$if(listings-disable-line-numbers)$
  xleftmargin     = 0.6em,
  framexleftmargin = 0.4em,
$else$
  numbers         = left,
  xleftmargin     = 2.7em,
  framexleftmargin = 2.5em,
$endif$
  backgroundcolor = \color{listing-background},
  basicstyle      = \color{listing-text-color}\linespread{1.0}%
                    \lst@ifdisplaystyle%
                    $if(code-block-font-size)$$code-block-font-size$$else$\small$endif$%
                    \fi\ttfamily{},
  breaklines      = true,
  frame           = single,
  framesep        = 0.19em,
  rulecolor       = \color{listing-rule},
  frameround      = ffff,
  tabsize         = 4,
  numberstyle     = \color{listing-numbers},
  aboveskip       = 1.0em,
  belowskip       = 0.1em,
  abovecaptionskip = 0em,
  belowcaptionskip = 1.0em,
  keywordstyle    = {\color{listing-keyword}\bfseries},
  keywordstyle    = {[2]\color{listing-keyword-2}\bfseries},
  keywordstyle    = {[3]\color{listing-keyword-3}\bfseries\itshape},
  sensitive       = true,
  identifierstyle = \color{listing-identifier},
  commentstyle    = \color{listing-comment},
  stringstyle     = \color{listing-string},
  showstringspaces = false,
  escapeinside      = {/*@}{@*/}, % Allow LaTeX inside these special comments
  literate        =
  {á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
  {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
  {à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
  {À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\'I}}1 {Ò}{{\'O}}1 {Ù}{{\`U}}1
  {ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\"o}}1 {ü}{{\"u}}1
  {Ä}{{\"A}}1 {Ë}{{\"E}}1 {Ï}{{\'I}}1 {Ö}{{\'O}}1 {Ü}{{\'U}}1
  {â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
  {Â}{{\^A}}1 {Ê}{{\^E}}1 {Î}{{\^I}}1 {Ô}{{\^O}}1 {Û}{{\'U}}1
  {œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
  {ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
  {€}{{\EUR}}1 {£}{{\pounds}}1 {«}{{\guillemotleft}}1
  {»}{{\guillemotright}}1 {ñ}{{\~n}}1 {Ñ}{{\~N}}1 {¿}{{?`}}1
  {…}{{\ldots}}1 {≥}{{>=}}1 {≤}{{<=}}1 {„}{{\glqq}}1 {“}{{\grqq}}1
  {”}{{''}}1
}
\lstset{style=eisvogel_listing_style}

%
% Java (Java SE 12, 2019-06-22)
%
\lstdefinelanguage{Java}{
  morekeywords={
    % normal keywords (without data types)
    abstract,assert,break,case,catch,class,continue,default,
    do,else,enum,exports,extends,final,finally,for,if,implements,
    import,instanceof,interface,module,native,new,package,private,
    protected,public,requires,return,static,strictfp,super,switch,
    synchronized,this,throw,throws,transient,try,volatile,while,
    % var is an identifier
    var
  },
  morekeywords={[2] % data types
    % primitive data types
    boolean,byte,char,double,float,int,long,short,
    % String
    String,
    % primitive wrapper types
    Boolean,Byte,Character,Double,Float,Integer,Long,Short
    % number types
    Number,AtomicInteger,AtomicLong,BigDecimal,BigInteger,DoubleAccumulator,DoubleAdder,LongAccumulator,LongAdder,Short,
    % other
    Object,Void,void
  },
  morekeywords={[3] % literals
    % reserved words for literal values
    null,true,false,
  },
  sensitive,
  morecomment   = [l]//,
  morecomment   = [s]{/*}{*/},
  morecomment   = [s]{/**}{*/},
  morestring    = [b]",
  morestring    = [b]',
}

\lstdefinelanguage{XML}{
  morestring      = [b]",
  moredelim       = [s][\bfseries\color{listing-keyword}]{<}{\ },
  moredelim       = [s][\bfseries\color{listing-keyword}]{</}{>},
  moredelim       = [l][\bfseries\color{listing-keyword}]{/>},
  moredelim       = [l][\bfseries\color{listing-keyword}]{>},
  morecomment     = [s]{<?}{?>},
  morecomment     = [s]{},
  commentstyle    = \color{listing-comment},
  stringstyle     = \color{listing-string},
  identifierstyle = \color{listing-identifier}
}
$endif$

%
% header and footer
%
$if(disable-header-and-footer)$
$else$
\usepackage[headsepline,footsepline]{scrlayer-scrpage}

\newpairofpagestyles{eisvogel-header-footer}{
  \clearpairofpagestyles
  \ihead*{$if(header-left)$$header-left$$else$$title$$endif$}
  \chead*{$if(header-center)$$header-center$$else$$endif$}
  \ohead*{$if(header-right)$$header-right$$else$$date$$endif$}
  \ifoot*{$if(footer-left)$$footer-left$$else$$for(author)$$author$$sep$, $endfor$$endif$}
  \cfoot*{$if(footer-center)$$footer-center$$else$$endif$}
  \ofoot*{$if(footer-right)$$footer-right$$else$\thepage$endif$}
  \addtokomafont{pageheadfoot}{\upshape}
}
\pagestyle{eisvogel-header-footer}

$if(book)$
\deftripstyle{ChapterStyle}{}{}{}{}{\pagemark}{}
\renewcommand*{\chapterpagestyle}{ChapterStyle}
$endif$

$if(page-background)$
\backgroundsetup{
scale=1,
color=black,
opacity=$if(page-background-opacity)$$page-background-opacity$$else$0.2$endif$,
angle=0,
contents={%
  \includegraphics[width=\paperwidth,height=\paperheight]{$page-background$}
  }%
}
$endif$
$endif$
```

#### Penjelasan per Bagian dari `eisvogel-added.latex`:

##### 1. Page Background Color (Warna Latar Belakang Halaman)

```latex
$if(page-background)$
\usepackage[pages=all]{background}
$endif$
```

*   **Tujuan**: Menambahkan latar belakang berwarna pada seluruh halaman dokumen.
*   **Package**: `background`
*   **Variabel Pandoc**: `page-background`
    *   **Jika `page-background` didefinisikan**: Memuat *package* `background` dengan opsi `pages=all` (`\usepackage[pages=all]{background}`). Package `background` digunakan untuk menambahkan elemen latar belakang pada halaman, dan `pages=all` memastikan latar belakang diterapkan ke semua halaman. Kode ini, dalam konteks `eisvogel-added.latex`, sepertinya hanya menyiapkan *package* dan tidak secara langsung mengatur warna latar belakang. Pengaturan warna latar belakang mungkin diatur lebih lanjut di bagian lain (misalnya, menggunakan opsi *package* atau perintah lain dari *package* `background`). *Namun, setelah melihat bagian terakhir (Page Background Image), sepertinya variabel `page-background` lebih ditujukan untuk gambar latar belakang, dan warna latar belakang mungkin diatur secara implisit oleh gambar itu sendiri atau pengaturan *default* package.*
    *   **Jika `page-background` tidak didefinisikan**: Tidak melakukan apa pun. Latar belakang halaman *default* (biasanya putih) akan digunakan.
*   **Opsi Variabel `page-background`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan kemampuan untuk menambahkan latar belakang halaman (dengan memuat *package* `background`). *Namun, berdasarkan konteks keseluruhan, sepertinya variabel ini lebih mengontrol apakah gambar latar belakang halaman akan digunakan, bukan hanya warna. Opsi warna latar belakang mungkin tidak langsung dikontrol oleh variabel ini.*

##### 2. Title Page Background Color (Warna Latar Belakang Halaman Judul)

```latex
%
% for the background color of the title page
%
$if(titlepage)$
\usepackage{pagecolor}
\usepackage{afterpage}
$if(titlepage-background)$
\usepackage{tikz}
$endif$
$if(geometry)$
$else$
\usepackage[margin=2.5cm,includehead=true,includefoot=true,centering]{geometry}
$endif$
$endif$
```

*   **Tujuan**: Mengatur warna latar belakang khusus untuk halaman judul.
*   **Packages**: `pagecolor`, `afterpage`, `tikz` (opsional), `geometry` (opsional)
*   **Variabel Pandoc**: `titlepage`, `titlepage-background`, `geometry`
    *   **Kondisi `titlepage`**: `$if(titlepage)$`... `$endif$`. Bagian ini hanya aktif jika halaman judul diaktifkan (variabel `titlepage` didefinisikan).
        *   **Memuat *Package* `pagecolor` dan `afterpage`**: Memuat *package* `pagecolor` (`\usepackage{pagecolor}`) dan `afterpage` (`\usepackage{afterpage}`).
            *   `pagecolor`: Digunakan untuk mengubah warna latar belakang halaman.
            *   `afterpage`: Digunakan untuk menunda perintah LaTeX hingga setelah halaman saat ini selesai diproses. Ini penting karena pengaturan warna halaman untuk halaman judul perlu diterapkan *setelah* halaman judul dibuat.
        *   **Dukungan `titlepage-background` (Kondisional)**: `$if(titlepage-background)$`... `$endif$`. Jika variabel `titlepage-background` juga didefinisikan.
            *   **Memuat *Package* `tikz`**: Memuat *package* `tikz` (`\usepackage{tikz}`). `tikz` adalah *package* grafis yang sangat kuat dan fleksibel di LaTeX. Dalam konteks ini, `tikz` kemungkinan digunakan untuk menggambar atau mengisi warna latar belakang halaman judul dengan lebih kompleks (misalnya, gradien, pola, atau bentuk tertentu). *Namun, kode untuk benar-benar mengatur warna latar belakang halaman judul (menggunakan perintah `\pagecolor` atau `tikz` commands) tidak terlihat di potongan kode ini. Pengaturan warna kemungkinan dilakukan di file template lain atau melalui makro yang didefinisikan di tempat lain.*
        *   **Pengaturan *Geometry* Halaman (Kondisional `geometry`)**: `$if(geometry)$`... `$else$ ... `$endif$`.
            *   **Jika `geometry` didefinisikan**: Tidak melakukan apa pun. Diasumsikan *geometry* halaman sudah diatur (mungkin di file `header.tex` atau `before-body.tex`).
            *   **Jika `geometry` tidak didefinisikan**: Memuat *package* `geometry` dengan pengaturan *default* (`\usepackage[margin=2.5cm,includehead=true,includefoot=true,centering]{geometry}`). Ini mengatur margin halaman menjadi 2.5cm di semua sisi, termasuk *header* dan *footer*, dan memusatkan halaman pada kertas. Pengaturan *geometry default* ini mungkin diterapkan hanya jika halaman judul diaktifkan dan *geometry* belum diatur secara eksplisit, untuk memastikan *layout* halaman judul yang baik.
    *   **Jika `titlepage` tidak didefinisikan**: Tidak melakukan apa pun. Warna latar belakang halaman judul *default* (biasanya putih) akan digunakan.
*   **Opsi Variabel `titlepage`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan halaman judul dan fitur terkait halaman judul, termasuk latar belakang halaman judul.
*   **Opsi Variabel `titlepage-background`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan penggunaan latar belakang halaman judul *khusus* (mungkin menggunakan `tikz`). *Meskipun kode untuk pengaturan warna sebenarnya tidak terlihat di sini.*
*   **Opsi Variabel `geometry`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Menandakan apakah *geometry* halaman sudah diatur secara eksternal. Jika tidak, *geometry default* akan diterapkan (hanya jika `titlepage` aktif).

##### 3. Break URLs (Pemutusan URL)

```latex
%
% break urls
%
\PassOptionsToPackage{hyphens}{url}
```

*   **Tujuan**: Memastikan URL dapat diputus baris dengan benar ketika terlalu panjang, menggunakan karakter *hyphen* (tanda hubung) di titik pemutusan.
*   **Perintah LaTeX**: `\PassOptionsToPackage{hyphens}{url}`
*   **Packages**: `url` (diasumsikan sudah dimuat oleh `after-header-includes.latex` atau template dasar Pandoc)
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Kode ini selalu diterapkan.
*   **Penjelasan**: Menggunakan `\PassOptionsToPackage{hyphens}{url}` untuk memberikan opsi `hyphens` ke *package* `url`. Opsi `hyphens` memberitahu *package* `url` untuk menggunakan tanda hubung saat memutus baris URL. Ini menghasilkan pemutusan URL yang lebih rapi dan mudah dibaca.

##### 4. `csquotes` Package (Package `csquotes`)

```latex
%
% When using babel or polyglossia with biblatex, loading csquotes is recommended
% to ensure that quoted texts are typeset according to the rules of your main language.
%
\usepackage{csquotes}
```

*   **Tujuan**: Memuat *package* `csquotes` untuk dukungan *smart quotes* dan kutipan yang tepat secara linguistik.
*   **Package**: `csquotes`
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Package `csquotes` selalu dimuat.
*   **Penjelasan**: Memuat *package* `csquotes` (`\usepackage{csquotes}`). Komentar dalam kode menjelaskan bahwa pemuatan *package* ini direkomendasikan saat menggunakan *package* `babel` atau `polyglossia` (untuk dukungan multibahasa) bersama dengan *package* `biblatex` (untuk bibliografi). Hal ini untuk memastikan bahwa tanda kutip diformat sesuai dengan aturan bahasa utama dokumen. *Sebenarnya, `csquotes` sudah dimuat secara kondisional di `common.latex` jika variabel `csquotes` diaktifkan. Pemanggilan `\usepackage{csquotes}` di sini mungkin redundan, atau untuk memastikan bahwa `csquotes` selalu dimuat di template Eisvogel, atau untuk memastikan urutan pemuatan package tertentu.*

##### 5. Captions (Caption/Keterangan Gambar dan Tabel)

```latex
%
% captions
%
\definecolor{caption-color}{HTML}{777777}
\usepackage[font={stretch=1.2}, textfont={color=caption-color}, position=top, skip=4mm, labelfont=bf, singlelinecheck=false, justification=$if(caption-justification)$$caption-justification$$else$raggedright$endif$]{caption}
\setcapindent{0em}
```

*   **Tujuan**: Mengatur gaya tampilan *caption* (keterangan gambar, tabel, dll.).
*   **Package**: `caption`
*   **Variabel Pandoc**: `caption-justification`
    *   **Definisi Warna `caption-color`**: `\definecolor{caption-color}{HTML}{777777}`. Mendefinisikan warna baru bernama `caption-color` menggunakan kode warna HTML `#777777` (abu-abu gelap). Warna ini akan digunakan untuk teks *caption*.
    *   **Memuat *Package* `caption` dengan Opsi**: `\usepackage[...] {caption}`. Memuat *package* `caption` dengan serangkaian opsi untuk mengatur gaya *caption*.
        *   `font={stretch=1.2}`: Mengatur *font stretch* (perenggangan *font*) *caption* menjadi 1.2. Ini sedikit melebarkan *font* *caption* secara horizontal.
        *   `textfont={color=caption-color}`: Mengatur warna teks *caption* menggunakan warna `caption-color` yang telah didefinisikan (abu-abu gelap).
        *   `position=top`: Menempatkan *caption* di atas *float* (gambar atau tabel).
        *   `skip=4mm`: Menambahkan jarak vertikal 4mm antara *caption* dan *float*.
        *   `labelfont=bf`: Mengatur *font* untuk *label* *caption* (misalnya, "Figure 1:", "Table 2:") menjadi tebal (*bold*).
        *   `singlelinecheck=false`: Menonaktifkan pemeriksaan *single line* untuk *caption*. Biasanya, *caption* satu baris akan dipusatkan. Opsi ini mencegah pemusatan dan memungkinkan *justification* diterapkan.
        *   `justification=$if(caption-justification)$$caption-justification$$else$raggedright$endif$`: Mengatur *justification* (perataan teks) untuk *caption*. Jika variabel `caption-justification` didefinisikan, nilainya digunakan. Jika tidak, *justification default* adalah `raggedright` (rata kiri, kanan tidak rata).
    *   **Pengaturan `capindent`**: `\setcapindent{0em}`. Mengatur indentasi baris pertama *caption* menjadi 0em (tanpa indentasi).
*   **Opsi Variabel `caption-justification`**: Variabel *string* yang berisi nilai *justification* LaTeX (misalnya, `"center"`, `"justified"`, `"raggedright"`, `"raggedleft"`). Menentukan perataan teks *caption*. Jika tidak didefinisikan, *default* adalah `raggedright`.

##### 6. Blockquote (Kutipan Blok)

```latex
%
% blockquote
%
\definecolor{blockquote-border}{RGB}{221,221,221}
\definecolor{blockquote-text}{RGB}{119,119,119}
\usepackage{mdframed}
\newmdenv[rightline=false,bottomline=false,topline=false,linewidth=3pt,linecolor=blockquote-border,skipabove=\parskip]{customblockquote}
\renewenvironment{quote}{\begin{customblockquote}\list{}{\rightmargin=0em\leftmargin=0em}%
\item\relax\color{blockquote-text}\ignorespaces}{\unskip\unskip\endlist\end{customblockquote}}
```

*   **Tujuan**: Mengatur gaya tampilan *blockquote* (kutipan panjang yang dipisahkan dari teks utama).
*   **Package**: `mdframed`
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Gaya *blockquote* selalu diterapkan seperti yang didefinisikan di sini.
    *   **Definisi Warna `blockquote-border` dan `blockquote-text`**:
        *   `\definecolor{blockquote-border}{RGB}{221,221,221}`: Mendefinisikan warna `blockquote-border` (abu-abu sangat terang) untuk garis batas *blockquote*.
        *   `\definecolor{blockquote-text}{RGB}{119,119,119}`: Mendefinisikan warna `blockquote-text` (abu-abu sedang) untuk teks di dalam *blockquote*.
    *   **Definisi Lingkungan `customblockquote`**: `\newmdenv[...] {customblockquote}`. Mendefinisikan lingkungan *mdframed* baru bernama `customblockquote` menggunakan `\newmdenv` dari *package* `mdframed`. Lingkungan `customblockquote` memiliki properti:
        *   `rightline=false,bottomline=false,topline=false`: Menghilangkan garis kanan, bawah, dan atas *frame* (hanya garis kiri yang akan terlihat sebagai penanda *blockquote*).
        *   `linewidth=3pt`: Lebar garis kiri *frame* adalah 3pt.
        *   `linecolor=blockquote-border`: Warna garis kiri *frame* menggunakan `blockquote-border` (abu-abu sangat terang).
        *   `skipabove=\parskip`: Menambahkan jarak vertikal di atas *blockquote* sebesar `\parskip` (jarak antar paragraf).
    *   **Redefinisi Lingkungan `quote`**: `\renewenvironment{quote}{...}{...}`. Mendefinisikan ulang lingkungan `quote` standar LaTeX. Lingkungan `quote` yang baru didefinisikan akan menggunakan lingkungan `customblockquote` sebagai *frame* dan mengatur gaya teks di dalamnya:
        *   `\begin{customblockquote}\list{}{\rightmargin=0em\leftmargin=0em}\item\relax\color{blockquote-text}\ignorespaces`: Memulai lingkungan `customblockquote`. Di dalamnya, memulai lingkungan `list` tanpa margin kiri dan kanan (`\list{}{...}`). Memulai item daftar (`\item\relax`) dan mengatur warna teks item menjadi `blockquote-text` (abu-abu sedang) menggunakan `\color{blockquote-text}`. `\ignorespaces` mengabaikan spasi di awal teks *blockquote*.
        *   `\unskip\unskip\endlist\end{customblockquote}`: Menutup lingkungan *list* (`\endlist`) dan lingkungan `customblockquote` (`\end{customblockquote}`). `\unskip\unskip` mungkin digunakan untuk menghilangkan spasi atau *skip* yang tidak diinginkan di akhir *blockquote*.
*   **Opsi Variabel `blockquote`**: Tidak ada variabel Pandoc yang langsung mengontrol gaya *blockquote* di bagian kode ini. Gaya *blockquote* *default* Eisvogel selalu diterapkan. Untuk mengubah gaya *blockquote*, kode LaTeX ini perlu dimodifikasi langsung.

##### 7. Font Setup (Pengaturan Font)

Bagian ini mengatur *font family* *default* menjadi Source Sans Pro dan *font monospace* menjadi Source Code Pro:

```latex
%
% Source Sans Pro as the default font family
% Source Code Pro for monospace text
%
% 'default' option sets the default
% font family to Source Sans Pro, not \sfdefault.
%
\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 % if pdftex
  $if(fontfamily)$
  $else$
  \usepackage[default]{sourcesanspro}
  \usepackage{sourcecodepro}
  $endif$
\else % if not pdftex
  $if(mainfont)$
  $else$
  \usepackage[default]{sourcesanspro}
  \usepackage{sourcecodepro}

  % XeLaTeX specific adjustments for straight quotes: [https://tex.stackexchange.com/a/354887](https://tex.stackexchange.com/a/354887)
  % This issue is already fixed (see [https://github.com/silkeh/latex-sourcecodepro/pull/5](https://github.com/silkeh/latex-sourcecodepro/pull/5)) but the
  % fix is still unreleased.
  % TODO: Remove this workaround when the new version of sourcecodepro is released on CTAN.
  \ifxetex
    \makeatletter
    \defaultfontfeatures[\ttfamily]
      { Numbers    = \sourcecodepro@figurestyle,
        Scale      = \SourceCodePro@scale,
        Extension = .otf }
    \setmonofont
      [ UprightFont    = *-\sourcecodepro@regstyle,
        ItalicFont      = *-\sourcecodepro@regstyle It,
        BoldFont        = *-\sourcecodepro@boldstyle,
        BoldItalicFont = *-\sourcecodepro@boldstyle It ]
      {SourceCodePro}
    \makeatother
  \fi
  $endif$
\fi
```

*   **Tujuan**: Mengatur *font family* *default* dokumen menjadi Source Sans Pro untuk teks utama dan Source Code Pro untuk teks *monospace* (kode, *verbatim*, dll.).
*   **Packages**: `sourcesanspro`, `sourcecodepro`
*   **Variabel Pandoc**: `fontfamily`, `mainfont`
    *   **Kondisi *Engine* TeX (PDFTeX vs. Lainnya)**: `\ifnum 0\ifxetex 1\fi\ifluatex 1\fi=0 ... \else ... \fi`. Memeriksa apakah *engine* TeX yang digunakan adalah PDFTeX. Jika PDFTeX, kondisi pertama dijalankan. Jika bukan (XeTeX atau LuaTeX), kondisi kedua dijalankan.
        *   **Jika PDFTeX**:
            *   **Kondisi `fontfamily`**: `$if(fontfamily)$`... `$else$ ... `$endif$`. Jika variabel `fontfamily` didefinisikan.
                *   **Jika `fontfamily` didefinisikan**: Tidak melakukan apa pun. Diasumsikan *font family* sudah diatur melalui variabel `fontfamily` (mungkin di file `header.tex` atau *command line*).
                *   **Jika `fontfamily` tidak didefinisikan**: Memuat *package* `sourcesanspro` dan `sourcecodepro` dengan opsi `default` (`\usepackage[default]{sourcesanspro}`, `\usepackage{sourcecodepro}`). Opsi `default` pada *package* `sourcesanspro` mengatur *font family* *default* dokumen menjadi Source Sans Pro. `sourcecodepro` menyediakan *font* Source Code Pro untuk teks *monospace*.
        *   **Jika Bukan PDFTeX (XeTeX atau LuaTeX)**:
            *   **Kondisi `mainfont`**: `$if(mainfont)$`... `$else$ ... `$endif$`. Jika variabel `mainfont` didefinisikan.
                *   **Jika `mainfont` didefinisikan**: Tidak melakukan apa pun. Diasumsikan *font* utama sudah diatur melalui variabel `mainfont` (mungkin di `header.tex` atau *command line*, dan kemungkinan menggunakan *package* *fontspec* atau serupa).
                *   **Jika `mainfont` tidak didefinisikan**: Memuat *package* `sourcesanspro` dan `sourcecodepro` dengan opsi `default` (sama seperti kasus PDFTeX).
                *   **Penyesuaian Khusus XeLaTeX untuk Tanda Kutip Lurus (Straight Quotes)**: `$ifxetex`... `\fi`. Jika *engine* TeX adalah XeTeX.
                    *   **Perbaikan *Font Monospace* untuk XeLaTeX**: Kode ini (menggunakan `\makeatletter`... `\makeatother`) adalah *workaround* atau perbaikan khusus untuk XeLaTeX dan *font* Source Code Pro. Komentar dalam kode merujuk ke masalah *straight quotes* (tanda kutip lurus) yang mungkin terjadi di versi *package* `sourcecodepro` yang lebih lama di XeLaTeX (masalahnya sudah diperbaiki di versi terbaru, tetapi *workaround* ini mungkin masih ada untuk kompatibilitas dengan versi lama atau sebagai tindakan pencegahan). Kode ini mengatur fitur *font* *default* untuk *font monospace* (`\ttfamily`) di XeLaTeX, khususnya terkait gaya angka (*Numbers*) dan skala (*Scale*) *font* Source Code Pro.
*   **Opsi Variabel `fontfamily`**: Variabel *string*. Menentukan *font family* *default* dokumen (hanya berpengaruh di PDFTeX jika didefinisikan).
*   **Opsi Variabel `mainfont`**: Variabel *string*. Menentukan *font* utama dokumen (hanya berpengaruh di XeTeX/LuaTeX jika didefinisikan).

##### 8. Heading Color (Warna Heading/Judul Bagian)

```latex
%
% heading color
%
\definecolor{heading-color}{RGB}{40,40,40}
\addtokomafont{section}{\color{heading-color}}
% When using the classes report, scrreprt, book,
% scrbook or memoir, uncomment the following line.
%\addtokomafont{chapter}{\color{heading-color}}
```

*   **Tujuan**: Mengatur warna teks untuk *heading* (judul bagian, subbagian, dll.). Secara *default* mengatur warna untuk *section* level. Ada baris yang dikomentari untuk mengatur warna *chapter* juga.
*   **Perintah LaTeX**: `\definecolor{heading-color}{RGB}{40,40,40}`, `\addtokomafont{section}{\color{heading-color}}`, `\addtokomafont{chapter}{\color{heading-color}}` (dikomentari)
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Warna *heading default* selalu diterapkan seperti yang didefinisikan di sini.
    *   **Definisi Warna `heading-color`**: `\definecolor{heading-color}{RGB}{40,40,40}`. Mendefinisikan warna `heading-color` (abu-abu gelap kehitaman) menggunakan kode RGB `(40,40,40)`.
    *   **Pengaturan Warna *Section* Level**: `\addtokomafont{section}{\color{heading-color}}`. Menggunakan `\addtokomafont` (dari kelas KOMA-Script, diasumsikan template menggunakan kelas KOMA-Script atau kelas yang kompatibel) untuk menambahkan perintah `\color{heading-color}` ke *font command* untuk *section* level. Ini berarti semua judul bagian level `\section` akan ditampilkan dengan warna `heading-color`.
    *   **Pengaturan Warna *Chapter* Level (Dikomentari)**: `%\addtokomafont{chapter}{\color{heading-color}}`. Baris ini dikomentari, tetapi jika di-*uncomment*, ini akan melakukan hal yang sama untuk judul *chapter* level: mengatur warna judul *chapter* menjadi `heading-color`. Komentar di atas baris ini menjelaskan bahwa baris ini sebaiknya di-*uncomment* jika menggunakan kelas dokumen `report`, `scrreprt`, `book`, `scrbook`, atau `memoir` (kelas dokumen yang memiliki level *chapter*).
*   **Opsi Variabel `heading-color`**: Tidak ada variabel Pandoc yang langsung mengontrol warna *heading* di bagian kode ini. Warna *heading default* Eisvogel selalu diterapkan. Untuk mengubah warna *heading*, kode LaTeX ini perlu dimodifikasi langsung.

##### 9. Variables for Title, Author and Date (Variabel untuk Judul, Penulis, dan Tanggal)

```latex
%
% variables for title, author and date
%
\usepackage{titling}
\title{$title$}
\author{$for(author)$$author$$sep$, $endfor$}
\date{$date$}
```

*   **Tujuan**: Menangani variabel Pandoc `$title`, `$author`, dan `$date` untuk judul dokumen, penulis, dan tanggal.
*   **Package**: `titling`
*   **Variabel Pandoc**: `title`, `author`, `date`
    *   **Memuat *Package* `titling`**: `\usepackage{titling}`. Memuat *package* `titling`. *Package* ini menyediakan kontrol lebih lanjut atas tampilan judul, penulis, dan tanggal dokumen.
    *   **Pengaturan Judul**: `\title{$title$}`. Menggunakan perintah `\title` (dari *package* `titling` atau kelas dokumen *default*) untuk mengatur judul dokumen. Nilai judul diambil dari variabel Pandoc `$title`.
    *   **Pengaturan Penulis**: `\author{$for(author)$$author$$sep$, $endfor$}`. Menggunakan perintah `\author` untuk mengatur penulis dokumen. Jika ada lebih dari satu penulis (daftar penulis dalam variabel `$author`), kode `$for(author)...$ $endfor$` adalah loop Pandoc yang akan menghasilkan daftar penulis yang dipisahkan koma dan spasi.
    *   **Pengaturan Tanggal**: `\date{$date$}`. Menggunakan perintah `\date` untuk mengatur tanggal dokumen. Nilai tanggal diambil dari variabel Pandoc `$date`.
*   **Opsi Variabel `title`**: Variabel *string*. Berisi judul dokumen.
*   **Opsi Variabel `author`**: Variabel *string* atau *list* *string*. Berisi nama penulis atau daftar nama penulis dokumen.
*   **Opsi Variabel `date`**: Variabel *string*. Berisi tanggal dokumen.

##### 10. Tables (Tabel)

Bagian ini mengatur gaya tabel secara detail:

```latex
%
% tables
%
$if(tables)$

\definecolor{table-row-color}{HTML}{F5F5F5}
\definecolor{table-rule-color}{HTML}{999999}

%\arrayrulecolor{black!40}
\arrayrulecolor{table-rule-color}      % color of \toprule, \midrule, \bottomrule
\setlength\heavyrulewidth{0.3ex}       % thickness of \toprule, \bottomrule
\renewcommand{\arraystretch}{1.3}       % spacing (padding)
\newcolumntype{P}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{L}[1]{>{\raggedright\arraybackslash}p{#1}}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\newcolumntype{R}[1]{>{\raggedleft\arraybackslash}p{#1}}

$if(table-use-row-colors)$
% Unfortunately the colored cells extend beyond the edge of the
% table because pandoc uses @-expressions (@{}) like so:
%
% \begin{longtable}[]{@{}ll@{}}
% \end{longtable}
%
% [https://en.wikibooks.org/wiki/LaTeX/Tables#.40-expressions](https://en.wikibooks.org/wiki/LaTeX/Tables#.40-expressions)
\usepackage{etoolbox}
\AtBeginEnvironment{longtable}{\rowcolors{2}{}{table-row-color!100}}
\preto{\toprule}{\hiderowcolors}{}{}
\appto{\endhead}{\showrowcolors}{}{}
\appto{\endfirsthead}{\showrowcolors}{}{}
$endif$
$endif$
```

*   **Tujuan**: Mengatur gaya tampilan tabel, termasuk warna, garis, *spacing*, dan tipe kolom.
*   **Packages**: `etoolbox` (opsional)
*   **Variabel Pandoc**: `tables`, `table-use-row-colors`
    *   **Kondisi `tables`**: `$if(tables)$`... `$endif$`. Bagian ini hanya aktif jika dukungan tabel diaktifkan (variabel `tables` didefinisikan, kemungkinan di `common.latex`).
        *   **Definisi Warna `table-row-color` dan `table-rule-color`**:
            *   `\definecolor{table-row-color}{HTML}{F5F5F5}`: Mendefinisikan warna `table-row-color` (abu-abu sangat terang) untuk warna latar belakang baris tabel bergantian.
            *   `\definecolor{table-rule-color}{HTML}{999999}`: Mendefinisikan warna `table-rule-color` (abu-abu sedang) untuk garis tabel (`\toprule`, `\midrule`, `\bottomrule`).
        *   **Pengaturan Warna Garis Tabel**: `\arrayrulecolor{table-rule-color}`. Mengatur warna *default* untuk garis tabel menjadi `table-rule-color`. Baris `%\arrayrulecolor{black!40}` yang dikomentari menunjukkan warna garis tabel *default* awalnya mungkin *black!40* (hitam transparan 40%).
        *   **Pengaturan Ketebalan Garis Tebal Tabel**: `\setlength\heavyrulewidth{0.3ex}`. Mengatur ketebalan garis tebal tabel (yang dihasilkan oleh perintah `\toprule` dan `\bottomrule` dari *package* `booktabs`) menjadi 0.3ex.
        *   **Pengaturan *Array Stretch***: `\renewcommand{\arraystretch}{1.3}`. Mengatur *array stretch* menjadi 1.3. *Array stretch* mempengaruhi jarak vertikal dalam sel tabel, dalam hal ini memberikan *padding* vertikal 30% lebih banyak.
        *   **Definisi Tipe Kolom Baru**: Mendefinisikan tipe kolom baru untuk tabel menggunakan `\newcolumntype`:
            *   `P{}`: Kolom paragraf (tipe `p`) dengan teks *raggedright* (rata kiri, kanan tidak rata).
            *   `L{}`: Sama dengan `P{}` (sepertinya *alias*).
            *   `C{}`: Kolom paragraf dengan teks *centered* (pusat).
            *   `R{}`: Kolom paragraf dengan teks *raggedleft* (rata kanan, kiri tidak rata).
        *   **Kondisi `table-use-row-colors`**: `$if(table-use-row-colors)$`... `$endif$`. Jika variabel `table-use-row-colors` didefinisikan.
            *   **Pewarnaan Baris Bergantian**: Menggunakan *package* `etoolbox` untuk menerapkan pewarnaan baris bergantian pada tabel panjang (`longtable`).
                *   `\AtBeginEnvironment{longtable}{\rowcolors{2}{}{table-row-color!100}}`: Pada awal setiap lingkungan `longtable`, menjalankan perintah `\rowcolors{2}{}{table-row-color!100}`. Perintah `\rowcolors{2}{}{color}` dari *package* `colortbl` (yang diasumsikan dimuat secara implisit atau eksplisit) mengatur pewarnaan baris bergantian setiap 2 baris. Argumen kedua kosong berarti baris ganjil tidak berwarna, dan argumen ketiga `table-row-color!100` (warna `table-row-color` dengan *opacity* 100%, yang berarti warna penuh) berarti baris genap berwarna dengan `table-row-color`.
                *   `\preto{\toprule}{\hiderowcolors}{}{}`, `\appto{\endhead}{\showrowcolors}{}{}`, `\appto{\endfirsthead}{\showrowcolors}{}{}`: Perintah-perintah ini menggunakan `\preto` dan `\appto` dari *package* `etoolbox` untuk menyisipkan perintah sebelum dan sesudah perintah `\toprule`, `\endhead`, dan `\endfirsthead` (perintah-perintah dari *package* `booktabs` yang digunakan untuk membuat garis tabel horizontal tebal). `\hiderowcolors` dan `\showrowcolors` (dari *package* `colortbl`) digunakan untuk menonaktifkan dan mengaktifkan kembali pewarnaan baris bergantian sementara selama garis horizontal tebal, agar garis tebal tidak terpengaruh oleh pewarnaan baris.
    *   **Jika `tables` tidak didefinisikan**: Tidak melakukan apa pun. Gaya tabel tidak diatur.
*   **Opsi Variabel `tables`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan tabel (diatur di `common.latex`). Mengaktifkan bagian gaya tabel di `eisvogel-added.latex`.
*   **Opsi Variabel `table-use-row-colors`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan pewarnaan baris bergantian untuk tabel.

##### 11. Remove Paragraph Indentation (Menghilangkan Indentasi Paragraf)

```latex
%
% remove paragraph indentation
%
\setlength{\parindent}{0pt}
\setlength{\parskip}{6pt plus 2pt minus 1pt}
\setlength{\emergencystretch}{3em}  % prevent overfull lines
```

*   **Tujuan**: Menghilangkan indentasi paragraf dan mengatur jarak antar paragraf.
*   **Perintah LaTeX**: `\setlength{\parindent}{0pt}`, `\setlength{\parskip}{6pt plus 2pt minus 1pt}`, `\setlength{\emergencystretch}{3em}` (redundant?)
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Pengaturan ini selalu diterapkan.
*   **Penjelasan**:
    *   `\setlength{\parindent}{0pt}`: Mengatur indentasi paragraf menjadi 0pt, menghilangkan indentasi baris pertama paragraf.
    *   `\setlength{\parskip}{6pt plus 2pt minus 1pt}`: Mengatur jarak antar paragraf menjadi 6pt, dengan sedikit *stretch* (hingga 2pt lebih banyak) dan *shrink* (hingga 1pt lebih sedikit).
    *   `\setlength{\emergencystretch}{3em}`: Mengatur `\emergencystretch` menjadi 3em. *Ini tampaknya redundan, karena perintah yang sama sudah ada di `common.latex` (bagian "prevent overfull lines"). Mungkin diulang di sini untuk memastikan pengaturan ini diterapkan, atau mungkin untuk tujuan historis dalam pengembangan template.*

##### 12. Listings (Listing Kode)

Bagian ini mengatur gaya *listing* kode secara rinci:

```latex
%
%
% Listings
%
%

$if(listings)$

%
% general listing colors
%
\definecolor{listing-background}{HTML}{F7F7F7}
\definecolor{listing-rule}{HTML}{B3B2B3}
\definecolor{listing-numbers}{HTML}{B3B2B3}
\definecolor{listing-text-color}{HTML}{000000}
\definecolor{listing-keyword}{HTML}{435489}
\definecolor{listing-keyword-2}{HTML}{1284CA} % additional keywords
\definecolor{listing-keyword-3}{HTML}{9137CB} % additional keywords
\definecolor{listing-identifier}{HTML}{435489}
\definecolor{listing-string}{HTML}{00999A}
\definecolor{listing-comment}{HTML}{8E8E8E}

\lstdefinestyle{eisvogel_listing_style}{
  language        = java,
$if(listings-disable-line-numbers)$
  xleftmargin     = 0.6em,
  framexleftmargin = 0.4em,
$else$
  numbers         = left,
  xleftmargin     = 2.7em,
  framexleftmargin = 2.5em,
$endif$
  backgroundcolor = \color{listing-background},
  basicstyle      = \color{listing-text-color}\linespread{1.0}%
                    \lst@ifdisplaystyle%
                    $if(code-block-font-size)$$code-block-font-size$$else$\small$endif$%
                    \fi\ttfamily{},
  breaklines      = true,
  frame           = single,
  framesep        = 0.19em,
  rulecolor       = \color{listing-rule},
  frameround      = ffff,
  tabsize         = 4,
  numberstyle     = \color{listing-numbers},
  aboveskip       = 1.0em,
  belowskip       = 0.1em,
  abovecaptionskip = 0em,
  belowcaptionskip = 1.0em,
  keywordstyle    = {\color{listing-keyword}\bfseries},
  keywordstyle    = {[2]\color{listing-keyword-2}\bfseries},
  keywordstyle    = {[3]\color{listing-keyword-3}\bfseries\itshape},
  sensitive       = true,
  identifierstyle = \color{listing-identifier},
  commentstyle    = \color{listing-comment},
  stringstyle     = \color{listing-string},
  showstringspaces = false,
  escapeinside      = {/*@}{@*/}, % Allow LaTeX inside these special comments
  literate        =
  {á}{{\'a}}1 {é}{{\'e}}1 {í}{{\'i}}1 {ó}{{\'o}}1 {ú}{{\'u}}1
  {Á}{{\'A}}1 {É}{{\'E}}1 {Í}{{\'I}}1 {Ó}{{\'O}}1 {Ú}{{\'U}}1
  {à}{{\`a}}1 {è}{{\`e}}1 {ì}{{\`i}}1 {ò}{{\`o}}1 {ù}{{\`u}}1
  {À}{{\`A}}1 {È}{{\'E}}1 {Ì}{{\'I}}1 {Ò}{{\'O}}1 {Ù}{{\'U}}1
  {ä}{{\"a}}1 {ë}{{\"e}}1 {ï}{{\"i}}1 {ö}{{\'o}}1 {ü}{{\'u}}1
  {Ä}{{\"A}}1 {Ë}{{\'E}}1 {Ï}{{\'I}}1 {Ö}{{\'O}}1 {Ü}{{\'U}}1
  {â}{{\^a}}1 {ê}{{\^e}}1 {î}{{\^i}}1 {ô}{{\^o}}1 {û}{{\^u}}1
  {Â}{{\^A}}1 {Ê}{{\'E}}1 {Î}{{\'I}}1 {Ô}{{\'O}}1 {Û}{{\'U}}1
  {œ}{{\oe}}1 {Œ}{{\OE}}1 {æ}{{\ae}}1 {Æ}{{\AE}}1 {ß}{{\ss}}1
  {ç}{{\c c}}1 {Ç}{{\c C}}1 {ø}{{\o}}1 {å}{{\r a}}1 {Å}{{\r A}}1
  {€}{{\EUR}}1 {£}{{\pounds}}1 {«}{{\guillemotleft}}1
  {»}{{\guillemotright}}1 {ñ}{{\~n}}1 {Ñ}{{\~N}}1 {¿}{{?`}}1
  {…}{{\ldots}}1 {≥}{{>=}}1 {≤}{{<=}}1 {„}{{\glqq}}1 {“}{{\grqq}}1
  {”}{{''}}1
}
\lstset{style=eisvogel_listing_style}

%
% Java (Java SE 12, 2019-06-22)
%
\lstdefinelanguage{Java}{
  morekeywords={
    % normal keywords (without data types)
    abstract,assert,break,case,catch,class,continue,default,
    do,else,enum,exports,extends,final,finally,for,if,implements,
    import,instanceof,interface,module,native,new,package,private,
    protected,public,requires,return,static,strictfp,super,switch,
    synchronized,this,throw,throws,transient,try,volatile,while,
    % var is an identifier
    var
  },
  morekeywords={[2] % data types
    % primitive data types
    boolean,byte,char,double,float,int,long,short,
    % String
    String,
    % primitive wrapper types
    Boolean,Byte,Character,Double,Float,Integer,Long,Short
    % number types
    Number,AtomicInteger,AtomicLong,BigDecimal,BigInteger,DoubleAccumulator,DoubleAdder,LongAccumulator,LongAdder,Short,
    % other
    Object,Void,void
  },
  morekeywords={[3] % literals
    % reserved words for literal values
    null,true,false,
  },
  sensitive,
  morecomment   = [l]//,
  morecomment   = [s]{/*}{*/},
  morecomment   = [s]{/**}{*/},
  morestring    = [b]",
  morestring    = [b]',
}

\lstdefinelanguage{XML}{
  morestring      = [b]",
  moredelim       = [s][\bfseries\color{listing-keyword}]{<}{\ },
  moredelim       = [s][\bfseries\color{listing-keyword}]{</}{>},
  moredelim       = [l][\bfseries\color{listing-keyword}]{/>},
  moredelim       = [l][\bfseries\color{listing-keyword}]{>},
  morecomment     = [s]{<?}{?>},
  morecomment     = [s]{},
  commentstyle    = \color{listing-comment},
  stringstyle     = \color{listing-string},
  identifierstyle = \color{listing-identifier}
}
$endif$
```

*   **Tujuan**: Mengatur gaya tampilan *listing* kode secara detail, termasuk warna, *frame*, *line numbers*, *keywords*, bahasa, dan karakter khusus.
*   **Packages**: `listings` (diasumsikan sudah dimuat di `common.latex`)
*   **Variabel Pandoc**: `listings`, `listings-disable-line-numbers`, `code-block-font-size`
    *   **Kondisi `listings`**: `$if(listings)$`... `$endif$`. Bagian ini hanya aktif jika dukungan *listings* diaktifkan (variabel `listings` didefinisikan, kemungkinan di `common.latex`).
        *   **Definisi Warna *Listing***: Mendefinisikan serangkaian warna menggunakan `\definecolor` untuk berbagai elemen *listing* kode: `listing-background`, `listing-rule`, `listing-numbers`, `listing-text-color`, `listing-keyword`, `listing-keyword-2`, `listing-keyword-3`, `listing-identifier`, `listing-string`, `listing-comment`. Warna-warna ini akan digunakan dalam definisi gaya *listing*.
        *   **Definisi Gaya Listing `eisvogel_listing_style`**: `\lstdefinestyle{eisvogel_listing_style}{...}`. Mendefinisikan gaya *listing* baru bernama `eisvogel_listing_style` menggunakan `\lstdefinestyle` dari *package* `listings`. Gaya ini mengatur banyak properti *listing*:
            *   `language = java`: Bahasa *default* untuk *listing* adalah Java. Ini bisa di-*override* untuk *listing* individu.
            *   **Line Numbers (Kondisional `listings-disable-line-numbers`)**: `$if(listings-disable-line-numbers)$`... `$else$ ... `$endif$`.
                *   **Jika `listings-disable-line-numbers` didefinisikan**: Menonaktifkan nomor baris dan mengatur margin kiri lebih kecil (`xleftmargin = 0.6em, framexleftmargin = 0.4em`).
                *   **Jika `listings-disable-line-numbers` tidak didefinisikan**: Mengaktifkan nomor baris di sebelah kiri (`numbers = left`) dan mengatur margin kiri lebih besar (`xleftmargin = 2.7em, framexleftmargin = 2.5em`) untuk memberi ruang bagi nomor baris.
            *   `backgroundcolor = \color{listing-background}`: Warna latar belakang *listing* menggunakan `listing-background` (abu-abu sangat terang).
            *   `basicstyle = \color{listing-text-color}\linespread{1.0}% \lst@ifdisplaystyle% $if(code-block-font-size)$$code-block-font-size$$else$\small$endif$% \fi\ttfamily{},`: Gaya teks dasar *listing*:
                *   Warna teks menggunakan `listing-text-color` (hitam).
                *   *Line spacing* (jarak baris) diatur ke 1.0.
                *   Ukuran *font* diatur secara kondisional: menggunakan variabel `code-block-font-size` jika didefinisikan, jika tidak, menggunakan `\small` (ukuran *font* kecil). `\lst@ifdisplaystyle` dan `\fi` memastikan ukuran *font* diubah hanya dalam mode *display*.
                *   *Font family* diatur ke *monospace* (`\ttfamily`).
            *   `breaklines = true`: Mengaktifkan pemutusan baris otomatis pada *listing*.
            *   `frame = single`: Menambahkan *frame* tunggal di sekitar *listing*.
            *   `framesep = 0.19em`: Jarak antara *frame* dan konten *listing* adalah 0.19em.
            *   `rulecolor = \color{listing-rule}`: Warna garis *frame* menggunakan `listing-rule` (abu-abu sedang).
            *   `frameround = ffff`: Membuat sudut *frame* menjadi persegi (tidak bulat, meskipun nilai "ffff" mungkin tidak standar untuk *frameround*, nilai yang diharapkan mungkin *true* atau *false*, perlu diklarifikasi dokumentasi *listings*). *Setelah pengecekan dokumentasi listings, `frameround` menerima nilai 'fttt' (round top left), 'tftt' (round top right), 'ttft' (round bottom right), 'tttf' (round bottom left), and 'ffff' (no rounding at all). Jadi 'ffff' memang berarti no rounding.*
            *   `tabsize = 4`: Ukuran *tab* adalah 4 spasi.
            *   `numberstyle = \color{listing-numbers}`: Gaya nomor baris menggunakan `listing-numbers` (abu-abu sedang).
            *   `aboveskip = 1.0em`: Jarak vertikal di atas *listing* adalah 1.0em.
            *   `belowskip = 0.1em`: Jarak vertikal di bawah *listing* adalah 0.1em.
            *   `abovecaptionskip = 0em`: Jarak vertikal di atas *caption* *listing* adalah 0em.
            *   `belowcaptionskip = 1.0em`: Jarak vertikal di bawah *caption* *listing* adalah 1.0em.
            *   `keywordstyle = {\color{listing-keyword}\bfseries}`: Gaya *keyword* (kata kunci utama) menggunakan `listing-keyword` (biru) dan *bold*.
            *   `keywordstyle = {[2]\color{listing-keyword-2}\bfseries}`: Gaya *keyword* kedua (kata kunci tambahan 2) menggunakan `listing-keyword-2` (biru muda) dan *bold*.
            *   `keywordstyle = {[3]\color{listing-keyword-3}\bfseries\itshape}`: Gaya *keyword* ketiga (kata kunci tambahan 3) menggunakan `listing-keyword-3` (ungu), *bold*, dan *italic*.
            *   `sensitive = true`: *Listing* bersifat *case-sensitive* (membedakan huruf besar dan kecil).
            *   `identifierstyle = \color{listing-identifier}`: Gaya *identifier* menggunakan `listing-identifier` (biru).
            *   `commentstyle = \color{listing-comment}`: Gaya *comment* menggunakan `listing-comment` (abu-abu).
            *   `stringstyle = \color{listing-string}`: Gaya *string* menggunakan `listing-string` (hijau kebiruan).
            *   `showstringspaces = false`: Tidak menampilkan spasi dalam *string* secara eksplisit (misalnya, dengan simbol).
            *   `escapeinside = {/*@}{@*/}`: Mengizinkan kode LaTeX disisipkan di dalam *listing* menggunakan sintaks `/*@ LaTeX code @*/`.
            *   `literate = ...`: Mengatur *literate replacements* untuk menangani karakter beraksen, simbol mata uang, dan tanda baca khusus. Ini mengganti karakter-karakter tertentu dengan perintah LaTeX yang sesuai agar dapat ditampilkan dengan benar dalam *listing*.
        *   **Mengatur Gaya Listing *Default***: `\lstset{style=eisvogel_listing_style}`. Mengatur gaya *default* untuk semua lingkungan *listing* menjadi `eisvogel_listing_style` yang baru didefinisikan.
        *   **Definisi Bahasa Listing Tambahan**: Mendefinisikan bahasa *listing* baru untuk Java dan XML menggunakan `\lstdefinelanguage`:
            *   `\lstdefinelanguage{Java}{...}`: Mendefinisikan bahasa "Java" dengan daftar *keywords* (kata kunci normal, tipe data, literal), gaya komentar (`//`, `/* ... */`, `/** ... */`), dan gaya *string* (`"` dan `'`).
            *   `\lstdefinelanguage{XML}{...}`: Mendefinisikan bahasa "XML" dengan gaya *string*, *delimiter* (tag XML), dan komentar (`<? ... ?>`, ``).
    *   **Jika `listings` tidak didefinisikan**: Tidak melakukan apa pun. Gaya *listing* kode tidak diatur secara khusus.
*   **Opsi Variabel `listings`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengaktifkan/menonaktifkan dukungan *listings* (diatur di `common.latex`). Mengaktifkan bagian gaya *listing* di `eisvogel-added.latex`.
*   **Opsi Variabel `listings-disable-line-numbers`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Menonaktifkan nomor baris pada *listing* kode dan mengatur margin kiri lebih kecil.
*   **Opsi Variabel `code-block-font-size`**: Variabel *string* (ukuran *font* LaTeX). Menentukan ukuran *font* untuk blok kode (juga digunakan di bagian "Highlighting" dalam `common.latex`).

##### 13. Header and Footer (Header dan Footer Halaman)

```latex
%
% header and footer
%
$if(disable-header-and-footer)$
$else$
\usepackage[headsepline,footsepline]{scrlayer-scrpage}

\newpairofpagestyles{eisvogel-header-footer}{
  \clearpairofpagestyles
  \ihead*{$if(header-left)$$header-left$$else$$title$$endif$}
  \chead*{$if(header-center)$$header-center$$else$$endif$}
  \ohead*{$if(header-right)$$header-right$$else$$date$$endif$}
  \ifoot*{$if(footer-left)$$footer-left$$else$$for(author)$$author$$sep$, $endfor$$endif$}
  \cfoot*{$if(footer-center)$$footer-center$$else$$endif$}
  \ofoot*{$if(footer-right)$$footer-right$$else$\thepage$endif$}
  \addtokomafont{pageheadfoot}{\upshape}
}
\pagestyle{eisvogel-header-footer}

$if(book)$
\deftripstyle{ChapterStyle}{}{}{}{}{\pagemark}{}
\renewcommand*{\chapterpagestyle}{ChapterStyle}
$endif$

$if(page-background)$
\backgroundsetup{
scale=1,
color=black,
opacity=$if(page-background-opacity)$$page-background-opacity$$else$0.2$endif$,
angle=0,
contents={%
  \includegraphics[width=\paperwidth,height=\paperheight]{$page-background$}
  }%
}
$endif$
$endif$
```

*   **Tujuan**: Mengatur *header* dan *footer* halaman, termasuk konten, garis pemisah, dan gaya. Juga menangani *background* halaman (gambar latar belakang).
*   **Packages**: `scrlayer-scrpage`
*   **Variabel Pandoc**: `disable-header-and-footer`, `header-left`, `header-center`, `header-right`, `footer-left`, `footer-center`, `footer-right`, `book`, `page-background`, `page-background-opacity`
    *   **Kondisi `disable-header-and-footer`**: `$if(disable-header-and-footer)$`... `$else$ ... `$endif$`. Bagian ini hanya aktif jika *header* dan *footer* tidak dinonaktifkan (variabel `disable-header-and-footer` tidak didefinisikan atau *false*).
        *   **Memuat *Package* `scrlayer-scrpage`**: `\usepackage[headsepline,footsepline]{scrlayer-scrpage}`. Memuat *package* `scrlayer-scrpage` dengan opsi `headsepline` dan `footsepline`. Package ini adalah *package* modern untuk mengatur *header* dan *footer* halaman, dan opsi ini menambahkan garis horizontal di bawah *header* dan di atas *footer*.
        *   **Definisi Gaya Halaman `eisvogel-header-footer`**: `\newpairofpagestyles{eisvogel-header-footer}{...}`. Mendefinisikan gaya halaman baru bernama `eisvogel-header-footer` menggunakan `\newpairofpagestyles` dari *package* `scrlayer-scrpage`. `\newpairofpagestyles` mendefinisikan gaya halaman untuk halaman ganjil dan genap sekaligus (dalam kasus ini, gaya yang sama digunakan untuk keduanya).
            *   `\clearpairofpagestyles`: Membersihkan semua pengaturan *header* dan *footer* *default*.
            *   **Pengaturan Header Content**:
                *   `\ihead*{$if(header-left)$$header-left$$else$$title$$endif$}`: Konten *header* kiri (*inner header*) adalah variabel `header-left` jika didefinisikan, jika tidak, menggunakan judul dokumen (`$title`). `\ihead*` digunakan untuk konten di bagian *inner* (dekat margin dalam). `*` menandakan konten yang *protected* (mungkin penting untuk variabel Pandoc).
                *   `\chead*{$if(header-center)$$header-center$$else$$endif$}`: Konten *header* tengah (*center header*) adalah variabel `header-center` jika didefinisikan, jika tidak, kosong. `\chead*` untuk *center header*.
                *   `\ohead*{$if(header-right)$$header-right$$else$$date$$endif$}`: Konten *header* kanan (*outer header*) adalah variabel `header-right` jika didefinisikan, jika tidak, menggunakan tanggal dokumen (`$date`). `\ohead*` untuk *outer header* (dekat margin luar/tepi halaman).
            *   **Pengaturan Footer Content**:
                *   `\ifoot*{$if(footer-left)$$footer-left$$else$$for(author)$$author$$sep$, $endfor$$endif$}`: Konten *footer* kiri (*inner footer*) adalah variabel `footer-left` jika didefinisikan, jika tidak, menggunakan daftar penulis dokumen (`$for(author)...$`). `\ifoot*` untuk *inner footer*.
                *   `\cfoot*{$if(footer-center)$$footer-center$$else$$endif$}`: Konten *footer* tengah (*center footer*) adalah variabel `footer-center` jika didefinisikan, jika tidak, kosong. `\cfoot*` untuk *center footer*.
                *   `\ofoot*{$if(footer-right)$$footer-right$$else$\thepage$endif$}`: Konten *footer* kanan (*outer footer*) adalah variabel `footer-right` jika didefinisikan, jika tidak, menggunakan nomor halaman (`\thepage`). `\ofoot*` untuk *outer footer*.
            *   `\addtokomafont{pageheadfoot}{\upshape}`: Mengatur *font shape* untuk semua elemen *header* dan *footer* menjadi *upright shape* (tegak, bukan *italic* atau *slanted*).
        *   **Mengaktifkan Gaya Halaman `eisvogel-header-footer`**: `\pagestyle{eisvogel-header-footer}`. Mengatur gaya halaman dokumen menjadi `eisvogel-header-footer` yang baru didefinisikan.
        *   **Gaya *Chapter* untuk Kelas Dokumen *Book* (Kondisional `book`)**: `$if(book)$`... `$endif$`. Jika dokumen adalah *book* (`book` diaktifkan).
            *   `\deftripstyle{ChapterStyle}{}{}{}{}{\pagemark}{}`: Mendefinisikan gaya halaman baru bernama `ChapterStyle` menggunakan `\deftripstyle` (dari *package* `scrlayer-scrpage`). `\deftripstyle` mendefinisikan gaya halaman dengan tiga bagian *header* dan tiga bagian *footer*, tetapi dalam kasus ini, hanya bagian *outer footer* (`\ofoot`) yang diatur untuk menampilkan nomor halaman (`\pagemark`). Bagian *header* dan *footer* lainnya kosong.
            *   `\renewcommand*{\chapterpagestyle}{ChapterStyle}`: Mengatur gaya halaman untuk halaman *chapter* menjadi `ChapterStyle`. Ini berarti halaman pembuka *chapter* (dan halaman-halaman setelahnya dalam *chapter*, tergantung kelas dokumen) akan menggunakan gaya `ChapterStyle` yang memiliki nomor halaman di *footer* kanan dan *header*/ *footer* lain kosong.
        *   **Page Background Image (Kondisional `page-background`)**: `$if(page-background)$`... `$endif$`. Jika variabel `page-background` didefinisikan.
            *   **Pengaturan *Background* Halaman dengan Gambar**: `\backgroundsetup{...}`. Menggunakan `\backgroundsetup` (dari *package* `background`) untuk mengatur *background* halaman.
                *   `scale=1`: Skala gambar latar belakang adalah 1 (ukuran asli).
                *   `color=black`: Warna latar belakang (sebelum gambar diaplikasikan) adalah hitam. *Ini mungkin tidak berpengaruh signifikan jika gambar latar belakang menutupi seluruh halaman.*
                *   `opacity=$if(page-background-opacity)$$page-background-opacity$$else$0.2$endif$`: Opasitas gambar latar belakang diatur oleh variabel `page-background-opacity` jika didefinisikan, jika tidak, *default* opasitas adalah 0.2 (20% - transparan).
                *   `angle=0`: Sudut rotasi gambar latar belakang adalah 0 derajat.
                *   `contents={\includegraphics[width=\paperwidth,height=\paperheight]{$page-background$}}`: Konten latar belakang adalah gambar yang dimasukkan menggunakan `\includegraphics`. Gambar akan diskalakan agar sesuai dengan lebar kertas (`\paperwidth`) dan tinggi kertas (`\paperheight`), dan *path* ke file gambar diambil dari variabel Pandoc `$page-background`.
    *   **Jika `disable-header-and-footer` didefinisikan**: Tidak melakukan apa pun. *Header* dan *footer* tidak diatur, dan *default* *header* dan *footer* (atau tanpa *header*/*footer* tergantung kelas dokumen) akan digunakan.
*   **Opsi Variabel `disable-header-and-footer`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Menonaktifkan *header* dan *footer* halaman.
*   **Opsi Variabel `header-left`**: Variabel *string*. Konten *header* kiri.
*   **Opsi Variabel `header-center`**: Variabel *string*. Konten *header* tengah.
*   **Opsi Variabel `header-right`**: Variabel *string*. Konten *header* kanan.
*   **Opsi Variabel `footer-left`**: Variabel *string*. Konten *footer* kiri.
*   **Opsi Variabel `footer-center`**: Variabel *string*. Konten *footer* tengah.
*   **Opsi Variabel `footer-right`**: Variabel *string*. Konten *footer* kanan.
*   **Opsi Variabel `book`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Menandakan dokumen adalah *book* (mempengaruhi gaya halaman *chapter*).
*   **Opsi Variabel `page-background`**: Variabel *string*. *Path* ke file gambar yang digunakan sebagai latar belakang halaman. Mengaktifkan penggunaan gambar latar belakang halaman.
*   **Opsi Variabel `page-background-opacity`**: Variabel *number* (antara 0 dan 1). Opasitas gambar latar belakang halaman. *Default* 0.2 jika tidak didefinisikan.

---

**Variabel Pandoc yang Dapat Digunakan (YAML) untuk `eisvogel-added.latex`:**

Berikut adalah daftar variabel Pandoc yang relevan dari file `eisvogel-added.latex` dan opsi yang mungkin (sudah termasuk yang dijelaskan di atas dan diringkas):

*   **`page-background`**: *String* (path file gambar). Mengaktifkan gambar latar belakang halaman dan menentukan *path* gambar.
*   **`titlepage`**: *Boolean*. Mengaktifkan halaman judul.
*   **`titlepage-background`**: *Boolean*. Mengaktifkan latar belakang halaman judul *khusus* (walaupun implementasi detail tidak terlihat langsung).
*   **`geometry`**: *Boolean*. Menandakan *geometry* halaman sudah diatur eksternal. Jika tidak, *geometry default* diterapkan (hanya jika `titlepage` aktif).
*   **`caption-justification`**: *String* (nilai *justification* LaTeX: `"center"`, `"justified"`, `"raggedright"`, `"raggedleft"`). Perataan teks *caption*.
*   **`fontfamily`**: *String*. *Font family* *default* (PDFTeX, jika didefinisikan).
*   **`mainfont`**: *String*. *Font* utama (XeTeX/LuaTeX, jika didefinisikan).
*   **`table-use-row-colors`**: *Boolean*. Mengaktifkan pewarnaan baris bergantian pada tabel.
*   **`listings`**: *Boolean*. Mengaktifkan dukungan *listings* (diatur di `common.latex`, mengaktifkan gaya *listing* di sini).
*   **`listings-disable-line-numbers`**: *Boolean*. Menonaktifkan nomor baris *listing*.
*   **`code-block-font-size`**: *String* (ukuran *font* LaTeX). Ukuran *font* blok kode (juga digunakan di `common.latex`).
*   **`disable-header-and-footer`**: *Boolean*. Menonaktifkan *header* dan *footer*.
*   **`header-left`**: *String*. Konten *header* kiri.
*   **`header-center`**: *String*. Konten *header* tengah.
*   **`header-right`**: *String*. Konten *header* kanan.
*   **`footer-left`**: *String*. Konten *footer* kiri.
*   **`footer-center`**: *String*. Konten *footer* tengah.
*   **`footer-right`**: *String*. Konten *footer* kanan.
*   **`book`**: *Boolean*. Menandakan dokumen adalah *book* (mempengaruhi gaya halaman *chapter*).
*   **`page-background-opacity`**: *Number* (0-1). Opasitas gambar latar belakang halaman.

---