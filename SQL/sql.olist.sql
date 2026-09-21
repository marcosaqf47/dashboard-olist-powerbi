CREATE SCHEMA olist;

CREATE TABLE olist.orders (
    order_id VARCHAR(35) PRIMARY KEY,
    customer_id VARCHAR(35),
    order_status VARCHAR(20),
    order_purchase_timestamp TIMESTAMP,
    order_approved_at TIMESTAMP,
    order_delivered_carrier_date TIMESTAMP,
    order_delivered_customer_date TIMESTAMP,
    order_estimated_delivery_date TIMESTAMP
);

CREATE TABLE olist.customers (
    customer_id VARCHAR(35) PRIMARY KEY,
    customer_unique_id VARCHAR(35),
    customer_zip_code_prefix VARCHAR(5),
    customer_city VARCHAR(50),
    customer_state VARCHAR(2)
);

CREATE TABLE olist.sellers (
    seller_id VARCHAR(35) PRIMARY KEY,
    seller_zip_code_prefix VARCHAR(5),
    seller_city VARCHAR(50),
    seller_state VARCHAR(2)
);

CREATE TABLE olist.products (
    product_id VARCHAR(35) PRIMARY KEY,
    product_category_name VARCHAR(60),
    product_name_lenght INT,
    product_description_lenght INT,
    product_photos_qty INT,
    product_weight_g NUMERIC(10,2),
    product_length_cm NUMERIC(10,2),
    product_height_cm NUMERIC(10,2),
    product_width_cm NUMERIC(10,2)
);

CREATE TABLE olist.order_items (
    order_id VARCHAR(35),
    order_item_id INT,
    product_id VARCHAR(35),
    seller_id VARCHAR(35),
    shipping_limit_date TIMESTAMP,
    price NUMERIC(10,2),
    freight_value NUMERIC(10,2),
    PRIMARY KEY (order_id, order_item_id)
);

CREATE TABLE olist.order_payments (
    order_id VARCHAR(35),
    payment_sequential INT,
    payment_type VARCHAR(20),
    payment_installments INT,
    payment_value NUMERIC(10,2),
    PRIMARY KEY (order_id, payment_sequential)
);

CREATE TABLE olist.order_reviews (
    review_id VARCHAR(35),
    order_id VARCHAR(35),
    review_score INT,
    review_comment_title TEXT,
    review_comment_message TEXT,
    review_creation_date TIMESTAMP,
    review_answer_timestamp TIMESTAMP
);

CREATE TABLE olist.product_category_translation (
    product_category_name VARCHAR(60) PRIMARY KEY,
    product_category_name_english VARCHAR(60)
);

-- =============================================
-- PROJETO Olist: QUERIES DE EXPLORACAO (EDA)
-- Objetivo: descobrir os insights que alimentam
-- o dashboard, o README e as propostas de venda
-- =============================================

-- 1. VISAO GERAL: faturamento, pedidos e ticket medio
-- (somente pedidos entregues, que representam venda efetiva)
SELECT
    COUNT(DISTINCT o.order_id) AS total_pedidos,
    COUNT(DISTINCT o.customer_id) AS total_clientes,
    ROUND(SUM(p.payment_value), 2) AS faturamento_total,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS ticket_medio,
    ROUND(AVG(i.price), 2) AS preco_medio_item
FROM olist.orders o
JOIN olist.order_payments p ON p.order_id = o.order_id
LEFT JOIN olist.order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered';

-- 2. SAZONALIDADE: faturamento e pedidos por mes/ano
-- (identifique picos: Black Friday, Natal, periodo de queda)
SELECT
    DATE_TRUNC('month', o.order_purchase_timestamp) AS mes,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(SUM(p.payment_value), 2) AS faturamento
FROM olist.orders o
JOIN olist.order_payments p ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 1;

-- 3. FATURAMENTO POR DIA DA SEMANA
-- (descubra se ha concentracao em dias uteis ou fim de semana)
SELECT
    TO_CHAR(o.order_purchase_timestamp, 'Day') AS dia_semana,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(SUM(p.payment_value), 2) AS faturamento
FROM olist.orders o
JOIN olist.order_payments p ON p.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 3 DESC;

-- 4. TOP 10 CATEGORIAS POR FATURAMENTO
-- (use a traducao para ingles; as categorias principais do dashboard)
SELECT
    COALESCE(t.product_category_name_english, pr.product_category_name) AS categoria,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(SUM(p.payment_value), 2) AS faturamento,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS ticket_medio
