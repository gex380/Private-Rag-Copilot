/** @type {import('next').NextConfig} */
const nextConfig = {
  reactStrictMode: true,
  swcMinify: true,

  // Environment variables exposed to the browser
  env: {
    NEXT_PUBLIC_APP_NAME: process.env.NEXT_PUBLIC_APP_NAME || 'Private RAG Copilot',
    NEXT_PUBLIC_APP_VERSION: process.env.NEXT_PUBLIC_APP_VERSION || '1.0.0',
  },

  // Image optimization configuration
  images: {
    domains: [], // Add domains for external images if needed
  },

  // Webpack configuration (if needed for custom loaders)
  webpack: (config) => {
    return config;
  },
};

module.exports = nextConfig;
