import Head from 'next/head';
import dynamic from 'next/dynamic';
import { Container } from 'react-bootstrap';

// Dynamically import SilenceSandbox to avoid SSR issues with FFmpeg
const SilenceSandbox = dynamic(
  () => import('../components/silence/SilenceSandbox'),
  { ssr: false }
);

export default function SilencePage() {
  return (
    <>
      <Head>
        <title>Silence Sandbox - Audio Analysis Tool</title>
        <meta name="description" content="Detect and analyze silence in audio files" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>

      <Container fluid className="p-4">
        <h1 className="mb-3">Silence Sandbox</h1>
        <p className="text-muted mb-4">
          Analyze audio files for silence detection
        </p>
        <SilenceSandbox />
      </Container>
    </>
  );
}
