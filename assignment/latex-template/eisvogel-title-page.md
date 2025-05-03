# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `eisvogel-title-page.latex`

File `eisvogel-title-page.latex` secara khusus bertanggung jawab untuk menghasilkan halaman judul dokumen. File ini menggunakan berbagai perintah LaTeX dan variabel Pandoc untuk mengatur tata letak, warna, *background*, teks (judul, *subtitle*, penulis, tanggal), logo, dan elemen dekoratif seperti garis berwarna pada halaman judul. Keberadaan dan tampilan halaman judul sangat dikontrol oleh variabel YAML seperti `titlepage`, `titlepage-background`, `titlepage-color`, `titlepage-text-color`, `titlepage-rule-color`, `titlepage-rule-height`, `titlepage-logo`, dan `logo-width`.

Berikut adalah isi file `eisvogel-title-page.latex` dan penjelasannya per bagian:

```latex
$if(titlepage)$
\begin{titlepage}
$if(titlepage-background)$
\newgeometry{top=2cm, right=4cm, bottom=3cm, left=4cm}
$else$
\newgeometry{left=6cm}
$endif$
$if(titlepage-color)$
\definecolor{titlepage-color}{HTML}{$titlepage-color$}
\newpagecolor{titlepage-color}\afterpage{\restorepagecolor}
$endif$
$if(titlepage-background)$
\tikz[remember picture,overlay] \node[inner sep=0pt] at (current page.center){\includegraphics[width=\paperwidth,height=\paperheight]{$titlepage-background$}};
$endif$
\newcommand{\colorRule}[3][black]{\textcolor[HTML]{#1}{\rule{#2}{#3}}}
\begin{flushleft}
\noindent
\\[-1em]
\color[HTML]{$if(titlepage-text-color)$$titlepage-text-color$$else$5F5F5F$endif$}
\makebox[0pt][l]{\colorRule[$if(titlepage-rule-color)$$titlepage-rule-color$$else$435488$endif$]{1.3\textwidth}{$if(titlepage-rule-height)$$titlepage-rule-height$$else$4$endif$pt}}
\par
\noindent

$if(titlepage-background)$
% The titlepage with a background image has other text spacing and text size
{
  \setstretch{2}
  \vfill
  \vskip -8em
  \noindent {\huge \textbf{\textsf{$title$}}}
  $if(subtitle)$
  \vskip 1em
  {\Large \textsf{$subtitle$}}
  $endif$
  \vskip 2em
  \noindent {\Large \textsf{$for(author)$$author$$sep$, $endfor$} \vskip 0.6em \textsf{$date$}}
  \vfill
}
$else$
{
  \setstretch{1.4}
  \vfill
  \noindent {\huge \textbf{\textsf{$title$}}}
  $if(subtitle)$
  \vskip 1em
  {\Large \textsf{$subtitle$}}
  $endif$
  \vskip 2em
  \noindent {\Large \textsf{$for(author)$$author$$sep$, $endfor$}}
  \vfill
}
$endif$

$if(titlepage-logo)$
\noindent
\includegraphics[width=$if(logo-width)$$logo-width$$else$35mm$endif$, left]{$titlepage-logo$}
$endif$

$if(titlepage-background)$
$else$
\textsf{$date$}
$endif$
\end{flushleft}
\end{titlepage}
\restoregeometry
\pagenumbering{arabic}
$endif$
```

#### Penjelasan per Bagian dari `eisvogel-title-page.latex`:

##### 1. Conditional `titlepage` Environment (Lingkungan `titlepage` Kondisional)

```latex
$if(titlepage)$
\begin{titlepage}
...
\end{titlepage}
$endif$
```

