# Skill: Power Supply Design for Audio Hardware

## Standard rails for KLANG projects

| Context | Rails | Notes |
|---|---|---|
| Eurorack module | ±12V, optional +5V | From Eurorack power header |
| Standalone audio | ±12V or ±15V | From wall adapter + rectifier + regulators |
| Microcontroller (Daisy etc.) | +3.3V or +5V | USB or from 7805 off ±12V |
| Breadboard prototype | ±12V from bench PSU | Use lab supply with current limit |

## ±12V split rail (Eurorack / opamp)

**From wall adapter (AC input):**
1. Bridge rectifier (1N4004 × 4 or W04 package)
2. Filter caps: 1000–4700µF per rail
3. LM7812 (+12V) and LM7912 (–12V) regulators
4. Output filter: 100nF ceramic per rail after regulator

**Minimum decoupling per IC:**
- 100nF ceramic between each supply pin and GND, as close to the IC as possible
- Shared 10µF electrolytic per cluster of ICs on each rail

## Eurorack power header (16-pin IDC)

```
Pin  1: –12V    Pin  2: GND
Pin  3: –12V    Pin  4: GND
Pin  5: –12V    Pin  6: GND
Pin  7: GND     Pin  8: GND
Pin  9: GND     Pin 10: GND
Pin 11: +12V    Pin 12: GND
Pin 13: +12V    Pin 14: GND
Pin 15: +12V    Pin 16: +5V
```
**Important:** –12V is on the SHROUDED end (keyed side) — check orientation every time.
Reverse polarity destroys ICs instantly.
Add reverse-polarity protection diode on breadboard prototypes.

## Virtual ground (for single-supply circuits)

When only +5V or +12V is available but opamps need a mid-rail reference:

**Option A — TLE2426 IC (best)**
- Dedicated virtual ground IC, 20mA drive, very low impedance
- Connect: IN=+Vcc, OUT=virtual GND, GND=GND
- Supplier: Mouser, ~€1.50, SOT-23

**Option B — Resistor divider + buffer**
- 2 × 10kΩ to divide Vcc/2, then opamp follower for low impedance
- Costs: ~€0.05 + one opamp section

**Option C — Resistor divider only (high-Z)**
- Fine for non-inverting input reference, not for signal ground

## Star grounding

- Separate analog and digital ground planes on PCB
- Join them at one point only — the power entry
- Never run high-current digital return current through analog ground area
- Audio connector shells: connect to chassis ground, not signal ground, via 10nF cap

## Gotchas
- Polarise electrolytic filter caps correctly — negative terminal to GND
- LM78xx / LM79xx need ≥ 2.5V dropout — input must be at least 14.5V for +12V output
- Eurorack bus can have significant ripple — always decouple at the module
- Current consumption: TL074 draws ~1.4mA per supply rail per IC — add up before sizing your supply
