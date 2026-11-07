Enum "직원역할" {
  "판매"
  "구매"
  "정비"
  "애프터서비스"
}


Enum "차량상태" {
  "입고"
  "정비중"
  "판매중"
  "판매완료"
}


Enum "판매방식" {
  "현금"
  "할부"
  "금융"
}


Enum "예약상태" {
  "대기"
  "확정"
  "취소"
  "완료"
}


Enum "정비상태" {
  "대기"
  "진행중"
  "완료"
}


Enum "사후처리유형" {
  "보증"
  "요청"
  "클레임"
}


Table "직원" {
  "직원번호" int [pk, increment, note: '직원번호']
  "이름" varchar(50) [note: '이름']
  "연락처" varchar(20) [note: '연락처']
  "역할" "직원역할" [note: '역할']
}


Table "고객" {
  "고객번호" int [pk, increment, note: '고객번호']
  "이름" varchar(50) [note: '이름']
  "주민번호" varchar(20) [unique, note: '주민번호']
  "연락처" varchar(20) [note: '연락처']
  "주소" varchar(255) [note: '주소']
}


Table "차량" {
  "차량번호" varchar(20) [pk, note: '차량번호']
  "모델명" varchar(100) [note: '모델명']
  "연식" int [note: '연식']
  "차량상태" "차량상태" [note: '차량상태']
  "매입가" decimal(12,2) [note: '매입가']
  "판매가" decimal(12,2) [note: '판매가']
  "매물등록일" date [note: '매물등록일']
  "판매일" date [note: '판매일']
  "담당직원번호" int [not null, note: '담당직원번호']
}


Table "판매계약" {
  "계약번호" int [pk, increment, note: '계약번호']
  "계약일" date [note: '계약일']
  "계약금액" decimal(12,2) [note: '계약금액']
  "판매방식" "판매방식" [note: '판매방식']
  "인도완료여부" boolean [default: false, note: '인도완료여부']
  "인도일" date [note: '인도일']
  "차량번호" varchar(20) [not null, unique, note: '차량번호']
  "고객번호" int [not null, note: '고객번호']
  "직원번호" int [not null, note: '직원번호']
}


Table "구매예약" {
  "예약번호" int [pk, increment, note: '예약번호']
  "예약일" date [note: '예약일']
  "예약상태" "예약상태" [note: '예약상태']
  "차량번호" varchar(20) [not null, note: '차량번호']
  "고객번호" int [not null, note: '고객번호']
}


Table "정비항목" {
  "정비항목번호" int [pk, increment, note: '정비항목번호']
  "항목명" varchar(100) [note: '항목명']
  "진행상태" "정비상태" [note: '진행상태']
  "차량번호" varchar(20) [not null, note: '차량번호']
  "직원번호" int [not null, note: '직원번호']
}


Table "상품화작업" {
  "작업번호" int [pk, increment, note: '작업번호']
  "작업명" varchar(100) [note: '작업명']
  "작업일" date [note: '작업일']
  "정비비" decimal(12,2) [default: 0, note: '정비비']
  "세차비" decimal(12,2) [default: 0, note: '세차비']
  "탁송비" decimal(12,2) [default: 0, note: '탁송비']
  "차량번호" varchar(20) [not null, note: '차량번호']
  "직원번호" int [not null, note: '직원번호']
}


Table "사후처리" {
  "처리번호" int [pk, increment, note: '처리번호']
  "처리유형" "사후처리유형" [note: '처리유형']
  "요청일" date [note: '요청일']
  "처리일" date [note: '처리일']
  "처리내용" text [note: '처리내용']
  "처리상태" varchar(30) [note: '처리상태']
  "보증기간" varchar(50) [note: '보증기간']
  "보증항목" varchar(255) [note: '보증항목']
  "차량번호" varchar(20) [not null, note: '차량번호']
  "고객번호" int [not null, note: '고객번호']
  "직원번호" int [not null, note: '직원번호']
}


// 직원 관계
Ref "담당하다": "차량"."담당직원번호" > "직원"."직원번호"
Ref "관리하다": "판매계약"."직원번호" > "직원"."직원번호"
Ref "등록하다": "정비항목"."직원번호" > "직원"."직원번호"
Ref "기록하다": "상품화작업"."직원번호" > "직원"."직원번호"
Ref "처리하다": "사후처리"."직원번호" > "직원"."직원번호"

// 고객 관계
Ref "체결하다": "판매계약"."고객번호" > "고객"."고객번호"
Ref "예약하다": "구매예약"."고객번호" > "고객"."고객번호"
Ref "요청하다": "사후처리"."고객번호" > "고객"."고객번호"

// 차량 관계
Ref "계약되다": "판매계약"."차량번호" - "차량"."차량번호"
Ref "예약되다": "구매예약"."차량번호" > "차량"."차량번호"
Ref "정비하다": "정비항목"."차량번호" > "차량"."차량번호"
Ref "상품화하다": "상품화작업"."차량번호" > "차량"."차량번호"
Ref "발생하다": "사후처리"."차량번호" > "차량"."차량번호"