# 🧪 Control System Laboratory Jobsheet with Python

This repository contains **Control System Laboratory Jobsheets** using Python and Jupyter Notebook, developed for students of the **D4 Electronics Engineering Program, Faculty of Vocational Studies, UNY**. The laboratory sessions are designed to reinforce fundamental control system concepts through hands-on simulations and coding in Python.

## 📂 Repository Structure

```

.
├── labsheet                 # Main folder containing the practical notebooks
│   ├── labsheet-01.ipynb    # Introduction to control systems and Python
│   ├── labsheet-02.ipynb    # Dynamic system modeling
│   └── labsheet-03.ipynb    # Time response analysis
├── LICENSE                  # Project license
└── README.md                # Project documentation

```

## 🎯 Learning Objectives

By completing this lab series, students will be able to:
- Analyze control systems using Python.
- Use libraries such as `control`, `scipy`, and `matplotlib` for system simulation.
- Design simple controllers and evaluate system performance.

## 🚀 Getting Started

### 💻 System Requirements
- Processor: Dual Core or better
- RAM: At least 4 GB
- OS: Windows / Linux / MacOS

### 🔧 Software Installation

#### 1. Install Python
It is recommended to use [Miniconda](https://docs.conda.io/en/latest/miniconda.html) for environment management.

#### 2. Create a Python Environment
```bash
conda create --name control python=3.9
conda activate control
```

#### 3. Install Required Libraries

```bash
conda install -c conda-forge control slycot
conda install -c anaconda jupyter matplotlib numpy scipy
```

#### 4. Launch Jupyter Notebook

```bash
jupyter notebook labsheet/
```

## 📘 Labsheet List

| No | Title                           | Description                                                        |
| -- | ------------------------------- | ------------------------------------------------------------------ |
| 01 | Introduction to Control Systems | Covers transfer functions, feedback, and plotting responses        |
| 02 | Dynamic System Modeling         | Explains first- and second-order system models                     |
| 03 | Time Response Analysis          | Simulates impulse, step, and ramp responses of closed-loop systems |

You can view the full syllabus on [Google Docs](https://docs.google.com/document/d/1rauoA8oMDj4RAIvSfa9mq3bl632q0-VMDjnlmvjqLts/edit?usp=sharing).

## 👨‍🏫 Author

This lab series was developed by:

* [2black0](https://github.com/2black0)

## 🕒 Version History

* **Version 1.0**

  * Labsheet 01 – 03 available
  * Python-based only (Octave not included in this version)

## 📄 License

This project is licensed under the [MIT License](LICENSE).

---

> 📢 For feedback, contributions, or issues, please open an *issue* on this repository.