*   **Tujuan**: Mengaktifkan atau menonaktifkan pembuatan seluruh halaman judul.
*   **LaTeX Environment**: `titlepage`
*   **Variabel Pandoc**: `titlepage`
    *   **Jika `titlepage` didefinisikan**: Konten di dalam blok `$if(titlepage)$`...`$endif$` akan diproses dan lingkungan `titlepage` LaTeX akan dibuat. Lingkungan `titlepage` secara otomatis membuat halaman terpisah untuk judul dan biasanya menekan nomor halaman pada halaman tersebut.
    *   **Jika `titlepage` tidak didefinisikan**: Blok kode akan diabaikan, dan halaman judul tidak akan dibuat.
*   **Opsi Variabel `titlepage`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengontrol apakah halaman judul akan dihasilkan atau tidak.

##### 2. Conditional Geometry Adjustment for Background Image (`titlepage-background`) (Penyesuaian *Geometry* Kondisional untuk Gambar Latar Belakang Halaman Judul)

```latex
$if(titlepage-background)$
\newgeometry{top=2cm, right=4cm, bottom=3cm, left=4cm}
$else$
\newgeometry{left=6cm}
$endif$
```

*   **Tujuan**: Menyesuaikan *geometry* (margin) halaman judul berdasarkan keberadaan gambar latar belakang (`titlepage-background`).
*   **Perintah LaTeX**: `\newgeometry{...}`
*   **Package**: `geometry` (diasumsikan sudah dimuat di `eisvogel-added.latex`)
*   **Variabel Pandoc**: `titlepage-background`
    *   **Jika `titlepage-background` didefinisikan**: Menggunakan `\newgeometry{top=2cm, right=4cm, bottom=3cm, left=4cm}`. Ini mengatur *geometry* halaman judul dengan margin atas 2cm, margin kanan 4cm, margin bawah 3cm, dan margin kiri 4cm. Margin yang lebih kecil di atas dan bawah serta margin kanan yang lebih besar mungkin dirancang untuk memberikan ruang visual yang lebih baik untuk teks halaman judul ketika gambar latar belakang ada.
    *   **Jika `titlepage-background` tidak didefinisikan**: Menggunakan `\newgeometry{left=6cm}`. Ini mengatur *geometry* halaman judul dengan hanya margin kiri yang besar, 6cm, dan margin lainnya menggunakan nilai *default*. Margin kiri yang besar mungkin bertujuan untuk memberikan ruang kosong yang signifikan di sisi kiri halaman judul untuk tujuan desain, ketika tidak ada gambar latar belakang.
*   **Opsi Variabel `titlepage-background`**: Variabel *boolean* (`true`/`false` atau ada/tidak ada). Mengontrol penyesuaian *geometry* halaman judul. Keberadaan variabel ini mengindikasikan penggunaan gambar latar belakang pada halaman judul, dan memicu penyesuaian margin yang sesuai.

##### 3. Conditional Title Page Color (`titlepage-color`) (Warna Latar Belakang Halaman Judul Kondisional)

```latex
$if(titlepage-color)$
\definecolor{titlepage-color}{HTML}{$titlepage-color$}
\newpagecolor{titlepage-color}\afterpage{\restorepagecolor}
$endif$
```

*   **Tujuan**: Mengatur warna latar belakang halaman judul jika variabel `titlepage-color` didefinisikan.
*   **Perintah LaTeX**: `\definecolor{...}`, `\newpagecolor{...}`, `\afterpage{\restorepagecolor}`
*   **Packages**: `pagecolor`, `afterpage` (diasumsikan sudah dimuat di `eisvogel-added.latex`)
*   **Variabel Pandoc**: `titlepage-color`
    *   **Jika `titlepage-color` didefinisikan**:
        *   `\definecolor{titlepage-color}{HTML}{$titlepage-color$}`: Mendefinisikan warna baru bernama `titlepage-color` menggunakan kode warna HTML yang diberikan oleh variabel Pandoc `$titlepage-color`.
        *   `\newpagecolor{titlepage-color}\afterpage{\restorepagecolor}`: Mengatur warna latar belakang halaman saat ini (halaman judul) menjadi `titlepage-color` menggunakan `\newpagecolor{titlepage-color}`. `\afterpage{\restorepagecolor}` memastikan bahwa perintah `\restorepagecolor` (untuk mengembalikan warna halaman ke *default*) dijalankan setelah halaman judul selesai diproses. Ini mencegah warna latar belakang halaman judul diterapkan ke halaman-halaman selanjutnya.
    *   **Jika `titlepage-color` tidak didefinisikan**: Tidak melakukan apa pun. Warna latar belakang halaman judul *default* (biasanya putih atau *transparent*) akan digunakan.
