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
