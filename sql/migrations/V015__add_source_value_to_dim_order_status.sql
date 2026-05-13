USE OlistDWH;
GO

-- Migration V015: Add source_value column to dim_order_status.
-- Description: source_value stores the raw lowercase value from the cleansed layer (e.g. 'delivered'),
--              used for FK resolution in fact_sales. status_name remains Title Case for Power BI display.
-- Applied: manually in SSMS

ALTER TABLE mart.dim_order_status
    ADD source_value NVARCHAR(25) NULL;
GO

UPDATE mart.dim_order_status
SET source_value = CASE order_status_key
    WHEN  1 THEN 'created'
    WHEN  2 THEN 'approved'
    WHEN  3 THEN 'invoiced'
    WHEN  4 THEN 'processing'
    WHEN  5 THEN 'shipped'
    WHEN  6 THEN 'delivered'
    WHEN  7 THEN 'canceled'
    WHEN  8 THEN 'unavailable'
END
WHERE order_status_key IN (1, 2, 3, 4, 5, 6, 7, 8);
GO
