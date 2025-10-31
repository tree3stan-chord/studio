'use client';

import { useState, useEffect } from 'react';
import dynamic from 'next/dynamic';
import Head from 'next/head';
import { Button, Container } from 'react-bootstrap';
import { IoArrowBack } from 'react-icons/io5';
import DAW from '../components/daw';
import { DAWProvider, useAudio, useUI } from '../contexts/DAWProvider';
import InstrumentSandbox from '../components/arco/InstrumentSandbox';

// Dynamically import SilenceSandbox to avoid SSR issues with FFmpeg
const SilenceSandbox = dynamic(
  () => import('../components/silence/SilenceSandbox'),
  { ssr: false }
);

// Dynamically import ChiaroscuroSandbox to avoid SSR issues with Web Audio API
const ChiaroscuroSandbox = dynamic(
  () => import('../components/chiaroscuro/ChiaroscuroSandbox'),
  { ssr: false }
);

// Dynamically import the modal to avoid SSR issues
const StudioModeSelector = dynamic(
  () => import('../components/StudioModeSelector'),
  { ssr: false }
);

// Component that initializes DAW in multitrack mode
const StudioDAW = () => {
  const { setDawMode } = useAudio();
  const { setShowDAW } = useUI();

  useEffect(() => {
    // Set multitrack as default mode
    setDawMode('multi');
    // Show the DAW
    setShowDAW(true);
  }, [setDawMode, setShowDAW]);

  return <DAW />;
};

export default function Studio() {
  const [selectedMode, setSelectedMode] = useState(null);
  const [mounted, setMounted] = useState(false);

  useEffect(() => {
    setMounted(true);
  }, []);

  const handleSelectMode = (mode) => {
    setSelectedMode(mode);
  };

  const handleBackToStudio = () => {
    setSelectedMode(null);
  };

  return (
    <>
      <Head>
        <title>Studio - Audio Production Suite</title>
        <meta name="description" content="Professional audio production tools - DAWn_EE, Arco, Catch, and Chiaroscuro" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      {/* Chiaroscuro gets full screen treatment */}
      {selectedMode === 'chiaroscuro' ? (
        <>
          <Button
            variant="outline-light"
            size="sm"
            onClick={handleBackToStudio}
            style={{
              position: 'fixed',
              top: '1rem',
              left: '1rem',
              zIndex: 2000,
              background: 'rgba(20, 20, 30, 0.8)',
              backdropFilter: 'blur(10px)',
              border: 'none'
            }}
            className="d-flex align-items-center gap-2"
          >
            <IoArrowBack />
            Back to Studio
          </Button>
          <ChiaroscuroSandbox />
        </>
      ) : (
        <Container fluid className="studio-container p-4">
          {/* Back button when a mode is selected */}
          {selectedMode && (
            <Button
              variant="outline-secondary"
              size="sm"
              onClick={handleBackToStudio}
              className="mb-3 d-flex align-items-center gap-2"
            >
              <IoArrowBack />
              Back to Studio
            </Button>
          )}

        {/* Mode selector modal - only render on client side */}
        {mounted && (
          <StudioModeSelector
            show={!selectedMode}
            onSelectMode={handleSelectMode}
          />
        )}

        {/* Show loading state before mount */}
        {!mounted && !selectedMode && (
          <div className="text-center mt-5">
            <div className="spinner-border text-primary" role="status">
              <span className="visually-hidden">Loading...</span>
            </div>
          </div>
        )}

        {/* Render selected mode */}
        {selectedMode === 'daw' && (
          <>
            <h1 className="mb-3">DAWn_EE</h1>
            <p className="text-muted mb-4">
              Digital Audio Workstation - Multitrack editing and audio production
            </p>
            <DAWProvider>
              <StudioDAW />
            </DAWProvider>
          </>
        )}

        {selectedMode === 'silence-sandbox' && (
          <>
            <h1 className="mb-3">Catch</h1>
            <p className="text-muted mb-4">
              Analyze audio files for silence detection
            </p>
            <SilenceSandbox />
          </>
        )}

        {selectedMode === 'arco' && (
          <>
            <h1 className="mb-3">Arco</h1>
            <p className="text-muted mb-4">
              Design and test custom virtual instruments
            </p>
            <InstrumentSandbox />
          </>
        )}

        </Container>
      )}
    </>
  );
}
