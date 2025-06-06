# 단비 앱 플로우 요약

## 📋 빠른 참조 가이드

### 🏗️ 앱 아키텍처 요약

```
┌─────────────────────────────────────────────────────────────────┐
│                        단비 앱 아키텍처                          │
├─────────────────────────────────────────────────────────────────┤
│  ┌─────────────┐    ┌─────────────┐    ┌─────────────┐         │
│  │ UI Layer    │    │Service Layer│    │ Data Layer  │         │
│  │             │    │             │    │             │         │
│  │ • Screens   │◄──►│ • AuthService│◄──►│ • Models    │         │
│  │ • Widgets   │    │ • ApiService │    │ • Storage   │         │
│  │ • Themes    │    │ • ThemeService    │ • Cache     │         │
│  └─────────────┘    └─────────────┘    └─────────────┘         │
│                             │                                   │
│                             ▼                                   │
│  ┌─────────────────────────────────────────────────────────────┐│
│  │                    Backend APIs                              ││
│  │  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐          ││
│  │  │  Auth   │ │Question │ │  User   │ │  Stats  │          ││
│  │  │  APIs   │ │  APIs   │ │  APIs   │ │  APIs   │          ││
│  │  └─────────┘ └─────────┘ └─────────┘ └─────────┘          ││
│  └─────────────────────────────────────────────────────────────┘│
└─────────────────────────────────────────────────────────────────┘
```

### 🔐 사용자 인증 플로우

```
앱 시작
   │
   ▼
토큰 확인 ────────┐
   │              │
   ▼              ▼
유효한 토큰?   홈화면(게스트)
   │              │
   ▼              ▼
자동 로그인    로그인/회원가입
   │              │
   ▼              ▼
홈화면(로그인)  5단계 회원가입
                  │
                  ▼
              1. 이메일 입력
              2. 이메일 인증  
              3. 비밀번호 설정
              4. 닉네임 설정
              5. 추가 정보
                  │
                  ▼
              가입 완료
```

### 🏠 메인 기능 플로우

```
홈 화면
├── 🔐 로그인된 사용자
│   ├── ✏️  질문 작성
│   ├── 📋 질문 목록
│   ├── 🤖 AI 채팅
│   ├── 👤 프로필 관리
│   ├── 🏆 랭킹 보기
│   └── 📝 내 질문 관리
│
└── 👤 게스트 사용자
    ├── 📋 질문 목록 (읽기만)
    └── 🔒 로그인 요구
```

### 📊 주요 화면별 기능

| 화면 | 주요 기능 | API 엔드포인트 |
|------|----------|---------------|
| 🏠 홈 화면 | 대시보드, 통계, 배너 | `GET /stats/*` |
| 📝 질문 목록 | 질문 조회, 필터링, 검색 | `GET /questions` |
| 📋 질문 상세 | 답변 조회, 작성, 채택 | `GET /questions/{id}` |
| ✏️ 질문 작성 | 새 질문 등록 | `POST /questions` |
| 👤 프로필 | 정보 수정, 인증, 설정 | `GET/PUT /users/profile` |
| 🔐 로그인 | JWT 인증 | `POST /auth/login` |
| 📝 회원가입 | 5단계 등록 프로세스 | `POST /auth/register` |

### 🎯 핵심 사용자 여정

#### 1️⃣ 질문하기 여정
```
로그인 → 질문 작성 → 제목/내용 입력 → 카테고리 선택 → 등록 → 목록으로 이동
```

#### 2️⃣ 답변하기 여정  
```
질문 목록 → 질문 선택 → 상세 보기 → 답변 작성 → 등록 → 알림 표시
```

#### 3️⃣ 답변 채택 여정
```
내 질문 → 질문 상세 → 답변 더블탭 → 채택 확인 → UI 업데이트 → 토스트 알림
```

#### 4️⃣ 회원가입 여정
```
이메일 입력 → 인증번호 확인 → 비밀번호 설정 → 닉네임 설정 → 추가정보 → 완료
```

### 🔄 데이터 흐름

