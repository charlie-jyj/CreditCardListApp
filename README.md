## 신용카드 추천 리스트 만들기
> Firebase Realtime Database 사용하기

### 1) 구현기능
- Firebase Realtime DB 사용하여 데이터 Retrieve

### 2) 기본 개념

#### (1) Database
- 데이터의 집합체
- 일반적으로 관계형 데이터베이스 형태

#### (2) Firebase Realtime Database
- NOSQL
- 비관계형 클라우드 데이터베이스
- 대량 데이터 수집 관리에 적합
- 하나의 큰 JSON 트리
    - 최대 32 단계 데이터 중첩 허용
    - 데이터 평면화 권장
    - 쿼리 성능 때문에
- 실시간 작동 (HTTP 요청 아님)
- 오프라인
    - 로컬에 저장 후 네트워크 연결 시 동기화
- 서버없이 데이터베이스와 클라이언트 직접 액세스
- 정렬 || 필터
- 깊고 좁은 쿼리 (하위 json에 접근 가능)

<img src=“https://www.ficode.co.uk/wp-content/uploads/2020/01/firebaseblog.png”>

#### (3) Cloud Firestore
- 비관계형 클라우드 데이터 베이스
- 실시간 동기화 
- 오프라인
- 서버Less
- 고급 쿼리 지원
- 문서와 컬렉션 조합
- 정렬 && 필터
- 얇고 넓은 쿼리 (하위 문서, 컬렉션 접근 X)

=> 데이터 모델이 다르므로 취사선택 

| RealtimeDatabase | CloudFireStore |
| --------------------- | ------------------ |
| 기본적인 데이터 동기화 | 고급쿼리, 정렬,트랜젝션 |
| 적은양의 데이터가 자주 변경 | 대용량 데이터가 자주 읽힘 |
| 간단한 JSON 트리 | 구조화된 컬렉션 |
| 많은 데이터베이스 | 단일 데이터 베이스 |
