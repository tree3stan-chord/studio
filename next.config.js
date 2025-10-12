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
}

module.exports = nextConfig
