# Skill: Daisy Seed Platform

## What it is
Daisy Seed is an embedded audio platform by Electro-Smith. STM32H750 MCU, 480MHz, floating-point DSP, on-board audio codec, 64MB SDRAM. Designed specifically for audio effects and synthesizers.

## Key specs

| Parameter | Value |
|---|---|
| MCU | STM32H750IBK6 (ARM Cortex-M7) |
| Clock | 480 MHz |
| RAM | 512KB internal + 64MB SDRAM |
| Flash | 128KB internal + 8MB external QSPI |
| Audio codec | AK4556 (24-bit, 8–192kHz) |
| Audio channels | Stereo in + stereo out |
| Typical sample rate | 48kHz |
| ADC | 12-bit, 12 channels |
| GPIO | 31 available pins |
| Comms | I2C, SPI, UART, USB |
| Power | 3.3V (USB or external 3.3–6V) |
| Dimensions | 57.15 × 29.0 mm |

## Audio codec (AK4556)

- Input: balanced differential or single-ended
- Input level: 2Vrms max (line level)
- Output: same
- Connects via I2S to MCU
- Handled transparently by libdaisy — just use AudioCallback

## Critical pinout (commonly used)

| Pin | Function |
|---|---|
| D15–D26 | ADC inputs (3.3V max — use resistor divider for higher voltages) |
| D13 | UART TX |
| D14 | UART RX |
| D10 | I2C SCL |
| D11 | I2C SDA |
| D7–D9 | SPI (SCK/MOSI/MISO) |
| USB | USB FS (Audio Class or CDC) |
| 3V3 | 3.3V output (up to 100mA) |
| VIN | 3.3–6V input |
| GND | Ground |

Full pinout: [electro-smith.com/daisy/daisy](https://electro-smith.com/daisy/daisy)

## Power requirements
- Nominal: 3.3V, ~120mA when running audio
- Can be powered from USB (5V) — on-board regulator
- When powering from Eurorack +12V: use 3.3V LDO (e.g. AMS1117-3.3)

## DaisySP library — common DSP objects

```cpp
Oscillator osc;    // osc.SetWaveform(), .SetFreq(), .SetAmp(), .Process()
Svf filter;        // filter.SetFreq(), .SetRes(), .Low(), .High(), .Band()
Adsr env;          // env.Process(gate), returns 0.0–1.0
DelayLine<float, MAX_DELAY> delay;
Chorus chorus;
Overdrive drive;
ReverbSc reverb;
```

## Gotchas
- ADC inputs are 3.3V max — a 10Vpp Eurorack CV will destroy the pin
  - Use a voltage divider (e.g. 100kΩ + 33kΩ) to scale ±5V → 0–3.3V
- SDRAM is slower than internal RAM — keep audio buffers in internal RAM
- Audio callback runs in interrupt context — no blocking, no malloc
- USB and audio codec share a clock — USB Audio Class needs careful setup
