# Skill: Arduino Platforms in Audio Hardware

## When to use Arduino in KLANG projects

Arduino is not an audio processing platform. Use it for:
- Panel control logic (buttons, encoders, pots → MIDI or CV)
- MIDI interface (MIDI in/out/thru with DIN connectors)
- Display driving (OLED, LCD)
- Sequencer logic
- Simple CV/gate generation (with external DAC)

Do not use Arduino for: DSP, audio effects, sample playback (use Daisy Seed instead).

## Common boards

| Board | MCU | Clock | Flash | RAM | Notes |
|---|---|---|---|---|---|
| Uno R3 | ATmega328P | 16MHz | 32KB | 2KB | Standard breadboard target |
| Nano | ATmega328P | 16MHz | 32KB | 2KB | Same as Uno, smaller |
| Pro Mini | ATmega328P | 8/16MHz | 32KB | 2KB | 3.3V or 5V variants |
| Micro | ATmega32U4 | 16MHz | 32KB | 2.5KB | Native USB — good for USB MIDI |
| Mega 2560 | ATmega2560 | 16MHz | 256KB | 8KB | More pins — for complex panel control |

## Audio limitations

- ATmega328P has no hardware DAC — audio output requires PWM (8-bit, noisy)
- 8-bit PWM at 31.25kHz is not hi-fi — use an external DAC (MCP4921, PCM5102A) via SPI
- For MIDI at 31.25 kbaud: use Hardware Serial (pin 0/1) or SoftwareSerial
- 2KB RAM = very small audio buffers — not suitable for delay or reverb

## MIDI with Arduino

**Hardware MIDI (5-pin DIN):**
- TX through 220Ω resistor to pin 4 of DIN connector
- RX via optocoupler (6N138 or H11L1) to Serial RX — optoisolation is mandatory
- Library: MIDI.h (FortySevenEffects) — most reliable

**USB MIDI:**
- Use ATmega32U4 board (Micro, Leonardo)
- Library: MIDIUSB.h
- Appears as class-compliant USB MIDI device

## GPIO and CV

- Analog inputs: 10-bit ADC, 0–5V (Uno/Nano) or 0–3.3V (Pro Mini 3.3V)
- PWM outputs: pins 3, 5, 6, 9, 10, 11 — frequency varies by timer
- For 1V/oct pitch CV output: use MCP4922 12-bit SPI DAC — gives ±4.095V range

## Gotchas
- 5V Arduino outputs are safe for 5V Eurorack gate/trigger — direct connection OK
- 3.3V Arduino outputs may not reliably trigger 5V Eurorack gates — use level shifter
- millis() and delay() are unreliable in interrupt-heavy MIDI code — use MIDI library callbacks
- Serial.print() blocks — never use in timing-critical code
