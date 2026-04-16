# Skill: VST Plugin Development with JUCE

## What it is
JUCE is a C++ framework for building audio plugins (VST3, AU, AAX, CLAP) and standalone applications. It abstracts the plugin API differences and provides DSP utilities, UI components, and parameter management.

## When to use
- When the project is a DAW plugin (effect, instrument, utility)
- When the deliverable is software, not hardware
- When real-time audio processing in a host is required

## Project setup

```bash
# Download JUCE from https://juce.com
# Use Projucer to generate project files
# Or use CMake (JUCE 6+ supports CMake natively)

cmake -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
```

## Core class structure

```cpp
#include <JuceHeader.h>

class MyPlugin : public juce::AudioProcessor
{
public:
    // ─── Plugin info ────────────────────────────────────────────────────────
    const juce::String getName() const override { return "My Plugin"; }
    bool acceptsMidi() const override            { return false; }
    bool producesMidi() const override           { return false; }
    double getTailLengthSeconds() const override { return 0.0; }

    // ─── Lifecycle ──────────────────────────────────────────────────────────
    void prepareToPlay(double sampleRate, int samplesPerBlock) override
    {
        // Initialise DSP here — called before playback starts
        currentSampleRate = sampleRate;
    }

    void releaseResources() override {}

    // ─── Audio processing ───────────────────────────────────────────────────
    // Signal path comments required at each stage
    void processBlock(juce::AudioBuffer<float>& buffer,
                      juce::MidiBuffer& midiMessages) override
    {
        juce::ScopedNoDenormals noDenormals;
        auto totalNumInputChannels  = getTotalNumInputChannels();
        auto totalNumOutputChannels = getTotalNumOutputChannels();

        // Clear unused output channels
        for(auto i = totalNumInputChannels; i < totalNumOutputChannels; ++i)
            buffer.clear(i, 0, buffer.getNumSamples());

        for(int channel = 0; channel < totalNumInputChannels; ++channel)
        {
            auto* channelData = buffer.getWritePointer(channel);
            // Stage 1: process signal
            for(int sample = 0; sample < buffer.getNumSamples(); ++sample)
            {
                channelData[sample] = channelData[sample]; // passthrough
            }
        }
    }

    // ─── Parameters ─────────────────────────────────────────────────────────
    juce::AudioProcessorValueTreeState::ParameterLayout createParameterLayout()
    {
        std::vector<std::unique_ptr<juce::RangedAudioParameter>> params;
        params.push_back(std::make_unique<juce::AudioParameterFloat>(
            "gain", "Gain", 0.0f, 1.0f, 0.5f));
        return { params.begin(), params.end() };
    }

    juce::AudioProcessorValueTreeState apvts{
        *this, nullptr, "Parameters", createParameterLayout()};

private:
    double currentSampleRate = 44100.0;
};
```

## Parameter management (APVTS)

```cpp
// Get parameter value (thread-safe)
float gain = *apvts.getRawParameterValue("gain");

// Attach a slider in the editor
juce::AudioProcessorValueTreeState::SliderAttachment gainAttachment{
    apvts, "gain", gainSlider};
```

## Plugin formats

| Format | Extension | Platform | Notes |
|---|---|---|---|
| VST3 | .vst3 | Mac/Win/Linux | Default target — use this |
| AU | .component | Mac only | Required for Logic Pro |
| AAX | .aaxplugin | Mac/Win | Pro Tools — requires AVID license |
| Standalone | .app/.exe | Any | Useful for hardware prototyping |

## Gotchas
- `processBlock()` runs on the audio thread — no UI calls, no allocations
- Denormal numbers (tiny floats near zero) kill CPU — use `ScopedNoDenormals` or add `1e-18f`
- Parameter values from APVTS are atomic — always read via `getRawParameterValue()`
- JUCE version matters — JUCE 7+ has breaking changes from JUCE 6; check project compatibility
- AU plugins require code signing on modern macOS — test early in development
