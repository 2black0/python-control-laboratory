# 📄 Convert Jupyter Notebooks (IPYNB) to PDF with Title Metadata

This project provides a simple way to **convert Jupyter Notebook files (`.ipynb`) to PDF** format **with automatic title metadata**, using **Google Colab**.

## ✅ Features

* **Auto Title Metadata**: The PDF title is taken from the notebook filename (before `.ipynb`). Underscores (`_`) are replaced with spaces, and each word is capitalized.
* **PDF Conversion**: Uses `nbconvert` to convert `.ipynb` to `.pdf`.
* **Google Colab Integration**: Designed to run in Google Colab with file upload and auto-download support.
* **User-Friendly**: Just upload your notebook, and the script does the rest.
* **Supports Multiple Files**: You can upload and process multiple notebooks at once.

## 🚀 How to Use

1. Open [Google Colab](https://colab.research.google.com) and create a new notebook.
2. Copy and paste the provided Python script into a code cell.
3. Run the cell.
4. Click **"Choose Files"** to upload your `.ipynb` files.
5. The script will:

   * Add a **PDF title** from the file name.
   * Convert the notebook to **PDF**.
   * **Automatically download** the PDF to your computer.

## 🧪 Example

If you upload a file called:

```
tugas_praktikum_sistem_kendali.ipynb
```

The script will:

* Set the **PDF title** to `"Tugas Praktikum Sistem Kendali"`.
* Convert it to a PDF.
* Download it to your device.

## 📦 Dependencies

All required libraries are already available in Google Colab:

* `json`: for reading/writing notebook metadata
* `os`: for handling file paths
* `google.colab`: for file upload/download
* `nbconvert`: to convert notebook to PDF
* `nbformat`: to edit notebook files

No manual installation is needed!

---