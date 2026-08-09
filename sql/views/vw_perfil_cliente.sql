
--  VIEW | vw_perfil_cliente


CREATE OR ALTER VIEW dbo.vw_perfil_cliente AS

WITH vendas_cliente AS (
    SELECT
        c.perfil,
        COUNT(DISTINCT c.cliente_id)                  AS qtd_clientes,
        COUNT(v.id_venda)                             AS qtd_vendas,
        CAST(SUM(v.valor_liquido) AS DECIMAL(14,2))   AS receita_liquida,
        CAST(AVG(v.valor_liquido) AS DECIMAL(12,2))   AS ticket_medio
    FROM dbo.clientes c
    LEFT JOIN dbo.vendas v ON c.cliente_id = v.cliente_id
    GROUP BY c.perfil
),
potencial_perfil AS (
    -- potencial mensal médio cadastrado por perfil
    SELECT
        perfil,
        CAST(AVG(potencial_mensal) AS DECIMAL(12,2)) AS potencial_medio_mensal
    FROM dbo.clientes
    GROUP BY perfil
)
SELECT
    vc.perfil,
    vc.qtd_clientes,
    vc.qtd_vendas,
    vc.receita_liquida,
    vc.ticket_medio,

    -- Receita média por cliente (indicador-chave de lucratividade)
    CAST(vc.receita_liquida / vc.qtd_clientes AS DECIMAL(12,2))  AS receita_por_cliente,

    -- Participação na receita total
    CAST(vc.receita_liquida / SUM(vc.receita_liquida) OVER () * 100 AS DECIMAL(5,1)) AS pct_receita_total,

    -- Potencial cadastrado
    pp.potencial_medio_mensal,

    -- Ranking de lucratividade (por receita/cliente)
    RANK() OVER (ORDER BY vc.receita_liquida / vc.qtd_clientes DESC) AS rank_lucratividade

FROM vendas_cliente vc
INNER JOIN potencial_perfil pp ON vc.perfil = pp.perfil;
GO