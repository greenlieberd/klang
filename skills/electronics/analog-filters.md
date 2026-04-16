# Skill: Analog Filters for Audio

## Key formulas

**Cutoff frequency (first-order RC):**
f_c = 1 / (2π × R × C)

**Q factor:** Controls resonance peak height. Q < 0.707 = overdamped. Q = 0.707 = Butterworth (maximally flat). Q > 1 = resonant peak.

## Filter types

### RC (passive, first-order)
- 1 resistor + 1 capacitor
- -6 dB/octave rolloff
- No active components — lossy (output impedance is R in parallel with path impedance)
- Use for: gentle high-frequency roll-off, decoupling, anti-aliasing before ADC when steep rolloff not required

### Sallen-Key (active, second-order)
- 2 RC sections + opamp (unity or low gain)
- –12 dB/octave rolloff per stage
- Non-inverting: retains phase
- Easy to design, widely used in audio crossovers and tone controls
- Q set by component ratio: Q = 1 / (3 – Av) for unity-gain topology

### State-Variable Filter (SVF)
- Simultaneously produces LP, HP, BP, and notch outputs from same input
- Q and cutoff independently adjustable
- 3 opamps minimum
- Classic synth filter topology (e.g., EMS VCS3, many Eurorack designs)
- Easy to voltage-control cutoff via OTA or VCA in feedback path

### Moog Ladder (transistor ladder)
- 4 cascaded one-pole RC stages using transistor pairs
- Self-oscillates at high resonance — musical character
- Requires careful biasing; temperature-sensitive (use matched transistor pairs)
- Textbook implementation: THAT340 quad matched transistors, Mouser ~€4.00, DIP-14

### Biquad
- Digital-style topology implemented in analog — precise, flexible
- Requires 2 integrators + summation
- Can implement LP, HP, BP, notch by mixing outputs

## Cutoff frequency component selection

| Target f_c | Practical values |
|---|---|
| 20 Hz (sub bass) | 10kΩ + 820nF |
| 80 Hz (LPF crossover) | 10kΩ + 200nF |
| 1 kHz (midpoint) | 10kΩ + 15nF |
| 10 kHz (treble rolloff) | 10kΩ + 1.5nF |
| 20 kHz (anti-alias) | 10kΩ + 820pF |

*Prefer E24 series values; solve for C after fixing R at a convenient value.*

## Filter response shapes

| Shape | Q (2nd order) | Use case |
|---|---|---|
| Bessel | 0.577 | Flat group delay — best transient response |
| Butterworth | 0.707 | Flat passband — general audio |
| Chebyshev | > 0.707 | Steeper rolloff, passband ripple — anti-alias |
| Resonant (synth) | 1–∞ | Musical; self-oscillation possible |

## Gotchas
- Q > 1 creates a boost before rolloff — compensate gain if needed
- Sallen-Key is sensitive to component tolerance for high-Q — use 1% resistors and stable caps
- SVF bias resistors must be matched for LP/HP symmetry
- Ladder filters need temperature compensation or trimming if cutoff precision matters
