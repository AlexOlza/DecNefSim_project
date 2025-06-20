#!/bin/bash

set -e  # Exit on error

# Config
ENV_DIR="venv"
PYTHON_VERSION="python3.10"

# Repos
REPOS=(
    "https://github.com/MedARC-AI/MindEyeV2.git"
    "https://github.com/Noirebao/MindSimulator.git"
    "https://github.com/AlexOlza/DecNefSim.git"
    #"git@github.com:AlexOlza/DecNefSim.git" # via SSH
)

echo "🔁 Cloning repositories..."
mkdir -p external
cd external || exit 1
for url in "${REPOS[@]}"; do
    name=$(basename "$url" .git)
    if [ ! -d "$name" ]; then
        echo "🌐 Cloning $name..."
        git clone "$url"
    else
        echo "✅ Repo '$name' already exists."
    fi
done
cd ..

# ---- Create virtual environment ----
if [ ! -d "$ENV_DIR" ]; then
    echo "📦 Creating virtual environment in ./$ENV_DIR"
    $PYTHON_VERSION -m venv "$ENV_DIR"
fi

echo "🔌 Activating virtual environment..."
source "$ENV_DIR/bin/activate"

echo "⬆️ Upgrading pip..."
pip install --upgrade pip setuptools wheel

# ---- Install pip-only dependencies ----
echo "📦 Installing pip-only packages..."
pip install \
    numpy matplotlib==3.8.2 jupyter jupyterlab_nvdashboard jupyterlab \
    tqdm scikit-image==0.22.0 accelerate==0.24.1 webdataset==0.2.73 \
    pandas==2.2.0 einops ftfy regex kornia==0.7.1 h5py==3.10.0 \
    open_clip_torch==2.24.0 torchvision==0.16.0 torch==2.1.0 \
    transformers==4.37.2 xformers==0.0.22.post7 torchmetrics==1.3.0.post0 \
    diffusers==0.23.0 deepspeed==0.13.1 wandb omegaconf==2.3.0 \
    pytorch-lightning==2.0.1 sentence-transformers==2.5.1 evaluate==0.4.1 \
    nltk==3.8.1 rouge_score==0.1.2 umap==0.1.1 seaborn==0.13.2
    umap-learn==0.5.7

pip install git+https://github.com/openai/CLIP.git --no-deps
pip install dalle2-pytorch
# ---- Generate PYTHONPATH activator ----
echo "🔧 Creating activate_env.sh to set PYTHONPATH..."
# Set path to main repo
MAIN_REPO_DIR="DecNefSim"

# Update PYTHONPATH
echo "🔧 Creating activate_env.sh to set PYTHONPATH..."

PYTHONPATH_LINE="export PYTHONPATH=\$PYTHONPATH:$(pwd)/external/MindEyeV2:$(pwd)/external/MindSimulator:$(pwd)/$MAIN_REPO_DIR"
echo "$PYTHONPATH_LINE" > activate_env.sh
chmod +x activate_env.sh

echo "➡️ Run 'source activate_env.sh' after activating the venv to use the external repos."

# ---- Freeze dependencies ----
echo "📤 Saving requirements.txt..."
#pip freeze > requirements.txt
pip freeze | grep -vE 'spyder|pyqt5|dev-package-X' > requirements.txt # Here grep excludes stuff related to the spyder GUI

echo "✅ All done."
echo "📎 To start working:"
echo "   1. source $ENV_DIR/bin/activate"
echo "   2. source activate_env.sh"
# activate_env.sh ---> only exports PYTHONPATH, which has the stuff I added above

# Another script, try_package.sh, installs a new package using pip.
# Then I try the package. If I decide to keep it, the script logs the name and version to manual_adds.txt.
# If I decide to discard the package, the script uninstalls it.
# To install the project elsewhere, I would manually dump manual_adds.txt to this script and/or to requirements.txt.
