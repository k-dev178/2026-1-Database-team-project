-- 8.4.1 검색 트랜잭션: 판매중 차량 중 판매가가 높은 차량 5건 조회
START TRANSACTION READ ONLY;

SELECT vehicle_id AS 차량식별번호,
       license_plate AS 차량번호,
       model_name AS 모델명,
       model_year AS 연식,
       sale_price AS 판매가
FROM `차량`
WHERE vehicle_status = '판매중'
ORDER BY sale_price DESC
LIMIT 5;

COMMIT;
