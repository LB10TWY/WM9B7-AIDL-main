# Deep Learning Module Environment Files (Windows + VS Code)

These files are designed for the **student tutorial workflow** discussed in class:

- one shared `venv` per student
- separate project folders for notebooks, scripts, data, and outputs
- a **CPU pathway** for standard work
- a **GPU pathway** for NVIDIA GPU work on Windows using **CUDA 12.8**
- package installation using **`python -m pip`** instead of `pip.exe`, which may be blocked on managed machines

## Recommended folder layout

```text
Documents/
└── student_id/
    ├── venv/
    ├── deepLearningCourse/
    │   ├── requirements.txt
    │   ├── requirements-cpu.txt
    │   ├── requirements-gpu-cu128.txt
    │   ├── requirements-gpu-rest.txt
    │   ├── environment.yml
    │   ├── setup_venv.ps1
    │   └── README_DL_ENV.md
    ├── Project_1/
    │   ├── notebooks/
    │   ├── scripts/
    │   ├── data/
    │   └── outputs/
    └── Project_2/
        ├── notebooks/
        ├── scripts/
        ├── data/
        └── outputs/
```

## What each file is for

### `requirements.txt`
The **shared non-PyTorch package list** used by both pathways.

### `requirements-cpu.txt`
The **CPU pathway**. It installs the shared packages plus `torch`, `torchvision`, and `torchaudio` from the default package index.

### `requirements-gpu-cu128.txt`
The **GPU PyTorch file** for Windows NVIDIA machines that need CUDA 12.8 wheels.

Install this **first** for the GPU pathway.

### `requirements-gpu-rest.txt`
The shared non-PyTorch packages for the GPU pathway.

Install this **after** `requirements-gpu-cu128.txt`.

### `environment.yml`
An optional **Conda CPU environment** for students who prefer Conda instead of `venv`.

### `setup_venv.ps1`
A PowerShell automation script that:
- creates the venv if needed
- upgrades pip/setuptools/wheel
- installs either the CPU or GPU pathway
- registers the Jupyter kernel

### `README_DL_ENV.md`
This file.

## Important installation rules

1. Open **VS Code** in the student root folder, for example:
   `Documents\u1234567`

2. Create the venv only once:

```powershell
python -m venv venv
```

3. On PowerShell, if activation is blocked, run:

```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy Bypass
```

Then activate:

```powershell
.\venv\Scripts\activate
```

4. On managed machines, do **not** use plain `pip install ...`.
   Use:

```powershell
python -m pip install ...
```

## Manual install: CPU pathway

```powershell
python -m pip install --upgrade pip setuptools wheel
python -m pip install -r .\deepLearningCourse\requirements-cpu.txt
python -m ipykernel install --user --name dl_env --display-name "Python (Deep Learning)"
```

## Manual install: GPU pathway

If a CPU PyTorch build was installed previously, remove it first:

```powershell
python -m pip uninstall -y torch torchvision torchaudio
```

Then install the GPU pathway:

```powershell
python -m pip install --upgrade pip setuptools wheel
python -m pip install -r .\deepLearningCourse\requirements-gpu-cu128.txt
python -m pip install -r .\deepLearningCourse\requirements-gpu-rest.txt
python -m ipykernel install --user --name dl_env --display-name "Python (Deep Learning)"
```

## PowerShell script usage

From the student root folder:

### CPU

```powershell
powershell -ExecutionPolicy Bypass -File .\deepLearningCourse\setup_venv.ps1 -Pathway cpu
```

### GPU

```powershell
powershell -ExecutionPolicy Bypass -File .\deepLearningCourse\setup_venv.ps1 -Pathway gpu
```

## Quick verification

### Check the interpreter path

```powershell
python -c "import sys; print(sys.executable)"
```

It should point to:

```text
...\student_id\venv\Scripts\python.exe
```

### Check PyTorch and CUDA

```powershell
python -c "import torch; print(torch.__version__); print(torch.version.cuda); print(torch.cuda.is_available())"
```

Expected outcomes:

- **CPU pathway:** `+cpu`, `None`, `False`
- **GPU pathway:** `+cu128`, `12.8`, `True`

## Running a Python file

```powershell
python .\Project_1\scripts\my_script.py
```

## Running a notebook

Open the notebook in VS Code and select the kernel:

```text
Python (Deep Learning)
```

## Notes on Python versions

These files are intended for current Windows lab machines using **Python 3.13 or 3.14**. PyTorch's official site states that the latest stable release requires Python 3.10 or later, and current CUDA 12.8 Windows wheels are available for modern Python versions. If a specific package temporarily lags on a newly released Python version, the quickest workaround is usually to recreate the venv with Python 3.13. 
