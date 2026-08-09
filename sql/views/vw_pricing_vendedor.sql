
--  VIEW | vw_pricing_vendedor

CREATE OR ALTER VIEW dbo.vw_pricing_vendedor AS

SELECT
    ve.vendedor_id,
    ve.nome,
    ve.regional,
    ve.senioridade,

    -- Volume e receita
    COUNT(v.id_venda)                             AS qtd_vendas,
    CAST(SUM(v.valor_liquido) AS DECIMAL(14,2))   AS receita_liquida,

    -- Desconto (média ponderada)
    CAST(SUM(v.desconto) / SUM(v.valor_bruto) * 100 AS DECIMAL(5,2)) AS pct_desconto,

    -- Custo e margem (usa custo do produto)
    CAST(SUM(p.custo * v.quantidade) AS DECIMAL(14,2))               AS custo_total,
    CAST(
        (SUM(v.valor_liquido) - SUM(p.custo * v.quantidade))
        / SUM(v.valor_liquido) * 100
    AS DECIMAL(5,2))                              AS margem_pct,

    -- Margem em R$
    CAST(SUM(v.valor_liquido) - SUM(p.custo * v.quantidade) AS DECIMAL(14,2)) AS margem_bruta

FROM dbo.vendas v
INNER JOIN dbo.vendedores ve ON v.vendedor_id = ve.vendedor_id
INNER JOIN dbo.produtos   p  ON v.produto_id  = p.produto_id
GROUP BY ve.vendedor_id, ve.nome, ve.regional, ve.senioridade;
GO