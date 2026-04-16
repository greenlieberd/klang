# Skill: KiCad Workflow

## Version
KiCad 7.x (current stable). File formats changed significantly from v5 — do not mix versions.

## Workflow: schematic → PCB → fabrication

### 1. Schematic (Eeschema)

- Use KiCad's built-in symbol library first; add custom symbols only when necessary
- Net naming: use explicit net labels for all named signals (e.g. `AUDIO_IN_L`, `+12V`, `GND`)
- Power symbols: use `+12V`, `-12V`, `GND`, `+3V3` — these create implicit connections
- Add value + footprint to every component before annotation
- Run **ERC (Electrical Rules Check)** — fix all errors, review all warnings
- Export netlist or use "Update PCB from Schematic" directly

### 2. Footprint assignment

- Match package to your actual component (DIP-8, SOT-23, TO-92, etc.)
- Through-hole (THT) preferred for KLANG breadboard-to-PCB conversions
- Pad sizes: 0.8mm hole / 1.6mm pad is standard for most THT components
- Connectors: use KiCad's `Connector_Audio` library for 3.5mm and 6.35mm jacks

### 3. PCB layout (Pcbnew)

**Layer stack (2-layer standard):**
- F.Cu: signal routing, components
- B.Cu: ground plane (pour) + signal routing
- F.SilkS: component labels, orientation marks
- F.Mask: soldermask

**Layout order:**
1. Place connectors (jacks, power header) on panel edge
2. Place ICs
3. Place decoupling caps immediately adjacent to IC supply pins
4. Route power first (pour or wide traces)
5. Route audio signal path
6. Add ground plane pour on B.Cu
7. Run **DRC (Design Rule Check)** — fix all errors

### 4. Net naming conventions for audio

| Net name | Signal |
|---|---|
| `AUDIO_IN_L` / `AUDIO_IN_R` | Input audio signal |
| `AUDIO_OUT_L` / `AUDIO_OUT_R` | Output audio signal |
| `CV_IN_1` | Control voltage input |
| `GATE_IN` | Gate/trigger input |
| `+12V` / `-12V` | Power rails |
| `AGND` | Analog ground |
| `DGND` | Digital ground |
| `GND` | Chassis/shield ground |

### 5. Gerber export for fabrication

File → Plot → Gerber. Required files:
- F.Cu, B.Cu (copper layers)
- F.SilkS (silkscreen)
- F.Mask, B.Mask (soldermask)
- Edge.Cuts (board outline)
- PTH.drl (drill file)

Zip all files → upload to JLCPCB or equivalent.

### 6. BOM export

Tools → Generate BOM → select BOM plugin → CSV format.
Columns needed: Reference, Value, Footprint, Quantity, Part number.

## JLCPCB design rules (PCB house defaults)

| Parameter | Minimum |
|---|---|
| Trace width | 0.1mm (0.2mm recommended) |
| Trace spacing | 0.1mm |
| Via hole | 0.3mm drill, 0.6mm pad |
| Min drill | 0.2mm |
| Board thickness | 1.6mm standard |
| Copper weight | 1oz standard |

## Gotchas
- Ground pours: set clearance to 0.3mm, thermal relief to avoid cold solder joints on THT
- Import graphics as footprints, not as copper — copper imports ignore DRC
- 3D viewer is useful for catching silkscreen errors and jack/pot conflicts before fabrication
- Export Gerbers and check them in a Gerber viewer (Gerbv or KiCad's built-in) before ordering