*   **Opsi Variabel `titlepage-color`**: Variabel *string* (kode warna HTML). Menentukan warna latar belakang halaman judul. Contoh: `"E0E0E0"` untuk abu-abu terang.

##### 4. Conditional Title Page Background Image (`titlepage-background`) (Gambar Latar Belakang Halaman Judul Kondisional)

```latex
$if(titlepage-background)$
\tikz[remember picture,overlay] \node[inner sep=0pt] at (current page.center){\includegraphics[width=\paperwidth,height=\paperheight]{$titlepage-background$}};
$endif$
```

*   **Tujuan**: Menyisipkan gambar latar belakang pada halaman judul jika variabel `titlepage-background` didefinisikan.
*   **Perintah LaTeX**: `\tikz`, `\node`, `\includegraphics`
*   **Package**: `tikz` (diasumsikan sudah dimuat di `eisvogel-added.latex`)
*   **Variabel Pandoc**: `titlepage-background`
    *   **Jika `titlepage-background` didefinisikan**:
        *   `\tikz[remember picture,overlay] \node[inner sep=0pt] at (current page.center){...}`: Menggunakan lingkungan `tikz` untuk menyisipkan gambar. Opsi `remember picture,overlay` memungkinkan TikZ untuk menggambar di atas konten halaman dan mengingat posisi node untuk referensi di masa mendatang.
        *   `\node[inner sep=0pt] at (current page.center){...}`: Membuat node TikZ (elemen grafis) tanpa *inner separation* (`inner sep=0pt`) dan menempatkannya di tengah halaman saat ini (`at (current page.center)`).
        *   `\includegraphics[width=\paperwidth,height=\paperheight]{$titlepage-background$}`: Isi node adalah perintah `\includegraphics` yang menyisipkan gambar. Gambar diskalakan agar sesuai dengan lebar kertas (`\paperwidth`) dan tinggi kertas (`\paperheight`), dan *path* ke file gambar diambil dari variabel Pandoc `$titlepage-background`. Ini memastikan gambar latar belakang menutupi seluruh halaman judul.
    *   **Jika `titlepage-background` tidak didefinisikan**: Tidak melakukan apa pun. Tidak ada gambar latar belakang yang akan disisipkan pada halaman judul.
*   **Opsi Variabel `titlepage-background`**: Variabel *string* (path file gambar). Menentukan *path* ke file gambar yang akan digunakan sebagai latar belakang halaman judul. Mengaktifkan penggunaan gambar latar belakang halaman judul.

##### 5. `\colorRule` Command Definition (Definisi Perintah `\colorRule`)

```latex
\newcommand{\colorRule}[3][black]{\textcolor[HTML]{#1}{\rule{#2}{#3}}}
```

