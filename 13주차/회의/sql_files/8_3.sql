-- 8.3 삭제 트랜잭션: 등록된 고객 정보 삭제
START TRANSACTION;

-- SELECT * FROM `고객`;

DELETE FROM `고객`
WHERE customer_id = 'CU011';

DELETE FROM `고객`
WHERE customer_id = 'CU012';

-- SELECT * FROM `고객`;

COMMIT;