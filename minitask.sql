docker compose up -d
docker compose cp shop_seed.sql db:/tmp/shop_seed.sql

docker compose exec db psql -U postgres -d shop

\i /tmp/shop_seed.sql

SELECT * FROM categorys;
SELECT * FROM products;


-- docker-compose 생성 
name: shop

services:
  db:
    container_name: shop-db
    image: postgres:18
    environment:
      POSTGRES_PASSWORD: admin1234
    ports:
      - "5433:5432"
    volumes:
      - pgdata:/var/lib/postgresql

volumes:
  pgdata:


-- shop 데이터베이스 생성 
CREATE DATABASE shop;

-- 유저 테이블 생성 
CREATE TABLE users
(
  user_id   SERIAL      PRIMARY KEY,
  user_name VARCHAR(10) NOT NULL,
  phone     CHAR(13)    NOT NULL, 
  gender    CHAR(1)     NOT NULL,
  region    VARCHAR(10),
);


-- 카테고리 테이블 생성 
CREATE TABLE categories  
(  
    category_id         SERIAL PRIMARY KEY ,  
    category_name       VARCHAR(100) NOT NULL UNIQUE ,  
    description         TEXT  
);

-- 상품 테이블 생성
CREATE TABLE products  
(  
    product_id      SERIAL PRIMARY KEY ,  
    product_name    VARCHAR(200) NOT NULL ,  
    price           NUMERIC(12, 2) NOT NULL DEFAULT 0 CHECK(price >= 0),  
    stock_qty       INT NOT NULL DEFAULT 0 CHECK ( stock_qty >= 0 ),  
    category_id     INT NOT NULL REFERENCES categories (category_id),  
    description     TEXT  
);

-- 장바구니 테이블 생성
CREATE TABLE carts   
(  
    cart_id     SERIAL PRIMARY KEY,  
    user_id     INT NOT NULL,  
    product_id  INT NOT NULL,  
    qty         INT NOT NULL DEFAULT 1 CHECK (qty > 0),  
      
    CONSTRAINT fk_carts_product  
	   FOREIGN KEY (product_id)  
	   REFERENCES products(product_id),  
      
    CONSTRAINT uq_carts_user_product  
       UNIQUE (user_id, product_id)  
);


--------------------------------------------------------------------------------
-- 시드 데이터 작성 
-- 유저 
INSERT INTO users (user_name, phone, gender, region) VALUES
    ('홍길동', '010-1111-1111', '여', '마포구'),
    ('신민아', '010-2222-2222', '여', '마포구'),
    ('주지훈', '010-3333-3333', '남', NULL),
    ('이종석', '010-4444-4444', '남', '마포구'),

-- 카테고리 
INSERT INTO categorys (category_name) VALUES 
    ('식품'), 
    ('주류'), 
    ('냉동식품'), 
    ('과일');

-- 상품 
INSERT INTO products (product_name, price, stock_qty, category_id) VALUES
    ('바나나킥', 1000, 150, 1),
    ('꽈배기', 1500, 100, 1),
    ('참이슬', 2500, 250, 2),
    ('카스', 3000, 0, 2),
    ('냉동김치만두', 17000, 10, 3),
    ('냉동고기만두', 11000, 50, 3),
    ('체리', 25000, 50, 4),
    ('아보카도', 8000, 520, 4);


-- 카트 
INSERT INTO carts (user_id, product_id, qty) VALUES
    (1, 2, 3),
    (1, 4, 20),
    (2, 2, 10),
    (3, 5, 30),
    (3, 3, 10);








