#!/bin/bash

# --- Configuration ---
# Set this to the root of your ComfyUI installation.
# If 'workspace/comfyui' is in your current directory when you run this script:
COMFYUI_BASE_PATH="/ComfyUI/models/"
# If your ComfyUI is elsewhere, set the absolute path, e.g.:
# COMFYUI_BASE_PATH="/home/your_user/AI/ComfyUI_instance"
# COMFYUI_BASE_PATH="C:/Users/YourUser/Documents/ComfyUI_Folder" (if using Git Bash on Windows)

# --- Check if wget is installed ---
if ! command -v wget &> /dev/null
then
    echo "wget could not be found. Please install wget to use this script."
    echo "On Debian/Ubuntu: sudo apt install wget"
    echo "On Fedora: sudo dnf install wget"
    echo "On macOS (with Homebrew): brew install wget"
    exit 1
fi

# --- Define Model Paths (relative to COMFYUI_BASE_PATH/models) ---
CHECKPOINT_PATH="${COMFYUI_BASE_PATH}/checkpoints/SD 1.5"
LORA_PHOTO_SD15_PATH="${COMFYUI_BASE_PATH}/loras/Photo/SD 1.5"
UPSCALE_MODELS_PATH="${COMFYUI_BASE_PATH}/upscale_models"
CONTROLNET_PATH="${COMFYUI_BASE_PATH}/controlnet"

# --- Create Directories ---
echo "Creating directories if they don't exist..."
mkdir -p "${CHECKPOINT_PATH}"
mkdir -p "${LORA_PHOTO_SD15_PATH}"
mkdir -p "${UPSCALE_MODELS_PATH}"
mkdir -p "${CONTROLNET_PATH}"
echo "Directories ensured."
echo ""

# --- Download Models ---

# 1. Checkpoint: juggernaut_reborn.safetensors
MODEL_NAME_CKPT="juggernaut_reborn.safetensors"
DEST_CKPT="${CHECKPOINT_PATH}/${MODEL_NAME_CKPT}"
URL_CKPT="https://huggingface.co/KamCastle/jugg/resolve/main/juggernaut_reborn.safetensors" # Juggernaut Reborn

if [ ! -f "${DEST_CKPT}" ]; then
    echo "Downloading ${MODEL_NAME_CKPT}..."
    wget -O "${DEST_CKPT}" "${URL_CKPT}"
    if [ $? -eq 0 ]; then echo "${MODEL_NAME_CKPT} downloaded successfully."; else echo "Failed to download ${MODEL_NAME_CKPT}."; fi
else
    echo "${MODEL_NAME_CKPT} already exists. Skipping."
fi
echo ""

# 2. LoRA: more_details.safetensors
MODEL_NAME_LORA1="more_details.safetensors"
DEST_LORA1="${LORA_PHOTO_SD15_PATH}/${MODEL_NAME_LORA1}"
URL_LORA1="https://huggingface.co/yungplin/More_details/resolve/main/more_details.safetensors" # More Details LoRA (Lykon)

if [ ! -f "${DEST_LORA1}" ]; then
    echo "Downloading ${MODEL_NAME_LORA1}..."
    wget -O "${DEST_LORA1}" "${URL_LORA1}"
    if [ $? -eq 0 ]; then echo "${MODEL_NAME_LORA1} downloaded successfully."; else echo "Failed to download ${MODEL_NAME_LORA1}."; fi
else
    echo "${MODEL_NAME_LORA1} already exists. Skipping."
fi
echo ""

# 3. LoRA: SDXLrender_v2.0.safetensors
MODEL_NAME_LORA2="SDXLrender_v2.0.safetensors"
DEST_LORA2="${LORA_PHOTO_SD15_PATH}/${MODEL_NAME_LORA2}"
URL_LORA2="https://huggingface.co/philz1337x/loras/resolve/main/SDXLrender_v2.0.safetensors" # SDXLrender (Stylized)_v2.0 (gladopps2)
# Note: This is an SDXL LoRA. The path "Photo/SD 1.5/" is per your error message.

if [ ! -f "${DEST_LORA2}" ]; then
    echo "Downloading ${MODEL_NAME_LORA2}..."
    wget -O "${DEST_LORA2}" "${URL_LORA2}"
    if [ $? -eq 0 ]; then echo "${MODEL_NAME_LORA2} downloaded successfully."; else echo "Failed to download ${MODEL_NAME_LORA2}."; fi
else
    echo "${MODEL_NAME_LORA2} already exists. Skipping."
fi
echo ""

# 4. Upscale Model: 4xNomosUniDAT_otf.pth
MODEL_NAME_UPSCALE="4xNomosUniDAT_otf.pth"
DEST_UPSCALE="${UPSCALE_MODELS_PATH}/${MODEL_NAME_UPSCALE}"
URL_UPSCALE="https://huggingface.co/pengxian/upscale_models/resolve/main/4xNomosUniDAT_otf.pth"

if [ ! -f "${DEST_UPSCALE}" ]; then
    echo "Downloading ${MODEL_NAME_UPSCALE}..."
    wget -O "${DEST_UPSCALE}" "${URL_UPSCALE}"
    if [ $? -eq 0 ]; then echo "${MODEL_NAME_UPSCALE} downloaded successfully."; else echo "Failed to download ${MODEL_NAME_UPSCALE}."; fi
else
    echo "${MODEL_NAME_UPSCALE} already exists. Skipping."
fi
echo ""

# 5. ControlNet: control_v11f1e_sd15_tile.pth
MODEL_NAME_CN="control_v11f1e_sd15_tile.pth"
DEST_CN="${CONTROLNET_PATH}/${MODEL_NAME_CN}"
URL_CN="https://huggingface.co/lllyasviel/ControlNet-v1-1/resolve/main/control_v11f1e_sd15_tile.pth"

if [ ! -f "${DEST_CN}" ]; then
    echo "Downloading ${MODEL_NAME_CN}..."
    wget -O "${DEST_CN}" "${URL_CN}"
    if [ $? -eq 0 ]; then echo "${MODEL_NAME_CN} downloaded successfully."; else echo "Failed to download ${MODEL_NAME_CN}."; fi
else
    echo "${MODEL_NAME_CN} already exists. Skipping."
fi
echo ""

echo "----------------------------------------------------"
echo "All download attempts finished."
echo "Make sure your ComfyUI is configured to look for models in these paths,"
echo "or restart ComfyUI and refresh your browser if it was already running."
echo "Expected base ComfyUI path for models: ${COMFYUI_BASE_PATH}/models"
echo "----------------------------------------------------"