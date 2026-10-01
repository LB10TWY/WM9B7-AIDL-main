param(
    [ValidateSet('cpu','gpu')]
    [string]$Pathway = 'cpu',

    [string]$VenvName = 'venv',

    [string]$KernelName = 'dl_env',

    [string]$KernelDisplayName = 'Python (Deep Learning)'
)

$ErrorActionPreference = 'Stop'

$Root = Get-Location
$VenvPath = Join-Path $Root $VenvName
$PythonInVenv = Join-Path $VenvPath 'Scripts\python.exe'
$CoursePath = Join-Path $Root 'deepLearningCourse'

Write-Host "Root folder: $Root"
Write-Host "Selected pathway: $Pathway"

if (-not (Test-Path $CoursePath)) {
    throw "Could not find the deepLearningCourse folder in $Root. Open the student root folder in VS Code first."
}

if (-not (Test-Path $VenvPath)) {
    Write-Host "Creating virtual environment..."
    python -m venv $VenvName
}

if (-not (Test-Path $PythonInVenv)) {
    throw "The virtual environment exists, but $PythonInVenv was not found."
}

Write-Host "Upgrading pip, setuptools, and wheel..."
& $PythonInVenv -m pip install --upgrade pip setuptools wheel

if ($Pathway -eq 'cpu') {
    Write-Host "Installing CPU pathway packages..."
    & $PythonInVenv -m pip install -r (Join-Path $CoursePath 'requirements-cpu.txt')
}
else {
    Write-Host "Removing any existing torch packages to avoid CPU/GPU conflicts..."
    & $PythonInVenv -m pip uninstall -y torch torchvision torchaudio

    Write-Host "Installing GPU PyTorch (CUDA 12.8)..."
    & $PythonInVenv -m pip install -r (Join-Path $CoursePath 'requirements-gpu-cu128.txt')

    Write-Host "Installing remaining shared packages..."
    & $PythonInVenv -m pip install -r (Join-Path $CoursePath 'requirements-gpu-rest.txt')
}

Write-Host "Registering the Jupyter kernel..."
& $PythonInVenv -m ipykernel install --user --name $KernelName --display-name $KernelDisplayName

Write-Host "\nSetup complete."
Write-Host "Select this interpreter in VS Code: $PythonInVenv"
Write-Host "Then choose the notebook kernel: $KernelDisplayName"
Write-Host "\nQuick verification command:"
Write-Host "& `"$PythonInVenv`" -c `"import torch; print(torch.__version__); print(torch.version.cuda); print(torch.cuda.is_available())`""
