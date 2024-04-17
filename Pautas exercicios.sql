--número de Clientes que existem na base de dados 
SELECT COUNT(*) AS Qtd_Clientes FROM CLIENTES;

--Quantos produtos foram vendidos no ano de 2022
SELECT COUNT(*) AS Qtd_Produtos, strftime('%Y', data_venda) AS Ano FROM VENDAS WHERE Ano = '2022';

--Categorias que mais vendeu em 2022 
SELECT COUNT(*) AS Qtd_Vendas, c.nome_categoria AS Categoria
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN PRODUTOS p ON p.id_produto = iv.produto_id
JOIN CATEGORIAS c ON c.id_categoria = p.categoria_id
WHERE strftime('%Y', v.data_venda) = '2022'
GROUP BY categoria 
ORDER BY COUNT(*) DESC
;

--Quem foi o fornecedor e quanto foi que ele mais vendeu no ano base(2020)
SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y', v.data_venda) AS Ano, f.nome AS Fornecedor
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN PRODUTOS p ON p.id_produto = iv.produto_id
JOIN FORNECEDORES f ON f.id_fornecedor = p.fornecedor_id
WHERE Ano = '2020'
GROUP BY Fornecedor
ORDER BY COUNT(*) DESC
LIMIT 1
;

--Quais as duas categorias que mais venderam no total de todos os anos 
SELECT COUNT(*) AS Qtd_Vendas, c.nome_categoria AS Categoria
FROM itens_venda iv
JOIN vendas v ON v.id_venda = iv.venda_id
JOIN PRODUTOS p ON p.id_produto = iv.produto_id
JOIN CATEGORIAS c ON c.id_categoria = p.categoria_id
GROUP BY Categoria
ORDER BY COUNT(*) DESC
LIMIT 2;

--Crie uma tabela comparando as vendas ao longo do tempo das duas categorias que mais venderam no total de todos os anos. 
SELECT "Ano/Mês",
SUM(CASE WHEN Categoria=='Eletrônicos' THEN Qtd_Vendas ELSE 0 END) AS Eletrônicos,
SUM(CASE WHEN Categoria=='Vestuário' THEN Qtd_Vendas ELSE 0 END) AS Vestuário
FROM(
    SELECT COUNT(*) AS Qtd_Vendas, strftime('%Y/%m', v.data_venda) AS "Ano/Mês", c.nome_categoria AS Categoria
    FROM itens_venda iv
    JOIN vendas v ON v.id_venda = iv.venda_id
    JOIN PRODUTOS p ON p.id_produto = iv.produto_id
    JOIN CATEGORIAS c ON c.id_categoria = p.categoria_id
    WHERE Categoria IN ('Eletrônicos', 'Vestuário')
    GROUP BY "Ano/Mês", Categoria
    ORDER BY "Ano/Mês", Categoria
)
GROUP BY "Ano/Mês"
;


