# 물리적 설계
## 내부 스키마(테이블 형태)
### 직원

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 직원번호 | employee_id | CHAR | 4 | N | PK, UQ | 직원 식별번호, 유일한 값 |
| 이름 | name | VARCHAR | 20 | N |  | 직원 이름 |
| 연락처 | phone | CHAR | 13 | N | UQ | 직원 연락처, 유일한 값 |
| 역할 | role | VARCHAR | 20 | N |  | `판매 담당자`, `매입 담당자`, `차량관리사`, `사후관리담당자` 중 하나 |

### 고객

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 고객번호 | customer_id | CHAR | 5 | N | PK, UQ | `CU` + 숫자 3자리 형식, 유일한 값 |
| 이름 | name | VARCHAR | 20 | N |  | 고객 이름 |
| 주민번호 | resident_number | CHAR | 14 | N | UQ | `######-#*******` 형식, 중복 불가 |
| 연락처 | phone | CHAR | 13 | N |  | `XXX-XXXX-XXXX` 형식 |
| 주소 | address | VARCHAR | 100 | N |  | 고객 주소 |

### 차량

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 차량식별번호 | vehicle_id | CHAR | 5 | N | PK, UQ | `V` + 숫자 4자리 형식, 유일한 값 |
| 차량번호 | license_plate | VARCHAR | 10 | N | UQ | 실제 차량번호, 중복 불가 |
| 직원번호 | employee_id | CHAR | 4 | N | FK | 직원(직원번호) 참조 |
| 모델명 | model_name | VARCHAR | 30 | N |  | 차량 모델명 |
| 연식 | model_year | INT | - | N |  | 차량 연식 |
| 차량상태 | vehicle_status | VARCHAR | 10 | N |  | `판매중`, `예약중`, `판매완료` 중 하나 |
| 매입가 | purchase_price | INT UNSIGNED | - | N |  | 0 이상의 원화 금액 |
| 판매가 | sale_price | INT UNSIGNED | - | N |  | 0 이상의 원화 금액 |
| 매물등록일 | listing_date | DATE | - | N |  | 매물 등록일 |
| 판매일 | sold_date | DATE | - | Y |  | 판매 전이면 NULL |
| 작업일 | work_date | DATE | - | Y |  | 상품화 또는 정비 작업일 |
| 부대비용 | additional_cost | INT UNSIGNED | - | N |  | 0 이상의 원화 금액 |
| 작업명 | work_name | VARCHAR | 30 | Y |  | 상품화 또는 정비 작업명 |
| 정비항목 | maintenance_item | VARCHAR | 20 | Y |  | `점검`, `정비`, `세차`, `광택`, `소모품 교체` 중 하나 |
| 진행상태 | progress_status | VARCHAR | 10 | Y |  | `등록`, `진행중`, `완료` 중 하나 |

### 차량작업

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 작업번호 | work_id | CHAR | 5 | N | PK | `W` + 숫자 4자리 형식 |
| 차량식별번호 | vehicle_id | CHAR | 5 | N | FK | 차량(차량식별번호) 참조 |
| 작업일 | work_date | DATE | - | Y |  | 상품화 또는 정비 작업일 |
| 부대비용 | additional_cost | INT UNSIGNED | - | N |  | 0 이상의 원화 금액 |
| 작업명 | work_name | VARCHAR | 30 | Y |  | 상품화 또는 정비 작업명 |
| 정비항목 | maintenance_item | VARCHAR | 20 | Y |  | `점검`, `정비`, `세차`, `광택`, `소모품 교체` 중 하나 |
| 진행상태 | progress_status | VARCHAR | 10 | Y |  | `등록`, `진행중`, `완료` 중 하나 |

