-- vw_funil_oportunidades

CREATE OR ALTER VIEW dbo.vw_funil_oportunidades AS

WITH base AS (
    SELECT
        o.linha,
        vd.regional,
        o.status,
        o.valor_estimado
    FROM dbo.oportunidades o
    INNER JOIN dbo.vendedores vd ON o.vendedor_id = vd.vendedor_id
)
SELECT
    linha,
    regional,
    COUNT(*)                                                              AS total_oportunidades,
    SUM(CASE WHEN status = 'Fechado ganho' THEN 1 ELSE 0 END)            AS ganhos,
    SUM(CASE WHEN status = 'Perdido'       THEN 1 ELSE 0 END)            AS perdidos,
    SUM(CASE WHEN status = 'Negociação'    THEN 1 ELSE 0 END)            AS em_negociacao,
    SUM(CASE WHEN status = 'Proposta'      THEN 1 ELSE 0 END)            AS em_proposta,
    CAST(SUM(CASE WHEN status = 'Fechado ganho' THEN valor_estimado ELSE 0 END) AS DECIMAL(14,2)) AS valor_ganho,
    CAST(
        SUM(CASE WHEN status = 'Fechado ganho' THEN 1.0 ELSE 0 END)
        / NULLIF(SUM(CASE WHEN status IN ('Fechado ganho','Perdido') THEN 1.0 ELSE 0 END), 0)
        * 100
    AS DECIMAL(5,1))                                                     AS taxa_conversao,
    CAST(
        SUM(CASE WHEN status IN ('Negociação','Proposta') THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100
    AS DECIMAL(5,1))                                                     AS pct_em_aberto
FROM base
GROUP BY linha, regional;
GO