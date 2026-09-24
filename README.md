# 지금 거신 번호는

세로형 텍스트 FMV 연애 게임. 아이폰 사파리와 홈 화면 웹앱(PWA)에서 플레이한다. 기획·설정 문서는 [`docs/`](docs/00_README.md)에 있다.

- 플레이: https://kingjnu-sakayume.github.io/game1/

## 배포 설정 (최초 1회)

GitHub 레포 **Settings → Pages → Source를 "GitHub Actions"로** 바꾼다. 이후 `main`에 push하면 자동 배포된다.

## 로컬 실행

```bash
npm install
npm run dev      # 개발 서버
npm run build    # 타입 검사 + 프로덕션 빌드 (dist/)
npm run preview  # 빌드 결과 미리보기 (http://localhost:4173/game1/)
npm run icons    # 임시 앱 아이콘(public/icons/*.png) 다시 생성
```

## 의존성

| 패키지 | 이유 |
|---|---|
| react, react-dom | 화면 구성 |
| vite, @vitejs/plugin-react | 개발 서버·빌드 |
| typescript, @types/react, @types/react-dom | 타입 검사 |
| lucide-react | 앱·UI 아이콘 |
| vite-plugin-pwa | manifest·서비스워커 생성 (홈 화면 추가, 오프라인 캐시) |
