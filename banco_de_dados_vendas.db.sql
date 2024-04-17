SELECT * from categorias;
SELECT * FROM produtos;
SELECT * from marcas;
SELECT * from fornecedores;

SELECT COUNT(*) as Qtd_Categorias FROM categorias;
SELECT COUNT(*) as Qtd_Clientes  FROM clientes;
SELECT COUNT(*) as Qtd_Fornecedores  FROM fornecedores;
SELECT COUNT(*) as Qtd_ItensVenda  FROM itens_venda;
SELECT COUNT(*) as Qtd_Marcas  FROM marcas;
SELECT COUNT(*) as Qtd_Produtos  from produtos;
SELECT COUNT(*) as Qtd_Vendas  from vendas;

SELECT * from vendas LIMIT 5;

SELECT DISTINCT(strftime('%Y',data_venda)) as Ano FROM vendas
ORDER BY Ano;

SELECT strftime('%Y', data_venda) as Ano, strftime('%m', data_venda) as Mes, COUNT(id_venda) as Total_vendas
FROM vendas
GROUP by Ano, Mes
ORDER by Ano;

SELECT strftime('%Y', data_venda) as Ano, strftime('%m', data_venda) as Mes, COUNT(id_venda) as Total_vendas
FROM vendas
WHERE Mes = '01'or Mes = '11' or Mes = '12'
GROUP by Ano, Mes
ORDER by Ano;

