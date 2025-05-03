# Penjelasan Template Pandoc to PDF dengan LaTeX

Template ini digunakan untuk mengkonversi dokumen dari format Markdown atau format teks lainnya menjadi PDF menggunakan Pandoc dan LaTeX. Template ini terdiri dari beberapa file yang bekerja bersama untuk menghasilkan dokumen PDF yang diformat sesuai dengan keinginan.

## `font-settings.latex`

File `font-settings.latex` bertanggung jawab untuk mengatur konfigurasi *font* dokumen. File ini menyediakan fleksibilitas yang luas dalam memilih dan menyesuaikan *font family*, *main font*, *sans-serif font*, *monospace font*, *math font*, dan *CJK (Chinese, Japanese, Korean) font*. File ini juga mendukung *fallback font* untuk XeTeX dan LuaTeX, serta opsi *font family* dan *mathspec*. Selain itu, file ini menyertakan dukungan untuk *zero-width non-joiner* (ZWNJ) karakter dan memuat *package* `upquote` dan `microtype` untuk meningkatkan kualitas tipografi dokumen. Konfigurasi *font* sangat dikendalikan oleh berbagai variabel YAML, yang memungkinkan pengguna untuk menyesuaikan tampilan teks dokumen secara detail.

Berikut adalah isi file `font-settings.latex` dan penjelasannya per bagian:

```latex
$-- User font settings (must come after default font and Beamer theme)
$if(fontfamily)$
\usepackage[$for(fontfamilyoptions)$$fontfamilyoptions$$sep$,$endfor$]{$fontfamily$}
$endif$
\ifPDFTeX\else
  % xetex/luatex font selection
$if(mainfont)$
  $if(mainfontfallback)$
    \ifLuaTeX
      \usepackage{luaotfload}
      \directlua{luaotfload.add_fallback("mainfontfallback",{
        $for(mainfontfallback)$"$mainfontfallback$"$sep$,$endfor$
      })}
    \fi
  $endif$
  \setmainfont[$for(mainfontoptions)$$mainfontoptions$$sep$,$endfor$$if(mainfontfallback)$,RawFeature={fallback=mainfontfallback}$endif$]{$mainfont$}
$endif$
$if(sansfont)$
  $if(sansfontfallback)$
    \ifLuaTeX
      \usepackage{luaotfload}
      \directlua{luaotfload.add_fallback("sansfontfallback",{
        $for(sansfontfallback)$"$sansfontfallback$"$sep$,$endfor$
      })}
    \fi
  $endif$
  \setsansfont[$for(sansfontoptions)$$sansfontoptions$$sep$,$endfor$$if(sansfontfallback)$,RawFeature={fallback=sansfontfallback}$endif$]{$sansfont$}
$endif$
$if(monofont)$
  $if(monofontfallback)$
    \ifLuaTeX
      \usepackage{luaotfload}
      \directlua{luaotfload.add_fallback("monofontfallback",{
        $for(monofontfallback)$"$monofontfallback$"$sep$,$endfor$
      })}
    \fi
  $endif$
  \setmonofont[$for(monofontoptions)$$monofontoptions$$sep$,$endfor$$if(monofontfallback)$,RawFeature={fallback=monofontfallback}$endif$]{$monofont$}
$endif$
$for(fontfamilies)$
  \newfontfamily{$fontfamilies.name$}[$for(fontfamilies.options)$$fontfamilies.options$$sep$,$endfor$]{$fontfamilies.font$}
$endfor$
$if(mathfont)$
$if(mathspec)$
  \ifXeTeX
    \setmathfont(Digits,Latin,Greek)[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]{$mathfont$}
  \else
    \setmathfont[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]{$mathfont$}
  \fi
$else$
  \setmathfont[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]{$mathfont$}
$endif$
$endif$
$if(CJKmainfont)$
  \ifXeTeX
    \usepackage{xeCJK}
    \setCJKmainfont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKmainfont$}
    $if(CJKsansfont)$
      \setCJKsansfont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKsansfont$}
    $endif$
    $if(CJKmonofont)$
      \setCJKmonofont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKmonofont$}
    $endif$
  \fi
$endif$
$if(luatexjapresetoptions)$
  \ifLuaTeX
    \usepackage[$for(luatexjapresetoptions)$$luatexjapresetoptions$$sep$,$endfor$]{luatexja-preset}
  \fi
$endif$
$if(CJKmainfont)$
  \ifLuaTeX
    \usepackage[$for(luatexjafontspecoptions)$$luatexjafontspecoptions$$sep$,$endfor$]{luatexja-fontspec}
    \setmainjfont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKmainfont$}
  \fi
$endif$
\fi
$if(zero-width-non-joiner)$
%% Support for zero-width non-joiner characters.
\makeatletter
\def\zerowidthnonjoiner{%
  % Prevent ligatures and adjust kerning, but still support hyphenating.
  \texorpdfstring{%
    \TextOrMath{\nobreak\discretionary{-}{}{\kern.03em}%
      \ifvmode\else\nobreak\hskip\z@skip\fi}{}%
  }{}%
}
\makeatother
\ifPDFTeX
  \DeclareUnicodeCharacter{200C}{\zerowidthnonjoiner}
\else
  \catcode`^^^^200c=\active
  \protected\def ^^^^200c{\zerowidthnonjoiner}
