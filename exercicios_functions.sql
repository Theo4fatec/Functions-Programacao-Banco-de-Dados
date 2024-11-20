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


--Exercicio 1.2
CREATE OR REPLACE FUNCTION fn_transferir(IN p_cod_cliente_remetente INT, p_cod_conta_remetente INT, IN p_cod_cliente_destinatario INT, IN p_cod_conta_destinatario INT, p_valor_transferencia NUMERIC(10, 2)) RETURNS BOOLEAN
LANGUAGE plpgsql
AS $$
DECLARE
    v_saldo_remetente NUMERIC(10, 2);
    v_saldo_destinatario NUMERIC(10, 2);
BEGIN
    SELECT saldo INTO v_saldo_remetente FROM tb_conta WHERE tb_conta.cod_cliente = p_cod_cliente_remetente AND tb_conta.cod_conta = p_cod_conta_remetente;
    SELECT saldo INTO v_saldo_destinatario FROM tb_conta WHERE tb_conta.cod_cliente = p_cod_cliente_destinatario AND tb_conta.cod_conta = p_cod_conta_destinatario;
    IF v_saldo_remetente >= p_valor_transferencia THEN
        UPDATE tb_conta SET saldo = saldo - p_valor_transferencia WHERE tb_conta.cod_cliente = p_cod_cliente_remetente AND tb_conta.cod_conta = p_cod_conta_remetente;
        UPDATE tb_conta SET saldo = saldo + p_valor_transferencia WHERE tb_conta.cod_cliente = p_cod_cliente_destinatario AND tb_conta.cod_conta = p_cod_conta_destinatario;
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END;
$$;


--Exercicio 1.3

--Bloco Anônimo do Exercicio 1.1 - fn_consultar_saldo 
DO
$$
DECLARE
    v_cod_cliente INT := 1;
    v_cod_conta INT := 2;
    v_saldo NUMERIC(10, 2);
BEGIN
    SELECT fn_consultar_saldo(v_cod_cliente, v_cod_conta) INTO v_saldo;
    RAISE NOTICE '%', v_saldo;
END;
$$;


--Bloco Anônimo do Exercicio 1.2 - fn_transferir
DO
$$
DECLARE
    v_cod_cliente_remetente INT := 1;
    v_cod_conta_remetente INT := 2;
    v_cod_cliente_destinatario INT := 2;
    v_cod_conta_destinatario INT := 1;
    v_valor_transferencia NUMERIC(10, 2) := 10.00;
    v_transferencia_finalizada BOOLEAN;
BEGIN
    SELECT fn_transferir(v_cod_cliente_remetente, v_cod_conta_remetente, v_cod_cliente_destinatario, v_cod_conta_destinatario, v_valor_transferencia) INTO v_transferencia_finalizada;
    IF v_transferencia_finalizada THEN
        RAISE NOTICE 'Transferência ocorreu';
    ELSE
        RAISE NOTICE 'Transferência não ocorreu';
    END IF;
END;
$$;

