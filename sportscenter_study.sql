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
