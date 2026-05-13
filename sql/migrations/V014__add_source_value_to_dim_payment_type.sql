USE OlistDWH;
GO

-- Migration V014: Add source_value column to dim_payment_type + normalize payment_type_name to Title Case.
-- Description: source_value stores the raw snake_case value from the cleansed layer (e.g. 'credit_card'),
--              used for FK resolution in fact_payments. payment_type_name is updated to a human-readable
--              Title Case label (e.g. 'Credit Card') for Power BI display.
-- Applied: manually in SSMS

ALTER TABLE mart.dim_payment_type
    ADD source_value NVARCHAR(25) NULL;
GO

UPDATE mart.dim_payment_type
SET
    source_value      = payment_type_name,
    payment_type_name = CASE payment_type_key
        WHEN -1 THEN 'UNKNOWN'
        WHEN  1 THEN 'Credit Card'
        WHEN  2 THEN 'Boleto'
        WHEN  3 THEN 'Voucher'
        WHEN  4 THEN 'Debit Card'
        WHEN  5 THEN 'Not Defined'
    END
WHERE payment_type_key IN (-1, 1, 2, 3, 4, 5);
GO
