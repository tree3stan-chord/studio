'use client';

import { useEffect } from 'react';
import Head from 'next/head';
import { Container } from 'react-bootstrap';
import DAW from '../components/daw';
import { DAWProvider, useAudio, useUI } from '../contexts/DAWProvider';

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

export default function DAWPage() {
  return (
    <>
      <Head>
        <title>DAWn_EE - Digital Audio Workstation</title>
        <meta name="description" content="Multi-track audio editor and production tool" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Container fluid className="p-4">
        <h1 className="mb-3">DAWn_EE</h1>
        <p className="text-muted mb-4">
          Digital Audio Workstation - Multitrack editing and audio production
        </p>
        <DAWProvider>
          <StudioDAW />
        </DAWProvider>
      </Container>
    </>
  );
}