*   **Tujuan**: Mendefinisikan perintah LaTeX baru bernama `\colorRule` untuk membuat garis horizontal berwarna dengan mudah.
*   **Perintah LaTeX**: `\newcommand`, `\textcolor`, `\rule`
*   **Packages**: `color` atau `xcolor` (diasumsikan sudah dimuat melalui *package* lain atau template dasar Pandoc)
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mendefinisikan perintah ini, tetapi perintah ini digunakan dalam bagian lain yang menggunakan variabel Pandoc.
*   **Penjelasan**: `\newcommand{\colorRule}[3][black]{...}` mendefinisikan perintah baru bernama `\colorRule` yang menerima tiga argumen. Argumen pertama bersifat opsional dan *default*-nya adalah `black`.
    *   `[3][black]`: Menentukan bahwa perintah `\colorRule` menerima 3 argumen, dan argumen pertama opsional dengan nilai *default* `black`.
    *   `#1`: Argumen pertama (warna, *default* `black`).
    *   `#2`: Argumen kedua (lebar garis).
    *   `#3`: Argumen ketiga (tinggi garis atau ketebalan).
    *   `\textcolor[HTML]{#1}{\rule{#2}{#3}}`: Isi definisi perintah.
        *   `\textcolor[HTML]{#1}{...}`: Mengatur warna teks menggunakan `\textcolor` dari *package* `color` atau `xcolor`. Opsi `[HTML]` menunjukkan bahwa warna diberikan dalam format kode warna HTML. Warna yang digunakan diambil dari argumen pertama (`#1`) dari perintah `\colorRule`.
        *   `\rule{#2}{#3}`: Membuat garis horizontal menggunakan perintah `\rule`.
            *   `{#2}`: Lebar garis diambil dari argumen kedua (`#2`) dari `\colorRule`.
            *   `{#3}`: Tinggi (ketebalan) garis diambil dari argumen ketiga (`#3`) dari `\colorRule`.
*   **Penggunaan**: Perintah `\colorRule` dapat digunakan untuk membuat garis horizontal berwarna dengan sintaks: `\colorRule[warna HTML]{lebar}{tinggi}`. Jika argumen warna opsional tidak diberikan, garis akan berwarna hitam.

##### 6. `flushleft` Environment and Title Section Styling (Lingkungan `flushleft` dan Gaya Bagian Judul)

```latex
\begin{flushleft}
\noindent
\\[-1em]
\color[HTML]{$if(titlepage-text-color)$$titlepage-text-color$$else$5F5F5F$endif$}
\makebox[0pt][l]{\colorRule[$if(titlepage-rule-color)$$titlepage-rule-color$$else$435488$endif$]{1.3\textwidth}{$if(titlepage-rule-height)$$titlepage-rule-height$$else$4$endif$pt}}
\par
\noindent

... Title Text ...

$if(titlepage-logo)$
\noindent
\includegraphics[width=$if(logo-width)$$logo-width$$else$35mm$endif$, left]{$titlepage-logo$}
$endif$

$if(titlepage-background)$
$else$
\textsf{$date$}
$endif$
\end{flushleft}
```

