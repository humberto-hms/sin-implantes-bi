GO

-- Validação geral
SELECT 'clientes'     AS tabela, COUNT(*) AS registros FROM dbo.clientes     UNION ALL
SELECT 'vendedores',             COUNT(*)              FROM dbo.vendedores    UNION ALL
SELECT 'produtos',               COUNT(*)              FROM dbo.produtos      UNION ALL
SELECT 'vendas',                 COUNT(*)              FROM dbo.vendas        UNION ALL
SELECT 'metas',                  COUNT(*)              FROM dbo.metas         UNION ALL
SELECT 'oportunidades',          COUNT(*)              FROM dbo.oportunidades UNION ALL
SELECT 'visitas',                COUNT(*)              FROM dbo.visitas;