\fi
%% End of ZWNJ support
$endif$
% Use upquote if available, for straight quotes in verbatim environments
\IfFileExists{upquote.sty}{\usepackage{upquote}}{}
\IfFileExists{microtype.sty}{% use microtype if available
  \usepackage[$for(microtypeoptions)$$microtypeoptions$$sep$,$endfor$]{microtype}
  \UseMicrotypeSet[protrusion]{basicmath} % disable protrusion for tt fonts
}{}
```

#### Penjelasan per Bagian dari `font-settings.latex`:

##### 1. `fontfamily` Package Loading (Pemuatan *Package* `fontfamily`)

```latex
$-- User font settings (must come after default font and Beamer theme)
$if(fontfamily)$
\usepackage[$for(fontfamilyoptions)$$fontfamilyoptions$$sep$,$endfor$]{$fontfamily$}
$endif$
```

*   **Tujuan**: Memuat *package* LaTeX yang ditentukan oleh variabel `fontfamily` untuk konfigurasi *font family* dasar dokumen, jika variabel tersebut didefinisikan.
*   **Perintah LaTeX**: `\usepackage`
*   **Variabel Pandoc**: `fontfamily`, `fontfamilyoptions`
    *   **Kondisional `fontfamily`**: `$if(fontfamily)$ ... $endif$`. Jika variabel `fontfamily` didefinisikan, blok kode di dalamnya akan diproses.
    *   `\usepackage[$for(fontfamilyoptions)$$fontfamilyoptions$$sep$,$endfor$]{$fontfamily$}`: Memuat *package* LaTeX menggunakan perintah `\usepackage`.
        *   `$fontfamily`: Nama *package* *font family* diambil dari variabel Pandoc `$fontfamily`. Contoh: `"mathptmx"`, `"helvet"`, `" courier"`.
        *   `[$for(fontfamilyoptions)$$fontfamilyoptions$$sep$,$endfor$]`: Opsi untuk *package* `fontfamily` diambil dari variabel daftar `$fontfamilyoptions`. Loop Pandoc `$for(fontfamilyoptions)...$ $endfor$` menghasilkan daftar opsi yang dipisahkan koma. Contoh opsi: `"sc"`, `"osf"`.
*   **Opsi Variabel `fontfamily`**: *String*. Nama *package* *font family* LaTeX. Menentukan *font family* dasar dokumen (misalnya, Times New Roman, Helvetica, Courier).
*   **Opsi Variabel `fontfamilyoptions`**: *List* *String*. Daftar opsi untuk *package* `fontfamily`. Memungkinkan konfigurasi *font family* lebih lanjut (misalnya, penggunaan *font* *small caps*, *old-style figures*, dll.).

##### 2. XeTeX/LuaTeX Font Selection (Pemilihan *Font* untuk XeTeX/LuaTeX)

```latex
\ifPDFTeX\else
  % xetex/luatex font selection
$if(mainfont)$
  $if(mainfontfallback)$
    \ifLuaTeX
      \usepackage{luaotfload}
      \directlua{luaotfload.add_fallback("mainfontfallback",{
        $for(mainfontfallback)$"$mainfontfallback$"$sep$,$endfor$
      })}
    \fi
  $endif$
  \setmainfont[$for(mainfontoptions)$$mainfontoptions$$sep$,$endfor$$if(mainfontfallback)$,RawFeature={fallback=mainfontfallback}$endif$]{$mainfont$}
$endif$
$if(sansfont)$
  ... (blok serupa untuk `sansfont` dan `sansfontfallback`) ...
$endif$
$if(monofont)$
  ... (blok serupa untuk `monofont` dan `monofontfallback`) ...
$endif$
$for(fontfamilies)$
  \newfontfamily{$fontfamilies.name$}[$for(fontfamilies.options)$$fontfamilies.options$$sep$,$endfor$]{$fontfamilies.font$}
$endfor$
$if(mathfont)$
  ... (blok untuk `mathfont` dan `mathspec` condition) ...
$endif$
$if(CJKmainfont)$
  ... (blok untuk `CJKmainfont`, `CJKsansfont`, `CJKmonofont` dan engine condition) ...
$endif$
$if(luatexjapresetoptions)$
  ... (blok untuk `luatexjapresetoptions` dan LuaTeX condition) ...
