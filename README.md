## 기능
- 검색: GitHub Repository 검색, 300ms 디바운스 적용, 최초/다음 페이지 분리 로딩, 결과 없을 때 사용자 피드백 표시
- 페이징: GitHub Link 헤더 파싱을 통한 `hasMore` 판단과 무한 스크롤, 800ms 스로틀로 과도한 호출 방지
- 북마크: `Hive` 기반 로컬 즐겨찾기 저장/해제, 최신 업데이트 순 정렬, 전체/마지막 항목 조회
- 위젯 동기화: `home_widget`으로 iOS 위젯에 마지막 북마크 1건 동기화
- 네트워크 안정화: `dio` 재시도(최대 4회, 2s backoff)와 1초 캐시 윈도우 기반의 초단기 캐싱
- 에러 처리: `Failure` 도메인 에러 모델과 `Either`(fpdart)로 명시적 에러 전파, 전역 미처리 예외 핸들링(bootstrap)

## 설계
1. 설계 채택 이유
- **GetX + get_it/injectable 혼합 DI**: 화면 생명주기/스코프는 GetX, 싱글턴·인프라 레이어는 get_it로 분리하여 유연하고 테스트 가능한 구조 확보
- **Repository/Service 분리**: Provider의 I/O·DTO를 Repository에서 도메인 모델로 변환하고, Service는 정책·흐름·정렬 등 비즈니스 로직만 담당
- **명시적 에러 모델(Failure) + Either**: 예외 남발 대신 타입으로 에러를 반영해 호출자가 처리 책임을 명확히 가짐
- **확장 가능한 페이징**: Link 헤더 파싱으로 GitHub API 변화에 둔감하며, `hasMore` 캐싱으로 View의 조건 분기 단순화

2. 설계
- **UI**
  - View
  - GetX Controller
- **Domain**
  - Service
  - Repository
- **Data**
  - Provider (Retrofit)
  - Hive Box
- **Infra**
  - dio + cache + retry
  - get_it / injectable
- **흐름**
  - View → Controller → Service → Repository → Provider(HTTP/Hive) → 서버/로컬 DB
  - 서버/로컬 DB → Repository → Domain Model → Service → Controller → View
- **의존성 연결**
  - Provider ↔ Dio (클라이언트)
  - get_it/injectable → Service / Repository / Provider (구성 및 주입)

3. 각 역할 정의 설명
- **Provider**: Retrofit 인터페이스(`GithubProvider`)로 GitHub REST 호출과 DTO 수신 담당
- **Repository**: DTO → 도메인 모델 매핑, Link 헤더 파싱, 페이징 커서 보관, 데이터 소스 오류를 `Failure`로 변환
- **Service**: 로딩 흐름·정책(예: 최신 업데이트순 정렬)·다중 Repository 조합을 포함한 비즈니스 로직 담당
- **Controller(GetX)**: 디바운스/스로틀·상태 관리·스크롤 이벤트 해석 등 화면 의사결정 로직 담당(뷰는 상태만 구독)
- **View**: 순수 UI, GetX 상태 구독 및 사용자 입력 전달만 수행
- **DI**: `get_it`(싱글턴/SDK/Provider), `GetX`(Controller 스코프)로 역할 분리 주입

get_it → 싱글톤·인프라 객체 주입, GetX → 화면 스코프 Controller 주입

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
- flutter: 3.32.8 버전
- ruby: 3.4.3 버전
- Xcode: 16.4.0 버전
- Cursor AI - 사용 프롬프트는 .cursorrules 참고 바랍니다.
### 사용 라이브러리
---
- **get**: 화면 상태 관리 및 라우팅/DI 스코프
- **get_it, injectable**: 인프라/도메인 싱글턴 DI 및 코드 생성 기반 구성
- **retrofit, dio**: 타입 안정적인 HTTP 인터페이스와 커스터마이즈 가능한 클라이언트
- **dio_cache_interceptor(_hive_store)**: 1초 이내 동일 요청 캐시 응답 단축(초단기 캐시)
- **pretty_dio_logger**: 디버그 네트워크 로깅
- **hive, hive_flutter**: 로컬 북마크 저장소
- **freezed, json_serializable**: 도메인 모델/DTO 불변 객체 및 직렬화
- **fpdart**: `Either`를 통한 명시적 에러 전파와 합성
- **home_widget**: 마지막 북마크를 iOS 위젯으로 동기화

코드 생성 명령어 예시:
```bash
make build_runner
```

## 협업 도구
- **import_path_converter**: 절대 경로 import 일관화
- **import_sorter**: import 그룹/정렬 규칙 자동화
- **get-cli**: 모듈 스캐폴딩(예: binding/controller/view) 가속

## 고민점
1. Clean Architecture vs. GetX Pattern
    - 레이어를 얇고 명확히 유지하면서도 GetX의 생산성을 취함. 도메인 규칙은 Service/Repository로 격리하고, Controller에는 화면 의사결정만 둠.
2. GetConnect vs. Retrofi
    -  강 타입 인터페이스, `build_runner` 기반 스키마 일관성, 테스트 용이성 측면에서 Retrofit을 선택.
3. Either vs. try-catch
    - 호출자에 에러 처리를 강제하고 조합 가능한 에러 흐름을 선호하여 `Either<Failure, T>` 채택.
4. DI 위치(bootstrap vs. binding)
    - 인프라/싱글턴은 `bootstrap`에서 선초기화, 화면 스코프는 각 `binding`에서 지연 주입.
5. 페이징 전략
    - 서버 응답 Link 헤더 존중, `hasMore`를 Service/Repository에서 계산하여 View 분기 최소화.

## 개선해야할 점
- 네트워크 에러 케이스에 따라 Failure 타입 세분화 및 사용자 친화적 UI 안내
- flavor 를 추가해 환경 세분화
- Repository 캐싱 전략 추가
- API 캐시 정책 고도화(ETag/If-None-Match)
- 기능 고도화에 따른 Service 객체에 비즈니스 로직 추가
- 테스트 코드 작성

- Android home widget 지원
- Log 수집
- View Tree 리펙토링

## 프로젝트 후기
- 설계와 객체 역할을 명확히 정의한 상태에서 AI 툴을 활용하니 반복 작업 자동화와 맥락 유지가 쉬워져 전반적인 개발 생산성이 크게 향상됨
   - 기능 개발 속도 향상: 약 40~50% (초기 화면 레이아웃, 상태/DI 구성, 리팩토링 제안 반영 등)
- 작은 범위에서도 레이어 분리의 이점을 체감: 테스트 용이성, 교체 가능성(예: Provider 교체) 확보
- 컨트롤러에 화면 의사결정을 몰고(View는 단순 구독) 성능/가독성 모두 개선
- dio 재시도/캐시의 체감 성능 향상 효과가 큼(특히 입력 디바운스와 결합 시)
