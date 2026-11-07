import react from '@vitejs/plugin-react';
import { defineConfig } from 'vitest/config';

// Vite 설정. vitest/config의 defineConfig를 써서 테스트 설정도 같은 파일에 둔다.
export default defineConfig({
  plugins: [react()],
  test: {
    environment: 'jsdom',
    setupFiles: ['./src/test/setup.ts'],
    // .claude/(서브모듈)의 템플릿 테스트 파일을 잡지 않도록 대상 폴더를 한정한다.
    include: ['src/**/*.test.{ts,tsx}', 'scripts/**/*.test.ts'],
  },
});
