FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

# System deps
RUN apt update && apt install -y ffmpeg git && rm -rf /var/lib/apt/lists/*

# Clone the VibeVoice community fork (has GUI + voice cloning)
WORKDIR /workspace
RUN git clone https://github.com/vibevoice-community/VibeVoice.git

WORKDIR /workspace/VibeVoice

# Python deps
RUN pip install -e . && pip install gradio librosa soundfile

# Pre-download the 1.5B model weights INTO the image, so pod startup is instant
RUN python3 -c "from huggingface_hub import snapshot_download; snapshot_download(repo_id='vibevoice/VibeVoice-1.5B')"

EXPOSE 7860

# Launch the GUI when the container starts
CMD ["python3", "demo/gradio_demo.py", "--model_path", "vibevoice/VibeVoice-1.5B", "--share"]
