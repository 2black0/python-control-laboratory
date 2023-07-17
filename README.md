# Jobsheet Praktikum Sistem Kendali dengan Python dan GNU Octave

Ini adalah Jobsheet untuk Praktikum Sistem Kendali dengan Python dan GNU Octave untuk mahasiswa D4 Teknik Elektronika Fakultas Vokasi UNY.

## Deskripsi

Praktikum Sistem Kendali dengan Python dan GNU Octave adalah salah satu praktikum yang ditawarkan dalam program studi D4 Teknik Elektronika Fakultas Vokasi UNY. Praktikum ini bertujuan untuk memberikan pemahaman dan pengalaman praktis dalam menerapkan konsep sistem kendali menggunakan dua bahasa pemrograman populer, yaitu Python dan GNU Octave.

Dalam praktikum ini, mahasiswa akan belajar mengenai prinsip dasar sistem kendali dan metode-metode yang digunakan untuk menganalisis dan merancang sistem kendali. Praktikum ini menggabungkan teori dengan penerapan langsung menggunakan perangkat lunak open-source, seperti Python dan GNU Octave, yang memberikan fleksibilitas dan kemudahan dalam memahami konsep-konsep yang diajarkan.

Pada awal praktikum, mahasiswa akan diperkenalkan dengan dasar-dasar sistem kendali, dimulai dari model matematika termasuk konsep umpan balik, fungsi transfer, diagram blok, dan metode analisis sistem kendali. Kemudian, mahasiswa akan belajar menggunakan bahasa pemrograman Python dan GNU Octave untuk melakukan simulasi sistem kendali, menganalisis respons sistem, dan merancang kontroler yang sesuai.

Selama praktikum, mahasiswa akan diberikan serangkaian tugas praktis, di mana mereka akan diberikan permasalahan kontrol yang berbeda dan diminta untuk mengimplementasikan solusi menggunakan Python dan GNU Octave. Mahasiswa akan belajar menggunakan library atau paket yang relevan, seperti NumPy, SciPy, Control, dan Octave Control Systems Toolbox, untuk memudahkan analisis dan desain sistem kendali.

## Memulai

### Perangkat Keras Yang dibutuhkan

* Laptop dengan spesifikasi minimal:
  * Prosesor 2 Core
  * RAM 4GB
  * Ruang Penyimpanan 10GB
* Sistem Operasi Windows / Linux (Ubuntu) / Mac OS

### Pemasangan Perangkat Lunak

#### Python
Download Miniconda sesuai dengan Sistem Operasi yang digunakan pada link berikut: https://docs.conda.io/en/latest/miniconda.html dan lakukan proses instalasi sesuai dengan video tutorial berikut
> Windows: https://youtu.be/r7XPcSNmWu4<br>
Linux : Coming Soon!<br>
Mac OS : https://youtu.be/4qS7qw9v884<br>
#### GNU Octave
Download GNU Octave Installer pada link berikut: https://octave.org/download dan lakukan proses instalasi sesuai dengan video tutorial berikut
> Windwos: https://youtu.be/XeNENyPvzNw<br>
Linux : Coming Soon!<br>
Mac OS : Coming Soon!<br>
### Menyiapkan Environment dan Library Python
> Video Tutorial: https://youtu.be/XidmHRA29Xk
* Buka Terimal pada Mac OS / Linux dan Anaconda Prompt pada Windows
* Buat Environment Baru dengan perintah
    ```
    conda create --name control python=3.9
    ```
* Aktifkan Environment dengan perintah
    ```
    conda activate control
    ```
* Install Library Python Control
    ```
    conda install -c conda-forge control slycot
    ```
* Install Library Jupyter Notebook
    ```
    conda install -c anaconda jupyter
    ```

### Menyiapkan Paket GNU Octave

## Penyusun
* [2black0](https://github.com/2black0)

## Version History

* Versi 1
    * Versi Awal Python
    * Versi Awal GNU Octave

## Lisensi

This project is licensed under the [NAME HERE] License - see the LICENSE.md file for details