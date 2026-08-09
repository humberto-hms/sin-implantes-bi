
--  VIEW | vw_price_leakage


CREATE OR ALTER VIEW dbo.vw_price_leakage AS

SELECT
    p.linha,
    ve.regional,

    SUM(v.quantidade)                                       AS unidades,

    -- Receita IDEAL: se tudo fosse vendido a preço de tabela
    CAST(SUM(p.preco * v.quantidade) AS DECIMAL(14,2))      AS receita_potencial,

    -- Receita REAL: o que efetivamente entrou
    CAST(SUM(v.valor_liquido) AS DECIMAL(14,2))             AS receita_real,

    -- PRICE LEAKAGE: diferença (dinheiro deixado na mesa)
    CAST(SUM(p.preco * v.quantidade) - SUM(v.valor_liquido) AS DECIMAL(14,2)) AS price_leakage,

    -- Leakage em % da receita potencial
    CAST(
        (SUM(p.preco * v.quantidade) - SUM(v.valor_liquido))
        / SUM(p.preco * v.quantidade) * 100
    AS DECIMAL(5,2))                                        AS leakage_pct,

    RANK() OVER (
        ORDER BY SUM(p.preco * v.quantidade) - SUM(v.valor_liquido) DESC
    )                                                       AS rank_leakage

FROM dbo.vendas v
INNER JOIN dbo.produtos   p  ON v.produto_id  = p.produto_id
INNER JOIN dbo.vendedores ve ON v.vendedor_id = ve.vendedor_id
GROUP BY p.linha, ve.regional;
GO