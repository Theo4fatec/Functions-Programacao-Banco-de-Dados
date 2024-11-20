-- Active: 1727015344955@@127.0.0.1@5432@20242_fatec_ipi_pbdi_theo@public

--Exercicio 1.1
CREATE OR REPLACE FUNCTION fn_consultar_saldo(IN p_cod_cliente INT, IN p_cod_conta INT)
RETURNS NUMERIC(10, 2)
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo NUMERIC(10, 2);
BEGIN
    SELECT saldo INTO v_saldo FROM tb_conta WHERE tb_conta.cod_cliente = p_cod_cliente AND tb_conta.cod_conta= p_cod_conta;
    RETURN v_saldo;
END;
$$;

