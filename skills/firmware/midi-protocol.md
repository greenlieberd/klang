# Skill: MIDI Protocol Reference

## Electrical specification (MIDI 1.0)

- **Baud rate:** 31,250 bps (31.25 kbaud)
- **Interface:** 5-pin DIN (180°), current loop
- **Output:** current source, 5mA
- **Input:** optoisolated (6N138, H11L1, or equivalent)
- **Logic levels:** current-loop (not TTL directly)
- **Cable length:** up to 15m specified

### 5-pin DIN pinout (looking into socket)
```
    ┌───────────┐
    │  2  4  5  │
    │    3      │
    └─────1─────┘
Pin 1: not connected
Pin 2: Shield/GND (output only)
Pin 4: Current source (+5V through 220Ω)
Pin 5: Data (active low)
Pin 3: not connected
```

### Optoisolator input circuit
```
DIN Pin 4 → 220Ω → LED anode of 6N138
DIN Pin 5 → LED cathode of 6N138
6N138 output → pull-up to +5V via 270Ω → MCU UART RX
```

## Message structure

All MIDI messages: status byte (MSB=1) + 0–2 data bytes (MSB=0).
Channel: lower 4 bits of status byte (0–15 = channels 1–16).

### Common messages

| Message | Status byte | Data 1 | Data 2 |
|---|---|---|---|
| Note Off | 0x80 + ch | Note (0–127) | Velocity (0–127) |
| Note On | 0x90 + ch | Note (0–127) | Velocity (0–127) |
| Aftertouch | 0xA0 + ch | Note | Pressure |
| CC | 0xB0 + ch | Controller (0–127) | Value (0–127) |
| Program Change | 0xC0 + ch | Program (0–127) | — |
| Pitch Bend | 0xE0 + ch | LSB (7-bit) | MSB (7-bit) |
| Clock | 0xF8 | — | — |
| Start | 0xFA | — | — |
| Stop | 0xFC | — | — |

**Note On with velocity 0 = Note Off** — handle this correctly.

### Common CC numbers

| CC | Function |
|---|---|
| 1 | Modulation wheel |
| 7 | Volume |
| 10 | Pan |
| 11 | Expression |
| 64 | Sustain pedal (0/127) |
| 74 | Filter cutoff (common mapping) |
| 71 | Filter resonance (common mapping) |

### Pitch Bend calculation
```
pitch_bend_value = (MSB << 7) | LSB   // 14-bit value, 0–16383
semitones = (pitch_bend_value - 8192) / 8192.0 * bend_range_semitones
```

### Note to frequency
```
f = 440.0 × 2^((note - 69) / 12)
// Or use DaisySP: mtof(note)
```

## Gotchas
- **Note On velocity 0 = Note Off** — don't assume every 0x9x is a sounding note
- Running status: MIDI can omit repeated status bytes — your parser must handle this
- MIDI clock at 24 pulses per quarter note — count pulses for BPM sync
- Channel 10 (0x09) is conventionally drums in General MIDI — may behave differently on synths
- USB MIDI and 5-pin DIN MIDI are separate specs — USB MIDI uses packets, not raw bytes
