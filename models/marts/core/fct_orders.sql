WITH orders AS (
    SELECT 
        *
    FROM {{ ref('stg_orders') }}
),

payments AS (
    SELECT
        *
    FROM {{ ref('stg_payments') }}
),

sum_amount_per_order AS (
    SELECT
        order_id,
        SUM(CASE WHEN status = 'success' then amount END) AS amount
    FROM payments
    GROUP BY order_id

),

final AS (
    SELECT
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        COALESCE(sum_amount_per_order.amount, 0) AS amount
    FROM 
        orders 
            LEFT JOIN 
        sum_amount_per_order ON orders.order_id = sum_amount_per_order.order_id
)

SELECT
    *
FROM final