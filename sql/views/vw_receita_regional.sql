
-- vw_receita_regional


CREATE OR ALTER VIEW dbo.vw_receita_regional AS

WITH receita_regional AS (
    SELECT
        vd.regional,
        COUNT(v.id_venda)                        AS qtd_vendas,
        CAST(SUM(v.valor_liquido) AS DECIMAL(12,2))  AS receita_liquida,
        CAST(AVG(v.valor_liquido) AS DECIMAL(12,2))  AS ticket_medio,
        COUNT(DISTINCT v.vendedor_id)            AS qtd_vendedores
    FROM dbo.vendas v
    INNER JOIN dbo.vendedores vd ON v.vendedor_id = vd.vendedor_id
    GROUP BY vd.regional
),
clientes_regional AS (
    -- clientes cadastrados por regional (fonte correta)
    SELECT regional, COUNT(cliente_id) AS clientes_cadastrados
    FROM dbo.clientes
    GROUP BY regional
)
SELECT
    r.regional,
    r.qtd_vendas,
    r.receita_liquida,
    r.ticket_medio,
    c.clientes_cadastrados,                     
    r.qtd_vendedores,
    CAST(r.receita_liquida / r.qtd_vendedores AS DECIMAL(12,2))              AS receita_por_vendedor,
    RANK() OVER (ORDER BY r.receita_liquida DESC)                             AS ranking,
    CAST(r.receita_liquida / SUM(r.receita_liquida) OVER () * 100 AS DECIMAL(5,1)) AS pct_total,
    CAST(MAX(r.receita_liquida) OVER () - r.receita_liquida AS DECIMAL(12,2)) AS gap_para_lider
FROM receita_regional r
INNER JOIN clientes_regional c ON r.regional = c.regional;
GO