*   **Tujuan**: Mengatur tata letak dan gaya visual bagian judul pada halaman judul, termasuk warna teks, garis horizontal berwarna, dan penempatan elemen teks utama (judul, *subtitle*, penulis, tanggal) serta logo. Menggunakan lingkungan `flushleft` untuk perataan kiri semua elemen.
*   **LaTeX Environments**: `flushleft`
*   **Perintah LaTeX**: `\noindent`, `\\[...]`, `\color`, `\makebox`, `\colorRule`, `\par`, `\setstretch`, `\vfill`, `\vskip`, `\textbf`, `\textsf`, `\huge`, `\Large`, `\includegraphics`, `\textsf{date}`
*   **Packages**: `color` atau `xcolor`, `setspace` (diasumsikan dimuat melalui *package* lain atau template dasar Pandoc), *graphicx* (untuk `\includegraphics`), `tikz` (implisit melalui `\colorRule` dan warna)
*   **Variabel Pandoc**: `titlepage-text-color`, `titlepage-rule-color`, `titlepage-rule-height`, `titlepage-background`, `title`, `subtitle`, `author`, `date`, `titlepage-logo`, `logo-width`
    *   **`\begin{flushleft} ... \end{flushleft}`**: Memulai lingkungan `flushleft`. Lingkungan ini memastikan semua konten di dalamnya rata kiri.
    *   `\noindent`: Menekan indentasi paragraf untuk baris pertama.
    *   `\\[-1em]`: Menambahkan *negative vertical space* (ruang vertikal negatif) sebesar -1em. Ini akan menarik konten ke atas sedikit, mungkin untuk menyesuaikan posisi visual elemen judul.
    *   `\color[HTML]{$if(titlepage-text-color)$$titlepage-text-color$$else$5F5F5F$endif$}`: Mengatur warna teks untuk bagian judul yang akan mengikuti. Warna diambil dari variabel Pandoc `$titlepage-text-color` jika didefinisikan, jika tidak, menggunakan warna *default* `#5F5F5F` (abu-abu sedang).
    *   `\makebox[0pt][l]{\colorRule[...]}`: Membuat kotak horizontal dengan lebar 0pt dan meratakannya ke kiri (`[0pt][l]`). Isi kotak adalah garis berwarna yang dibuat menggunakan perintah `\colorRule`.
        *   `\colorRule[$if(titlepage-rule-color)$$titlepage-rule-color$$else$435488$endif$]{1.3\textwidth}{$if(titlepage-rule-height)$$titlepage-rule-height$$else$4$endif$pt}`: Menggunakan perintah `\colorRule` untuk membuat garis horizontal berwarna.
            *   Warna garis diambil dari variabel `$titlepage-rule-color` jika didefinisikan, jika tidak, *default* `#435488` (biru).
            *   Lebar garis adalah 1.3 kali lebar teks saat ini (`1.3\textwidth`), sehingga garis lebih lebar dari blok teks.
            *   Tinggi (ketebalan) garis diambil dari variabel `$titlepage-rule-height` jika didefinisikan, jika tidak, *default* 4pt.
    *   `\par\noindent`: Mengakhiri paragraf dan memulai paragraf baru tanpa indentasi. Ini sepertinya untuk memisahkan garis berwarna dari teks judul yang akan menyusul.
    *   **Conditional Text Layout based on `titlepage-background`**: `$if(titlepage-background)$ ... `$else$ ... `$endif$`. Memilih tata letak teks yang berbeda berdasarkan keberadaan gambar latar belakang.
        *   **Jika `titlepage-background` didefinisikan (dengan gambar latar belakang)**:
            *   `\setstretch{2}`: Mengatur *line spacing* menjadi 2 (dua spasi) menggunakan lingkungan `setspace` (atau perintah serupa). *Line spacing* yang lebih besar mungkin digunakan untuk meningkatkan keterbacaan teks di atas gambar latar belakang.
            *   `\vfill\vskip -8em`: Menggunakan `\vfill` untuk mendorong konten ke bagian bawah halaman secara vertikal, dan kemudian menggunakan `\vskip -8em` untuk menarik konten ke atas lagi sebesar 8em. Kombinasi ini kemungkinan besar bertujuan untuk memposisikan blok teks secara vertikal di tengah halaman atau sedikit di atas tengah, secara visual disesuaikan untuk tata letak dengan gambar latar belakang.
            *   `\noindent {\huge \textbf{\textsf{$title$}}}`: Menampilkan judul dokumen (`$title$`) menggunakan ukuran *font* `\huge`, tebal (`\textbf`), dan *font family* *sans-serif* (`\textsf`).
            *   `$if(subtitle)$ \vskip 1em {\Large \textsf{$subtitle$}} $endif$`: Jika variabel `$subtitle` didefinisikan, menampilkan *subtitle* dengan ukuran *font* `\Large` dan *sans-serif*, dengan jarak vertikal 1em di bawah judul.
            *   `\vskip 2em \noindent {\Large \textsf{$for(author)$$author$$sep$, $endfor$} \vskip 0.6em \textsf{$date$}}`: Menampilkan daftar penulis (`$for(author)...$`) dan tanggal (`$date$`) dengan ukuran *font* `\Large` dan *sans-serif*. Daftar penulis dan tanggal dipisahkan dengan jarak vertikal 2em dari *subtitle* (atau judul jika tidak ada *subtitle*), dan tanggal ditempatkan 0.6em di bawah daftar penulis.
            *   `\vfill`: Menggunakan `\vfill` lagi di akhir blok teks. Bersama dengan `\vfill` sebelumnya, ini kemungkinan besar bertujuan untuk memusatkan blok teks secara vertikal di halaman.
        *   **Jika `titlepage-background` tidak didefinisikan (tanpa gambar latar belakang)**:
            *   `\setstretch{1.4}`: Mengatur *line spacing* menjadi 1.4 (satu setengah spasi). *Line spacing* yang sedikit lebih kecil dari tata letak gambar latar belakang.
            *   `\vfill`: Menggunakan `\vfill` untuk mendorong konten ke bagian bawah halaman.
            *   `\noindent {\huge \textbf{\textsf{$title$}}}`: Menampilkan judul (sama dengan kasus gambar latar belakang).
            *   `$if(subtitle)$ \vskip 1em {\Large \textsf{$subtitle$}} $endif$`: Menampilkan *subtitle* (sama dengan kasus gambar latar belakang).
            *   `\vskip 2em \noindent {\Large \textsf{$for(author)$$author$$sep$, $endfor$}}`: Menampilkan daftar penulis (sama dengan kasus gambar latar belakang), tetapi **tidak menampilkan tanggal di sini**. Tanggal ditampilkan di tempat lain dalam tata letak tanpa gambar latar belakang.
            *   `\vfill`: Menggunakan `\vfill` lagi (sama dengan kasus gambar latar belakang, kemungkinan untuk *vertical centering*).
    *   **Conditional Logo Inclusion (`titlepage-logo`)**: `$if(titlepage-logo)$ ... `$endif$`. Jika variabel `$titlepage-logo` didefinisikan.
        *   `\noindent \includegraphics[width=$if(logo-width)$$logo-width$$else$35mm$endif$, left]{$titlepage-logo$}`: Menyisipkan logo gambar menggunakan `\includegraphics`.
            *   `width=$if(logo-width)$$logo-width$$else$35mm$endif$`: Lebar logo diambil dari variabel `$logo-width` jika didefinisikan, jika tidak, *default* lebar adalah 35mm.
            *   `left`: Opsi `left` mungkin tidak valid untuk `\includegraphics` dan kemungkinan sintaks yang salah atau opsi yang tidak berpengaruh. Opsi penempatan horizontal biasanya diatur melalui lingkungan atau perintah lain di LaTeX. *Setelah pengecekan dokumentasi graphicx, option `left` is indeed invalid within `\includegraphics`. It is likely intended for horizontal placement but misplaced.*
            *   `{$titlepage-logo}`: *Path* ke file gambar logo diambil dari variabel `$titlepage-logo`.
    *   **Conditional Date Placement (tanpa `titlepage-background`)**: `$if(titlepage-background)$ ... `$else$ \textsf{$date$} $endif$`.
        *   **Jika `titlepage-background` tidak didefinisikan**: `\textsf{$date$}`. Menampilkan tanggal dokumen (`$date$`) menggunakan *font* *sans-serif*. Dalam tata letak tanpa gambar latar belakang, tanggal ditampilkan di bagian bawah halaman, di luar blok teks utama (berbeda dengan tata letak dengan gambar latar belakang, di mana tanggal ditampilkan di dalam blok teks utama bersama penulis).
