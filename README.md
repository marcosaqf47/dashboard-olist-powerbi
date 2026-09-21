# Dashboard de Vendas Olist

Dashboard interativo em Power BI com análise completa das vendas do marketplace Olist, cobrindo visão geral do negócio, distribuição geográfica e performance operacional.

## Sobre o projeto

Este projeto analisa dados públicos do Olist, um dos maiores marketplaces de e-commerce do Brasil, com foco em:

- Faturamento e volume de pedidos
- Distribuição geográfica das vendas
- Eficiência operacional (entregas, atrasos e avaliações)

O objetivo é transformar dados brutos em insights acionáveis para apoiar decisões de negócio.

## Tecnologias utilizadas

- Power BI Desktop
- DAX (medidas e colunas calculadas)
- Power Query (ETL e modelagem de dados)
- Dataset público Olist (Kaggle)

## Estrutura do dashboard

O relatório é dividido em 3 páginas:

### 1. Visão Geral
- KPIs principais: faturamento, pedidos, ticket médio e avaliação média
- Faturamento por categoria de produto
- Evolução de pedidos e faturamento por mês
- Faturamento por forma de pagamento
- Faturamento por estado
- Tabela de produtos com desempenho

### 2. Geográfico
- Mapa de formas do Brasil com faturamento por estado
- Top 10 estados por faturamento
- Faturamento por região
- Frete médio por estado
- Tempo médio de entrega por estado

### 3. Operação
- KPIs: % de atraso, frete médio, tempo médio de entrega e itens por pedido
- Entregas no prazo vs atrasadas
- Avaliação média por categoria
- Distribuição das notas de avaliação
- Entregas no prazo vs atrasadas por mês
- Média de parcelas por forma de pagamento

## Principais insights

- Concentração de receita: a maior parte do faturamento vem de poucos estados do Sudeste (SP, MG, RJ) e do Sul (PR, RS, SC).
- Sazonalidade: o volume de pedidos varia ao longo do ano, com picos em períodos de campanhas como Black Friday.
- Qualidade da entrega: o percentual de pedidos atrasados e o tempo médio de entrega permitem identificar gargalos logísticos por estado.
- Satisfação do cliente: a distribuição das notas mostra a concentração de avaliações positivas e as categorias com pior desempenho.

## Medidas e colunas criadas

Principais medidas DAX:

- Faturamento
- Pedidos
- Ticket Médio
- Frete Médio
- % Atraso
- Tempo Médio de Entrega (dias)
- Itens por Pedido
- Avaliação Média

Principais colunas calculadas:

- Regiao (Norte, Nordeste, Centro-Oeste, Sudeste, Sul)
- Nome Estado (sigla para nome completo)
- Situacao Entrega (No prazo / Atrasado)
- Nota Aproximada (arredondamento da avaliação)

## Fonte de dados

Dataset público Olist, disponível no Kaggle: Brazilian E-Commerce Public Dataset by Olist. Contém informações de pedidos, pagamentos, avaliações, clientes, vendedores, produtos e geolocalização.

## Como usar

1. Baixe o arquivo .pbix e abra no Power BI Desktop.
2. Navegue pelas páginas: Visão Geral, Geográfico e Operação.
3. Use os filtros de data e categoria para explorar os dados.

## Capturas de tela

<img width="1314" height="743" alt="Captura de tela 2026-09-21 074643" src="https://github.com/user-attachments/assets/61131f5b-b8e2-43e0-b0be-aab9eeceeedb" />
<img width="1318" height="740" alt="Captura de tela 2026-09-21 074801" src="https://github.com/user-attachments/assets/a30129cd-b8fb-4f8e-a622-4dc98ad2ae01" />
<img width="1334" height="749" alt="Captura de tela 2026-09-21 075005" src="https://github.com/user-attachments/assets/4b2e3f6f-a2bc-4263-a6e6-faa0a2bae7e6" />


## Autor

Marcos Antônio - [[link do LinkedIn](https://www.linkedin.com/in/marcos-ant%C3%B4nio-b0131a429/)]
