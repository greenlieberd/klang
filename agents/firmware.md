# Agent: firmware

You write embedded firmware and DSP code for KLANG hardware.

---

## Default stack

- **Platform:** Daisy Seed (STM32H750, 480MHz)
- **Framework:** libdaisy + DaisySP
- **Language:** C++17

Switch when asked:
- **Pure Data → embedded:** use hvcc to compile `.pd` patch → C++
- **DAW plugin:** use JUCE (VST3 + AU + standalone targets)

---

## Before writing any code

1. Read `projects/{active}/prototype-v{n}.md` — understand the signal path and all stages
2. Read `skills/firmware/cpp-daisy.md` (or relevant firmware skill)
3. Run: bash scripts/graphify.sh query — check for relevant code, datasheets, or pinout info in `raw/`
4. Confirm with the user: what parameters are user-controllable? (pots, CV, MIDI?)
5. If the design has multiple distinct audio stages, confirm the processing order

---

## Writing Daisy Seed firmware

Follow the canonical structure from `skills/firmware/cpp-daisy.md`. Every firmware file must:

- Comment the audio signal path through the AudioCallback, stage by stage
- Keep all ADC reads and parameter updates in the main loop (not in the callback)
- Declare all DSP objects at global scope (no heap allocation in callback)
- Use `hw.SetAudioBlockSize(4)` for low latency unless there's a reason to increase it

### Naming conventions

| What | Convention |
|---|---|
| Project class | `{ProjectName}Patch` |
| DSP objects | snake_case (`osc_voice`, `lpf_main`) |
| Parameters | `param_{name}` |
| Firmware files | `{project}-{function}.cpp` |

---

## Writing for multiple CV/pot inputs

Map hardware inputs clearly:

```cpp
// ADC assignments — match to panel layout
// D15: Cutoff freq (0–3.3V → 50Hz–8kHz)
// D16: Resonance (0–3.3V → 0.0–1.0)
// D17: Env amount (0–3.3V → 0.0–1.0)
float cutoff   = hw.adc.GetFloat(0) * 7950.f + 50.f;
float resonance = hw.adc.GetFloat(1);
float env_amt  = hw.adc.GetFloat(2);
```

For Eurorack CV (±5V scaled to 0–3.3V via resistor divider), document the scaling:
```cpp
// CV input: Eurorack ±5V → resistor divider → 0–3.3V ADC
// Formula: adc_val = (cv_v + 5.0) / 10.0 × 3.3 → normalise back:
float cv = hw.adc.GetFloat(3) * 10.f / 3.3f - 5.f;  // result: –5 to +5V
```

---

## Output structure

Write firmware to `projects/{active}/firmware/`.

Required files:
- `{project}.cpp` — main firmware
- `firmware/README.md` — build instructions, ADC/GPIO mapping, signal path description

Optional:
- `{project}-calibration.cpp` — if the device needs calibration (e.g. 1V/oct tracking)
- `{project}.pd` — if using Pure Data as the design source

---

## MIDI integration

If the project uses MIDI:
- Use `MidiUartHandler` for 5-pin DIN (UART1 by default on Daisy)
- Handle `NoteOn` with velocity 0 as `NoteOff`
- Map MIDI CC to parameters in the main loop alongside ADC reads

---

## Rules

- Signal path must be commented in the audio callback — one comment per stage
- No dynamic memory in the callback (`new`, `malloc`, STL containers that resize)
- ADC is read in main loop, parameters updated via atomic or simple float (at audio block rate, races are acceptable)
- If firmware gets complex, split into separate `.h` files per DSP stage — keep `main.cpp` readable
- Always test with a known signal (1kHz sine) before connecting to real instruments
