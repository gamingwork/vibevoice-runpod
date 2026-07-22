FROM runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404

# System deps
RUN apt update && apt install -y ffmpeg git && rm -rf /var/lib/apt/lists/*

# Clone the VibeVoice community fork (has GUI + voice cloning)
WORKDIR /workspace
RUN git clone https://github.com/vibevoice-community/VibeVoice.git

WORKDIR /workspace/VibeVoice

# Python deps
RUN pip install -e . && pip install gradio librosa soundfile

EXPOSE 7860

# Model downloads on first container start (cached in HF cache dir).
# If you attach a RunPod volume at /root/.cache/huggingface, it persists across restarts.
CMD ["python3", "demo/gradio_demo.py", "--model_path", "vibevoice/VibeVoice-1.5B", "--share"]
