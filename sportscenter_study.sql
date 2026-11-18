-- 데이터베이스 생성 (DDL)
CREATE DATABASE sportscenter;

-- 회원 테이블  (DDL)

CREATE TABLE members
(
    member_id   SERIAL      PRIMARY KEY, 
    name        VARCHAR(30) NOT NULL, 
    gender      CHAR(1)     NOT NULL, 
    birth_year  SMALLINT    NOT NULL,
    phone       VARCHAR(20), 
    email       VARCHAR(50),
    region      VARCHAR(10), 
    join_date   DATE        NOT NULL
);


-- 회원 등록 
-- (첫번째 방법) INSERT INTO members (컬럼1, 컬럼2, 컬럼3) VALUES (컬럼1값, 컬럼2값, 컬럼3값);
-- (두번째 방법) INSERT INTO members VALUES (모든 컬럼, , , , );
-- (세번째 방법) INSERT INTO members SELECT * FORM WHERE ~~~
-- (네번째 방법) INSERT INTO members (컬럼1, 컬럼2, 컬럼3) 
-- VALUES 
-- (컬럼1값, 컬럼2값, 컬럼3값),
-- (컬럼1값, 컬럼2값, 컬럼3값),
-- (컬럼1값, 컬럼2값, 컬럼3값),
-- (컬럼1값, 컬럼2값, 컬럼3값)


-- DML(Data Manipulate Language)
INSERT INTO members 
(
    name, 
    gender, 
    birth_year, 
    phone, 
    email, 
    region, 
    join_date
)
VALUES
(
    '김하늘', 
    'F', 
    1995, 
    '010-1234-5678', 
    'haneul@example.com', 
    '마포구', 
    '2026-09-01'
);




-- 종목 개설 강좌 목록 (DDL)
CREATE TABLE sports
(
    sports_id   SERIAL      PRIMARY KEY,
    sports_name VARCHAR(20) NOT NULL
);

INSERT INTO sports (sports_name) VALUES ('수영');
INSERT INTO sports (sports_name) VALUES ('헬스');





-- 개설 강좌 (DDL)
CREATE TABLE courses
(
    course_id       SERIAL      PRIMARY KEY,
    sports_id       INT         NOT NULL REFERENCES sports (sports_id),   -- 외래키 (Foregn Key)
    course_name     VARCHAR(30) NOT NULL, 
    level           VARCHAR(20) NOT NULL,
    class_days      VARCHAR(10) NOT NULL, 
    start_time      TIME        NOT NULL, 
    capacity        SMALLINT    NOT NULL, 
    fee             INT         NOT NULL  
);