*   **Opsi Variabel terkait Gaya Judul**:
    *   `titlepage-text-color`: *String* (kode warna HTML). Warna teks bagian judul.
    *   `titlepage-rule-color`: *String* (kode warna HTML). Warna garis horizontal di bawah judul.
    *   `titlepage-rule-height`: *Number* (unit panjang LaTeX, misalnya, `4pt`, `0.3ex`). Ketebalan garis horizontal di bawah judul.
    *   `titlepage-logo`: *String* (path file gambar). *Path* ke file gambar logo halaman judul.
    *   `logo-width`: *String* (unit panjang LaTeX, misalnya, `35mm`, `2in`). Lebar logo halaman judul.

##### 7. `\restoregeometry` and `\pagenumbering{arabic}` (Pengembalian *Geometry* dan Penomoran Halaman)

```latex
\end{titlepage}
\restoregeometry
\pagenumbering{arabic}
$endif$
```

*   **Tujuan**: Mengembalikan *geometry* halaman ke pengaturan *default* setelah halaman judul, dan memulai penomoran halaman dengan angka Arab.
*   **Perintah LaTeX**: `\restoregeometry`, `\pagenumbering{arabic}`
*   **Packages**: `geometry`
*   **Variabel Pandoc**: Tidak ada variabel Pandoc yang langsung mengontrol bagian kode ini. Kode ini selalu diterapkan jika halaman judul diaktifkan (`$if(titlepage)$`).
    *   `\end{titlepage}`: Menutup lingkungan `titlepage`.
    *   `\restoregeometry`: Menggunakan perintah `\restoregeometry` (dari *package* `geometry`) untuk mengembalikan *geometry* halaman ke pengaturan yang berlaku sebelum perintah `\newgeometry` di halaman judul. Ini penting agar perubahan *geometry* yang diterapkan khusus untuk halaman judul tidak mempengaruhi halaman-halaman dokumen selanjutnya.
    *   `\pagenumbering{arabic}`: Mengatur gaya penomoran halaman menjadi angka Arab (`arabic`). Ini memastikan bahwa penomoran halaman dimulai dengan angka Arab (1, 2, 3, ...) setelah halaman judul (yang biasanya tidak diberi nomor atau menggunakan gaya penomoran yang berbeda, seperti angka Romawi kecil untuk halaman *preliminaries*).