### 판매계약

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 계약번호 | contract_id | CHAR | 5 | N | PK | `C` + 숫자 4자리 형식 |
| 차량식별번호 | vehicle_id | CHAR | 5 | N | FK | 차량(차량식별번호) 참조 |
| 고객번호 | customer_id | CHAR | 5 | N | FK | 고객(고객번호) 참조 |
| 직원번호 | employee_id | CHAR | 4 | N | FK | 직원(직원번호) 참조 |
| 계약(구매)일 | contract_date | DATE | - | N |  | 계약 또는 구매 발생일 |
| 계약금액 | contract_amount | INT UNSIGNED | - | N |  | 0 이상의 원화 금액 |
| 판매방식 | payment_method | VARCHAR | 10 | N |  | `현금`, `카드`, `할부` 중 하나 |
| 인도완료여부 | delivery_completed | CHAR | 1 | N |  | `Y` 또는 `N` |
| 인도일 | delivery_date | DATE | - | Y |  | 인도 전이면 NULL |
| 예약일 | reservation_date | DATE | - | Y |  | 예약이 없으면 NULL |
| 예약상태 | reservation_status | VARCHAR | 10 | N |  | `진행중`, `완료`, `취소` 중 하나 |

### 사후처리

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 처리번호 | service_id | CHAR | 5 | N | PK | `P` + 숫자 4자리 형식 |
| 차량식별번호 | vehicle_id | CHAR | 5 | N | FK | 차량(차량식별번호) 참조 |
| 고객번호 | customer_id | CHAR | 5 | N | FK | 고객(고객번호) 참조 |
| 직원번호 | employee_id | CHAR | 4 | N | FK | 직원(직원번호) 참조 |
| 처리유형 | service_type | VARCHAR | 10 | Y |  | `보증`, `A/S`, `클레임` 중 하나 |
| 요청일 | request_date | DATE | - | Y |  | 처리 요청일 |
| 처리일 | process_date | DATE | - | Y |  | 처리 완료 전이면 NULL |
| 처리내용 | service_content | VARCHAR | 100 | Y |  | 처리 요청 또는 결과 내용 |
| 처리상태 | service_status | VARCHAR | 10 | Y |  | `접수`, `처리중`, `처리완료` 중 하나 |
| 보증기간 | warranty_period | VARCHAR | 10 | Y |  | 보증 없음이면 NULL |

### 관리하다

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 직원번호 | employee_id | CHAR | 4 | N | PK, FK | 직원(직원번호) 참조 |
| 차량식별번호 | vehicle_id | CHAR | 5 | N | PK, FK | 차량(차량식별번호) 참조 |

### 처리하다

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 직원번호 | employee_id | CHAR | 4 | N | PK, FK | 직원(직원번호) 참조 |
| 처리번호 | service_id | CHAR | 5 | N | PK, FK | 사후처리(처리번호) 참조 |

### 사후처리보증항목

| 속성 | 컬럼 이름 | 데이터 타입 | 크기 | NULL 허용 | 키 | 기타 |
| --- | --- | --- | --- | --- | --- | --- |
| 처리번호 | service_id | CHAR | 5 | N | PK, FK | 사후처리(처리번호) 참조 |
| 보증항목 | warranty_item | VARCHAR | 50 | N | PK | 보증 대상 항목 |

## 인덱스 정의서
### 인덱스 대상 선정

인덱스 대상은 먼저 업무에서 자주 조회되는 테이블을 선정한 뒤, SQL 문에서 `WHERE` 절, `ORDER BY` 절, `GROUP BY` 절, `DISTINCT` 절에 자주 사용되거나 조인 조건으로 자주 사용되는 컬럼을 기준으로 선정한다. 또한 자주 사용되는 컬럼 중에서도 평균 분포도(selectivity)가 대략 10% 미만인 컬럼을 우선적으로 고려한다. 분포도는 특정 컬럼 값으로 검색했을 때 전체 데이터 중 선택되는 데이터의 비율을 의미하며, 값이 작을수록 인덱스 효율이 높다.

분포도 계산식은 다음과 같다.

```text
분포도(%) = 1 / 컬럼 값의 종류 * 100
분포도(%) = 해당 컬럼 값을 갖는 행의 평균 수 / 테이블의 총 행 수 * 100
```

본 시스템에서는 차량 조회, 계약 이력 조회, 사후처리 조회가 자주 발생하므로 `차량`, `판매계약`, `사후처리` 테이블을 인덱스 대상 테이블로 선정한다. 기본키와 유일키는 자동으로 인덱스가 생성되므로, 별도 인덱스 대상에서는 제외한다.

