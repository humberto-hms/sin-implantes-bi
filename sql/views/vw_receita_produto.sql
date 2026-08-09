
--  VIEW | vw_receita_produto
CREATE OR ALTER VIEW dbo.vw_receita_produto AS

WITH vendas_produto AS (
    SELECT
        p.linha,
        COUNT(v.id_venda)                              AS qtd_vendas,
        SUM(v.quantidade)                              AS unidades_vendidas,
        CAST(SUM(v.valor_liquido) AS DECIMAL(12,2))    AS receita_liquida,
        -- custo total = custo unitário × quantidade vendida
        CAST(SUM(p.custo * v.quantidade) AS DECIMAL(12,2)) AS custo_total
    FROM dbo.vendas v
    INNER JOIN dbo.produtos p ON v.produto_id = p.produto_id
    GROUP BY p.linha
)
SELECT
    linha,
    qtd_vendas,
    unidades_vendidas,
    receita_liquida,
    custo_total,

    -- Margem bruta em R$ (receita - custo)
    CAST(receita_liquida - custo_total AS DECIMAL(12,2))  AS margem_bruta,

    -- Margem % (quanto da receita vira lucro)
    CAST((receita_liquida - custo_total) / receita_liquida * 100 AS DECIMAL(5,1)) AS margem_pct,

    -- Participação na receita total
    CAST(receita_liquida / SUM(receita_liquida) OVER () * 100 AS DECIMAL(5,1))    AS pct_receita_total,

    -- Rankings
    RANK() OVER (ORDER BY receita_liquida DESC)                    AS rank_receita,
    RANK() OVER (ORDER BY (receita_liquida - custo_total) DESC)    AS rank_margem

FROM vendas_produto;
GO