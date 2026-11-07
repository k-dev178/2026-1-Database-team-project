-- 8.4.4 검색 트랜잭션: 평균 판매가보다 높은 차량 조회
START TRANSACTION READ ONLY;

SELECT vehicle_id AS 차량식별번호,
       model_name AS 모델명,
       sale_price AS 판매가
FROM `차량`
WHERE sale_price > (
    SELECT AVG(sale_price)
    FROM `차량`
)
ORDER BY sale_price DESC;

COMMIT;
