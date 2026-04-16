# Skill: Passive Components in Audio Circuits

## Resistors

**Series (E-series)**
- E12: 12 values per decade — coarse, use for non-critical values
- E24: 24 values per decade — standard for most audio work
- E96: 96 values per decade — use when precise gain or filter cutoff needed

**Tolerance**
- 5% (gold): acceptable for non-critical gain stages
- 1% (brown): use for filter networks, gain-setting pairs, difference amps
- 0.1%: matching pairs in precision circuits (difference amp, balanced stages)

**Types**
- Carbon film: cheap, noisy at low values — avoid in preamp signal path
- Metal film: standard for audio — low noise, good stability
- Wirewound: high power, inductive — never use in signal path

**Noise**
- Thermal (Johnson) noise: V_n = √(4kTRΔf) — at 1kΩ, room temp, 20kHz BW ≈ 18 nV
- Keep feedback resistors ≤ 100kΩ to control thermal noise

## Capacitors

**Types and audio use cases**

| Type | Use in audio | Avoid for |
|---|---|---|
| Electrolytic (polarised) | Power supply filtering, DC blocking (with correct polarity) | AC coupling in signal path (use film instead) |
| Film (polyester, MKT) | AC coupling, filter networks — good general purpose | Nowhere — standard signal path cap |
| Film (polypropylene, MKP) | High-quality filter caps, oscillator timing | Cost-sensitive designs |
| Ceramic (X7R) | Decoupling (100nF near IC supply pins) | Audio signal path — piezoelectric microphonics |
| Ceramic (C0G/NP0) | Small values in filters (< 1nF) where stability matters | Large value decoupling |

**Value selection for audio**
- AC coupling: choose C so f_c = 1/(2πRC) is well below audio band
  - At 10kΩ load, 10µF gives f_c ≈ 1.6 Hz — good
  - At 10kΩ load, 100nF gives f_c ≈ 159 Hz — too high, will cut bass
- Bypass / decoupling: 100nF ceramic per IC supply pin + 10µF electrolytic per board section

## Inductors

Rarely used in the audio signal path. Common uses:
- **Common-mode choke**: on balanced lines to reject RF interference
- **Power supply filter**: ferrite bead (0Ω at DC, impedance at RF) in series with supply to IC
- **EMI suppression**: ferrite bead on USB D+/D– lines

## Gotchas
- Electrolytic caps are polarised — wrong polarity destroys them (sometimes violently)
- Ceramic caps in signal path cause distortion due to piezo effect (especially Class 2 dielectrics like X5R/X7R)
- Capacitor ESR matters for power supply decoupling — low-ESR electrolytics for switching supplies
- Film caps have better audio specs but are physically larger — plan PCB space accordingly
