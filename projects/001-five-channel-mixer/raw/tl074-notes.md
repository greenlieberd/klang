# TL074 Quad JFET Op-Amp

Manufacturer: Texas Instruments
Package: DIP-14
Supply voltage: ±18V max, typical ±15V
Input offset voltage: 3mV typical
Input noise: 18 nV/√Hz
GBW product: 3 MHz typical
Slew rate: 13 V/μs
Quiescent current: 1.4 mA per channel

## Use in audio mixers
Standard choice for summing amplifiers. Each section can drive one channel of a summing bus.
Virtual ground at inverting input allows parallel channel summing with independent gain per channel.
Pin layout: OUT-A(1), IN-A-(2), IN-A+(3), V+(4), IN-B+(5), IN-B-(6), OUT-B(7), GND(8-flip), OUT-C(8), IN-C-(9), IN-C+(10), V-(11), IN-D+(12), IN-D-(13), OUT-D(14)

## Recommended use
- 10kΩ input resistors per channel
- 10kΩ feedback resistor for unity gain sum
- 100nF bypass on each supply pin