```
사용자 액션
    │
    ▼
UI 컴포넌트
    │
    ▼
Service Layer ◄─────► Local Storage
    │                      │
    ▼                      ▼
Backend API           SecureStorage
    │                 (JWT 토큰)
    ▼
JSON 응답
    │
    ▼
Model 파싱
    │
    ▼
UI 업데이트
```

### 🛡️ 보안 아키텍처

```
┌─────────────────────────────────────────────┐
│              JWT 토큰 라이프사이클            │
├─────────────────────────────────────────────┤
│                                             │
│ 로그인 → 토큰 발급 → 안전한 저장             │
│                          │                  │
│                          ▼                  │
│ API 요청 ←─── 토큰 자동 첨부                 │
│    │                                        │
│    ▼                                        │
│ 토큰 검증 ──┐                               │
│             │                               │
│    ┌────────▼─────────┐                     │
│    │ 유효? │ 만료?     │                     │
│    └─┬─────┴─────┬───┘                     │
│      │           │                         │
│      ▼           ▼                         │
│   계속 진행   토큰 갱신                      │
│              (또는 로그아웃)                 │
└─────────────────────────────────────────────┘
```

### 📱 UI/UX 패턴

#### 테마 시스템
- 🌞 라이트 모드 / 🌙 다크 모드
- 동적 색상 변경
- 사용자 설정 저장

#### 네비게이션 패턴
- 📱 iOS 스타일 네비게이션
- 🍔 햄버거 메뉴 (Drawer)
- 🔄 뒤로 가기 일관성

#### 입력 검증
- ✅ 실시간 유효성 검사
- 🚨 사용자 친화적 오류 메시지
- 💡 도움말 텍스트

### 🚀 성능 최적화

```
┌─────────────────────────────────────────────┐
│               성능 최적화 전략                │
├─────────────────────────────────────────────┤
│                                             │
│ ┌─────────────┐    ┌─────────────┐         │
│ │  클라이언트  │    │   서버      │         │
│ │             │    │             │         │
│ │ • 로컬 캐싱  │◄──►│ • 페이지네이션│         │
│ │ • 이미지 캐싱│    │ • 압축 응답  │         │
│ │ • 상태 관리 │    │ • CDN 사용   │         │
│ │ • 지연 로딩 │    │ • 인덱싱     │         │
│ └─────────────┘    └─────────────┘         │
└─────────────────────────────────────────────┘
```

### 📊 핵심 메트릭스

| 항목 | 현재 상태 | 목표 |
|------|----------|------|
| 🚀 앱 로딩 시간 | < 3초 | < 2초 |
| 📱 화면 전환 | < 300ms | < 200ms |
| 🔄 API 응답 시간 | < 500ms | < 300ms |
| 💾 메모리 사용량 | < 100MB | < 80MB |
| 🔋 배터리 효율성 | 양호 | 우수 |

### 🛠️ 개발 도구 및 라이브러리

#### 주요 의존성
```yaml
dependencies:
  flutter: sdk
  cupertino_icons: ^1.0.8
  http: ^1.1.0
  shared_preferences: ^2.2.2
  image_picker: ^1.0.4
  dio: ^5.3.2
  flutter_secure_storage: ^9.0.0
  cached_network_image: ^3.3.0
  intl: ^0.19.0
  uuid: ^4.2.1
```

#### 개발 환경
- 🎯 Flutter 3.29.3
- 🎯 Dart 3.4.4+
- 📱 iOS 16.0+
- 🤖 Android API 21+
- 🔧 VS Code + Flutter Extension

### 📁 파일 구조 요약

```
lib/
├── 🚀 main.dart
├── 📱 screens/
│   ├── home_screen.dart
│   ├── login_screen.dart
│   ├── signup_*.dart
│   └── profile_*.dart
├── 🛠️ services/
│   ├── auth_service.dart
│   ├── api_service.dart
│   └── storage_service.dart
├── 📊 models/
│   ├── user.dart
│   ├── question.dart
│   └── api_response.dart
├── 🎨 theme/
│   └── app_theme.dart
└── 🧩 widgets/
    ├── common/
    └── home/
```

이 요약 문서는 개발팀이 빠르게 참조할 수 있는 단비 앱의 전체적인 구조와 플로우를 정리한 것입니다. 