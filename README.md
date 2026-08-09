# 📊 SIN Implantes — Portfólio de Business Intelligence 🚧

> Projeto de análise comercial desenvolvido com **SQL Server** e **Power BI**, simulando o ambiente real de uma área de inteligência comercial no setor de implantes odontológicos.

> ⚠️ **Projeto em construção** — a camada SQL está completa; o dashboard no Power BI está em desenvolvimento.

---

## 🚦 Status do Projeto

| Etapa | Status |
|---|---|
| Modelagem do banco de dados (SQL Server) | ✅ Concluído |
| Criação das tabelas (star schema) | ✅ Concluído |
| Carga de dados (BULK INSERT) | ✅ Concluído |
| 8 views analíticas | ✅ Concluído |
| Dashboard no Power BI | 🚧 Em desenvolvimento |
| Documentação final | 🚧 Em desenvolvimento |

---

## 🏢 Contexto do Negócio

A **SIN Implantes** é uma empresa do setor odontológico com atuação nacional, força de vendas estruturada em **6 regionais**, **100 representantes** (força externa e interna) e **4 linhas de produto**. Este projeto analisa o desempenho comercial do **1º semestre de 2025**.

---

## 🎯 Objetivo

Responder perguntas de negócio estratégicas utilizando SQL e visualizá-las em dashboards no Power BI, entregando insights acionáveis para as áreas Comercial, Regional e Diretoria.

---

## 🗂️ Estrutura do Banco de Dados

| Tabela | Descrição | Registros |
|---|---|---|
| `clientes` | Clínicas cadastradas com perfil e regional | 500 |
| `vendedores` | Representantes com hierarquia e senioridade | 100 |
| `produtos` | Portfólio de produtos por linha | 4 |
| `vendas` | Transações comerciais | 20.000 |
| `metas` | Metas mensais por vendedor | 100 |
| `oportunidades` | Pipeline CRM com status | 7.000 |
| `visitas` | Registro de visitas por canal | 9.000 |

---

## ❓ Perguntas de Negócio

| # | Pergunta | View |
|---|---|---|
| 1 | Qual foi a receita líquida total por mês? | `vw_receita_mensal` |
| 2 | Quais regionais mais vendem e qual o gap? | `vw_receita_regional` |
| 3 | Quais vendedores atingiram a meta? | `vw_atingimento_metas` |
| 4 | Qual linha de produto tem maior receita e margem? | `vw_receita_produto` |
| 5 | Qual a taxa de conversão de oportunidades? | `vw_funil_oportunidades` |
| 6 | Como está a atividade de visitas por canal? | `vw_visitas_canal` |
| 7 | Qual o desconto médio por regional? | `vw_desconto_regional` |
| 8 | Qual o perfil de cliente mais lucrativo? | `vw_perfil_cliente` |

---

## 🛠️ Tecnologias

- **SQL Server** — modelagem, ETL e views analíticas
- **Power BI Desktop** — dashboard interativo *(em breve)*
- **T-SQL** — CTEs, window functions, agregações

---

## 📁 Estrutura de Arquivos

```
📦 sin-implantes-bi/
 ┣ 📂 sql/
 ┃ ┣ 📂 setup/          → criação do banco, tabelas e carga
 ┃ ┗ 📂 views/          → 8 views analíticas (P1 a P8)
 ┣ 📂 powerbi/          → dashboard (em breve)
 ┗ README.md
```

---

## 👨‍💼 Sobre

Projeto de portfólio desenvolvido para demonstrar competências de **Análise de BI**: modelagem relacional, escrita de queries analíticas e tradução de dados em insights de negócio.

---

*README provisório — será atualizado com o dashboard completo e insights ao final do projeto.*
