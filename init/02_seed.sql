-- ユーザーデータ: 100,000件
INSERT INTO users (name, email, age, created_at)
SELECT
    'User_' || i,
    'user' || i || '@example.com',
    18 + (random() * 60)::int,
    CURRENT_TIMESTAMP - (random() * 365)::int * INTERVAL '1 day'
FROM generate_series(1, 100000) AS i;

-- 商品データ: 10,000件
INSERT INTO products (name, price, category, stock, created_at)
SELECT
    'Product_' || i,
    100 + (random() * 9900)::int,
    (ARRAY['Electronics', 'Clothing', 'Food', 'Books', 'Sports'])[1 + (random() * 4)::int],
    (random() * 100)::int,
    CURRENT_TIMESTAMP - (random() * 365)::int * INTERVAL '1 day'
FROM generate_series(1, 10000) AS i;

-- 注文データ: 10,000,000件
INSERT INTO orders (user_id, product_id, quantity, total_price, status, ordered_at)
SELECT
    1 + (random() * 99999)::int,
    1 + (random() * 9999)::int,
    1 + (random() * 5)::int,
    100 + (random() * 50000)::int,
    (ARRAY['pending', 'confirmed', 'shipped', 'delivered', 'cancelled'])[1 + (random() * 4)::int],
    CURRENT_TIMESTAMP - (random() * 180)::int * INTERVAL '1 day'
FROM generate_series(1, 10000000) AS i;

-- アクセスログデータ: 10,000,000件
INSERT INTO access_logs (user_id, path, method, status_code, response_time_ms, accessed_at)
SELECT
    1 + (random() * 99999)::int,
    (ARRAY['/api/users', '/api/products', '/api/orders', '/api/cart', '/api/checkout', '/api/search', '/api/reviews'])[1 + (random() * 6)::int],
    (ARRAY['GET', 'POST', 'PUT', 'DELETE'])[1 + (random() * 3)::int],
    (ARRAY[200, 200, 200, 200, 201, 400, 401, 404, 500])[1 + (random() * 8)::int],
    10 + (random() * 990)::int,
    CURRENT_TIMESTAMP - (random() * 90)::int * INTERVAL '1 day' - (random() * 86400)::int * INTERVAL '1 second'
FROM generate_series(1, 10000000) AS i;

-- レビューデータ: 10,000,000件
INSERT INTO reviews (user_id, product_id, rating, comment, created_at)
SELECT
    1 + (random() * 99999)::int,
    1 + (random() * 9999)::int,
    1 + (random() * 4)::int,
    (ARRAY['Great product!', 'Good value for money.', 'Not bad.', 'Could be better.', 'Excellent quality!', 'Fast delivery.', 'Highly recommended.', 'Average product.', NULL])[1 + (random() * 8)::int],
    CURRENT_TIMESTAMP - (random() * 365)::int * INTERVAL '1 day'
FROM generate_series(1, 10000000) AS i;

-- 統計情報を更新
ANALYZE users;
ANALYZE products;
ANALYZE orders;
ANALYZE access_logs;
ANALYZE reviews;

-- 初期化完了マーカー
CREATE TABLE _init_completed (completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);