FROM olist.orders o
JOIN olist.order_payments p ON p.order_id = o.order_id
JOIN olist.order_items i ON i.order_id = o.order_id
JOIN olist.products pr ON pr.product_id = i.product_id
LEFT JOIN olist.product_category_translation t ON t.product_category_name = pr.product_category_name
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 3 DESC
LIMIT 10;

-- 5. FATURAMENTO E PEDIDOS POR ESTADO
-- (alimenta o mapa do dashboard; note a concentracao em SP, RJ, MG)
SELECT
    c.customer_state AS estado,
    COUNT(DISTINCT o.order_id) AS pedidos,
    ROUND(SUM(p.payment_value), 2) AS faturamento,
    ROUND(SUM(p.payment_value) / COUNT(DISTINCT o.order_id), 2) AS ticket_medio
FROM olist.orders o
JOIN olist.order_payments p ON p.order_id = o.order_id
JOIN olist.customers c ON c.customer_id = o.customer_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 3 DESC;

-- 6. FORMAS DE PAGAMENTO
-- (qual metodo domina, ticket medio por metodo, parcelamento)
SELECT
    payment_type AS forma_pagamento,
    COUNT(DISTINCT order_id) AS pedidos,
    ROUND(SUM(payment_value), 2) AS faturamento,
    ROUND(AVG(payment_installments), 1) AS parcelas_medias
FROM olist.order_payments
GROUP BY 1
ORDER BY 3 DESC;

-- 7. AVALIACAO MEDIA E DISTRIBUICAO DE SCORES
-- (so funciona apos importar a order_reviews; core do KPI de satisfacao)
SELECT
    review_score AS nota,
    COUNT(*) AS quantidade
FROM olist.order_reviews
GROUP BY 1
ORDER BY 1;

SELECT ROUND(AVG(review_score), 2) AS avaliacao_media
FROM olist.order_reviews;

-- 8. AVALIACAO MEDIA POR CATEGORIA
-- (categorias com faturamento alto mas nota baixa = oportunidade)
SELECT
    COALESCE(t.product_category_name_english, pr.product_category_name) AS categoria,
    ROUND(AVG(r.review_score), 2) AS avaliacao_media,
    COUNT(DISTINCT o.order_id) AS pedidos
FROM olist.orders o
JOIN olist.order_items i ON i.order_id = o.order_id
JOIN olist.products pr ON pr.product_id = i.product_id
LEFT JOIN olist.product_category_translation t ON t.product_category_name = pr.product_category_name
JOIN olist.order_reviews r ON r.order_id = o.order_id
GROUP BY 1
HAVING COUNT(DISTINCT o.order_id) > 100
ORDER BY 2 ASC
LIMIT 15;

-- 9. ATRASOS DE ENTREGA
-- (compare prazo estimado com entrega real; base do KPI operacional)
SELECT
    COUNT(*) AS total_entregues,
    SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) AS entregas_atrasadas,
    ROUND(100.0 * SUM(CASE WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0 END) / COUNT(*), 1) AS pct_atraso
FROM olist.orders
WHERE order_status = 'delivered'
  AND order_delivered_customer_date IS NOT NULL;

-- 10. TEMPO MEDIO DE ENTREGA EM DIAS POR ESTADO
-- (estados mais rapidos e mais lentos; relacao com frete)
SELECT
    c.customer_state AS estado,
    ROUND(AVG(EXTRACT(EPOCH FROM (o.order_delivered_customer_date - o.order_purchase_timestamp)) / 86400.0)::numeric, 1) AS dias_ate_entrega,
    ROUND(AVG(i.freight_value), 2) AS frete_medio
FROM olist.orders o
JOIN olist.customers c ON c.customer_id = o.customer_id
JOIN olist.order_items i ON i.order_id = o.order_id
WHERE o.order_status = 'delivered'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

-- 11. VALOR DE FRETE: media geral e share no valor do pedido
SELECT
    ROUND(AVG(freight_value), 2) AS frete_medio,
    ROUND(SUM(freight_value), 2) AS frete_total
FROM olist.order_items;

-- 12. TOP 10 PRODUTOS POR FATURAMENTO
SELECT
    i.product_id,
    COALESCE(t.product_category_name_english, pr.product_category_name) AS categoria,
    COUNT(DISTINCT i.order_id) AS pedidos,
    ROUND(SUM(i.price), 2) AS faturamento
FROM olist.order_items i
JOIN olist.products pr ON pr.product_id = i.product_id
LEFT JOIN olist.product_category_translation t ON t.product_category_name = pr.product_category_name
GROUP BY 1, 2
ORDER BY 4 DESC
LIMIT 10;

-- 13. RECORRENCIA: quantos clientes compraram mais de uma vez
-- (compras por cliente unico; insight de fidelidade)
SELECT
    compras_por_cliente,
    COUNT(*) AS quantidade_clientes
