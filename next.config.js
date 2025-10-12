/** @type {import('next').NextConfig} */
const nextConfig = {
  output: 'export',
  reactStrictMode: true,
  // Allow audio files and other assets
  webpack: (config) => {
    config.module.rules.push({
      test: /\.(mp3|wav|ogg|flac)$/,
      type: 'asset/resource',
    });
    return config;
  },
  // Add CSP headers to allow blob: URLs for audio processing
  async headers() {
    return [
      {
        source: '/:path*',
        headers: [
          {
            key: 'Content-Security-Policy',
            value: [
              "default-src 'self'",
              "script-src 'self' 'unsafe-eval' 'unsafe-inline'",
              "style-src 'self' 'unsafe-inline'",
              "img-src 'self' data: blob:",
              "media-src 'self' blob: data:",
              "connect-src 'self' blob: data: https://unpkg.com",
              "worker-src 'self' blob:",
              "child-src 'self' blob:",
              "font-src 'self' data:",
            ].join('; '),
          },
        ],
      },
    ];
  },
}

module.exports = nextConfig
