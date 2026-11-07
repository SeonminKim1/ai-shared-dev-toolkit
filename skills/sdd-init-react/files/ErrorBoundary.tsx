import { Component, type ErrorInfo, type ReactNode } from 'react';
import { ErrorCode } from '../errors/AppError';

type ErrorBoundaryProps = {
  children: ReactNode;
};

type ErrorBoundaryState = {
  hasError: boolean;
};

/** 예상하지 못한 렌더링 에러를 받아 공통 에러 화면을 보여 준다. App 최상위에 하나만 둔다. */
export class ErrorBoundary extends Component<
  ErrorBoundaryProps,
  ErrorBoundaryState
> {
  state: ErrorBoundaryState = { hasError: false };

  static getDerivedStateFromError(): ErrorBoundaryState {
    return { hasError: true };
  }

  componentDidCatch(error: Error, info: ErrorInfo): void {
    // 원인 추적용 로그. 에러 수집 도구를 붙이면 여기서 보낸다.
    console.error(error, info.componentStack);
  }

  render(): ReactNode {
    if (this.state.hasError) {
      return (
        <main role="alert">
          <p>{ErrorCode.UNKNOWN_ERROR.message}</p>
          <button type="button" onClick={() => window.location.reload()}>
            다시 시도
          </button>
        </main>
      );
    }
    return this.props.children;
  }
}