INSERT INTO courses (sports_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (1, '수영 초급 새벽반', '초급', '월수금', '06:00', 20, 70000);
INSERT INTO courses (sports_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (2, '헬스 자유이용', '자유', '매일', '06:00', 50, 50000);

INSERT INTO courses (sports_id, course_name, level, class_days, start_time, capacity, fee)
VALUES (30, '헬스 자유이용', '자유', '매일', '06:00', 50, 50000);



-- 1:1 사물함 테이블 생성 
CREATE TABLE lockers
(
    locker_no   INT     PRIMARY KEY,      
    member_id   INT     NOT NULL UNIQUE REFERENCES members (member_id) ON DELETE CASCADE,
    asign_date  DATE    NOT NULL
);

INSERT INTO lockers VALUES (101, 1, '2026-11-01');
INSERT INTO lockers VALUES (102, 3, '2026-11-01');  -- 임시 회원 

-- 임시 회원 추가 
INSERT INTO members (name, gender, birth_year, join_date)
VALUES ('임시회원', 'M', 2000, '2026-11-01');
SELECT member_id, name FROM members;



-- 수강 신청 테이블 
CREATE TABLE enrollments
(
   member_id    INT             NOT NULL REFERENCES members(member_id),
   course_id    INT             NOT NULL REFERENCES courses(course_id),
   enroll_month CHAR(7)         NOT NULL,
   status       VARCHAR(10)     NOT NULL,
   pay_amount   NUMERIC(10,2)   NOT NULL CHECK (pay_amount >=0),
   PRIMARY KEY (member_id, course_id, enroll_month)
);

INSERT INTO enrollments 
VALUES (1, 1, '2026-11', '수료', 50000);

INSERT INTO enrollments 
VALUES (2, 2, '2026-10', '수료', 70000);

INSERT INTO enrollments 
VALUES (2, 2, '2026-10', '수료', 60000);




-- 강사 테이블 만들기 
DROP TABLE IF EXISTS tutor CASCADE;

CREATE TABLE instructors
(
    instructor_id   SERIAL      PRIMARY KEY,
    name      VARCHAR(20) NOT NULL, 
    sports_id       INT         NOT NULL REFERENCES sports(sports_id),
    phone     VARCHAR(20),
    hire_data       DATE        NOT NULL
);


INSERT INTO tutor (tutor_name, sports_id, tutor_phone, hire_data)
VALUES
('홍길동', 1, '010-1234-5678', '2025-01-03'),
('손흥민', 2, '010-1111-2222', '2024-07-13');


-- 테이블 수정 ALTER TABLE 

ALTER TABLE courses
ADD COLUMN instructor_id INT REFERENCES tutor(instructor_id); 



SELECT course_name AS 강좌명,
fee AS 수강료,
fee * 3 AS "3개월수강료"
FROM courses
LIMIT 5;



SELECT region FROM members;
-- 중복 없이 
SELECT DISTINCT region FROM members;

SELECT DISTINCT sport_id, level FROM courses;


SELECT * FROM members WHERE member_id <= 7;

-- 지역이 마포구인 사람만
SELECT * FROM members WHERE region = '마포구';

-- 이메일 주소가 없는 사람들
SELECT * FROM members WHERE email IS NULL;

-- 이메일 주소가 없는 사람들 카운트
SELECT COUNT(*) FROM members WHERE email IS NULL;
SELECT COUNT(*) AS "E-MAIL 미기재" FROM members WHERE email IS NULL;


SELECT * FROM members WHERE birth_year BETWEEN 1995 AND 2000;

SELECT * FROM courses WHERE course_id IN (1, 5, 10);


SELECT * FROM members WHERE name LIKE '김%';


-- 11/19(수)

SELECT course_name, level, start_time
FROM courses
WHERE sport_id = 1
AND (level = '초급' OR start_time < '09:00');

SELECT name, birth_year,
        CASE WHEN birth_year <= 1960 THEN '할인'
            WHEN birth_year >= 2000 THEN '청소년'
            ELSE '일반'
        END AS 요금구분
FROM members
ORDER BY birth_year, name
LIMIT 10;


-- 수강료가 비싼 순서대로 정렬 (ASC : 오름차순(기본), DESC: 내림차순)
SELECT course_name, fee
FROM courses
WHERE fee >= 80000
ORDER BY fee DESC, course_name;

-- email NULL 값 
SELECT name, email 
FROM members
ORDER BY email DESC, name; 

-- 집계합수 사용 
-- 한글 띄어쓰기 할 경우에는 ""
SELECT
    COUNT(*)            AS 강좌수,
    MIN(fee)            AS 최저수강료,
    MAX(fee)            AS 최고수강료, 
    SUM(capacity)       AS 전체정원,
    ROUND(AVG(fee), 2)  AS 평균수강료
FROM courses;


-- COUNT(*) vs COUNT(컬럼) 차이

SELECT
    COUNT(*)                AS 회원수 ,
    COUNT(email)            AS 이메일있음 ,
    COUNT(phone)            AS 전화번호있음 ,
    COUNT(DISTINCT region)  AS 거주지
FROM members;


-- 최고 매출 SUM

SELECT  
    COUNT(*)            AS 신청건수,
    SUM(pay_amount)     AS 매출,
    MAX(pay_amount)     AS 최고매출
FROM enrollments    
WHERE enroll_month = '2026-11';


-- GROUP BY 
SELECT  
    enroll_month        AS 신청월,
    COUNT(*)            AS 신청건수,
    SUM(pay_amount)     AS 매출
FROM enrollments
GROUP BY enroll_month
ORDER BY enroll_month;


SELECT 
    enroll_month, status, COUNT(*) AS 건수
FROM enrollments
GROUP BY enroll_month, status
ORDER BY enroll_month, status;


-- HAVING 
-- <> : ''가 아닌 조건 
-- WHERE status IN ('수강', '진행중')  --> 이렇게 써도 되지만 괄호가 많아질 수록 속도를 예측할 수 없어서 추천하지 않음 
SELECT course_id, COUNT(*) AS 누적신청
FROM enrollments
WHERE status <> '취소'
GROUP BY course_id
HAVING COUNT(*) >= 18
ORDER BY 누적신청 DESC, course_id;

-- 거주지, 해당거주지회원수
-- 조건: 해당 거주지 회원수 10명 이상인 경우 
SELECT region, COUNT(*) AS 해당거주지회원수
FROM members
GROUP BY region
HAVING COUNT(*) >= 10
ORDER BY 해당거주지회원수 DESC, region;

------------------------------------------------------------------------------------------------------
-- UNION /  UNION ALL
-- 주의 사항: 컬럼의 수가 일치해야 함 
SELECT member_id FROM enrollments WHERE course_id = 4 AND enroll_month = '2026-09'
UNION 
SELECT member_id FROM enrollments WHERE course_id = 4 AND enroll_month = '2026-10'
UNION  
SELECT member_id FROM enrollments WHERE course_id = 4 AND enroll_month = '2026-11'
ORDER BY member_id;


SELECT '강사' AS 구분, name, phone FROM instructors WHERE sport_id = 4
UNION ALL
SELECT '회원' AS 구분, name, phone FROM members WHERE region = '영등포구';


-- JOIN
SELECT 
    e.member_id,
    m.name,
    c.course_name,
    e.enroll_month,
    e.status
FROM enrollments e
LEFT JOIN members m ON e.member_id = m.member_id
LEFT JOIN courses c ON e.course_id = c.course_id
WHERE e.course_id = 1 AND e.enroll_month = '2026-11'
ORDER BY m.name;

-- LIFT, RIGHT, FULL OUTER  해보기 
SELECT
    c.course_id,
    c.course_name,
    i.name AS 강사
FROM courses c
FULL OUTER JOIN instructors i ON c.instructor_id = i.instructor_id
ORDER BY c.course_id;


-- 서브(sub) 쿼리 (쿼리 안에 쿼리)
SELECT AVG(fee) FROM courses;

EXPLAIN(COSTS OFF)

SELECT course_name, fee 
FROM courses
WHERE fee > (SELECT AVG(fee) FROM courses)
ORDER BY fee DESC, course_name;


--FROM Sub Query

-- Inline View

SELECT 
    paid.member_id  AS 회원번호, 
    m.name          AS 회원명,
    paid.total_paid AS 매출액
FROM 
(
    SELECT member_id, SUM(pay_amount) AS total_paid
    FROM enrollments
    GROUP BY member_id
) AS paid
LEFT JOIN members m ON paid.member_id = m.member_id
WHERE paid.total_paid >= 400000
ORDER BY paid.total_paid DESC, paid.member_id;


-- Scala Sub Query

SELECT 
    course_name,
    fee, 
    ROUND((SELECT AVG(fee) FROM courses), 2)        AS 전체평균,
    fee - ROUND((SELECT AVG(fee) FROM courses), 2)  AS 평균과차이
FROM courses;