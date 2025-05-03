# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `after-header-includes.latex`

File ini digunakan untuk menambahkan perintah-perintah LaTeX **setelah** *header* utama dokumen dan **sebelum** konten dokumen. Ini berguna untuk menambahkan *package* atau konfigurasi LaTeX tambahan setelah *header* dasar dibuat oleh Pandoc.

Berikut adalah isi file `after-header-includes.latex` untuk referensi dan *copy-paste*:

```latex
\usepackage{bookmark}
\IfFileExists{xurl.sty}{\usepackage{xurl}}{} % add URL line breaks if available
\urlstyle{$if(urlstyle)$$urlstyle$$else$same$endif$}
$if(links-as-notes)$
% Make links footnotes instead of hotlinks:
\DeclareRobustCommand{\href}[2]{#2\footnote{\url{#1}}}
$endif$
$if(verbatim-in-note)$
\VerbatimFootnotes % allow verbatim text in footnotes
$endif$
```

**Penjelasan baris per baris (tanpa sintaks LaTeX di penjelasan):**

*   **Pemuatan Package `bookmark`**: Baris pertama berfungsi untuk memuat *package* LaTeX yang bernama `bookmark`. Package ini memiliki fungsi untuk menghasilkan *bookmark* atau penanda navigasi pada dokumen PDF. *Bookmark* ini akan muncul di panel navigasi PDF *viewer*, memudahkan pembaca untuk berpindah antar bagian dokumen.

*   **Pemuatan Kondisional Package `xurl` untuk Pemutusan Baris URL**: Baris kedua adalah perintah kondisional yang memeriksa keberadaan *package* `xurl.sty`. Jika *package* ini tersedia, maka `xurl` akan dimuat. Fungsi utama dari *package* `xurl` adalah untuk memungkinkan pemutusan baris otomatis pada URL yang terlalu panjang. Hal ini mencegah URL keluar dari batas margin halaman.

*   **Pengaturan Gaya URL Secara Kondisional**: Baris ketiga digunakan untuk mengatur tampilan gaya URL. Pengaturan ini bersifat kondisional, tergantung pada apakah variabel `urlstyle` didefinisikan dalam konfigurasi Pandoc. Jika `urlstyle` didefinisikan, gaya URL akan mengikuti nilai variabel tersebut. Jika tidak, gaya URL akan diatur agar sama dengan teks sekitarnya.

*   **Blok Kondisional: Mengubah Link Menjadi Catatan Kaki**: Blok kode yang dimulai dengan `$if(links-as-notes)$` hingga `$endif$` adalah blok kondisional. Blok ini hanya aktif jika variabel Pandoc `links-as-notes` diaktifkan. Jika aktif, link dalam dokumen tidak akan menjadi *hotlink* (link yang bisa diklik langsung), melainkan akan diubah menjadi catatan kaki (*footnote*). Teks link akan tetap ada di dokumen, sementara URL tujuan akan dipindahkan ke catatan kaki di bagian bawah halaman.

*   **Blok Kondisional: Mengizinkan Teks Verbatim dalam Catatan Kaki**: Blok kode yang dimulai dengan `$if(verbatim-in-note)$` hingga `$endif$` juga merupakan blok kondisional. Blok ini aktif jika variabel Pandoc `verbatim-in-note` diatur. Jika aktif, fitur yang memungkinkan teks *verbatim* (seperti kode) dimasukkan ke dalam catatan kaki akan diaktifkan. Fitur ini penting agar kode dalam catatan kaki dapat ditampilkan dengan benar tanpa kesalahan format LaTeX.

### Variabel Pandoc yang Dapat Digunakan (YAML)

Beberapa aspek dari `after-header-includes.latex` dapat dikontrol melalui variabel Pandoc. Variabel-variabel ini biasanya didefinisikan dalam file YAML (misalnya, `metadata.yaml`) atau dapat juga diberikan melalui *command line* Pandoc. Berikut adalah variabel yang relevan dan opsi yang mungkin:

*   **`urlstyle`**: Variabel ini digunakan untuk menentukan gaya tampilan URL dalam dokumen.

    *   **Opsi yang mungkin**:  Variabel ini menerima nilai *string* yang merepresentasikan *style* URL LaTeX. Beberapa opsi umum meliputi:
        *   `"tt"`: Menampilkan URL dengan gaya *monospace* (seperti teks pada mesin tik). Contoh: `\texttt{https://www.example.com}`.
        *   `"rm"`: Menampilkan URL dengan gaya *roman* (gaya teks normal). Contoh: `\textrm{https://www.example.com}`.
        *   `"sf"`: Menampilkan URL dengan gaya *sans-serif*. Contoh: `\textsf{https://www.example.com}`.
        *   `"same"`: Menggunakan gaya yang sama dengan teks di sekitarnya (ini adalah perilaku *default* jika variabel `urlstyle` tidak didefinisikan).
    *   **Contoh penggunaan dalam YAML**:
        ```yaml
        urlstyle: "tt"
        ```
        Dengan konfigurasi ini, semua URL dalam dokumen akan ditampilkan menggunakan gaya *monospace*.

*   **`links-as-notes`**: Variabel *boolean* ini menentukan apakah *link* akan ditampilkan sebagai *hotlink* atau sebagai catatan kaki.

    *   **Opsi yang mungkin**:
        *   `true` atau `yes`: Mengaktifkan fitur *links-as-notes*. Semua *link* akan diubah menjadi catatan kaki.
        *   `false` atau `no`: Menonaktifkan fitur *links-as-notes*. *Link* akan tetap menjadi *hotlink* (perilaku *default*).
    *   **Contoh penggunaan dalam YAML**:
        ```yaml
        links-as-notes: true
        ```
        Dengan konfigurasi ini, semua *link* dalam dokumen akan diubah menjadi catatan kaki dengan URL tujuan berada di catatan kaki.

*   **`verbatim-in-note`**: Variabel *boolean* ini mengontrol apakah teks *verbatim* (seperti kode) diizinkan dalam catatan kaki.

    *   **Opsi yang mungkin**:
        *   `true` atau `yes`: Mengaktifkan dukungan teks *verbatim* dalam catatan kaki. Anda perlu mengaktifkan ini jika Anda berencana memasukkan kode atau teks *verbatim* lain ke dalam catatan kaki.
        *   `false` atau `no`: Menonaktifkan dukungan teks *verbatim* dalam catatan kaki (perilaku *default*). Jika Anda memasukkan teks *verbatim* ke catatan kaki tanpa mengaktifkan opsi ini, kompilasi LaTeX mungkin gagal.
    *   **Contoh penggunaan dalam YAML**:
        ```yaml
        verbatim-in-note: true
        ```
        Dengan konfigurasi ini, Anda dapat dengan aman memasukkan kode atau teks *verbatim* ke dalam catatan kaki tanpa menyebabkan masalah pada kompilasi LaTeX.

---