$endif$
$if(CJKmainfont)$
  ... (blok kedua untuk `CJKmainfont` dan LuaTeX condition with `luatexja-fontspec`) ...
$endif$
\fi
```

*   **Tujuan**: Mengatur *main font*, *sans-serif font*, *monospace font*, *additional font families*, *math font*, dan *CJK font* untuk XeTeX dan LuaTeX *engine*. Bagian ini **hanya** dieksekusi jika *engine* LaTeX yang digunakan **bukan** PDFTeX (`\ifPDFTeX\else ... \fi`).
*   **Kondisi *Engine***: `\ifPDFTeX\else ... \fi`. Memastikan kode di dalam blok `\else` hanya diproses jika *engine* bukan PDFTeX (yaitu, XeTeX atau LuaTeX). PDFTeX menggunakan mekanisme pemilihan *font* yang berbeda (*font family* *packages*), sementara XeTeX dan LuaTeX menggunakan *font feature* sistem operasi.

    *   **Main Font Configuration (`mainfont`, `mainfontoptions`, `mainfontfallback`)**:
        ```latex
        $if(mainfont)$
          $if(mainfontfallback)$
            \ifLuaTeX
              \usepackage{luaotfload}
              \directlua{luaotfload.add_fallback("mainfontfallback",{
                $for(mainfontfallback)$"$mainfontfallback$"$sep$,$endfor$
              })}
            \fi
          $endif$
          \setmainfont[$for(mainfontoptions)$$mainfontoptions$$sep$,$endfor$$if(mainfontfallback)$,RawFeature={fallback=mainfontfallback}$endif$]{$mainfont$}
        $endif$
        ```
        *   **Kondisional `mainfont`**: `$if(mainfont)$ ... $endif$`. Jika variabel `mainfont` didefinisikan, konfigurasi *main font* akan diterapkan.
        *   **Fallback Font (Kondisional `mainfontfallback` dan LuaTeX)**:
            *   `$if(mainfontfallback)$ \ifLuaTeX ... \fi $endif$`. Jika variabel `mainfontfallback` didefinisikan dan *engine* adalah LuaTeX.
            *   `\usepackage{luaotfload}`: Memuat *package* `luaotfload` (hanya untuk LuaTeX), yang menyediakan fitur *font management* tingkat lanjut dalam LuaTeX.
            *   `\directlua{luaotfload.add_fallback("mainfontfallback",{ ... })}`: Menggunakan `\directlua` untuk menjalankan kode Lua dan memanggil fungsi `luaotfload.add_fallback`. Ini mendefinisikan *fallback font set* bernama `"mainfontfallback"`. Jika karakter tidak ditemukan dalam *main font* utama, LuaTeX akan mencoba *font*-*font* dalam *fallback set* ini secara berurutan. *Font*-*font* dalam *fallback set* diambil dari variabel daftar `$mainfontfallback`.
        *   `\setmainfont[...] {$mainfont$}`: Mengatur *main font* dokumen menggunakan perintah `\setmainfont` (dari *package* `fontspec`, yang diasumsikan sudah dimuat atau dimuat secara implisit).
            *   `[$for(mainfontoptions)$$mainfontoptions$$sep$,$endfor$$if(mainfontfallback)$,RawFeature={fallback=mainfontfallback}$endif$]`: Opsi untuk `\setmainfont` diambil dari variabel daftar `$mainfontoptions`. Jika `mainfontfallback` juga didefinisikan, opsi `RawFeature={fallback=mainfontfallback}` ditambahkan untuk mengaktifkan *fallback font set* yang didefinisikan sebelumnya.
            *   `{$mainfont$}`: Nama *font* *main font* diambil dari variabel Pandoc `$mainfont`. Ini harus berupa nama *font* yang dikenal oleh sistem operasi (misalnya, `"Times New Roman"`, `"Arial"`, `"Libertinus Serif"`).

    *   **Sans-Serif Font Configuration (`sansfont`, `sansfontoptions`, `sansfontfallback`)**: Blok kode yang sangat mirip dengan konfigurasi *main font*, tetapi menggunakan perintah `\setsansfont` dan variabel `sansfont`, `sansfontoptions`, dan `sansfontfallback` untuk mengatur *sans-serif font*.

    *   **Monospace Font Configuration (`monofont`, `monofontoptions`, `monofontfallback`)**: Blok kode yang sangat mirip dengan konfigurasi *main font*, tetapi menggunakan perintah `\setmonofont` dan variabel `monofont`, `monofontoptions`, dan `monofontfallback` untuk mengatur *monospace font*.

    *   **Additional Font Families (`fontfamilies`)**:
        ```latex
        $for(fontfamilies)$
          \newfontfamily{$fontfamilies.name$}[$for(fontfamilies.options)$$fontfamilies.options$$sep$,$endfor$]{$fontfamilies.font$}
        $endfor$
        ```
        *   **Loop `fontfamilies`**: `$for(fontfamilies)$ ... $endfor$`. Loop ini memproses daftar *font families* tambahan yang didefinisikan dalam variabel daftar `$fontfamilies`. Setiap elemen dalam daftar `$fontfamilies` diasumsikan sebagai objek (atau *map*) dengan properti `name`, `options`, dan `font`.
        *   `\newfontfamily{$fontfamilies.name$} [...] {$fontfamilies.font$}`: Mendefinisikan *font family* baru menggunakan perintah `\newfontfamily` (dari *package* `fontspec`).
            *   `{$fontfamilies.name$}`: Nama untuk *font family* baru diambil dari properti `name` dari elemen saat ini dalam loop `$fontfamilies`. Ini adalah nama perintah yang akan digunakan untuk mengakses *font family* ini dalam dokumen (misalnya, `\myfontfamily`).
            *   `[$for(fontfamilies.options)$$fontfamilies.options$$sep$,$endfor$]`: Opsi untuk `\newfontfamily` diambil dari properti `options` dari elemen saat ini dalam loop `$fontfamilies`.
            *   `{$fontfamilies.font$}`: Nama file *font* atau nama *font* sistem diambil dari properti `font` dari elemen saat ini dalam loop `$fontfamilies`.

    *   **Math Font Configuration (`mathfont`, `mathfontoptions`, `mathspec`)**:
        ```latex
        $if(mathfont)$
        $if(mathspec)$
          \ifXeTeX
            \setmathfont(Digits,Latin,Greek)[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]{$mathfont$}
          \else
            \setmathfont[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]{$mathfont$}
          \fi
        $else$
          \setmathfont[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]{$mathfont$}
        $endif$
        $endif$
        ```
        *   **Kondisional `mathfont`**: `$if(mathfont)$ ... $endif$`. Jika variabel `mathfont` didefinisikan, konfigurasi *math font* akan diterapkan.
        *   **`mathspec` Condition (Kondisional `mathspec`)**: `$if(mathspec)$ ... $else$ ... $endif$`. Jika variabel `mathspec` didefinisikan. Variabel `mathspec` kemungkinan menunjukkan apakah *package* `mathspec` digunakan atau tidak.
            *   **Jika `mathspec` didefinisikan**:
                *   `\ifXeTeX ... \else ... \fi`. Memeriksa apakah *engine* adalah XeTeX.
                    *   **Jika XeTeX**: `\setmathfont(Digits,Latin,Greek)[...] {$mathfont$}`. Menggunakan `\setmathfont(Digits,Latin,Greek)` untuk mengatur *math font* **hanya untuk *digits*, huruf Latin, dan huruf Yunani**. Ini mungkin diperlukan untuk kompatibilitas dengan *package* `mathspec` di XeTeX.
                    *   **Jika Bukan XeTeX (LuaTeX)**: `\setmathfont[...] {$mathfont$}`. Menggunakan `\setmathfont` tanpa batasan lebih lanjut untuk LuaTeX.
            *   **Jika `mathspec` tidak didefinisikan**: `\setmathfont[...] {$mathfont$}`. Menggunakan `\setmathfont` tanpa batasan, diasumsikan *package* `mathspec` tidak digunakan.
        *   `\setmathfont[...] {$mathfont$}`: Mengatur *math font* menggunakan perintah `\setmathfont` (dari *package* `fontspec` atau `unicode-math`).
            *   `[$for(mathfontoptions)$$mathfontoptions$$sep$,$endfor$]`: Opsi untuk `\setmathfont` diambil dari variabel daftar `$mathfontoptions`.
            *   `{$mathfont$}`: Nama *font* *math font* diambil dari variabel Pandoc `$mathfont`.

    *   **CJK Font Configuration (`CJKmainfont`, `CJKsansfont`, `CJKmonofont`, `CJKoptions`)**:
        ```latex
        $if(CJKmainfont)$
          \ifXeTeX
            \usepackage{xeCJK}
            \setCJKmainfont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKmainfont$}
            $if(CJKsansfont)$
              \setCJKsansfont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKsansfont$}
            $endif$
            $if(CJKmonofont)$
              \setCJKmonofont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKmonofont$}
            $endif$
          \fi
        $endif$
        $if(luatexjapresetoptions)$
          \ifLuaTeX
            \usepackage[$for(luatexjapresetoptions)$$luatexjapresetoptions$$sep$,$endfor$]{luatexja-preset}
          \fi
        $endif$
        $if(CJKmainfont)$
          \ifLuaTeX
            \usepackage[$for(luatexjafontspecoptions)$$luatexjafontspecoptions$$sep$,$endfor$]{luatexja-fontspec}
            \setmainjfont[$for(CJKoptions)$$CJKoptions$$sep$,$endfor$]{$CJKmainfont$}
          \fi
        $endif$
        ```
        *   **`CJKmainfont` for XeTeX**:
            *   `$if(CJKmainfont)$ \ifXeTeX ... \fi $endif$`. Jika variabel `CJKmainfont` didefinisikan dan *engine* adalah XeTeX.
            *   `\usepackage{xeCJK}`: Memuat *package* `xeCJK`, yang menyediakan dukungan CJK di XeTeX.
            *   `\setCJKmainfont[...] {$CJKmainfont$}`: Mengatur *main CJK font* menggunakan perintah `\setCJKmainfont` (dari *package* `xeCJK`). Opsi diambil dari `$CJKoptions`.
            *   **`CJKsansfont`, `CJKmonofont` (Kondisional di dalam `CJKmainfont` dan XeTeX)**: `$if(CJKsansfont)$ ... $endif$` and `$if(CJKmonofont)$ ... $endif$`. Jika variabel `CJKsansfont` dan `CJKmonofont` didefinisikan, mengatur *CJK sans-serif font* dan *CJK monospace font* menggunakan `\setCJKsansfont` dan `\setCJKmonofont` (dari *package* `xeCJK`), dengan opsi dari `$CJKoptions`.
        *   **`luatexjapresetoptions` for LuaTeX**:
            *   `$if(luatexjapresetoptions)$ \ifLuaTeX ... \fi $endif$`. Jika variabel `luatexjapresetoptions` didefinisikan dan *engine* adalah LuaTeX.
            *   `\usepackage[$for(luatexjapresetoptions)$$luatexjapresetoptions$$sep$,$endfor$]{luatexja-preset}`: Memuat *package* `luatexja-preset` dengan opsi dari `$luatexjapresetoptions`. *Package* `luatexja-preset` adalah *package* untuk dukungan bahasa Jepang di LuaLaTeX, dan menyediakan konfigurasi *font* *preset* dan opsi terkait tipografi Jepang.
        *   **`CJKmainfont` for LuaTeX with `luatexja-fontspec`**:
            *   `$if(CJKmainfont)$ \ifLuaTeX ... \fi $endif$`. Jika variabel `CJKmainfont` didefinisikan dan *engine* adalah LuaTeX.
            *   `\usepackage[$for(luatexjafontspecoptions)$$luatexjafontspecoptions$$sep$,$endfor$]{luatexja-fontspec}`: Memuat *package* `luatexja-fontspec` dengan opsi dari `$luatexjafontspecoptions`. *Package* `luatexja-fontspec` menyediakan antarmuka *fontspec*-style untuk konfigurasi *font* CJK di LuaLaTeX, menawarkan lebih banyak kontrol dan fleksibilitas daripada `luatexja-preset`.
            *   `\setmainjfont[...] {$CJKmainfont$}`: Mengatur *main Japanese font* menggunakan perintah `\setmainjfont` (dari *package* `luatexja-fontspec`). Opsi diambil dari `$CJKoptions`. *Meskipun perintah ini bernama `\setmainjfont` (Japanese font), opsi `$CJKoptions` dan variabel `$CJKmainfont` bernama `CJKmainfont` menunjukkan bahwa ini mungkin digunakan untuk *main CJK font* secara umum, bukan hanya Japanese.*

*   **Opsi Variabel terkait Font Selection (XeTeX/LuaTeX)**:
    *   **`mainfont`**: *String*. Nama *main font* sistem untuk XeTeX/LuaTeX.
    *   **`mainfontoptions`**: *List* *String*. Opsi untuk `\setmainfont`.
    *   **`mainfontfallback`**: *List* *String*. Daftar *fallback font* untuk *main font* (hanya LuaTeX).
    *   **`sansfont`**: *String*. Nama *sans-serif font* sistem untuk XeTeX/LuaTeX.
    *   **`sansfontoptions`**: *List* *String*. Opsi untuk `\setsansfont`.
    *   **`sansfontfallback`**: *List* *String*. Daftar *fallback font* untuk *sans-serif font* (hanya LuaTeX).
    *   **`monofont`**: *String*. Nama *monospace font* sistem untuk XeTeX/LuaTeX.
    *   **`monofontoptions`**: *List* *String*. Opsi untuk `\setmonofont`.
    *   **`monofontfallback`**: *List* *String*. Daftar *fallback font* untuk *monospace font* (hanya LuaTeX).
    *   **`fontfamilies`**: *List* *Object* (*Map*). Daftar *font families* tambahan yang didefinisikan dengan `\newfontfamily`. Setiap objek harus memiliki properti `name`, `options`, dan `font`.
    *   **`mathfont`**: *String*. Nama *math font* sistem untuk XeTeX/LuaTeX.
    *   **`mathfontoptions`**: *List* *String*. Opsi untuk `\setmathfont`.
    *   **`mathspec`**: *Boolean*. Menandakan penggunaan *package* `mathspec` (mempengaruhi konfigurasi `\setmathfont` di XeTeX).
    *   **`CJKmainfont`**: *String*. Nama *main CJK font* sistem untuk XeTeX/LuaTeX.
    *   **`CJKoptions`**: *List* *String*. Opsi untuk perintah *CJK font* (`\setCJKmainfont`, `\setCJKsansfont`, `\setCJKmonofont`, `\setmainjfont`).
    *   **`CJKsansfont`**: *String*. Nama *CJK sans-serif font* sistem untuk XeTeX (kondisional `CJKmainfont`).
    *   **`CJKmonofont`**: *String*. Nama *CJK monospace font* sistem untuk XeTeX (kondisional `CJKmainfont`).
    *   **`luatexjapresetoptions`**: *List* *String*. Opsi untuk *package* `luatexja-preset` (hanya LuaTeX).
    *   **`luatexjafontspecoptions`**: *List* *String*. Opsi untuk *package* `luatexja-fontspec` (hanya LuaTeX).

##### 3. Zero-Width Non-Joiner (ZWNJ) Support (Dukungan *Zero-Width Non-Joiner*)

```latex
$if(zero-width-non-joiner)$
%% Support for zero-width non-joiner characters.
\makeatletter
\def\zerowidthnonjoiner{%
  % Prevent ligatures and adjust kerning, but still support hyphenating.
  \texorpdfstring{%
    \TextOrMath{\nobreak\discretionary{-}{}{\kern.03em}%
      \ifvmode\else\nobreak\hskip\z@skip\fi}{}%
  }{}%
}
\makeatother
\ifPDFTeX
  \DeclareUnicodeCharacter{200C}{\zerowidthnonjoiner}
