# Skill: Audio PCB Design Rules

## Grounding

**Star ground topology:**
- One central ground point per PCB
- Analog and digital grounds are separate planes, joined at one star point
- The star point is at the power entry (where supply connects to board)
- Never let digital return current flow through the analog ground area

**Ground plane:**
- Use a full copper pour on B.Cu for analog circuits
- Split plane at the analog/digital boundary — connect at star point only
- Connect all bypass caps to the ground plane with the shortest possible trace

**Chassis ground:**
- Audio connector shells → chassis → one-point connection to signal ground via 10nF ceramic cap
- Prevents ground loops from cable shields

## Trace widths

| Signal type | Minimum width | Recommended |
|---|---|---|
| Audio signal | 0.2mm | 0.3mm |
| Control signal | 0.2mm | 0.2mm |
| Power rails (±12V) | 0.5mm | 0.8mm |
| High current (> 500mA) | 1.0mm | 1.5mm |
| Ground pour connections | 0.5mm | to pour |

## Decoupling capacitors

- 100nF ceramic (C0G or X7R) between each IC supply pin and GND
- Place as close to the supply pin as possible — trace from cap to pin must be short
- 10µF electrolytic per IC cluster (one per board section)
- Additional 1µF film cap parallel with electrolytic for mid-frequency decoupling

## Component placement for audio

1. **Power entry and regulators** — one edge of board
2. **Decoupling caps** — directly adjacent to IC pins they serve
3. **Audio connectors** — panel edge, ordered to match front-panel layout
4. **ICs** — grouped by signal stage (input → processing → output, left to right)
5. **Pots/encoders** — panel-mount, trace back to board via wires or right-angle header

## Signal routing rules

- Route audio signal on F.Cu; avoid crossing under noisy digital logic
- Keep input and output traces physically separated — crosstalk and oscillation risk
- Avoid running audio traces parallel to power supply traces over long distances
- Minimise loop area for sensitive nodes (inverting input of opamp especially)
- 100Ω series resistor on output side of each audio jack — short-circuit protection

## Eurorack-specific

- Power header: 16-pin IDC, 2.54mm pitch, keyed (shrouded) — pin 1 = –12V
- Add 10µF + 100nF to each rail on the module board
- Reverse-polarity protection: Schottky diode (1N5817) in series on each rail (or Zener to GND)
- Panel-mount pots: use right-angle PCB mount or connect via wires — don't cantilever heavy parts

## JLCPCB practical settings

| Setting | Value |
|---|---|
| PCB thickness | 1.6mm |
| Copper weight | 1oz |
| Surface finish | HASL (lead-free) or ENIG for fine pitch |
| Soldermask colour | Black for KLANG aesthetic |
| Min drill | 0.3mm (use 0.8mm for THT — most components) |

## Gotchas
- Thermal reliefs on ground pours help hand-soldering THT components; disable for reflow
- Long parallel traces between high-gain opamp input and output → oscillation risk
- Power plane voids near audio traces cause impedance discontinuity — keep pours solid
- Silkscreen on pads is ignored by most fab houses but causes visual confusion — keep clear
