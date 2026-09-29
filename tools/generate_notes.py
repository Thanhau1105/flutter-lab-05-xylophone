"""Generate seven original xylophone-style WAV notes with the Python standard library."""

import math
import struct
import wave
from pathlib import Path

SAMPLE_RATE = 44100
DURATION = 0.75
FREQUENCIES = [261.63, 293.66, 329.63, 349.23, 392.00, 440.00, 493.88]
OUTPUT = Path(__file__).resolve().parents[1] / "assets" / "notes"
OUTPUT.mkdir(parents=True, exist_ok=True)

for number, frequency in enumerate(FREQUENCIES, start=1):
    path = OUTPUT / f"note_{number}.wav"
    with wave.open(str(path), "wb") as file:
        file.setnchannels(1)
        file.setsampwidth(2)
        file.setframerate(SAMPLE_RATE)
        frames = bytearray()
        for sample_index in range(int(SAMPLE_RATE * DURATION)):
            time = sample_index / SAMPLE_RATE
            attack = min(1.0, time / 0.008)
            fundamental = math.sin(2 * math.pi * frequency * time) * math.exp(-4.0 * time)
            overtone = 0.30 * math.sin(2 * math.pi * frequency * 2.76 * time) * math.exp(-11.0 * time)
            shimmer = 0.12 * math.sin(2 * math.pi * frequency * 5.40 * time) * math.exp(-18.0 * time)
            value = max(-1.0, min(1.0, (fundamental + overtone + shimmer) * attack * 0.67))
            frames.extend(struct.pack("<h", int(value * 32767)))
        file.writeframes(frames)
    print(path)
