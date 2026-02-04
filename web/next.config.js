/** @type {import('next').NextConfig} */
const nextConfig = {
  devIndicators: {
    buildActivity: false,
    appIsrStatus: false,
  },
  // Desabilitar overlay de erros também
  reactStrictMode: false,
}

module.exports = nextConfig
