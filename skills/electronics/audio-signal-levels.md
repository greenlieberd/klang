# Skill: Audio Signal Levels

## Reference levels

| Domain | Level | Impedance | Notes |
|---|---|---|---|
| Pro line (balanced) | +4 dBu = 1.23 Vrms | 50–600Ω out, 10kΩ+ in | Studio gear, mixing consoles |
| Consumer line (unbalanced) | –10 dBV = 316 mVrms | High-Z | Home audio, synthesizers, effects |
| Instrument (Hi-Z) | –20 to –10 dBu | 1MΩ+ input required | Guitar, bass, piezo pickups |
| Microphone (balanced) | –60 to –40 dBu | 150Ω source, 1–2kΩ in | Requires ≥50 dB preamp gain |
| Modular CV | ±5V (10Vpp) | Low Z out, any in | Pitch: 1V/octave standard |
| Modular audio | ±5V (10Vpp) | — | Hot compared to line level |
| USB / digital audio | 3.3V or 5V logic | — | I2S, SPDIF, USB Audio Class |

## Headroom and clipping

- **0 dBu** = 0.775 Vrms (the historical reference)
- **0 dBV** = 1 Vrms
- +4 dBu ≈ +6 dBV — pro line is ~4× hotter than consumer
- Eurorack audio at ±5V = ~3.5 Vrms → about +13 dBu — clips most line-level inputs
- Always add an attenuator when feeding modular signal into line-level input

## Impedance rules

- **Bridging rule**: output impedance should be ≥ 10× lower than input impedance
  - Low-Z out into high-Z in = correct
  - High-Z out into low-Z in = signal loss and distortion
- Guitar pickup (1–50kΩ source) → needs ≥ 1MΩ input (JFET buffer or opamp follower)
- Mic (150Ω source) → needs transformer or differential input with low noise figure
- Modular output (100–1kΩ) → can drive any typical input

## Level conversion

To go from modular (±5V) to consumer line (–10 dBV):
- Divide by ~16 — use a resistor voltage divider or inverting amp with Rf/Rin = 1/16

To go from instrument to line:
- Buffer first (JFET follower), then gain stage: 20–40 dB

## Gotchas
- Don't confuse dBu (relative to 0.775V) and dBV (relative to 1V) — the 2.2 dB difference matters in specs
- Many consumer devices labelled "line level" accept both –10 dBV and +4 dBu — check headroom
- Eurorack gate/trigger: 0V = off, 5V = on (some older gear uses +8V or +10V — don't assume)
