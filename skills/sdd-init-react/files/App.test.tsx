import { render, screen } from '@testing-library/react';
import { describe, expect, it } from 'vitest';
import { App } from './App';

// 앱이 import·렌더링되고 첫 화면 제목이 보이는지 확인하는 스모크 테스트.
describe('App', () => {
  it('첫 화면이 렌더링된다', () => {
    render(<App />);
    expect(screen.getByRole('heading', { level: 1 })).toBeInTheDocument();
  });
});