*   **Opsi Variabel**: Tidak ada variabel Pandoc khusus yang secara langsung mengontrol bagian kode ini. Keberadaan bagian kode ini bergantung pada variabel `$titlepage` yang mengontrol pembuatan halaman judul secara keseluruhan.

---

**Variabel Pandoc yang Dapat Digunakan (YAML) untuk `eisvogel-title-page.latex`:**

Berikut adalah daftar variabel Pandoc yang relevan dari file `eisvogel-title-page.latex` dan opsi yang mungkin (sudah termasuk yang dijelaskan di atas dan diringkas):

*   **`titlepage`**: *Boolean*. Mengaktifkan pembuatan halaman judul.
*   **`titlepage-background`**: *String* (path file gambar). Mengaktifkan gambar latar belakang halaman judul dan menentukan *path* gambar. Juga mempengaruhi *geometry* dan tata letak teks halaman judul.
*   **`titlepage-color`**: *String* (kode warna HTML). Warna latar belakang halaman judul.
*   **`titlepage-text-color`**: *String* (kode warna HTML). Warna teks utama pada halaman judul.
*   **`titlepage-rule-color`**: *String* (kode warna HTML). Warna garis horizontal di bawah judul pada halaman judul.
*   **`titlepage-rule-height`**: *Number* (unit panjang LaTeX, misalnya, `4pt`). Ketebalan garis horizontal di bawah judul pada halaman judul.
*   **`titlepage-logo`**: *String* (path file gambar). *Path* ke file gambar logo yang akan ditampilkan di halaman judul.
*   **`logo-width`**: *String* (unit panjang LaTeX, misalnya, `35mm`). Lebar logo halaman judul.
*   **`title`**: *String*. Judul dokumen (ditampilkan di halaman judul).
*   **`subtitle`**: *String*. *Subtitle* dokumen (opsional, ditampilkan di halaman judul di bawah judul).
*   **`author`**: *String* atau *List* *String*. Nama penulis atau daftar nama penulis (ditampilkan di halaman judul).
*   **`date`**: *String*. Tanggal dokumen (ditampilkan di halaman judul, penempatan berbeda tergantung `titlepage-background`).

---