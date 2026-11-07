import type { ReactElement } from 'react';
import { ErrorBoundary } from './components/ErrorBoundary';
import { HomePage } from './pages/HomePage';

/** 앱 루트: 최상위 ErrorBoundary 아래에 화면을 둔다. 라우팅·Provider는 여기에 등록한다. */
export function App(): ReactElement {
  return (
    <ErrorBoundary>
      <HomePage />
    </ErrorBoundary>
  );
}
