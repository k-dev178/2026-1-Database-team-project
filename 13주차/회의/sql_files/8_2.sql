-- 8.2 변경 트랜잭션: 등록된 고객 연락처와 주소 변경
START TRANSACTION;

-- SELECT * FROM `고객`;

UPDATE `고객`
SET phone = '010-3001-0011',
    address = '서울시 관악구 신림로 210'
WHERE customer_id = 'CU011';

UPDATE `고객`
SET phone = '010-3001-0012',
    address = '경기도 용인시 기흥구 구성로 220'
WHERE customer_id = 'CU012';

-- SELECT * FROM `고객` WHERE customer_id = 'CU011';

COMMIT;
