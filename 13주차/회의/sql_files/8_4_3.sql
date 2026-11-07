-- 8.4.3 검색 트랜잭션: 계약별 고객, 차량, 담당 직원 정보 조회
START TRANSACTION READ ONLY;

SELECT sc.contract_id AS 계약번호,
       c.name AS 고객명,
       v.model_name AS 차량모델,
       e.name AS 담당직원,
       sc.contract_date AS 계약일,
       sc.contract_amount AS 계약금액,
       sc.reservation_status AS 예약상태
FROM `판매계약` sc
JOIN `고객` c ON sc.customer_id = c.customer_id
JOIN `차량` v ON sc.vehicle_id = v.vehicle_id
JOIN `직원` e ON sc.employee_id = e.employee_id
ORDER BY sc.contract_date DESC;

COMMIT;
