-- Papel dos fornecedores na Black Friday
SELECT sum(Qtd_Vendas)
from (
  SELECT strftime('%Y/%m',v.data_venda) as "Ano/Mes", f.nome as Nome_fornecedor, COUNT(iv.produto_id) as Qtd_Vendas
  from itens_venda iv
  Join vendas v on v.id_venda = iv.venda_id
  join produtos p on p.id_produto = iv.produto_id
  join fornecedores f on f.id_fornecedor = p.fornecedor_id
  -- WHERE strftime('%m', data_venda) = '11'
  GROUP BY Nome_fornecedor, "Ano/Mes"
  ORDER By "Ano/Mes", Qtd_Vendas
  )
;

-- Categorias de produtos na Black Friday
SELECT strftime('%Y/%m', v.data_venda) as "Ano/Mes", c.nome_categoria as Nome_categoria, COUNT(iv.produto_id) as Qtd_Vendas
FROM itens_venda iv
join vendas v on v.id_venda = iv.venda_id
join produtos p on p.id_produto = iv.produto_id
join categorias c on c.id_categoria = p.categoria_id
WHERE strftime('%m', data_venda) = '11'
GROUP by Nome_categoria, "Ano/Mes"
ORDER By "Ano/Mes", Qtd_vendas
;

-- Pior perfomance na ultima black friday
SELECT strftime('%Y/%m',v.data_venda) as "Ano/Mes", COUNT(iv.produto_id) as Qtd_Vendas, f.nome as Nome_fornecedor
from itens_venda iv
Join vendas v on v.id_venda = iv.venda_id
join produtos p on p.id_produto = iv.produto_id
join fornecedores f on f.id_fornecedor = p.fornecedor_id
WHERE Nome_fornecedor = 'NebulaNetworks'
GROUP BY Nome_fornecedor, "Ano/Mes"
ORDER By "Ano/Mes", Qtd_Vendas
;

-- Consultas de um ou mais fornecedores para comparar 
SELECT "Ano/Mes",
       SUM(CASE WHEN Nome_fornecedor = 'NebulaNetworks' THEN Qtd_Vendas ELSE 0 END) AS Qtd_Vendas_NebulaNetworks,
       SUM(CASE WHEN Nome_fornecedor = 'HorizonDistributors' THEN Qtd_Vendas ELSE 0 END) AS Qtd_Vendas_HorizonDistributors,
       SUM(CASE WHEN Nome_fornecedor = 'AstroSupply' THEN Qtd_Vendas ELSE 0 END) AS Qtd_Vendas_AstroSupply,
       SUM(CASE WHEN Nome_fornecedor = 'InfinityImports' THEN Qtd_Vendas ELSE 0 END) AS Qtd_Vendas_InfinityImports
FROM (
    SELECT strftime('%Y/%m', v.data_venda) AS "Ano/Mes",
           COUNT(iv.produto_id) AS Qtd_Vendas,
           f.nome AS Nome_fornecedor
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
    WHERE Nome_fornecedor IN ('NebulaNetworks', 'HorizonDistributors', 'AstroSupply', 'InfinityImports')
    GROUP BY Nome_fornecedor, "Ano/Mes"
    ORDER BY "Ano/Mes", Qtd_Vendas
)
GROUP BY "Ano/Mes"
ORDER BY "Ano/Mes"
;

--Retorna total 
SELECT COUNT(iv.produto_id) as Qtd_Vendas
from itens_venda iv
;

-- Porcentagem das Categorias 
SELECT Nome_categoria, Qtd_vendas, ROUND(100.0*Qtd_Vendas/(SELECT COUNT(*) from itens_venda), 2) || '%' as Porcentagem
FROM(
    SELECT c.nome_categoria as Nome_categoria, COUNT(iv.produto_id) as Qtd_Vendas
    FROM itens_venda iv
    join vendas v on v.id_venda = iv.venda_id
    join produtos p on p.id_produto = iv.produto_id
    join categorias c on c.id_categoria = p.categoria_id
    GROUP by Nome_categoria
    ORDER By Qtd_vendas DESC
  )
  ;
  
 -- Porcentagem fornecedor
 SELECT Nome_Fornecedor, Qtd_Vendas, ROUND(100.0 * Qtd_Vendas / (SELECT COUNT(*) FROM itens_venda), 2) || '%' AS Porcentagem
FROM(
    SELECT f.nome AS Nome_Fornecedor, COUNT(iv.produto_id) AS Qtd_Vendas
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN produtos p ON p.id_produto = iv.produto_id
    JOIN fornecedores f ON f.id_fornecedor = p.fornecedor_id
    GROUP BY Nome_Fornecedor
    ORDER BY Qtd_Vendas DESC
    )
;

--Quadro geral
SELECT Mes,
  SUM(Case when Ano='2020' then Qtd_Vendas else 0 end) as "2020",
  SUM(Case when Ano='2021' then Qtd_Vendas else 0 end) as "2021",
  SUM(Case when Ano='2022' then Qtd_Vendas else 0 end) as "2022",
  SUM(Case when Ano='2023' then Qtd_Vendas else 0 end) as "2023"
from(
  SELECT strftime('%m', data_venda) as Mes, strftime('%Y', data_venda) as Ano, COUNT(*) as Qtd_Vendas
  FROM vendas
  GROUP by Mes, Ano
  order by Mes
  )
group by Mes
;

-- Métricas 
SELECT AVG(Qtd_Vendas) as Media_Qtd_Vendas
from (
  SELECT COUNT(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
  from vendas v
  WHERE strftime('%m', v.data_venda) = '11' and Ano != '2022'
  GROUP By Ano
)
;

SELECT Qtd_Vendas as Qtd_Vendas_Atual
from(
  SELECT COUNT(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
  from vendas v
  WHERE strftime('%m', v.data_venda) = '11' and Ano = '2022'
  GROUP By Ano
)
;

with Media_Vendas_Anteriores AS (SELECT AVG(Qtd_Vendas) as Media_Qtd_Vendas
    from (
      SELECT COUNT(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
      from vendas v
      WHERE strftime('%m', v.data_venda) = '11' and Ano != '2022'
      GROUP By Ano
    )), Vendas_Atual as (SELECT Qtd_Vendas as Qtd_Vendas_Atual
    from(
      SELECT COUNT(*) as Qtd_Vendas, strftime('%Y', v.data_venda) as Ano
      from vendas v
      WHERE strftime('%m', v.data_venda) = '11' and Ano = '2022'
      GROUP By Ano
    ))
    SELECT mva.Media_Qtd_Vendas,
    va.Qtd_Vendas_Atual,
    ROUND((va.Qtd_Vendas_Atual - mva.Media_Qtd_Vendas)/mva.Media_Qtd_Vendas *100.0, 2) || '%' as Porcentagem
    From Vendas_Atual va, Media_Vendas_Anteriores mva





