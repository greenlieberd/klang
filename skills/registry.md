# Skills Registry

All available skill files. Check this before starting any task.
Load the relevant files into context before responding.

---

## Electronics

- [opamp-audio](electronics/opamp-audio.md) — opamp configurations for audio: summing, inverting, non-inverting, difference amp, virtual ground
- [audio-signal-levels](electronics/audio-signal-levels.md) — line/instrument/mic/modular levels, impedance matching, headroom
- [passive-components](electronics/passive-components.md) — resistors, capacitors, and inductors in audio circuits: tolerances, types, audio use cases
- [power-supply-design](electronics/power-supply-design.md) — ±12V split rail, USB +5V, decoupling, star grounding, regulators
- [analog-filters](electronics/analog-filters.md) — RC, Sallen-Key, state-variable, Moog ladder topologies; Q, cutoff, formulas

## Platforms

- [daisy-seed](platforms/daisy-seed.md) — STM32H7 audio platform, pinout, audio codec, power requirements
- [eurorack-format](platforms/eurorack-format.md) — 3U/HP format, power header, CV/gate/audio electrical standards
- [arduino](platforms/arduino.md) — ATmega platforms, audio limitations, use cases in control hardware

## Firmware

- [cpp-daisy](firmware/cpp-daisy.md) — DaisySeed C++ + DaisySP: audio callback pattern, ADC, MIDI, DSP objects
- [pure-data](firmware/pure-data.md) — Pd patch design for audio, hvcc compilation to C++ for embedded
- [midi-protocol](firmware/midi-protocol.md) — MIDI 1.0 electrical spec, message types, channel filtering
- [vst-plugin](firmware/vst-plugin.md) — JUCE AudioProcessor, processBlock, parameters, VST3/AU targets

## Production

- [kicad-workflow](production/kicad-workflow.md) — schematic to Gerber: footprints, DRC, BOM export, net naming
- [pcb-design-rules](production/pcb-design-rules.md) — audio PCB layout: ground plane, trace widths, decoupling, JLCPCB rules
- [3d-printing-enclosures](production/3d-printing-enclosures.md) — panel cutout sizes, tolerances, material choice, export formats

## Drafts
Skills in _drafts/ are under review. Do not rely on them without flagging [DRAFT].
