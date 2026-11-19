SELECT * FROM sports;

INSERT INTO sports (sport_name)
VALUES ('필라테스')
RETURNING sport_id, sport_name;