| 대상 테이블 | 선정 컬럼 | 사용되는 SQL 조건 | 선정 이유 |
|---|---|---|---|
| 차량 | vehicle_status, listing_date | WHERE, ORDER BY | 차량 상태별 조회가 자주 발생하고, 최근 등록 차량 순으로 정렬하는 업무가 많기 때문에 선정 |
| 판매계약 | customer_id, contract_date | WHERE, JOIN, ORDER BY | 고객별 구매 이력 조회와 최근 계약 내역 조회에 자주 사용되기 때문에 선정 |
| 사후처리 | service_status, request_date | WHERE, ORDER BY | 접수 또는 처리중인 사후처리 건을 상태별로 조회하고 요청일 순으로 처리해야 하므로 선정 |

`vehicle_status`, `service_status`는 상태 조건 검색에 자주 사용되고, `listing_date`, `contract_date`, `request_date`는 최신순 또는 오래된 요청순 정렬에 자주 사용된다. `customer_id`는 판매계약과 고객을 연결하는 조인 조건이면서 고객별 계약 이력 조회 조건으로 자주 사용되므로 인덱스 대상으로 선정한다.

### 인덱스 최적화
#### 인덱스의 효율성 검토

인덱스를 생성한 컬럼은 검색 조건으로 자주 사용되더라도 값이 자주 변경되지 않아야 한다. 인덱스는 조회 성능을 높이는 장점이 있지만, 삽입·삭제·갱신이 발생할 때 인덱스도 함께 변경되어야 하므로 데이터 변경이 빈번한 컬럼에 생성하면 오히려 전체 성능이 낮아질 수 있다.

따라서 평균 분포도가 10% 미만으로 양호한 컬럼이라도 값이 자주 변경되는 경우에는 인덱스 설정을 피하는 것이 좋다. 또한 한 테이블에 인덱스 수가 5개를 초과하면 데이터 조작 작업의 부담이 커질 수 있으므로, 삽입·삭제·갱신이 빈번하게 발생하는 테이블에서는 사용 빈도가 낮은 인덱스를 삭제하거나 조정해야 한다.

본 설계에서는 각 테이블에 필요한 보조 인덱스를 최소한으로 설정하였다. `차량`, `판매계약`, `사후처리` 테이블에 각각 1개씩 총 3개의 인덱스만 정의하므로 테이블별 인덱스 수가 5개를 초과하지 않는다.

| 인덱스 대상 | 변경 빈도 검토 | 효율성 판단 |
|---|---|---|
| 차량(vehicle_status, listing_date) | `vehicle_status`는 판매 진행에 따라 변경될 수 있으나 변경 횟수가 제한적이고, `listing_date`는 등록 후 거의 변경되지 않는다. | 상태별 차량 조회와 등록일 정렬에 자주 사용되므로 유지한다. |
| 판매계약(customer_id, contract_date) | 계약 생성 후 `customer_id`, `contract_date`는 거의 변경되지 않는다. | 고객별 계약 이력 조회와 최근 계약 조회에 자주 사용되므로 유지한다. |
| 사후처리(service_status, request_date) | `service_status`는 처리 과정에서 변경될 수 있으나 접수, 처리중, 처리완료 수준으로 제한적이며, `request_date`는 변경되지 않는다. | 처리 상태별 조회와 요청일 정렬에 자주 사용되므로 유지한다. |

결론적으로 선정한 인덱스는 조회 빈도가 높고 변경 빈도가 비교적 낮은 컬럼을 대상으로 하므로 효율성이 있다고 판단한다. 다만 실제 운영 중 데이터 변경 작업이 많아져 성능 저하가 발생하면, 사용 빈도가 낮은 인덱스부터 삭제하여 조정한다.

#### 인덱스의 데이터 타입 검토

