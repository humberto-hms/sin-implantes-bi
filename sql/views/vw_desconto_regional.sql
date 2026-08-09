
--  VIEW | vw_desconto_regional

CREATE OR ALTER VIEW dbo.vw_desconto_regional AS

SELECT
    vd.regional,

    -- Volume
    COUNT(v.id_venda)                              AS qtd_vendas,

    -- Valores absolutos
    CAST(SUM(v.valor_bruto)   AS DECIMAL(14,2))    AS receita_bruta,
    CAST(SUM(v.desconto)      AS DECIMAL(14,2))    AS total_desconto,
    CAST(SUM(v.valor_liquido) AS DECIMAL(14,2))    AS receita_liquida,

    -- Desconto médio % (peso pelo volume — mais preciso que média simples)
    CAST(
        SUM(v.desconto) / SUM(v.valor_bruto) * 100
    AS DECIMAL(5,2))                               AS pct_desconto_medio,

    -- Ticket médio líquido
    CAST(AVG(v.valor_liquido) AS DECIMAL(12,2))    AS ticket_medio,

    -- Desconto médio por venda em R$
    CAST(AVG(v.desconto) AS DECIMAL(10,2))         AS desconto_medio_venda,

    -- Ranking (quem mais desconta)
    RANK() OVER (ORDER BY SUM(v.desconto) / SUM(v.valor_bruto) DESC) AS rank_desconto

FROM dbo.vendas v
INNER JOIN dbo.vendedores vd ON v.vendedor_id = vd.vendedor_id
GROUP BY vd.regional;
GO