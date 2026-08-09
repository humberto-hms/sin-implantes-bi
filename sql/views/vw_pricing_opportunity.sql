
--  VIEW | vw_pricing_opportunity

CREATE OR ALTER VIEW dbo.vw_pricing_opportunity AS

WITH desconto_vendedor AS (
    SELECT
        ve.vendedor_id,
        ve.nome,
        ve.regional,
        CAST(SUM(v.desconto) / SUM(v.valor_bruto) * 100 AS DECIMAL(5,2)) AS pct_desconto,
        CAST(SUM(v.valor_liquido) AS DECIMAL(14,2))                      AS receita_liquida,
        CAST(
            (SUM(v.valor_liquido) - SUM(p.custo * v.quantidade))
            / SUM(v.valor_liquido) * 100
        AS DECIMAL(5,2))                                                 AS margem_pct
    FROM dbo.vendas v
    INNER JOIN dbo.vendedores ve ON v.vendedor_id = ve.vendedor_id
    INNER JOIN dbo.produtos   p  ON v.produto_id  = p.produto_id
    GROUP BY ve.vendedor_id, ve.nome, ve.regional
),
percentis AS (
    -- calcula P75 e P90 do desconto sobre todos os vendedores
    SELECT DISTINCT
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY pct_desconto) OVER () AS p75,
        PERCENTILE_CONT(0.90) WITHIN GROUP (ORDER BY pct_desconto) OVER () AS p90
    FROM desconto_vendedor
)
SELECT
    d.vendedor_id,
    d.nome,
    d.regional,
    d.pct_desconto,
    d.margem_pct,
    d.receita_liquida,

    CAST(pc.p75 AS DECIMAL(5,2)) AS limite_p75,
    CAST(pc.p90 AS DECIMAL(5,2)) AS limite_p90,

    -- Classificação semáforo
    CASE
        WHEN d.pct_desconto > pc.p90 THEN '🔴 Pricing Opportunity'
        WHEN d.pct_desconto > pc.p75 THEN '🟡 Atenção'
        ELSE '🟢 Saudável'
    END AS classificacao

FROM desconto_vendedor d
CROSS JOIN percentis pc;
GO