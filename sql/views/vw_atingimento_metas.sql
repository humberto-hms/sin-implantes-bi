
--  VIEW | vw_atingimento_metas


CREATE OR ALTER VIEW dbo.vw_atingimento_metas AS

WITH realizado AS (
    -- Total vendido por vendedor por mês
    SELECT
        vendedor_id,
        FORMAT(data, 'yyyy-MM')             AS mes,
        CAST(SUM(valor_liquido) AS DECIMAL(12,2)) AS total_realizado
    FROM dbo.vendas
    GROUP BY vendedor_id, FORMAT(data, 'yyyy-MM')
)
SELECT
    -- Identificação
    m.mes,
    v.vendedor_id,
    v.nome,
    v.regional,
    v.senioridade,
    v.gerente_distrital,

    -- Valores
    CAST(m.meta_valor    AS DECIMAL(12,2))  AS meta_valor,
    COALESCE(r.total_realizado, 0)          AS total_realizado,

    -- Atingimento %
    CAST(
        COALESCE(r.total_realizado, 0) / m.meta_valor * 100
    AS DECIMAL(5,1))                        AS pct_atingimento,

    -- Gap (positivo = acima, negativo = abaixo)
    CAST(
        COALESCE(r.total_realizado, 0) - m.meta_valor
    AS DECIMAL(12,2))                       AS gap_meta,

    -- Classificação
    CASE
        WHEN COALESCE(r.total_realizado, 0) >= m.meta_valor * 1.10 THEN 'Superou'
        WHEN COALESCE(r.total_realizado, 0) >= m.meta_valor        THEN 'Atingiu'
        WHEN COALESCE(r.total_realizado, 0) >= m.meta_valor * 0.90 THEN 'Quase'
        ELSE 'Abaixo'
    END                                     AS status_meta,

    -- Ranking dentro da regional no mês
    RANK() OVER (
        PARTITION BY m.mes, v.regional
        ORDER BY COALESCE(r.total_realizado, 0) DESC
    )                                       AS ranking_regional

FROM dbo.metas m
INNER JOIN dbo.vendedores v  ON m.vendedor_id = v.vendedor_id
LEFT  JOIN realizado r       ON m.vendedor_id = r.vendedor_id
                             AND m.mes        = r.mes;
