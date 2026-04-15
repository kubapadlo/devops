// jest.config.mjs
import nextJest from 'next/jest.js'

const createJestConfig = nextJest({
  // Ścieżka do aplikacji Next.js, aby załadować next.config.js i pliki .env
  dir: './',
})

/** @type {import('jest').Config} */
const config = {
  setupFilesAfterEnv: ['<rootDir>/jest.setup.ts'],
  testEnvironment: 'jest-environment-jsdom',
  moduleNameMapper: {
    // Obsługa aliasów (jeśli używasz @/...)
    '^@/(.*)$': '<rootDir>/$1',
  },
}

export default createJestConfig(config)