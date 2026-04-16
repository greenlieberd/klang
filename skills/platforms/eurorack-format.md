# Skill: Eurorack Format

## Physical format

| Parameter | Value |
|---|---|
| Height | 3U = 128.5mm panel height |
| Width unit | 1HP = 5.08mm |
| Rack width | 84HP standard (also 42HP, 104HP) |
| Depth | No strict standard — aim for < 40mm for compatibility |
| Panel material | Typically 1.5–2mm aluminium |
| Panel mounting | 3mm screws into rack rail |

## Power header (16-pin IDC)

```
KEY END (–12V side)
Pin 1:  –12V    Pin 2:  GND
Pin 3:  –12V    Pin 4:  GND
Pin 5:  –12V    Pin 6:  GND
Pin 7:   GND    Pin 8:  GND
Pin 9:   GND    Pin 10: GND
Pin 11: +12V    Pin 12: GND
Pin 13: +12V    Pin 14: GND
Pin 15: +12V    Pin 16: +5V
```

**–12V is always at the keyed/shrouded end.** Every board must have reverse-polarity protection — at minimum a Schottky diode on each rail, or a tantalum cap to GND (fails short, blows a fuse). 

Add 10µF + 100nF decoupling per rail on the module PCB.

## Signal standards

| Signal | Voltage | Notes |
|---|---|---|
| Audio | ±5V (10Vpp) | Significantly hotter than line level |
| CV (generic) | 0 to +5V or –5 to +5V | Module-dependent |
| Pitch CV | 1V/octave (1V/oct) | 0V = some reference note, usually C2 or C3 |
| Gate | 0V / +5V | Some older gear uses +8V or +10V |
| Trigger | Short +5V pulse | Usually 1–10ms |
| Clock | +5V pulse | Tempo-derived; rate varies |

## Jacks

- 3.5mm mono TS jacks (Thonkiconn / PJ301BM most common)
- Normalled: passive connection between two jacks when top jack unpatched
- Half-normalled: connection maintained even when top jack is patched

## Panel hole sizes (standard)

| Component | Hole diameter |
|---|---|
| 3.5mm jack (Thonkiconn) | 6mm |
| 6.35mm jack (1/4") | 9.5mm |
| 9mm pot shaft | 7mm |
| 6mm pot shaft | 6mm |
| LED (3mm) | 3.2mm |
| LED (5mm) | 5.2mm |
| Toggle switch | 6mm |
| Pushbutton | to spec |

## Gotchas
- Eurorack CV and audio at ±5V will rail or destroy inputs expecting line level — always attenuate
- Daisy Seed ADC is 3.3V max — scale Eurorack inputs (±5V) with a resistor divider
- 1V/oct tracking requires precision resistors (0.1%) and temperature stability
- Some manufacturers deviate from standards — verify before patching unfamiliar gear
- Always add a 100Ω series resistor on each audio/CV output jack for short-circuit protection
