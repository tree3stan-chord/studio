import Head from 'next/head';
import InstrumentSandbox from '../components/arco/InstrumentSandbox';

export default function ArcoPage() {
  return (
    <>
      <Head>
        <title>Arco - Virtual Instrument Designer</title>
        <meta name="description" content="Create and design custom virtual instruments with Arco" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
        <link rel="icon" href="/favicon.ico" />
      </Head>
      <main>
        <InstrumentSandbox />
      </main>
    </>
  );
}
