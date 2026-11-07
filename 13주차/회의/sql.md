## 7.1) 테이블 생성
```sql
CREATE TABLE `직원` (
    employee_id CHAR(4) NOT NULL,
    name VARCHAR(20) NOT NULL,
    phone CHAR(13) NOT NULL,
    role VARCHAR(20) NOT NULL,
    CONSTRAINT employee_pk PRIMARY KEY (employee_id),
    CONSTRAINT employee_phone_uq UNIQUE (phone),
    CONSTRAINT employee_role_ck CHECK (role IN ('판매 담당자', '매입 담당자', '차량관리사', '사후관리담당자'))
);

CREATE TABLE `고객` (
    customer_id CHAR(5) NOT NULL,
    name VARCHAR(20) NOT NULL,
    resident_number CHAR(14) NOT NULL,
    phone CHAR(13) NOT NULL,
    address VARCHAR(100) NOT NULL,
    CONSTRAINT customer_pk PRIMARY KEY (customer_id),
    CONSTRAINT customer_id_uq UNIQUE (customer_id),
    CONSTRAINT customer_resident_number_uq UNIQUE (resident_number),
    CONSTRAINT customer_id_ck CHECK (customer_id REGEXP '^CU[0-9]{3}$'),
    CONSTRAINT customer_resident_number_ck CHECK (resident_number REGEXP '^[0-9]{6}-[0-9][*]{6}$'),
    CONSTRAINT customer_phone_ck CHECK (phone REGEXP '^[0-9]{3}-[0-9]{4}-[0-9]{4}$')
);

CREATE TABLE `차량` (
    vehicle_id CHAR(5) NOT NULL,
    license_plate VARCHAR(10) NOT NULL,
    employee_id CHAR(4) NOT NULL,
    model_name VARCHAR(30) NOT NULL,
    model_year INT NOT NULL,
    vehicle_status VARCHAR(10) NOT NULL,
    purchase_price INT UNSIGNED NOT NULL,
    sale_price INT UNSIGNED NOT NULL,
    listing_date DATE NOT NULL,
    sold_date DATE,
    work_date DATE,
    additional_cost INT UNSIGNED NOT NULL,
    work_name VARCHAR(30),
    maintenance_item VARCHAR(20),
    progress_status VARCHAR(10),
    CONSTRAINT vehicle_pk PRIMARY KEY (vehicle_id),
    CONSTRAINT vehicle_id_uq UNIQUE (vehicle_id),
    CONSTRAINT vehicle_license_plate_uq UNIQUE (license_plate),
    CONSTRAINT vehicle_employee_fk FOREIGN KEY (employee_id) REFERENCES `직원`(employee_id),
    CONSTRAINT vehicle_id_ck CHECK (vehicle_id REGEXP '^V[0-9]{4}$'),
    CONSTRAINT vehicle_price_ck CHECK (purchase_price >= 0 AND sale_price >= 0 AND additional_cost >= 0),
    CONSTRAINT vehicle_status_ck CHECK (vehicle_status IN ('판매중', '예약중', '판매완료')),
    CONSTRAINT vehicle_maintenance_item_ck CHECK (maintenance_item IN ('점검', '정비', '세차', '광택', '소모품 교체')),
    CONSTRAINT vehicle_progress_status_ck CHECK (progress_status IN ('등록', '진행중', '완료'))
);

CREATE TABLE `차량작업` (
    work_id CHAR(5) NOT NULL,
    vehicle_id CHAR(5) NOT NULL,
    work_date DATE,
    additional_cost INT UNSIGNED NOT NULL,
    work_name VARCHAR(30),
    maintenance_item VARCHAR(20),
    progress_status VARCHAR(10),
    CONSTRAINT vehicle_work_pk PRIMARY KEY (work_id),
    CONSTRAINT vehicle_work_vehicle_fk FOREIGN KEY (vehicle_id) REFERENCES `차량`(vehicle_id),
    CONSTRAINT vehicle_work_id_ck CHECK (work_id REGEXP '^W[0-9]{4}$'),
    CONSTRAINT vehicle_work_additional_cost_ck CHECK (additional_cost >= 0),
    CONSTRAINT vehicle_work_maintenance_item_ck CHECK (maintenance_item IN ('점검', '정비', '세차', '광택', '소모품 교체')),
    CONSTRAINT vehicle_work_progress_status_ck CHECK (progress_status IN ('등록', '진행중', '완료'))
);

CREATE TABLE `관리하다` (
    employee_id CHAR(4) NOT NULL,
    vehicle_id CHAR(5) NOT NULL,
    CONSTRAINT manage_vehicle_pk PRIMARY KEY (employee_id, vehicle_id),
    CONSTRAINT manage_vehicle_employee_fk FOREIGN KEY (employee_id) REFERENCES `직원`(employee_id),
    CONSTRAINT manage_vehicle_vehicle_fk FOREIGN KEY (vehicle_id) REFERENCES `차량`(vehicle_id)
);

CREATE TABLE `판매계약` (
    contract_id CHAR(5) NOT NULL,
    vehicle_id CHAR(5) NOT NULL,
    customer_id CHAR(5) NOT NULL,
    employee_id CHAR(4) NOT NULL,
    contract_date DATE NOT NULL,
    contract_amount INT UNSIGNED NOT NULL,
    payment_method VARCHAR(10) NOT NULL,
    delivery_completed CHAR(1) NOT NULL,
    delivery_date DATE,
    reservation_date DATE,
    reservation_status VARCHAR(10) NOT NULL,
    CONSTRAINT sales_contract_pk PRIMARY KEY (contract_id),
    CONSTRAINT sales_contract_vehicle_fk FOREIGN KEY (vehicle_id) REFERENCES `차량`(vehicle_id),
    CONSTRAINT sales_contract_customer_fk FOREIGN KEY (customer_id) REFERENCES `고객`(customer_id),
    CONSTRAINT sales_contract_employee_fk FOREIGN KEY (employee_id) REFERENCES `직원`(employee_id),
    CONSTRAINT sales_contract_id_ck CHECK (contract_id REGEXP '^C[0-9]{4}$'),
    CONSTRAINT sales_contract_amount_ck CHECK (contract_amount >= 0),
    CONSTRAINT sales_contract_payment_method_ck CHECK (payment_method IN ('현금', '카드', '할부')),
    CONSTRAINT sales_contract_delivery_completed_ck CHECK (delivery_completed IN ('Y', 'N')),
    CONSTRAINT sales_contract_reservation_status_ck CHECK (reservation_status IN ('진행중', '완료', '취소'))
);

CREATE TABLE `사후처리` (
    service_id CHAR(5) NOT NULL,
    vehicle_id CHAR(5) NOT NULL,
    customer_id CHAR(5) NOT NULL,
    employee_id CHAR(4) NOT NULL,
    service_type VARCHAR(10),
    request_date DATE,
    process_date DATE,
    service_content VARCHAR(100),
    service_status VARCHAR(10),
    warranty_period VARCHAR(10),
    CONSTRAINT after_service_pk PRIMARY KEY (service_id),
    CONSTRAINT after_service_vehicle_fk FOREIGN KEY (vehicle_id) REFERENCES `차량`(vehicle_id),
    CONSTRAINT after_service_customer_fk FOREIGN KEY (customer_id) REFERENCES `고객`(customer_id),
    CONSTRAINT after_service_employee_fk FOREIGN KEY (employee_id) REFERENCES `직원`(employee_id),
    CONSTRAINT after_service_id_ck CHECK (service_id REGEXP '^P[0-9]{4}$'),
    CONSTRAINT after_service_type_ck CHECK (service_type IN ('보증', 'A/S', '클레임')),
    CONSTRAINT after_service_status_ck CHECK (service_status IN ('접수', '처리중', '처리완료'))
);

CREATE TABLE `처리하다` (
    employee_id CHAR(4) NOT NULL,
    service_id CHAR(5) NOT NULL,
    CONSTRAINT process_service_pk PRIMARY KEY (employee_id, service_id),
    CONSTRAINT process_service_employee_fk FOREIGN KEY (employee_id) REFERENCES `직원`(employee_id),
    CONSTRAINT process_service_after_service_fk FOREIGN KEY (service_id) REFERENCES `사후처리`(service_id)
);

CREATE TABLE `사후처리보증항목` (
    service_id CHAR(5) NOT NULL,
    warranty_item VARCHAR(50) NOT NULL,
    CONSTRAINT after_service_warranty_item_pk PRIMARY KEY (service_id, warranty_item),
    CONSTRAINT after_service_warranty_item_fk FOREIGN KEY (service_id) REFERENCES `사후처리`(service_id)
);
```

