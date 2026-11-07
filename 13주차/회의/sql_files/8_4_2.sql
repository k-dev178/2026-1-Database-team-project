-- 8.4.2 검색 트랜잭션: 차량 상태별 차량 수와 평균 판매가 조회
START TRANSACTION READ ONLY;

SELECT vehicle_status AS 차량상태,
       COUNT(*) AS 차량수,
       ROUND(AVG(sale_price), 0) AS 평균판매가
FROM `차량`
GROUP BY vehicle_status
ORDER BY COUNT(*) DESC;

COMMIT;
