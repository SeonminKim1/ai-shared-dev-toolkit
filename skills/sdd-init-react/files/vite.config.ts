import react from '@vitejs/plugin-react';
import { defineConfig } from 'vitest/config';

// Vite 설정. vitest/config의 defineConfig를 써서 테스트 설정도 같은 파일에 둔다.
export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
  },
});