FROM (
    SELECT customer_unique_id, COUNT(DISTINCT order_id) AS compras_por_cliente
    FROM olist.orders o
    JOIN olist.customers c ON c.customer_id = o.customer_id
    GROUP BY 1
) sub
GROUP BY 1
ORDER BY 1;

-- 14. STATUS DOS PEDIDOS: distribuicao geral
SELECT
    order_status,
    COUNT(*) AS quantidade,
    ROUND(100.0 * COUNT(*) / SUM(COUNT(*)) OVER (), 1) AS pct
FROM olist.orders
GROUP BY 1
ORDER BY 2 DESC;

-- =============================================
-- VIEWS CONSOLIDADAS PARA O POWER BI
-- vw_vendas  : 1 linha por pedido (fato)
-- vw_produtos: 1 linha por item (suporte a categoria/produto)
-- =============================================

CREATE OR REPLACE VIEW olist.vw_vendas AS
WITH pagamentos AS (
    SELECT
        order_id,
        SUM(payment_value) AS total_pago,
        (array_agg(payment_type ORDER BY payment_sequential))[1] AS forma_pagamento_principal,
        ROUND(AVG(payment_installments), 1) AS parcelas_media
    FROM olist.order_payments
    GROUP BY order_id
),
itens AS (
    SELECT
        order_id,
        COUNT(*) AS num_itens,
        SUM(price) AS valor_itens,
        SUM(freight_value) AS frete_total,
        COUNT(DISTINCT seller_id) AS num_vendedores,
        COUNT(DISTINCT product_id) AS num_produtos
    FROM olist.order_items
    GROUP BY order_id
),
avaliacoes AS (
    SELECT
        order_id,
        ROUND(AVG(review_score), 2) AS avaliacao_media
    FROM olist.order_reviews
    GROUP BY order_id
),
categoria_principal AS (
    -- categoria do item de maior valor de cada pedido
    SELECT DISTINCT ON (i.order_id)
        i.order_id,
        COALESCE(t.product_category_name_english, pr.product_category_name) AS categoria_principal
    FROM olist.order_items i
    JOIN olist.products pr ON pr.product_id = i.product_id
    LEFT JOIN olist.product_category_translation t ON t.product_category_name = pr.product_category_name
    ORDER BY i.order_id, i.price DESC
)
SELECT
    o.order_id,
    o.order_status,
    o.order_purchase_timestamp AS data_pedido,
    o.order_approved_at AS data_aprovacao,
    o.order_delivered_customer_date AS data_entrega,
    o.order_estimated_delivery_date AS data_estimada,
    CASE WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
         THEN 1 ELSE 0 END AS flag_atraso,
    c.customer_unique_id,
    c.customer_city,
    c.customer_state,
    COALESCE(pag.total_pago, 0) AS total_pago,
    pag.forma_pagamento_principal,
    pag.parcelas_media,
    COALESCE(it.num_itens, 0) AS num_itens,
    COALESCE(it.valor_itens, 0) AS valor_itens,
    COALESCE(it.frete_total, 0) AS frete_total,
    it.num_vendedores,
    it.num_produtos,
    av.avaliacao_media,
    cp.categoria_principal
FROM olist.orders o
LEFT JOIN olist.customers c ON c.customer_id = o.customer_id
LEFT JOIN pagamentos pag ON pag.order_id = o.order_id
LEFT JOIN itens it ON it.order_id = o.order_id
LEFT JOIN avaliacoes av ON av.order_id = o.order_id
LEFT JOIN categoria_principal cp ON cp.order_id = o.order_id;

CREATE OR REPLACE VIEW olist.vw_produtos AS
SELECT
    i.order_id,
    i.order_item_id,
    i.product_id,
    pr.product_category_name,
    COALESCE(t.product_category_name_english, pr.product_category_name) AS categoria,
    i.seller_id,
    i.price,
    i.freight_value,
    i.shipping_limit_date
FROM olist.order_items i
JOIN olist.products pr ON pr.product_id = i.product_id
LEFT JOIN olist.product_category_translation t ON t.product_category_name = pr.product_category_name;

--Validação
SELECT COUNT(*) FROM olist.vw_vendas;
-- esperado: ~99.441 (mesmo total de orders)

SELECT COUNT(*) FROM olist.vw_produtos;
-- esperado: ~112.650 (mesmo total de order_items)

SELECT order_id, data_pedido, total_pago, num_itens, valor_itens, frete_total, avaliacao_media, categoria_principal
FROM olist.vw_vendas LIMIT 10;

