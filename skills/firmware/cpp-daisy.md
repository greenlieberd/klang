# Skill: C++ Firmware for Daisy Seed

## Project setup

```bash
# Using the Daisy project template
git clone https://github.com/electro-smith/DaisyExamples
# Or scaffold manually with daisy-init
```

Minimum CMakeLists.txt or Makefile targets: link libdaisy + DaisySP.

## Canonical firmware structure

```cpp
#include "daisy_seed.h"
#include "dsp/daisysp.h"

using namespace daisy;
using namespace daisysp;

DaisySeed hw;

// Declare DSP objects at global scope (no heap allocation in callback)
Oscillator osc;
Svf        filter;
Adsr       env;

// ─── Audio Callback ───────────────────────────────────────────────────────────
// Called at audio rate (~48kHz). Keep lean — no blocking, no malloc.
// Signal path comment required at every stage.
void AudioCallback(AudioHandle::InputBuffer  in,
                   AudioHandle::OutputBuffer out,
                   size_t                    size)
{
    for(size_t i = 0; i < size; i++)
    {
        // Stage 1: read envelope
        float gate = hw.adc.GetFloat(0) > 0.5f;
        float amp  = env.Process(gate);

        // Stage 2: oscillator
        float sig = osc.Process() * amp;

        // Stage 3: filter
        filter.Process(sig);
        sig = filter.Low();

        // Output (stereo)
        out[0][i] = sig;
        out[1][i] = sig;
    }
}

// ─── Main ─────────────────────────────────────────────────────────────────────
int main()
{
    hw.Init();
    hw.SetAudioBlockSize(4);   // 4 samples per block — lower latency
    hw.SetAudioSampleRate(SaiHandle::Config::SampleRate::SAI_48KHZ);

    // ADC setup — configure channels before StartAdc
    AdcChannelConfig adc_cfg[2];
    adc_cfg[0].InitSingle(hw.GetPin(15));  // Pot 1 → D15
    adc_cfg[1].InitSingle(hw.GetPin(16));  // Pot 2 → D16
    hw.adc.Init(adc_cfg, 2);
    hw.adc.Start();

    // Init DSP objects
    float sample_rate = hw.AudioSampleRate();
    osc.Init(sample_rate);
    osc.SetWaveform(Oscillator::WAVE_SAW);
    osc.SetFreq(440.f);
    osc.SetAmp(1.f);

    filter.Init(sample_rate);
    filter.SetFreq(1000.f);
    filter.SetRes(0.5f);

    env.Init(sample_rate);
    env.SetAttackTime(0.01f);
    env.SetDecayTime(0.1f);
    env.SetSustainLevel(0.7f);
    env.SetReleaseTime(0.3f);

    hw.StartAudio(AudioCallback);

    // Main loop — read ADC, update DSP parameters
    while(1)
    {
        float freq = hw.adc.GetFloat(0) * 2000.f + 50.f;
        float res  = hw.adc.GetFloat(1);
        filter.SetFreq(freq);
        filter.SetRes(res);
        hw.DelayMs(1);
    }
}
```

## Key DaisySP objects

| Object | Init | Key methods |
|---|---|---|
| `Oscillator` | `Init(sr)` | `SetWaveform()`, `SetFreq()`, `SetAmp()`, `Process()` |
| `Svf` | `Init(sr)` | `SetFreq()`, `SetRes()`, `Process(in)`, `.Low()` `.High()` `.Band()` |
| `Adsr` | `Init(sr)` | `SetAttackTime()`, `SetDecayTime()`, `SetSustainLevel()`, `SetReleaseTime()`, `Process(gate)` |
| `DelayLine<T,N>` | (template) | `Write(in)`, `Read()` |
| `ReverbSc` | `Init(sr)` | `SetFeedback()`, `SetLpFreq()`, `Process(inL,inR,&outL,&outR)` |
| `Overdrive` | `Init()` | `SetDrive()`, `Process(in)` |

## MIDI (via UART)

```cpp
MidiUartHandler midi;
MidiUartHandler::Config midi_cfg;
midi_cfg.transport_config.periph = UartHandler::Config::Peripheral::USART_1;
midi.Init(midi_cfg);
midi.StartReceive();

// In main loop:
midi.Listen();
while(midi.HasEvents()) {
    auto msg = midi.PopEvent();
    if(msg.type == NoteOn) {
        float freq = mtof(msg.AsNoteOn().note);
        osc.SetFreq(freq);
    }
}
```

## Rules
- No dynamic memory in audio callback (`new`, `malloc`, `std::vector` resizing)
- ADC reads go in the main loop — not in the audio callback
- Audio callback block size: 4 samples is lowest latency; 48 is more CPU-efficient
- Keep global DSP objects — stack allocation in callback causes issues
