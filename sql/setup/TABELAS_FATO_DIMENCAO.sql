
USE SIN_Implantes;
GO

--Clientes
CREATE TABLE dbo.clientes (
    cliente_id       INT            PRIMARY KEY,
    clinica          VARCHAR(100)   NOT NULL,
    regional         VARCHAR(50)    NOT NULL,
    perfil           VARCHAR(30)    NOT NULL,  
    potencial_mensal DECIMAL(12,2)  NOT NULL,
    data_cadastro    DATE           NOT NULL
)

--VENDEDORES 
CREATE TABLE dbo.vendedores (
    vendedor_id        INT           PRIMARY KEY,
    nome               VARCHAR(100)  NOT NULL,
    tipo               VARCHAR(20)   NOT NULL,   
    regional           VARCHAR(50)   NOT NULL,
    supervisor         VARCHAR(100)  NULL,
    gerente_distrital  VARCHAR(100)  NULL,
    tempo_empresa      INT           NOT NULL,   
    senioridade        VARCHAR(20)   NOT NULL   
)

--PRODUTOS 
CREATE TABLE dbo.produtos (
    produto_id  INT           PRIMARY KEY,
    produto     VARCHAR(100)  NOT NULL,
    linha       VARCHAR(50)   NOT NULL,   -- Epikut / Unitite / Strong / Tryon
    preco       DECIMAL(10,2) NOT NULL,
    custo       DECIMAL(10,2) NOT NULL
)

--VENDAS
CREATE TABLE dbo.vendas (
    id_venda      INT             PRIMARY KEY,
    data          DATE            NOT NULL,
    cliente_id    INT             NOT NULL,
    vendedor_id   INT             NOT NULL,
    produto_id    INT             NOT NULL,
    quantidade    INT             NOT NULL,
    valor_bruto   DECIMAL(12,2)   NOT NULL,
    desconto      DECIMAL(10,2)   NOT NULL,
    valor_liquido DECIMAL(12,2)   NOT NULL,

    CONSTRAINT FK_vendas_cliente   FOREIGN KEY (cliente_id)  REFERENCES dbo.clientes(cliente_id),
    CONSTRAINT FK_vendas_vendedor  FOREIGN KEY (vendedor_id) REFERENCES dbo.vendedores(vendedor_id),
    CONSTRAINT FK_vendas_produto   FOREIGN KEY (produto_id)  REFERENCES dbo.produtos(produto_id)
)

-- METAS
CREATE TABLE dbo.metas (
    id_meta     INT IDENTITY(1,1) PRIMARY KEY,  
    mes         VARCHAR(7)    NOT NULL,          
    vendedor_id INT           NOT NULL,
    meta_valor  DECIMAL(12,2) NOT NULL,

    CONSTRAINT FK_metas_vendedor FOREIGN KEY (vendedor_id) REFERENCES dbo.vendedores(vendedor_id)
)

--OPORTUNIDADES 
CREATE TABLE dbo.oportunidades (
    id_oportunidade INT           PRIMARY KEY,
    cliente_id      INT           NOT NULL,
    vendedor_id     INT           NOT NULL,
    data_abertura   DATE          NOT NULL,
    valor_estimado  DECIMAL(12,2) NOT NULL,
    linha           VARCHAR(50)   NOT NULL,
    status          VARCHAR(30)   NOT NULL,  

    CONSTRAINT FK_op_cliente  FOREIGN KEY (cliente_id)  REFERENCES dbo.clientes(cliente_id),
    CONSTRAINT FK_op_vendedor FOREIGN KEY (vendedor_id) REFERENCES dbo.vendedores(vendedor_id)
)

--VISITAS
CREATE TABLE dbo.visitas (
    id_visita   INT           PRIMARY KEY,
    data        DATE          NOT NULL,
    cliente_id  INT           NOT NULL,
    vendedor_id INT           NOT NULL,
    tipo_visita VARCHAR(30)   NOT NULL,  
    objetivo    VARCHAR(50)   NOT NULL,  
    status      VARCHAR(20)   NOT NULL,  

    CONSTRAINT FK_vis_cliente  FOREIGN KEY (cliente_id)  REFERENCES dbo.clientes(cliente_id),
    CONSTRAINT FK_vis_vendedor FOREIGN KEY (vendedor_id) REFERENCES dbo.vendedores(vendedor_id)
);
GO