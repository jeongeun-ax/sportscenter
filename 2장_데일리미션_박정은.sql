-- 1번 
SELECT member_id, name, birth_year, region, phone 
FROM members
WHERE 1970 <= birth_year
AND birth_year <= 1989
GROUP BY birth_year, member_id
ORDER BY email DESC, birth_year, member_id
LIMIT 8;


-- 2번 
-- 미해결: 남/여로 변경
SELECT 
    region                   AS 거주지역,
    gender                   AS 성별,
    COUNT(*)                 AS 회원수,
    ROUND(AVG(birth_year),0) AS 평균출생연도
FROM members
GROUP BY region, gender
HAVING COUNT(*) >= 5
ORDER BY region, gender;


-- 3번
SELECT 
    m.name          AS 회원명, 
    m.phone         AS 전화번호, 
    c.course_name   AS 강좌명,
    e.enroll_month  AS 수강월
FROM members m
LEFT JOIN enrollments e ON e.member_id = m.member_id
LEFT JOIN courses c ON c.course_id = e.course_id
WHERE e.status = '취소' AND e.enroll_month = '2026-10'
ORDER BY m.name;


-- 4번 
SELECT 
    s.sport_name                AS 종목,
    e.enroll_month              AS 수강월,
    COUNT(*)                    AS 수강인원,
    ROUND(SUM(e.pay_amount),0)  AS 매출
FROM enrollments e
LEFT JOIN courses c ON c.course_id = e.course_id
LEFT JOIN sports s ON s.sport_id = c.sport_id
WHERE e.status <> '취소'
GROUP BY s.sport_name, enroll_month
Having SUM(e.pay_amount) >= 1000000
ORDER BY s.sport_name DESC, enroll_month;




