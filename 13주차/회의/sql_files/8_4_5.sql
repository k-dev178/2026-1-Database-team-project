-- 8.4.5 검색 트랜잭션: 계약 건수가 2건 이상인 판매 담당자 조회
START TRANSACTION READ ONLY;

SELECT e.employee_id AS 직원번호,
       e.name AS 직원명,
       COUNT(sc.contract_id) AS 계약건수,
       SUM(sc.contract_amount) AS 총계약금액
FROM `직원` e
JOIN `판매계약` sc ON e.employee_id = sc.employee_id
WHERE e.role = '판매 담당자'
GROUP BY e.employee_id, e.name
HAVING COUNT(sc.contract_id) >= 2
ORDER BY 총계약금액 DESC;

COMMIT;
