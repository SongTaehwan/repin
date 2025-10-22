# Repin - GitHub Repository 북마크 앱

Flutter + GetX로 구현한 GitHub Repository 검색 및 북마크 관리 앱

## 주요 기능

- **검색**: 디바운스(300ms) + 무한 스크롤, Link 헤더 기반 페이징
- **북마크**: Hive 로컬 저장, 최신순 정렬
- **iOS 위젯**: 마지막 북마크를 홈 위젯에 동기화
- **안정성**: dio 재시도(최대 4회) + 1초 캐시 윈도우

## 기술 스택

### 아키텍처

- **상태관리/라우팅**: GetX (화면 스코프)
- **DI**: get_it/injectable (싱글턴), GetX (Controller)
- **에러처리**: fpdart Either<Failure, T> 타입 기반 명시적 전파

### 핵심 라이브러리

- **네트워크**: retrofit + dio (재시도/캐싱)
- **로컬DB**: hive_flutter
- **직렬화**: freezed + json_serializable
- **위젯**: home_widget (iOS)

### 레이어 구조

```
View → Controller → Service → Repository → Provider (Retrofit/Hive)
                       ↓            ↓              ↓
                  비즈니스 로직  도메인 변환    HTTP/DB I/O
```

## 디렉토리 구조

```text
lib/
  app/
    core/
      constant/           # 상수(페이징 스로틀, 스크롤 오프셋 등)
      debug/              # 라우트 스택 관찰자
      errors/             # Failure 도메인 에러
      utils/
        api/              # dio 클라이언트, 캐시/재시도 인터셉터
        helpers/          # DI 초기화, 위젯 동기화 유틸 등
    data/
      provider/           # Retrofit Provider + DTO
      repository/         # Repository 구현(페이징/도메인 모델 매핑/에러 변환)
      services/           # 비즈니스 로직 서비스(Search/Bookmark)
      model/              # 도메인 모델(Freezed)
    modules/
      repository_search/  # 검색 화면 (binding/controller/view)
      repository_bookmark/# 북마크 화면 (binding/controller/view)
      app_container/      # 탭 컨테이너 및 Nested Router
    routes/               # GetX 라우팅 정의
    shared/widgets/       # 공용 위젯(리스트 아이템 등)
bootstrap.dart            # 전역 에러/DI/런타임 초기화
main.dart                 # 엔트리 포인트
```

## 개발 환경

- Flutter 3.32.8 / Ruby 3.4.3 / Xcode 16.4.0

### 명령어

```bash
make build_runner  # 코드 생성
```

## 핵심 설계 결정

| 주제     | 선택                           | 이유                           |
| -------- | ------------------------------ | ------------------------------ |
| 아키텍처 | GetX + Clean Architecture 절충 | 생산성 유지 + 레이어 분리      |
| HTTP     | Retrofit                       | 강타입 + 테스트 용이성         |
| 에러처리 | Either<Failure, T>             | 타입 안전 + 호출자 책임 명확화 |
| 페이징   | Link 헤더 파싱                 | API 변경 대응력                |
| DI       | get_it(인프라) + GetX(화면)    | 역할별 DI 분리                 |

## 개선 계획

- [ ] Failure 타입 세분화 + 사용자 친화적 에러 UI
- [ ] Flavor 환경 분리
- [ ] ETag 기반 캐시 최적화
- [ ] 테스트 코드 작성
- [ ] Android 위젯 지원
