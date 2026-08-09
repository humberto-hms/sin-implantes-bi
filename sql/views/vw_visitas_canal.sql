CREATE OR ALTER VIEW dbo.vw_visitas_canal AS

SELECT
    CASE
        WHEN tipo_visita = 'Presencial' THEN 'Campo'
        ELSE 'Remoto'
    END                                                   AS modalidade,
    tipo_visita                                           AS canal,
    COUNT(*)                                              AS total_visitas,
    SUM(CASE WHEN status = 'Realizada' THEN 1 ELSE 0 END) AS realizadas,
    SUM(CASE WHEN status = 'Pendente'  THEN 1 ELSE 0 END) AS pendentes,
    CAST(
        SUM(CASE WHEN status = 'Realizada' THEN 1.0 ELSE 0 END)
        / COUNT(*) * 100
    AS DECIMAL(5,1))                                      AS taxa_execucao_pct,
    SUM(CASE WHEN objetivo = 'Prospecção' THEN 1 ELSE 0 END) AS obj_prospeccao,
    SUM(CASE WHEN objetivo = 'Negociação' THEN 1 ELSE 0 END) AS obj_negociacao,
    SUM(CASE WHEN objetivo = 'Pós-venda'  THEN 1 ELSE 0 END) AS obj_posvenda,
    COUNT(DISTINCT cliente_id)                            AS clientes_cobertos
FROM dbo.visitas
GROUP BY
    CASE WHEN tipo_visita = 'Presencial' THEN 'Campo' ELSE 'Remoto' END,
    tipo_visita;
GO