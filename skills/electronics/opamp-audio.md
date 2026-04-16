# Skill: Op-Amp Configurations for Audio

## Key concepts

**Inverting amplifier**
- Gain = –Rf / Rin (negative = phase inversion)
- Input impedance = Rin
- Use when phase inversion is acceptable; typical for summing stages

**Non-inverting amplifier**
- Gain = 1 + Rf / R1
- Input impedance = very high (MΩ range)
- Use for input buffers and unity-gain followers (voltage follower: short Rf to GND, remove R1)

**Summing amplifier (inverting)**
- Each input has its own Rin; output = –Rf × (V1/R1 + V2/R2 + ...)
- All inputs see the same virtual ground at the inverting input
- Use for mixers: 10kΩ inputs, 10kΩ feedback → unity gain per channel

**Difference amplifier**
- Rejects common-mode signal; passes differential signal
- All four resistors must match precisely (use 0.1% resistors)
- Use for balanced input stages and hum rejection

**Virtual ground (mid-rail)**
- For single-supply circuits needing a reference at Vcc/2
- Use TLE2426 (dedicated virtual ground IC) for low noise
- Or: resistor divider (2×10kΩ) + 100µF bypass cap to GND — cheaper but higher impedance

## Audio-specific selection criteria

| Parameter | Audio requirement |
|---|---|
| GBW product | ≥ 10× the highest audio frequency at the intended gain |
| Slew rate | ≥ 2π × f × Vpk (≥ 1 V/µs for most audio) |
| Input noise | ≤ 10 nV/√Hz for low-noise preamp; ≤ 20 nV/√Hz acceptable for line level |
| THD | < 0.01% at rated audio frequencies |
| Supply | ±12V or ±15V preferred; single supply with virtual ground also works |

## Recommended ICs for KLANG projects

| IC | Type | Notes |
|---|---|---|
| TL072 / TL074 | Dual/quad JFET | Low cost, low noise, standard for audio — use first |
| NE5532 | Dual bipolar | Lower noise than TL07x; good for preamps |
| LM358 | Dual | Cheap, single-supply — avoid for audio; crossover distortion near GND |
| OPA2134 | Dual precision | Hi-fi grade; use when TL072 isn't good enough |

## Gotchas
- Always decouple supply pins: 100nF ceramic close to IC, 10µF electrolytic nearby
- Input bias current can cause DC offset through high-value resistors — keep feedback resistors ≤ 100kΩ
- Unused opamp inputs must not float — connect to GND or virtual ground through a resistor
- Gain-bandwidth product applies at the intended frequency — don't run out of headroom