인덱스를 효율적으로 활용하기 위해서는 인덱스 대상 컬럼의 데이터 타입이 업무 처리 방식에 적합한지 검토해야 한다. 업무 도메인에 맞는 데이터 타입이 지정되어 있더라도, 검색과 정렬이 더 효율적으로 수행될 수 있다면 데이터 타입을 조정할 수 있다. 예를 들어 날짜 컬럼이 시·분·초까지 필요하지 않고 날짜 단위로만 처리된다면 `DATE` 대신 `CHAR(8)` 형식의 `YYYYMMDD` 값을 사용할 수 있다.

또한 데이터 길이가 일정하지 않은 문자열 컬럼은 고정 길이 타입보다 `VARCHAR`와 같은 가변 길이 데이터 타입을 사용하는 것이 저장 공간 측면에서 효율적이다. 반대로 식별번호처럼 길이가 항상 일정한 값은 `CHAR` 타입을 사용하여 물리적 저장 구조를 단순하게 유지한다.

| 인덱스 대상 컬럼 | 현재 데이터 타입 | 데이터 타입 검토 |
|---|---|---|
| vehicle_status | VARCHAR(10) | 상태값은 한글 문자열이고 값의 길이가 일정하지 않을 수 있으므로 `VARCHAR(10)`을 유지한다. |
| listing_date | DATE | 매물 등록일은 날짜 단위 검색과 정렬에 사용되며 시·분·초가 필요하지 않으므로 `DATE` 타입을 유지한다. 필요 시 `YYYYMMDD` 형식의 `CHAR(8)`로도 변환 가능하다. |
| customer_id | CHAR(5) | `CU` + 숫자 3자리로 길이가 고정되어 있으므로 `CHAR(5)`가 적합하다. |
| contract_date | DATE | 계약일은 날짜 단위로 관리되므로 `DATE` 타입을 유지한다. |
| service_status | VARCHAR(10) | 처리상태는 `접수`, `처리중`, `처리완료`처럼 길이가 달라질 수 있으므로 `VARCHAR(10)`을 유지한다. |
| request_date | DATE | 요청일은 날짜 단위로 조회와 정렬에 사용되므로 `DATE` 타입을 유지한다. |

따라서 현재 인덱스 대상 컬럼은 대부분 업무 처리 방식에 적합한 데이터 타입을 사용하고 있다. 식별번호는 고정 길이 `CHAR`, 상태값은 가변 길이 `VARCHAR`, 날짜값은 날짜 연산과 정렬을 고려하여 `DATE` 타입을 사용한다.

#### 인덱스 정렬 및 결합 인덱스 검토

인덱스는 정렬 상태에 따라 순정렬(ascending) 인덱스와 역정렬(descending) 인덱스로 나눌 수 있다. 따라서 조회 업무에서 오름차순 정렬이 자주 사용되는지, 내림차순 정렬이 자주 사용되는지 검토해야 한다. 특히 최근 등록 차량, 최근 계약 내역, 오래된 요청 순서처럼 정렬 방향이 명확한 경우에는 인덱스 정렬 방향을 함께 고려한다.

여러 컬럼이 검색 조건에서 동시에 사용되는 경우에는 결합 인덱스를 생성할 수 있다. 결합 인덱스에서는 컬럼의 순서가 성능에 큰 영향을 미치므로, 검색 대상의 범위를 먼저 줄일 수 있는 컬럼을 앞에 배치하는 것이 중요하다. 예를 들어 고객별 계약 내역을 조회할 때 `customer_id`와 `contract_date`가 함께 사용된다면, `contract_date`보다 `customer_id`를 먼저 두어 특정 고객의 계약만 먼저 좁힌 뒤 날짜 기준으로 정렬하거나 범위 검색하는 것이 효율적이다.

| 인덱스명 | 결합 인덱스 컬럼 순서 | 정렬 방향 | 검토 내용 |
|---|---|---|---|
| IDX_차량_상태_등록일 | vehicle_status, listing_date | vehicle_status ASC, listing_date DESC | 차량상태로 먼저 검색 범위를 줄인 뒤, 최근 등록 차량이 먼저 보이도록 등록일은 역정렬로 설정한다. |
| IDX_판매계약_고객_계약일 | customer_id, contract_date | customer_id ASC, contract_date DESC | 고객번호로 특정 고객의 계약만 먼저 찾고, 해당 고객의 계약 내역을 최근 계약일 순으로 정렬한다. |
| IDX_사후처리_상태_요청일 | service_status, request_date | service_status ASC, request_date ASC | 처리상태로 접수 또는 처리중인 건을 먼저 좁힌 뒤, 먼저 요청된 건부터 처리할 수 있도록 요청일은 순정렬로 설정한다. |

