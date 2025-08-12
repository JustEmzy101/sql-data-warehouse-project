-- Here we test if all data are matching from the gold layer
--Foriegn Key Integrity

SELECT
*
FROM gold.fact_sales fs
LEFT JOIN gold.dim_customers dc
ON fs.customer_id = dc.customer_id
LEFT JOIN gold.dim_products dp
ON fs.product_key = dp.product_key
WHERE fs.product_key IS NULL OR fs.customer_id IS NULL
