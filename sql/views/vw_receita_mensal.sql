
-- vw_receita_mensal


CREATE OR ALTER VIEW dbo.vw_receita_mensal AS

SELECT
    FORMAT(data, 'yyyy-MM')            AS mes_ordem,
    FORMAT(data, 'MMM/yyyy', 'pt-BR')  AS mes_label,
    COUNT(id_venda)                    AS qtd_vendas,
    CAST(SUM(valor_bruto)    AS DECIMAL(12,2))  AS receita_bruta,
    CAST(SUM(desconto)       AS DECIMAL(12,2))  AS total_desconto,
    CAST(SUM(valor_liquido)  AS DECIMAL(12,2))  AS receita_liquida,
    CAST(AVG(valor_liquido)  AS DECIMAL(12,2))  AS ticket_medio

FROM dbo.vendas

GROUP BY
    FORMAT(data, 'yyyy-MM'),
    FORMAT(data, 'MMM/yyyy', 'pt-BR');