위와 같이 결합 인덱스의 첫 번째 컬럼은 검색 범위를 줄이는 조건 컬럼으로 선정하고, 두 번째 컬럼은 정렬 또는 범위 검색에 사용되는 날짜 컬럼으로 선정한다. 이를 통해 전체 테이블을 스캔하지 않고 조건에 맞는 데이터 범위를 먼저 줄인 후 정렬을 수행할 수 있다.

```sql
CREATE INDEX IDX_차량_상태_등록일
ON 차량(vehicle_status ASC, listing_date DESC);

CREATE INDEX IDX_판매계약_고객_계약일
ON 판매계약(customer_id ASC, contract_date DESC);

CREATE INDEX IDX_사후처리_상태_요청일
ON 사후처리(service_status ASC, request_date ASC);
```

## 인덱스 정의서 작성

인덱스 대상 선정과 최적화 검토 결과를 바탕으로 다음과 같이 인덱스 정의서를 작성한다. 인덱스 정의서에는 릴레이션명, 속성명, 실제 테이블명, 컬럼명, 인덱스명, 데이터 타입, 정렬 방식을 포함한다.

| 릴레이션명 | 속성명 | 테이블명 | 컬럼명 | 인덱스명 | 데이터 타입 | 정렬 |
|---|---|---|---|---|---|---|
| 차량 | 차량상태, 매물등록일 | vehicle | vehicle_status, listing_date | vehicle_status_listing_date_idx | VARCHAR(10), DATE | ASC, DESC |
| 판매계약 | 고객번호, 계약(구매)일 | sales_contract | customer_id, contract_date | customer_contract_date_idx | CHAR(5), DATE | ASC, DESC |
| 사후처리 | 처리상태, 요청일 | after_service | service_status, request_date | service_status_request_date_idx | VARCHAR(10), DATE | ASC, ASC |

각 인덱스가 필요한 이유는 다음과 같다.

| 인덱스명 | 분포도 검토 | 필요성 |
|---|---|---|
| vehicle_status_listing_date_idx | 차량상태는 단독 분포도는 높을 수 있으나 매물등록일과 결합하면 검색 범위를 줄일 수 있다. | 차량 목록 조회에서 `vehicle_status`가 `WHERE` 절에 자주 사용되고, `listing_date`가 `ORDER BY` 절에 자주 사용되므로 상태별 최신 차량 조회 성능을 높일 수 있다. |
| customer_contract_date_idx | 고객번호는 고객별 계약 조회에서 검색 대상을 특정 고객으로 줄일 수 있고, 계약일과 결합하면 기간별 조회가 가능하다. | 고객별 구매 이력 조회에서 `customer_id`가 조인 조건과 검색 조건으로 자주 사용되고, `contract_date`가 최근 계약순 정렬에 사용되므로 인덱스 필요성이 높다. |
| service_status_request_date_idx | 처리상태는 단독 분포도는 높을 수 있으나 요청일과 결합하면 처리 대상 범위를 줄일 수 있다. | 사후처리 업무에서 `service_status`가 `WHERE` 절에 자주 사용되고, `request_date`가 처리 우선순위 정렬에 사용되므로 접수 및 처리중 건 조회에 효과적이다. |

최종 인덱스 생성문은 다음과 같다.

```sql
CREATE INDEX vehicle_status_listing_date_idx
ON vehicle(vehicle_status ASC, listing_date DESC);

CREATE INDEX customer_contract_date_idx
ON sales_contract(customer_id ASC, contract_date DESC);

CREATE INDEX service_status_request_date_idx
ON after_service(service_status ASC, request_date ASC);
```
