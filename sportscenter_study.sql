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

