/** 에러 항목 하나: 식별자와 사용자에게 보여 줄 문구. */
export type ErrorDetail = {
  code: string;
  message: string;
};

/**
 * 예상한 에러 목록. 기능 spec의 에러 케이스마다 항목을 추가한다.
 * (`erasableSyntaxOnly` 설정 때문에 enum 대신 `as const` 객체를 쓴다)
 */
export const ErrorCode = {
  UNKNOWN_ERROR: {
    code: 'unknown_error',
    message: '알 수 없는 오류가 발생했어요. 잠시 후 다시 시도해 주세요.',
  },
} as const satisfies Record<string, ErrorDetail>;

/** 예상한 에러. `throw new AppError(ErrorCode.XXX)`로 던진다. */
export class AppError extends Error {
  readonly code: string;

  constructor(detail: ErrorDetail, options?: { cause?: unknown }) {
    super(detail.message, options);
    this.name = 'AppError';
    this.code = detail.code;
  }
}

/** 값이 AppError인지 확인한다(hook에서 catch한 값을 좁힐 때 쓴다). */
export function isAppError(value: unknown): value is AppError {
  return value instanceof AppError;
}