\else
  \catcode`^^^^200c=\active
  \protected\def ^^^^200c{\zerowidthnonjoiner}
\fi
%% End of ZWNJ support
$endif$
```

*   **Tujuan**: Menyediakan dukungan untuk karakter *zero-width non-joiner* (ZWNJ, Unicode U+200C) dalam dokumen. ZWNJ adalah karakter kontrol yang digunakan dalam beberapa sistem tulisan (seperti Arab, Persia, India) untuk mencegah pembentukan *ligatures* atau menyesuaikan *kerning* antar karakter, sambil tetap memungkinkan pemisahan kata (*hyphenation*).
*   **Kondisional `zero-width-non-joiner`**: `$if(zero-width-non-joiner)$ ... $endif$`. Jika variabel `zero-width-non-joiner` didefinisikan, dukungan ZWNJ akan diaktifkan.
*   **Definisi Perintah `\zerowidthnonjoiner`**:
    *   `\makeatletter ... \makeatother`: Menggunakan `\makeatletter` dan `\makeatother` untuk memungkinkan penggunaan karakter `@` dalam definisi perintah.
    *   `\def\zerowidthnonjoiner{...}`: Mendefinisikan perintah baru bernama `\zerowidthnonjoiner`. Perintah ini dirancang untuk disisipkan ketika karakter ZWNJ ditemui dalam input dokumen.
    *   `\texorpdfstring{...}{}`: Menggunakan `\texorpdfstring` untuk menyediakan definisi yang berbeda untuk LaTeX dan PDF *bookmarks*/*metadata*. Argumen kedua kosong `{}` berarti karakter ZWNJ tidak akan muncul dalam *bookmarks* atau *metadata* PDF. Argumen pertama adalah definisi LaTeX yang kompleks:
        *   `\TextOrMath{...}{}`: Menggunakan `\TextOrMath` untuk menyediakan definisi yang berbeda untuk *text mode* dan *math mode*. Argumen kedua kosong `{}` berarti tidak ada tindakan khusus yang diambil dalam *math mode* (ZWNJ mungkin tidak relevan atau ditangani secara berbeda dalam matematika). Argumen pertama adalah definisi *text mode*:
            *   `\nobreak\discretionary{-}{}{\kern.03em}`: Kombinasi perintah untuk mengontrol pemisahan kata dan *kerning*.
                *   `\nobreak`: Mencegah pemisahan baris di titik ini.
                *   `\discretionary{-}{}{\kern.03em}`: Memungkinkan *hyphenation* (pemisahan kata) tetapi dengan hati-hati. `\discretionary{before-break}{after-break}{no-break}`. Di sini: `before-break` adalah `-` (hyphen), `after-break` adalah kosong (tidak ada setelah pemisahan), `no-break` adalah `\kern.03em` (sedikit ruang horizontal jika tidak ada pemisahan). Ini berarti jika pemisahan kata terjadi di ZWNJ, sebuah *hyphen* akan disisipkan. Jika tidak ada pemisahan kata, ruang kecil 0.03em akan disisipkan untuk *kerning* halus.
            *   `\ifvmode\else\nobreak\hskip\z@skip\fi`: Menambahkan kondisi berdasarkan *vertical mode* (`\ifvmode`). Jika tidak dalam *vertical mode* (yaitu, dalam paragraf horizontal), menambahkan `\nobreak\hskip\z@skip`. Ini kemungkinan untuk mencegah pemisahan baris dan menambahkan *horizontal skip* 0pt (`\z@skip`) jika tidak dalam *vertical mode*. `\nobreak` redundant di sini karena sudah ada di dalam `\TextOrMath`, *so this part might be redundant or for extra precaution.*
*   **Implementasi untuk PDFTeX dan Non-PDFTeX**:
    *   `\ifPDFTeX ... \else ... \fi`. Membedakan implementasi untuk PDFTeX dan *engine* lain (XeTeX/LuaTeX).
    *   **PDFTeX**: `\DeclareUnicodeCharacter{200C}{\zerowidthnonjoiner}`. Menggunakan `\DeclareUnicodeCharacter` untuk mengasosiasikan karakter Unicode U+200C (ZWNJ) dengan perintah `\zerowidthnonjoiner`. Dalam PDFTeX, ini adalah cara standar untuk menangani karakter Unicode khusus.
    *   **Non-PDFTeX (XeTeX/LuaTeX)**:
        *   `\catcode`^^^^200c=\active`: Mengatur *category code* karakter Unicode U+200C menjadi *active*. Ini membuat karakter aktif, yang berarti dapat memiliki definisi perintah terkait. `^^^^200c` adalah representasi *character code* U+200C dalam notasi LaTeX.
        *   `\protected\def ^^^^200c{\zerowidthnonjoiner}`: Mendefinisikan karakter aktif U+200C untuk menjalankan perintah `\zerowidthnonjoiner`. `\protected\def` digunakan untuk definisi perintah yang robust.

*   **Opsi Variabel `zero-width-non-joiner`**: *Boolean*. Mengaktifkan atau menonaktifkan dukungan untuk karakter *zero-width non-joiner* (ZWNJ).

##### 4. `upquote` and `microtype` Package Loading (Pemuatan *Package* `upquote` dan `microtype`)

```latex
% Use upquote if available, for straight quotes in verbatim environments
\IfFileExists{upquote.sty}{\usepackage{upquote}}{}
\IfFileExists{microtype.sty}{% use microtype if available
  \usepackage[$for(microtypeoptions)$$microtypeoptions$$sep$,$endfor$]{microtype}
  \UseMicrotypeSet[protrusion]{basicmath} % disable protrusion for tt fonts
}{}
```

*   **Tujuan**: Memuat *package* `upquote` dan `microtype` jika file *package* mereka ada. Kedua *package* ini meningkatkan tipografi dokumen.
*   **Conditional Package Loading using `\IfFileExists`**: `\IfFileExists{package.sty}{load-package-command}{}`. Perintah `\IfFileExists` memeriksa apakah file *package* `.sty` ada sebelum mencoba memuat *package*. Jika file ada, perintah pemuatan *package* dijalankan; jika tidak, tidak ada yang dilakukan (argumen ketiga kosong `{}`). Ini adalah cara yang aman untuk memuat *package* opsional yang mungkin tidak selalu tersedia di semua sistem.

    *   **`upquote`**:
        *   `\IfFileExists{upquote.sty}{\usepackage{upquote}}{}`: Memeriksa apakah file `upquote.sty` ada. Jika ya, memuat *package* `upquote` menggunakan `\usepackage{upquote}`.
        *   **Tujuan `upquote`**: *Package* `upquote` digunakan untuk menangani *straight quotes* (``'`` dan ``"``) dengan lebih baik dalam lingkungan *verbatim*. Secara *default*, LaTeX mungkin tidak menangani *straight quotes* dalam *verbatim environments* dengan baik, dan `upquote` memperbaiki ini.
    *   **`microtype`**:
        *   `\IfFileExists{microtype.sty}{...}{}`: Memeriksa apakah file `microtype.sty` ada. Jika ya, blok kode di dalam kurung kurawal `{...}` dijalankan.
        *   `\usepackage[$for(microtypeoptions)$$microtypeoptions$$sep$,$endfor$]{microtype}`: Memuat *package* `microtype` dengan opsi yang diambil dari variabel daftar `$microtypeoptions`.
        *   `\UseMicrotypeSet[protrusion]{basicmath}`: Menggunakan perintah `\UseMicrotypeSet` (dari *package* `microtype`) untuk mengaktifkan set fitur *microtype* `protrusion` **khusus untuk matematika dasar** (`basicmath`). Opsi `protrusion` dari *microtype* menyesuaikan sedikit *shape* karakter agar terlihat lebih rata tepi, meningkatkan estetika tipografi. `basicmath` mungkin dipilih untuk menonaktifkan *protrusion* untuk *monospace fonts* (`tt fonts`), seperti yang ditunjukkan oleh komentar `disable protrusion for tt fonts`. *However, the comment says disable protrusion for tt fonts, but `basicmath` rather restricts protrusion to basic math fonts, not disables it for tt fonts. This might be a slight misunderstanding or a configuration intention to not apply protrusion to tt fonts in other parts of the template.*
        *   **Tujuan `microtype`**: *Package* `microtype` adalah *package* tipografi tingkat lanjut yang menyediakan berbagai fitur untuk meningkatkan *micro-typography* LaTeX output, seperti *font protrusion*, *character kerning*, *letter spacing*, dan *expansion*.

*   **Opsi Variabel `microtypeoptions`**: *List* *String*. Daftar opsi untuk *package* `microtype`. Memungkinkan pengguna untuk menyesuaikan perilaku *microtype*.

---

**Variabel Pandoc yang Dapat Digunakan (YAML) untuk `font-settings.latex`:**

Berikut adalah daftar variabel Pandoc yang relevan dari file `font-settings.latex` dan opsi yang mungkin (sudah termasuk yang dijelaskan di atas dan diringkas):

*   **`fontfamily`**: *String*. Nama *package* *font family* LaTeX. (e.g., `"mathptmx"`, `"helvet"`, `"courier"`)
*   **`fontfamilyoptions`**: *List* *String*. Opsi untuk *package* `fontfamily`. (e.g., `["sc", "osf"]`)
*   **`mainfont`**: *String*. Nama *main font* sistem untuk XeTeX/LuaTeX. (e.g., `"Times New Roman"`, `"Arial"`, `"Libertinus Serif"`)
*   **`mainfontoptions`**: *List* *String*. Opsi untuk `\setmainfont`. (e.g., `["Ligatures=TeX", "Numbers=OldStyle"]`)
*   **`mainfontfallback`**: *List* *String*. Daftar *fallback font* untuk *main font* (LuaTeX only). (e.g., `["DejaVu Serif"]`)
*   **`sansfont`**: *String*. Nama *sans-serif font* sistem untuk XeTeX/LuaTeX.
*   **`sansfontoptions`**: *List* *String*. Opsi untuk `\setsansfont`.
*   **`sansfontfallback`**: *List* *String*. Daftar *fallback font* untuk *sans-serif font* (LuaTeX only).
*   **`monofont`**: *String*. Nama *monospace font* sistem untuk XeTeX/LuaTeX.
*   **`monofontoptions`**: *List* *String*. Opsi untuk `\setmonofont`.
*   **`monofontfallback`**: *List* *String*. Daftar *fallback font* untuk *monospace font* (LuaTeX only).
*   **`fontfamilies`**: *List* *Object* (*Map*). *Font families* tambahan. Setiap objek memiliki:
    *   `name`: *String*. Nama *font family* (untuk `\newfontfamily`). (e.g., `"mySpecialFont"`)
    *   `options`: *List* *String*. Opsi untuk `\newfontfamily`. (e.g., `["Ligatures=TeX"]`)
    *   `font`: *String*. Nama file *font* atau *font* sistem. (e.g., `"SpecialFont-Regular.otf"`, `"Linux Libertine O"`)
*   **`mathfont`**: *String*. Nama *math font* sistem untuk XeTeX/LuaTeX. (e.g., `"Libertinus Math"`, `"XITS Math"`)
*   **`mathfontoptions`**: *List* *String*. Opsi untuk `\setmathfont`. (e.g., `["range=..."]`)
*   **`mathspec`**: *Boolean*. Menggunakan *package* `mathspec` (mempengaruhi `\setmathfont` di XeTeX).
*   **`CJKmainfont`**: *String*. Nama *main CJK font* sistem untuk XeTeX/LuaTeX. (e.g., `"SimSun"`, `"Noto Serif CJK"`).
*   **`CJKoptions`**: *List* *String*. Opsi untuk *CJK font* commands. (e.g., `["BoldFont=...", "ItalicFont=..."]`).
*   **`CJKsansfont`**: *String*. Nama *CJK sans-serif font* sistem untuk XeTeX (kondisional `CJKmainfont`).
*   **`CJKmonofont`**: *String*. Nama *CJK monospace font* sistem untuk XeTeX (kondisional `CJKmainfont`).
*   **`luatexjapresetoptions`**: *List* *String*. Opsi untuk *package* `luatexja-preset` (LuaTeX only). (e.g., `["jis2004"]`).
*   **`luatexjafontspecoptions`**: *List* *String*. Opsi untuk *package* `luatexja-fontspec` (LuaTeX only). (e.g., `["EmbedFont=..."]`).
*   **`zero-width-non-joiner`**: *Boolean*. Mengaktifkan dukungan ZWNJ.
*   **`microtypeoptions`**: *List* *String*. Opsi untuk *package* `microtype`. (e.g., `["protrusion=true"]`).

---