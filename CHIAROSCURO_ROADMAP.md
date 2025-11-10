# Chiaroscuro - Interactive Audio-Visual Playground
## Project Roadmap & Implementation Plan

> **Vision**: A meditative, intuitive sound playground where users manipulate lava lamp-like visuals to generate ethereal, paulstretch-inspired soundscapes through real-time audio processing and granular synthesis.

---

## Table of Contents
1. [Repository Structure & Setup](#1-repository-structure--setup)
2. [MVP Phase 1: Foundation](#2-mvp-phase-1-foundation)
3. [MVP Phase 2: Core Interactions](#3-mvp-phase-2-core-interactions)
4. [Phase 3: Enhanced Features](#4-phase-3-enhanced-features)
5. [Phase 4: Polish & Integration](#5-phase-4-polish--integration)
6. [Future Enhancements](#6-future-enhancements)
7. [Technical Architecture](#7-technical-architecture)

---

## 1. Repository Structure & Setup

### 1.1 Create Chiaroscuro Repository
**Priority**: CRITICAL | **Estimated Time**: 1 hour

- [ ] Create new GitHub repository: `tree3stan-chord/chiaroscuro`
- [ ] Initialize with `.gitignore` (Node.js template)
- [ ] Create basic `package.json` with dependencies
- [ ] Set up project structure (see below)

**Recommended Structure**:
```
chiaroscuro/
├── .git
├── .gitignore
├── package.json
├── package-lock.json
├── next.config.js (if needed for standalone dev)
├── README.md
├── ChiaroscuroSandbox.js (main export)
├── components/
│   ├── ChiaroscuroCanvas.js
│   ├── ControlPanel.js
│   └── PermissionGate.js
├── lib/
│   ├── AudioEngine.js
│   ├── BlobPhysics.js
│   ├── GestureMapper.js
│   └── utils.js
└── styles/
    └── Chiaroscuro.module.css
```

### 1.2 Core Dependencies
**Priority**: CRITICAL | **Estimated Time**: 30 minutes

```json
{
  "name": "chiaroscuro",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "next": "^14.0.0",
    "bootstrap": "^5.3.0",
    "react-bootstrap": "^2.9.0",
    "react-icons": "^4.11.0"
  },
  "devDependencies": {
    "eslint": "^8.50.0",
    "eslint-config-next": "^14.0.0"
  }
}
```

### 1.3 Add as Submodule to Studio
**Priority**: CRITICAL | **Estimated Time**: 15 minutes

```bash
cd /home/espadon/src/studio
git submodule add git@github.com:tree3stan-chord/chiaroscuro.git components/chiaroscuro
git add .gitmodules components/chiaroscuro
git commit -m "Add chiaroscuro as submodule"
```

### 1.4 Update Studio Integration
**Priority**: CRITICAL | **Estimated Time**: 30 minutes

**Files to modify**:
- `pages/index.js`: Add chiaroscuro mode case
- `components/StudioModeSelector.js`: Add Chiaroscuro card

**Suggested Icon & Color**:
- Icon: `FaDroplet` + `GiAura` or `RiLightbulbFlashLine`
- Color: `#e74c3c` (warm red-orange, like lava)

---

## 2. MVP Phase 1: Foundation
**Goal**: Get basic canvas rendering and audio input working
**Estimated Time**: 4-6 hours

### 2.1 Microphone Permission & Input
**Priority**: CRITICAL | **Estimated Time**: 2 hours

- [ ] Create `PermissionGate.js` component
  - Request microphone permissions
  - Handle permission denial gracefully
  - Show clear instructions to user
- [ ] Set up Web Audio API context
- [ ] Create `MediaStreamSource` from microphone
- [ ] Connect to `AnalyserNode` for FFT analysis
- [ ] Test: Display mic input level meter

**Technical Notes**:
```javascript
// Basic audio context setup
const audioContext = new (window.AudioContext || window.webkitAudioContext)();
const analyser = audioContext.createAnalyser();
analyser.fftSize = 2048;

navigator.mediaDevices.getUserMedia({ audio: true })
  .then(stream => {
    const source = audioContext.createMediaStreamSource(stream);
    source.connect(analyser);
  });
```

### 2.2 Basic Canvas Rendering
**Priority**: CRITICAL | **Estimated Time**: 2-3 hours

- [ ] Set up HTML5 Canvas with proper sizing
- [ ] Implement simple blob rendering (circles with gradients)
- [ ] Create animation loop (60fps using requestAnimationFrame)
- [ ] Add single blob that responds to mic amplitude
  - Volume = blob size
  - Dominant frequency = blob color (warm to cool spectrum)
- [ ] Test: Blob pulses/changes color based on audio input

**Visual Style**:
- Dark background (#0a0a0a or #1a1a2e)
- Radial gradients for "glow" effect
- Smooth color transitions (use HSL color space)

### 2.3 Basic Physics Simulation
**Priority**: HIGH | **Estimated Time**: 1-2 hours

- [ ] Implement simple blob movement
  - Random drift when idle
  - Respond to audio input (energy = movement speed)
- [ ] Add boundary collision (bounce off edges)
- [ ] Smooth movement with velocity damping

---

## 3. MVP Phase 2: Core Interactions
**Goal**: Make it interactive and generate sound
**Estimated Time**: 6-8 hours

### 3.1 Granular Audio Engine
**Priority**: CRITICAL | **Estimated Time**: 3-4 hours

- [ ] Implement circular buffer for audio capture
  - Store last 5-10 seconds of mic input
  - Continuously overwrite old data
- [ ] Create basic granular synthesizer
  - Extract short grains (50-200ms) from buffer
  - Apply windowing (Hann window)
  - Trigger grain playback with overlap
- [ ] Add basic time-stretching
  - Grain playback rate vs. trigger rate
  - Start with 2-4x stretch (paulstretch-like)
- [ ] Connect to audio output
- [ ] Test: Hold a note/sound, should hear it stretched

**Paulstretch Algorithm Simplified**:
1. Take short grain from input
2. Apply FFT
3. Randomize phase
4. Apply inverse FFT
5. Overlap-add with previous grains
6. Result: Ethereal, stretched sound

### 3.2 Mouse/Touch Interaction
**Priority**: CRITICAL | **Estimated Time**: 2-3 hours

- [ ] Detect mouse hover over blob
  - Change cursor to indicate interactivity
  - Visual feedback (glow, outline)
- [ ] Implement drag interaction
  - Click + hold to grab blob
  - Drag horizontally = change stretch factor
  - Drag vertically = change pitch
- [ ] Trigger grain synthesis on drag
  - Continuous grain generation while dragging
  - Map drag distance to audio parameters
- [ ] Test: Drag blob, hear ethereal stretched sound

**Interaction Mapping (MVP)**:
```
X-axis (horizontal): Time-stretch factor (1x to 4x)
Y-axis (vertical):   Pitch shift (-12 to +12 semitones)
```

### 3.3 Visual-Audio Feedback Loop
**Priority**: HIGH | **Estimated Time**: 1-2 hours

- [ ] Blob size responds to synthesis intensity
- [ ] Blob color shifts based on pitch
- [ ] Add visual "trail" effect during drag
- [ ] Particle effects on interaction

---

## 4. Phase 3: Enhanced Features
**Goal**: Add depth and playability
**Estimated Time**: 8-10 hours

### 4.1 Multiple Blobs
**Priority**: MEDIUM | **Estimated Time**: 2-3 hours

- [ ] Support 2-4 simultaneous blobs
- [ ] Each blob = separate audio layer
- [ ] Blob collision detection
  - Merge blobs = blend audio
  - Bounce apart = divergent timbres
- [ ] Blob splitting on strong audio transients

### 4.2 "Memory Blob" Feature
**Priority**: HIGH | **Estimated Time**: 2-3 hours

- [ ] Tap/click blob to "freeze" it
  - Captures current grain buffer state
  - Becomes persistent, looping
- [ ] Frozen blobs visualized differently
  - Different color/opacity
  - Pulsing animation
- [ ] Tap again to unfreeze
- [ ] Maximum 3-5 memory blobs at once

### 4.3 Effects Processing
**Priority**: MEDIUM | **Estimated Time**: 2-3 hours

- [ ] Implement reverb (ConvolverNode)
  - Use impulse response (load from file or generate)
  - Wet/dry mix control
- [ ] Add delay/echo
  - DelayNode with feedback
  - Sync to visual blob trails
- [ ] Optional: Low-pass filter on stretched audio
  - Makes it more "ethereal"

### 4.4 Control Panel
**Priority**: MEDIUM | **Estimated Time**: 1-2 hours

- [ ] Minimal UI overlay (top-right corner)
  - Master volume
  - Reverb amount
  - Input gain
  - "Clear all" button (remove all memory blobs)
- [ ] Collapsible/hideable
- [ ] Keyboard shortcuts (space to clear, etc.)

---

## 5. Phase 4: Polish & Integration
**Goal**: Production-ready for Studio integration
**Estimated Time**: 4-6 hours

### 5.1 Performance Optimization
**Priority**: HIGH | **Estimated Time**: 2-3 hours

- [ ] Optimize canvas rendering
  - Use offscreen canvas if needed
  - Reduce draw calls
- [ ] Optimize audio processing
  - Use AudioWorkletNode instead of ScriptProcessorNode
  - Minimize garbage collection
- [ ] Test on different devices/browsers
- [ ] Aim for 60fps with <5% CPU usage

### 5.2 Visual Polish
**Priority**: MEDIUM | **Estimated Time**: 2-3 hours

- [ ] Add motion blur effect
- [ ] Improve blob aesthetics
  - Better gradients
  - Subtle textures
  - Edge softening
- [ ] Particle system for interactions
- [ ] Loading animations
- [ ] Smooth transitions

### 5.3 Studio Integration
**Priority**: CRITICAL | **Estimated Time**: 1-2 hours

- [ ] Test import in main studio app
- [ ] Add to StudioModeSelector.js
  - Card with appropriate icon/description
  - Color: warm red-orange (#e74c3c or #ff6b6b)
- [ ] Add route in pages/index.js
- [ ] Write description text:
  ```
  Title: Chiaroscuro
  Subtitle: Interactive Audio Playground
  Description: Manipulate ethereal soundscapes by shaping
               fluid lava lamp visuals with real-time audio
  ```

### 5.4 Error Handling & UX
**Priority**: HIGH | **Estimated Time**: 1 hour

- [ ] Handle no microphone available
- [ ] Handle audio context blocked (user gesture required)
- [ ] Handle browser incompatibility (Safari quirks)
- [ ] Add helpful tooltips
- [ ] First-time user tutorial (optional overlay)

---

## 6. Future Enhancements
**Post-MVP Features** (prioritized)

### 6.1 Advanced Interactions
- [ ] Pinch/expand gesture (grain size control)
- [ ] Two-finger swirl (modulation)
- [ ] Draw barriers that blobs bounce off
- [ ] "Gravity wells" to attract blobs

### 6.2 Audio Features
- [ ] Multiple input sources
  - Mic input
  - Arco instrument output
  - File upload
  - Line-in input
- [ ] Export functionality
  - Record session to WAV/MP3
  - Export to DAWn_EE
- [ ] MIDI control support
- [ ] Advanced synthesis modes
  - Spectral freezing
  - Convolution with blob shapes
  - Formant shifting

### 6.3 Visual Features
- [ ] Heat map mode (frequency visualization)
- [ ] "Trails" mode (leave persistent traces)
- [ ] Different blob styles (lava, smoke, liquid, plasma)
- [ ] WebGL shader effects
- [ ] 3D mode (Three.js integration)

### 6.4 Sharing & Presets
- [ ] Snapshot feature (save moment as image + audio)
- [ ] Session recording/playback
- [ ] Share configurations via URL params
- [ ] Community preset library

### 6.5 Integration Features
- [ ] Export audio to DAWn_EE for further editing
- [ ] Analyze Chiaroscuro output with Catch
- [ ] Use Arco instruments as input source
- [ ] Sync with DAWn_EE transport controls

---

## 7. Technical Architecture

### 7.1 Component Hierarchy
```
ChiaroscuroSandbox (main export)
├── PermissionGate
│   └── MicrophonePermissionUI
├── ChiaroscuroCanvas
│   ├── BlobRenderer
│   └── ParticleSystem
├── ControlPanel
│   ├── VolumeControl
│   ├── EffectsControls
│   └── ClearButton
└── AudioEngine (not React, pure JS)
    ├── InputBuffer
    ├── GranularSynth
    ├── EffectsChain
    └── OutputMixer
```

### 7.2 Audio Processing Flow
```
Microphone Input
    ↓
MediaStreamSource
    ↓
AnalyserNode (FFT) ──→ Visual Feedback
    ↓
Circular Buffer (5-10s)
    ↓
Granular Synthesizer
    ├── Grain Extraction
    ├── Time Stretching
    ├── Pitch Shifting
    └── Windowing
    ↓
Effects Chain
    ├── Reverb (ConvolverNode)
    ├── Delay (DelayNode)
    └── Filter (BiquadFilterNode)
    ↓
Master Gain
    ↓
Audio Output
```

### 7.3 Performance Targets
- **Frame Rate**: 60 FPS (canvas rendering)
- **Audio Latency**: <50ms (interaction to sound)
- **CPU Usage**: <10% on modern devices
- **Memory**: <100MB for 10-minute session
- **Browser Support**: Chrome 90+, Firefox 88+, Safari 14+, Edge 90+

### 7.4 Key Libraries & APIs
- **React 18**: UI components
- **Web Audio API**: Audio processing
- **Canvas 2D API**: Initial rendering (WebGL later)
- **MediaStream API**: Microphone access
- **AudioWorklet API**: Efficient audio processing (post-MVP)

### 7.5 File Size Estimates
- **ChiaroscuroSandbox.js**: ~200-300 lines
- **AudioEngine.js**: ~300-400 lines
- **BlobPhysics.js**: ~200-300 lines
- **ChiaroscuroCanvas.js**: ~250-350 lines
- **Total**: ~1000-1500 lines for MVP

---

## Implementation Timeline

### Sprint 1: Foundation (Week 1)
- Days 1-2: Repo setup, audio permissions, basic canvas
- Days 3-4: Audio input visualization, blob rendering
- Day 5: Basic physics simulation

**Deliverable**: Single blob that responds to mic input visually

### Sprint 2: Interaction (Week 2)
- Days 1-3: Granular synthesis engine
- Days 4-5: Mouse interaction, drag-to-stretch

**Deliverable**: Working MVP - drag blob to generate stretched sound

### Sprint 3: Features (Week 3)
- Days 1-2: Multiple blobs
- Days 3-4: Memory blob feature
- Day 5: Effects (reverb, delay)

**Deliverable**: Feature-complete alpha version

### Sprint 4: Polish (Week 4)
- Days 1-2: Performance optimization
- Days 3-4: Visual polish, UI refinements
- Day 5: Studio integration, testing

**Deliverable**: Production-ready v1.0

---

## Success Metrics

### MVP Success Criteria
- [ ] User can grant mic permissions smoothly
- [ ] Audio input visualized in real-time (<50ms latency)
- [ ] Drag interaction generates audible stretched sound
- [ ] No audio glitches or dropouts
- [ ] Runs at 60fps on target devices
- [ ] Integrates cleanly into Studio app

### User Experience Goals
- **Intuitive**: No tutorial needed for basic interaction
- **Meditative**: Calming, not overwhelming
- **Responsive**: Immediate visual + audio feedback
- **Stable**: No crashes, glitches, or errors
- **Accessible**: Works on various devices/browsers

### Technical Goals
- **Maintainable**: Clean code, well-documented
- **Modular**: Easy to add features later
- **Performant**: Efficient resource usage
- **Scalable**: Can handle complexity growth

---

## Notes & Considerations

### Design Philosophy
- **Less is more**: Start minimal, add complexity gradually
- **Feel over precision**: Prioritize intuitive interaction
- **Visual-first**: The visuals drive the audio, not vice versa
- **Playful experimentation**: No wrong way to use it

### Potential Challenges
1. **Browser audio latency**: May need device-specific tuning
2. **Mobile performance**: Canvas + audio intensive
3. **Safari Web Audio quirks**: Known issues with AudioContext
4. **Microphone permissions**: Users may deny access

### Risk Mitigation
- Test early and often on target browsers
- Have fallback for denied microphone (use test tone)
- Implement performance monitoring
- Graceful degradation for older browsers

---

## Getting Started

### For Developers

1. **Clone the repository** (once created):
   ```bash
   git clone git@github.com:tree3stan-chord/chiaroscuro.git
   cd chiaroscuro
   npm install
   ```

2. **Run standalone dev server**:
   ```bash
   npm run dev
   ```

3. **Integrate into Studio**:
   ```bash
   cd /home/espadon/src/studio
   git submodule add git@github.com:tree3stan-chord/chiaroscuro.git components/chiaroscuro
   git submodule update --init --recursive
   ```

### Project Conventions
- Use ES6+ features
- Follow existing Studio codebase style
- Comment complex audio/physics algorithms
- Use meaningful variable names
- Keep components under 400 lines

---

## Resources & References

### Audio Processing
- [Web Audio API Documentation](https://developer.mozilla.org/en-US/docs/Web/API/Web_Audio_API)
- [Granular Synthesis Tutorial](https://pbat.ch/wiki/granular_synthesis)
- [Paulstretch Algorithm](https://wiki.audacityteam.org/wiki/Paulstretch)

### Visual Design
- [Lava Lamp Physics Simulation](https://codepen.io/search/pens?q=lava+lamp)
- [Blob Morphing Techniques](https://tympanus.net/codrops/tag/blob/)
- [Metaball Rendering](https://www.paulbourke.net/geometry/metaballs/)

### Inspiration Projects
- [Patatap](https://patatap.com/) - Visual sound toy
- [Tone.js Examples](https://tonejs.github.io/examples/) - Web audio library
- [p5.js Sound Examples](https://p5js.org/examples/sound-oscillator-frequency.html)

---

**Last Updated**: 2025-10-30
**Version**: 1.0
**Maintainer**: tree3stan-chord team
