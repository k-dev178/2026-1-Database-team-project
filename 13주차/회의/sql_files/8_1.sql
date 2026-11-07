-- 8.1 삽입 트랜잭션: 고객 정보 등록
START TRANSACTION;

-- SELECT * FROM `고객`;

INSERT INTO `고객` (customer_id, name, resident_number, phone, address) VALUES
('CU011', '문태준', '890215-1******', '010-2001-0011', '서울시 관악구 남부순환로 110'),
('CU012', '배수빈', '880927-2******', '010-2001-0012', '경기도 용인시 수지구 풍덕천로 120');

-- SELECT * FROM `고객`;

COMMIT;