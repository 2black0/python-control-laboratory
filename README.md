# 🧪 Control System Laboratory Jobsheet with Python

This repository contains a collection of **Control System Laboratory Jobsheets and Assignments** developed using Python and Jupyter Notebook. It is designed for students in the **D4 Electronics Engineering Program** at the **Faculty of Vocational Studies, UNY**. The purpose of this repository is to enhance understanding of control systems through simulations, coding practices, and guided exercises.

---

## 📁 Repository Structure

```
.
├── assignment                # Assignments and teaching materials per meeting
│   ├── 01-meeting            # Meeting 1: Labs, tasks, and handouts
│   ├── 02-meeting            # Meeting 2: Defuzzification and fuzzy logic tasks
│   ├── latex-template        # Pandoc LaTeX templates for PDF generation
│   └── tool                  # Conversion tools for IPYNB to PDF
├── labsheet                 # Practical labs using Python
│   ├── labsheet-01.ipynb
│   ├── labsheet-02.ipynb
│   └── labsheet-03.ipynb
├── LICENSE
└── README.md
```

---

## 🎯 Learning Objectives

Through the labsheets and assignments, students will be able to:

* Understand the foundations of control systems.
* Apply Python libraries such as `control`, `scipy`, `numpy`, and `matplotlib` to simulate systems.
* Design and analyze controllers using real-world case studies.
* Learn fuzzy logic techniques and implement defuzzification methods such as MOM, SOM, and Centroid.

---

## 🧪 Labsheets

| No | Title                           | Description                                                        |
| -- | ------------------------------- | ------------------------------------------------------------------ |
| 01 | Introduction to Control Systems | Covers transfer functions, feedback, and plotting responses        |
| 02 | Dynamic System Modeling         | Explains first- and second-order system models                     |
| 03 | Time Response Analysis          | Simulates impulse, step, and ramp responses of closed-loop systems |

🔗 [View Full Syllabus](https://docs.google.com/document/d/1rauoA8oMDj4RAIvSfa9mq3bl632q0-VMDjnlmvjqLts/edit?usp=sharing)

---

## 📝 Assignments

Assignments are organized by meeting and include:

### 📘 01-meeting

* Control system introduction tasks in `.ipynb` and `.pdf` formats
* Markdown notes and exercises

### 📘 02-meeting

* Fuzzy logic and defuzzification methods with diagrams
* Exercises on bisector, centroid, MOM, SOM, LOM
* Revisions and evaluation tasks

### 📘 latex-template

* Custom templates for exporting assignments as high-quality PDFs using `pandoc`

### 🛠️ tool

* Scripts and notebooks to convert Jupyter files (`.ipynb`) into LaTeX or PDF documents

---

## ⚙️ Setup Instructions

### 💻 System Requirements

* CPU: Dual Core or higher
* RAM: ≥ 4 GB
* OS: Windows / Linux / macOS

### 🐍 Python Environment Setup

We recommend using [Miniconda](https://docs.conda.io/en/latest/miniconda.html).

1. **Create and activate environment:**

```bash
conda create --name control python=3.9
conda activate control
```

2. **Install required libraries:**

```bash
conda install -c conda-forge control slycot
conda install -c anaconda jupyter matplotlib numpy scipy
```

3. **Launch Jupyter Notebook:**

```bash
jupyter notebook labsheet/
```

---

## 👨‍🏫 Author

Developed by:

* [2black0](https://github.com/2black0)

---

## 🕒 Version History

* **v1.0**

  * Labsheet 01–03 added
  * Assignment Meeting 1 & 2 added
  * Python-only (Octave version coming soon)

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

> 💬 For feedback, issues, or contributions, feel free to [open an issue](https://github.com/2black0/control-system-lab-python/issues) on this repository.