## 7.2) 데이터 삽입

```sql
INSERT INTO `직원` (employee_id, name, phone, role) VALUES
('E001', '김민준', '010-1001-0001', '판매 담당자'),
('E002', '이서연', '010-1001-0002', '매입 담당자'),
('E003', '박도윤', '010-1001-0003', '차량관리사'),
('E004', '최지우', '010-1001-0004', '사후관리담당자'),
('E005', '정하준', '010-1001-0005', '판매 담당자'),
('E006', '강서아', '010-1001-0006', '매입 담당자'),
('E007', '윤지호', '010-1001-0007', '차량관리사'),
('E008', '장하린', '010-1001-0008', '사후관리담당자'),
('E009', '임시우', '010-1001-0009', '판매 담당자'),
('E010', '한유나', '010-1001-0010', '차량관리사');

INSERT INTO `고객` (customer_id, name, resident_number, phone, address) VALUES
('CU001', '박지훈', '990101-1******', '010-2001-0001', '서울시 강남구 테헤란로 10'),
('CU002', '최유진', '980505-2******', '010-2001-0002', '서울시 송파구 올림픽로 20'),
('CU003', '이현우', '970312-1******', '010-2001-0003', '서울시 마포구 월드컵북로 30'),
('CU004', '김서윤', '960824-2******', '010-2001-0004', '서울시 성동구 왕십리로 40'),
('CU005', '정민재', '950716-1******', '010-2001-0005', '경기도 성남시 분당구 판교로 50'),
('CU006', '한지민', '940228-2******', '010-2001-0006', '경기도 수원시 영통구 광교로 60'),
('CU007', '오준서', '930909-1******', '010-2001-0007', '인천시 연수구 송도과학로 70'),
('CU008', '신예린', '920411-2******', '010-2001-0008', '부산시 해운대구 센텀로 80'),
('CU009', '유태양', '910621-1******', '010-2001-0009', '대전시 유성구 대학로 90'),
('CU010', '서아름', '900103-2******', '010-2001-0010', '대구시 수성구 달구벌대로 100');

INSERT INTO `차량` (vehicle_id, license_plate, employee_id, model_name, model_year, vehicle_status, purchase_price, sale_price, listing_date, sold_date, work_date, additional_cost, work_name, maintenance_item, progress_status) VALUES
('V0001', '12가3456', 'E002', '아반떼', 2021, '판매완료', 13000000, 15500000, '2026-05-01', '2026-05-20', '2026-05-03', 300000, '기본 상품화', '점검', '완료'),
('V0002', '34나7890', 'E002', '쏘나타', 2020, '판매중', 16000000, 18500000, '2026-05-02', NULL, '2026-05-04', 450000, '외관 정비', '광택', '진행중'),
('V0003', '56다1234', 'E006', 'K5', 2022, '예약중', 19000000, 21500000, '2026-05-03', NULL, '2026-05-05', 250000, '실내 세차', '세차', '완료'),
('V0004', '78라5678', 'E006', '그랜저', 2019, '판매완료', 22000000, 24800000, '2026-05-04', '2026-05-22', '2026-05-06', 600000, '소모품 정비', '소모품 교체', '완료'),
('V0005', '90마1111', 'E002', '스포티지', 2021, '판매중', 21000000, 23500000, '2026-05-05', NULL, '2026-05-07', 350000, '성능 점검', '점검', '완료'),
('V0006', '11바2222', 'E006', '투싼', 2020, '예약중', 20000000, 22600000, '2026-05-06', NULL, '2026-05-08', 400000, '하체 정비', '정비', '진행중'),
('V0007', '22사3333', 'E002', '모닝', 2022, '판매중', 8000000, 9800000, '2026-05-07', NULL, '2026-05-09', 150000, '출고 세차', '세차', '완료'),
('V0008', '33아4444', 'E006', '카니발', 2018, '판매완료', 24000000, 27000000, '2026-05-08', '2026-05-25', '2026-05-10', 700000, '광택 작업', '광택', '완료'),
('V0009', '44자5555', 'E002', '셀토스', 2023, '판매중', 23000000, 25800000, '2026-05-09', NULL, '2026-05-11', 300000, '기본 정비', '정비', '등록'),
('V0010', '55차6666', 'E006', '제네시스 G80', 2021, '예약중', 42000000, 46500000, '2026-05-10', NULL, '2026-05-12', 800000, '프리미엄 상품화', '소모품 교체', '진행중');

INSERT INTO `차량작업` (work_id, vehicle_id, work_date, additional_cost, work_name, maintenance_item, progress_status) VALUES
('W0001', 'V0001', '2026-05-03', 300000, '기본 상품화', '점검', '완료'),
('W0002', 'V0002', '2026-05-04', 450000, '외관 정비', '광택', '진행중'),
('W0003', 'V0003', '2026-05-05', 250000, '실내 세차', '세차', '완료'),
('W0004', 'V0004', '2026-05-06', 600000, '소모품 정비', '소모품 교체', '완료'),
('W0005', 'V0005', '2026-05-07', 350000, '성능 점검', '점검', '완료'),
('W0006', 'V0006', '2026-05-08', 400000, '하체 정비', '정비', '진행중'),
('W0007', 'V0007', '2026-05-09', 150000, '출고 세차', '세차', '완료'),
('W0008', 'V0008', '2026-05-10', 700000, '광택 작업', '광택', '완료'),
('W0009', 'V0009', '2026-05-11', 300000, '기본 정비', '정비', '등록'),
('W0010', 'V0010', '2026-05-12', 800000, '프리미엄 상품화', '소모품 교체', '진행중');

INSERT INTO `관리하다` (employee_id, vehicle_id) VALUES
('E003', 'V0001'),
('E003', 'V0002'),
('E007', 'V0003'),
('E007', 'V0004'),
('E010', 'V0005'),
('E010', 'V0006'),
('E003', 'V0007'),
('E007', 'V0008'),
('E010', 'V0009'),
('E003', 'V0010');

INSERT INTO `판매계약` (contract_id, vehicle_id, customer_id, employee_id, contract_date, contract_amount, payment_method, delivery_completed, delivery_date, reservation_date, reservation_status) VALUES
('C0001', 'V0001', 'CU001', 'E001', '2026-05-20', 15500000, '카드', 'Y', '2026-05-22', '2026-05-18', '완료'),
('C0002', 'V0002', 'CU002', 'E005', '2026-05-21', 18500000, '현금', 'N', NULL, '2026-05-19', '진행중'),
('C0003', 'V0003', 'CU003', 'E009', '2026-05-22', 21500000, '할부', 'N', NULL, '2026-05-20', '진행중'),
('C0004', 'V0004', 'CU004', 'E001', '2026-05-22', 24800000, '카드', 'Y', '2026-05-24', '2026-05-19', '완료'),
('C0005', 'V0005', 'CU005', 'E005', '2026-05-23', 23500000, '현금', 'N', NULL, '2026-05-21', '취소'),
('C0006', 'V0006', 'CU006', 'E009', '2026-05-24', 22600000, '할부', 'N', NULL, '2026-05-22', '진행중'),
('C0007', 'V0007', 'CU007', 'E001', '2026-05-25', 9800000, '카드', 'N', NULL, '2026-05-23', '진행중'),
('C0008', 'V0008', 'CU008', 'E005', '2026-05-25', 27000000, '현금', 'Y', '2026-05-27', '2026-05-22', '완료'),
('C0009', 'V0009', 'CU009', 'E009', '2026-05-26', 25800000, '할부', 'N', NULL, '2026-05-24', '취소'),
('C0010', 'V0010', 'CU010', 'E001', '2026-05-27', 46500000, '카드', 'N', NULL, '2026-05-25', '진행중');

INSERT INTO `사후처리` (service_id, vehicle_id, customer_id, employee_id, service_type, request_date, process_date, service_content, service_status, warranty_period) VALUES
('P0001', 'V0001', 'CU001', 'E004', '보증', '2026-05-25', NULL, '엔진 소음 점검 요청', '접수', '6개월'),
('P0002', 'V0002', 'CU002', 'E008', 'A/S', '2026-05-26', NULL, '내비게이션 오류 확인', '처리중', NULL),
('P0003', 'V0003', 'CU003', 'E004', '클레임', '2026-05-26', '2026-05-28', '계약 일정 변경 요청', '처리완료', NULL),
('P0004', 'V0004', 'CU004', 'E008', '보증', '2026-05-27', NULL, '브레이크 소음 점검', '접수', '3개월'),
('P0005', 'V0005', 'CU005', 'E004', 'A/S', '2026-05-27', '2026-05-29', '타이어 공기압 점검', '처리완료', NULL),
('P0006', 'V0006', 'CU006', 'E008', '클레임', '2026-05-28', NULL, '예약 취소 문의', '처리중', NULL),
('P0007', 'V0007', 'CU007', 'E004', '보증', '2026-05-28', NULL, '배터리 상태 점검', '접수', '6개월'),
('P0008', 'V0008', 'CU008', 'E008', 'A/S', '2026-05-29', '2026-05-30', '블랙박스 작동 확인', '처리완료', NULL),
('P0009', 'V0009', 'CU009', 'E004', '클레임', '2026-05-29', NULL, '차량 상태 설명 재확인 요청', '처리중', NULL),
('P0010', 'V0010', 'CU010', 'E008', '보증', '2026-05-30', NULL, '전자장비 보증 문의', '접수', '12개월');

INSERT INTO `처리하다` (employee_id, service_id) VALUES
('E004', 'P0001'),
('E008', 'P0002'),
('E004', 'P0003'),
('E008', 'P0004'),
('E004', 'P0005'),
('E008', 'P0006'),
('E004', 'P0007'),
('E008', 'P0008'),
('E004', 'P0009'),
('E008', 'P0010');

INSERT INTO `사후처리보증항목` (service_id, warranty_item) VALUES
('P0001', '엔진'),
('P0002', '내비게이션'),
('P0003', '계약 상담'),
('P0004', '브레이크'),
('P0005', '타이어'),
('P0006', '예약 관리'),
('P0007', '배터리'),
('P0008', '블랙박스'),
('P0009', '차량 상태'),
('P0010', '전자장비');
```

## 7.3) 테이블 삭제

```sql
DROP TABLE `사후처리보증항목`;
DROP TABLE `처리하다`;
DROP TABLE `사후처리`;
DROP TABLE `판매계약`;
DROP TABLE `관리하다`;
DROP TABLE `차량작업`;
DROP TABLE `차량`;
DROP TABLE `고객`;
DROP TABLE `직원`;
```
