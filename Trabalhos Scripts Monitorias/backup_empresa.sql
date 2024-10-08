toc.dat                                                                                             0000600 0004000 0002000 00000056766 14605045620 0014465 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        PGDMP   7    6                |            empresa    13.13    16.0 F    !           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false         "           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false         #           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false         $           1262    24586    empresa    DATABASE     ~   CREATE DATABASE empresa WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';
    DROP DATABASE empresa;
                postgres    false                     2615    24587    loja01    SCHEMA        CREATE SCHEMA loja01;
    DROP SCHEMA loja01;
                postgres    false         %           0    0    SCHEMA loja01    ACL     %   GRANT ALL ON SCHEMA loja01 TO user1;
                   postgres    false    8         �            1255    32883 <   fn_categoria(integer, character varying, integer, character)    FUNCTION     �  CREATE FUNCTION loja01.fn_categoria(p_id_categoria integer, p_descricao character varying, p_flag integer, p_opcao character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE 
    	v_id_categoria loja01.tb_categoria.id_categoria%TYPE;
    BEGIN
    	IF p_opcao = 'I' THEN
        	SELECT nextval('loja01.sq_categoria') INTO v_id_categoria;
            INSERT INTO loja01.tb_categoria(id_categoria,ds_categoria,
            fg_ativo) VALUES (v_id_categoria, p_descricao, p_flag);
            RETURN v_id_categoria;        
        ELSIF p_opcao = 'U' THEN
        	UPDATE loja01.tb_categoria SET ds_categoria = p_descricao 
            WHERE id_categoria = p_id_categoria;
        	RETURN v_id_categoria;
        ELSIF p_opcao = 'D' THEN
        	DELETE FROM loja01.tb_categoria 
            WHERE id_categoria = p_id_categoria;
            RETURN 0;
        ELSE
        	RETURN 100;
        END IF;
        EXCEPTION WHEN OTHERS THEN RETURN -1;
    END  
$$;
 }   DROP FUNCTION loja01.fn_categoria(p_id_categoria integer, p_descricao character varying, p_flag integer, p_opcao character);
       loja01          postgres    false    8         �            1259    24588    sq_pk_tb_cliente    SEQUENCE     y   CREATE SEQUENCE loja01.sq_pk_tb_cliente
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE loja01.sq_pk_tb_cliente;
       loja01          postgres    false    8         �            1259    24590 
   tb_cliente    TABLE     F  CREATE TABLE loja01.tb_cliente (
    id_cliente integer DEFAULT nextval('loja01.sq_pk_tb_cliente'::regclass) NOT NULL,
    titulo character(4),
    nome character varying(32) NOT NULL,
    sobrenome character varying(32) NOT NULL,
    endereco character varying(62) NOT NULL,
    numero character varying(5) NOT NULL,
    complemento character varying(62),
    cep character varying(10),
    cidade character varying(62) NOT NULL,
    estado character(2) NOT NULL,
    fone_fixo character varying(15) NOT NULL,
    fone_movel character varying(15) NOT NULL,
    fg_ativo integer
);
    DROP TABLE loja01.tb_cliente;
       loja01         heap    postgres    false    203    8         �            1255    32884    fn_cliente_estado(character)    FUNCTION     �   CREATE FUNCTION loja01.fn_cliente_estado(pestado character) RETURNS SETOF loja01.tb_cliente
    LANGUAGE sql
    AS $$
SELECT *
FROM loja01.tb_cliente
WHERE estado = pestado;
$$;
 ;   DROP FUNCTION loja01.fn_cliente_estado(pestado character);
       loja01          postgres    false    204    8         �            1255    32897    fn_empregado_auditoria()    FUNCTION     {  CREATE FUNCTION loja01.fn_empregado_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
    	IF(tg_op = 'DELETE') THEN
           	INSERT INTO loja01.tb_empregados_auditoria
            SELECT 'E', user, now(),OLD.*;
            RETURN OLD;
    	ELSIF(tg_op = 'UPDATE') THEN
           	INSERT INTO loja01.tb_empregados_auditoria
            SELECT 'A', user, now(),NEW.*;
            RETURN NEW;
    	ELSIF(tg_op = 'INSERT') THEN
           	INSERT INTO loja01.tb_empregados_auditoria
            SELECT 'I', user, now(),NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL;                   
    END
$$;
 /   DROP FUNCTION loja01.fn_empregado_auditoria();
       loja01          postgres    false    8         �            1255    32875    fn_loop_basico()    FUNCTION     \  CREATE FUNCTION loja01.fn_loop_basico() RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE 
       v_contador integer;
    BEGIN
       v_contador := 0;
       LOOP
          v_contador := v_contador + 1;
          RAISE NOTICE 'Contador: %',v_contador;          
          EXIT WHEN v_contador > 20;
       END LOOP;
       RETURN;
    END;
$$;
 '   DROP FUNCTION loja01.fn_loop_basico();
       loja01          postgres    false    8         �            1255    32869    fn_ret_nome_cliente(integer)    FUNCTION     8  CREATE FUNCTION loja01.fn_ret_nome_cliente(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
	DECLARE 
       v_nome loja01.tb_cliente.nome%TYPE;
    
    BEGIN
       SELECT nome INTO v_nome FROM loja01.tb_cliente WHERE id_cliente = $1;
       RETURN 'Nome do cliente: ' ||v_nome;
    END
$_$;
 3   DROP FUNCTION loja01.fn_ret_nome_cliente(integer);
       loja01          postgres    false    8         �            1255    32871 #   fn_ret_nome_cliente_record(integer)    FUNCTION     �  CREATE FUNCTION loja01.fn_ret_nome_cliente_record(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
	DECLARE 
       v_linha RECORD;    
    BEGIN
       SELECT * INTO v_linha FROM loja01.tb_cliente WHERE id_cliente = $1;
       IF NOT FOUND THEN
       	 RAISE EXCEPTION 'Cliente % não encontrado',$1;
       ELSE
       	 RETURN 'Cliente encontrado!!';
       END IF;
    END
$_$;
 :   DROP FUNCTION loja01.fn_ret_nome_cliente_record(integer);
       loja01          postgres    false    8         �            1255    32870 "   fn_ret_nome_cliente_tupla(integer)    FUNCTION     9  CREATE FUNCTION loja01.fn_ret_nome_cliente_tupla(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
	DECLARE 
       v_tupla loja01.tb_cliente%ROWTYPE;    
    BEGIN
       SELECT * INTO v_tupla FROM loja01.tb_cliente WHERE id_cliente = $1;
       RETURN 'Tupla (linha): ' ||v_tupla;
    END
$_$;
 9   DROP FUNCTION loja01.fn_ret_nome_cliente_tupla(integer);
       loja01          postgres    false    8         �            1255    32867    fn_soma(real, real)    FUNCTION     �   CREATE FUNCTION loja01.fn_soma(pvar1 real, pvar2 real) RETURNS real
    LANGUAGE plpgsql
    AS $$
  BEGIN
  	RETURN pvar1 + pvar2;
  END
$$;
 6   DROP FUNCTION loja01.fn_soma(pvar1 real, pvar2 real);
       loja01          postgres    false    8         �            1255    32868    fn_soma2_ret_string(real, real)    FUNCTION     �   CREATE FUNCTION loja01.fn_soma2_ret_string(pvar1 real, pvar2 real) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    pSoma real;
  BEGIN
    pSoma = pvar1 + pvar2;
  	RETURN 'O valor da soma -> ' || pSoma;
  END
$$;
 B   DROP FUNCTION loja01.fn_soma2_ret_string(pvar1 real, pvar2 real);
       loja01          postgres    false    8         �            1255    32865    fn_teste(real)    FUNCTION     �   CREATE FUNCTION loja01.fn_teste(real) RETURNS real
    LANGUAGE plpgsql
    AS $_$
  DECLARE 
  	v_subtotal ALIAS FOR $1;
  BEGIN
  	RETURN v_subtotal * 0.06;
  END
$_$;
 %   DROP FUNCTION loja01.fn_teste(real);
       loja01          postgres    false    8         �            1255    32866    fn_teste2(real)    FUNCTION     |   CREATE FUNCTION loja01.fn_teste2(real) RETURNS real
    LANGUAGE plpgsql
    AS $_$
  BEGIN
  	RETURN $1 * 0.06;
  END
$_$;
 &   DROP FUNCTION loja01.fn_teste2(real);
       loja01          postgres    false    8         �            1259    32778    sq_pk_tb_item    SEQUENCE     v   CREATE SEQUENCE loja01.sq_pk_tb_item
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE loja01.sq_pk_tb_item;
       loja01          postgres    false    8         �            1259    32780    sq_pk_tb_pedido    SEQUENCE     x   CREATE SEQUENCE loja01.sq_pk_tb_pedido
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE loja01.sq_pk_tb_pedido;
       loja01          postgres    false    8         �            1259    32784    tb_item    TABLE     �   CREATE TABLE loja01.tb_item (
    id_item integer DEFAULT nextval('loja01.sq_pk_tb_item'::regclass) NOT NULL,
    ds_item character varying(64) NOT NULL,
    preco_custo numeric(7,2),
    preco_venda numeric(7,2),
    fg_ativo integer
);
    DROP TABLE loja01.tb_item;
       loja01         heap    postgres    false    205    8         �            1259    32801    tb_item_pedido    TABLE     }   CREATE TABLE loja01.tb_item_pedido (
    id_item integer NOT NULL,
    id_pedido integer NOT NULL,
    quantidade integer
);
 "   DROP TABLE loja01.tb_item_pedido;
       loja01         heap    postgres    false    8         �            1259    32790 	   tb_pedido    TABLE       CREATE TABLE loja01.tb_pedido (
    id_pedido integer DEFAULT nextval('loja01.sq_pk_tb_pedido'::regclass) NOT NULL,
    id_cliente integer NOT NULL,
    dt_compra timestamp without time zone,
    dt_entrega timestamp without time zone,
    valor numeric(7,2),
    fg_ativo integer
);
    DROP TABLE loja01.tb_pedido;
       loja01         heap    postgres    false    206    8         �            1259    32835    situacao_cliente    VIEW     y  CREATE VIEW loja01.situacao_cliente AS
 SELECT pedido.id_pedido,
    pedido.id_cliente,
    ( SELECT cliente.nome
           FROM loja01.tb_cliente cliente
          WHERE (cliente.id_cliente = pedido.id_cliente)) AS nome,
    ( SELECT sum(((item_pedido.quantidade)::numeric * item.preco_venda)) AS "Total Pedido"
           FROM loja01.tb_item_pedido item_pedido,
            loja01.tb_item item
          WHERE ((item_pedido.id_item = item.id_item) AND (pedido.id_pedido = item_pedido.id_pedido))
          GROUP BY item_pedido.id_pedido
          ORDER BY item_pedido.id_pedido) AS "Total Pedido"
   FROM loja01.tb_pedido pedido;
 #   DROP VIEW loja01.situacao_cliente;
       loja01          postgres    false    209    204    204    208    208    210    210    210    209    8         �            1259    32840    situacao_cliente_join    VIEW       CREATE VIEW loja01.situacao_cliente_join AS
 SELECT pedido.id_pedido,
    cliente.id_cliente,
    cliente.nome,
    item_pedido.id_item,
    item.ds_item,
    item_pedido.quantidade,
    (item.preco_venda * (item_pedido.quantidade)::numeric) AS valor_total
   FROM (((loja01.tb_pedido pedido
     JOIN loja01.tb_item_pedido item_pedido ON ((pedido.id_pedido = item_pedido.id_pedido)))
     JOIN loja01.tb_cliente cliente ON ((pedido.id_cliente = cliente.id_cliente)))
     JOIN loja01.tb_item item ON ((item_pedido.id_item = item.id_item)));
 (   DROP VIEW loja01.situacao_cliente_join;
       loja01          postgres    false    204    210    210    209    209    208    208    208    204    210    8         �            1259    32876    sq_categoria    SEQUENCE     u   CREATE SEQUENCE loja01.sq_categoria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE loja01.sq_categoria;
       loja01          postgres    false    8         �            1259    32782    sq_pk_tb_estoque    SEQUENCE     y   CREATE SEQUENCE loja01.sq_pk_tb_estoque
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE loja01.sq_pk_tb_estoque;
       loja01          postgres    false    8         �            1259    32878    tb_categoria    TABLE     �   CREATE TABLE loja01.tb_categoria (
    id_categoria integer NOT NULL,
    ds_categoria character varying(40) NOT NULL,
    fg_ativo integer NOT NULL
);
     DROP TABLE loja01.tb_categoria;
       loja01         heap    postgres    false    8         �            1259    32850 
   tb_cidades    TABLE     y   CREATE TABLE loja01.tb_cidades (
    nome character varying(50),
    populacao double precision,
    altitude integer
);
    DROP TABLE loja01.tb_cidades;
       loja01         heap    postgres    false    8         �            1259    32816    tb_codigo_barras    TABLE     k   CREATE TABLE loja01.tb_codigo_barras (
    codigo_barras integer NOT NULL,
    id_item integer NOT NULL
);
 $   DROP TABLE loja01.tb_codigo_barras;
       loja01         heap    postgres    false    8         �            1259    32885    tb_empregados    TABLE     `   CREATE TABLE loja01.tb_empregados (
    nome character varying NOT NULL,
    salario numeric
);
 !   DROP TABLE loja01.tb_empregados;
       loja01         heap    postgres    false    8         �            1259    32891    tb_empregados_auditoria    TABLE     �   CREATE TABLE loja01.tb_empregados_auditoria (
    operacao character(1) NOT NULL,
    usuario character varying NOT NULL,
    dt_hr timestamp without time zone NOT NULL,
    nome character varying NOT NULL,
    salario numeric
);
 +   DROP TABLE loja01.tb_empregados_auditoria;
       loja01         heap    postgres    false    8         �            1259    32824 
   tb_estoque    TABLE     �   CREATE TABLE loja01.tb_estoque (
    id_item integer DEFAULT nextval('loja01.sq_pk_tb_estoque'::regclass) NOT NULL,
    quantidade integer
);
    DROP TABLE loja01.tb_estoque;
       loja01         heap    postgres    false    207    8         �            1259    32872    tb_log    TABLE     j   CREATE TABLE loja01.tb_log (
    nome character varying(30),
    data_hora timestamp without time zone
);
    DROP TABLE loja01.tb_log;
       loja01         heap    postgres    false    8         �            1259    32901    users    TABLE     o   CREATE TABLE loja01.users (
    id integer NOT NULL,
    name character varying(50),
    gems numeric(10,0)
);
    DROP TABLE loja01.users;
       loja01         heap    postgres    false    8         �            1259    32899    users_id_seq    SEQUENCE     �   CREATE SEQUENCE loja01.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 #   DROP SEQUENCE loja01.users_id_seq;
       loja01          postgres    false    222    8         &           0    0    users_id_seq    SEQUENCE OWNED BY     =   ALTER SEQUENCE loja01.users_id_seq OWNED BY loja01.users.id;
          loja01          postgres    false    221         t           2604    32904    users id    DEFAULT     d   ALTER TABLE ONLY loja01.users ALTER COLUMN id SET DEFAULT nextval('loja01.users_id_seq'::regclass);
 7   ALTER TABLE loja01.users ALTER COLUMN id DROP DEFAULT;
       loja01          postgres    false    221    222    222                   0    32878    tb_categoria 
   TABLE DATA           L   COPY loja01.tb_categoria (id_categoria, ds_categoria, fg_ativo) FROM stdin;
    loja01          postgres    false    218       3098.dat           0    32850 
   tb_cidades 
   TABLE DATA           ?   COPY loja01.tb_cidades (nome, populacao, altitude) FROM stdin;
    loja01          postgres    false    215       3095.dat           0    24590 
   tb_cliente 
   TABLE DATA           �   COPY loja01.tb_cliente (id_cliente, titulo, nome, sobrenome, endereco, numero, complemento, cep, cidade, estado, fone_fixo, fone_movel, fg_ativo) FROM stdin;
    loja01          postgres    false    204       3086.dat           0    32816    tb_codigo_barras 
   TABLE DATA           B   COPY loja01.tb_codigo_barras (codigo_barras, id_item) FROM stdin;
    loja01          postgres    false    211       3093.dat           0    32885    tb_empregados 
   TABLE DATA           6   COPY loja01.tb_empregados (nome, salario) FROM stdin;
    loja01          postgres    false    219       3099.dat           0    32891    tb_empregados_auditoria 
   TABLE DATA           Z   COPY loja01.tb_empregados_auditoria (operacao, usuario, dt_hr, nome, salario) FROM stdin;
    loja01          postgres    false    220       3100.dat           0    32824 
   tb_estoque 
   TABLE DATA           9   COPY loja01.tb_estoque (id_item, quantidade) FROM stdin;
    loja01          postgres    false    212       3094.dat           0    32784    tb_item 
   TABLE DATA           W   COPY loja01.tb_item (id_item, ds_item, preco_custo, preco_venda, fg_ativo) FROM stdin;
    loja01          postgres    false    208       3090.dat           0    32801    tb_item_pedido 
   TABLE DATA           H   COPY loja01.tb_item_pedido (id_item, id_pedido, quantidade) FROM stdin;
    loja01          postgres    false    210       3092.dat           0    32872    tb_log 
   TABLE DATA           1   COPY loja01.tb_log (nome, data_hora) FROM stdin;
    loja01          postgres    false    216       3096.dat           0    32790 	   tb_pedido 
   TABLE DATA           b   COPY loja01.tb_pedido (id_pedido, id_cliente, dt_compra, dt_entrega, valor, fg_ativo) FROM stdin;
    loja01          postgres    false    209       3091.dat           0    32901    users 
   TABLE DATA           /   COPY loja01.users (id, name, gems) FROM stdin;
    loja01          postgres    false    222       3102.dat '           0    0    sq_categoria    SEQUENCE SET     ;   SELECT pg_catalog.setval('loja01.sq_categoria', 1, false);
          loja01          postgres    false    217         (           0    0    sq_pk_tb_cliente    SEQUENCE SET     >   SELECT pg_catalog.setval('loja01.sq_pk_tb_cliente', 7, true);
          loja01          postgres    false    203         )           0    0    sq_pk_tb_estoque    SEQUENCE SET     ?   SELECT pg_catalog.setval('loja01.sq_pk_tb_estoque', 1, false);
          loja01          postgres    false    207         *           0    0    sq_pk_tb_item    SEQUENCE SET     <   SELECT pg_catalog.setval('loja01.sq_pk_tb_item', 11, true);
          loja01          postgres    false    205         +           0    0    sq_pk_tb_pedido    SEQUENCE SET     =   SELECT pg_catalog.setval('loja01.sq_pk_tb_pedido', 5, true);
          loja01          postgres    false    206         ,           0    0    users_id_seq    SEQUENCE SET     :   SELECT pg_catalog.setval('loja01.users_id_seq', 4, true);
          loja01          postgres    false    221         ~           2606    32829    tb_estoque pk_est_id_item 
   CONSTRAINT     \   ALTER TABLE ONLY loja01.tb_estoque
    ADD CONSTRAINT pk_est_id_item PRIMARY KEY (id_item);
 C   ALTER TABLE ONLY loja01.tb_estoque DROP CONSTRAINT pk_est_id_item;
       loja01            postgres    false    212         v           2606    24595    tb_cliente pk_id_cliente 
   CONSTRAINT     ^   ALTER TABLE ONLY loja01.tb_cliente
    ADD CONSTRAINT pk_id_cliente PRIMARY KEY (id_cliente);
 B   ALTER TABLE ONLY loja01.tb_cliente DROP CONSTRAINT pk_id_cliente;
       loja01            postgres    false    204         x           2606    32789    tb_item pk_id_item 
   CONSTRAINT     U   ALTER TABLE ONLY loja01.tb_item
    ADD CONSTRAINT pk_id_item PRIMARY KEY (id_item);
 <   ALTER TABLE ONLY loja01.tb_item DROP CONSTRAINT pk_id_item;
       loja01            postgres    false    208         z           2606    32795    tb_pedido pk_id_pedido 
   CONSTRAINT     [   ALTER TABLE ONLY loja01.tb_pedido
    ADD CONSTRAINT pk_id_pedido PRIMARY KEY (id_pedido);
 @   ALTER TABLE ONLY loja01.tb_pedido DROP CONSTRAINT pk_id_pedido;
       loja01            postgres    false    209         |           2606    32805    tb_item_pedido pk_item_pedido 
   CONSTRAINT     k   ALTER TABLE ONLY loja01.tb_item_pedido
    ADD CONSTRAINT pk_item_pedido PRIMARY KEY (id_item, id_pedido);
 G   ALTER TABLE ONLY loja01.tb_item_pedido DROP CONSTRAINT pk_item_pedido;
       loja01            postgres    false    210    210         �           2606    32882    tb_categoria tb_categoria_pkey 
   CONSTRAINT     f   ALTER TABLE ONLY loja01.tb_categoria
    ADD CONSTRAINT tb_categoria_pkey PRIMARY KEY (id_categoria);
 H   ALTER TABLE ONLY loja01.tb_categoria DROP CONSTRAINT tb_categoria_pkey;
       loja01            postgres    false    218         �           2606    32906    users users_pkey 
   CONSTRAINT     N   ALTER TABLE ONLY loja01.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);
 :   ALTER TABLE ONLY loja01.users DROP CONSTRAINT users_pkey;
       loja01            postgres    false    222         �           2620    32898 $   tb_empregados tg_empregado_auditoria    TRIGGER     �   CREATE TRIGGER tg_empregado_auditoria AFTER INSERT OR DELETE OR UPDATE ON loja01.tb_empregados FOR EACH ROW EXECUTE FUNCTION loja01.fn_empregado_auditoria();
 =   DROP TRIGGER tg_empregado_auditoria ON loja01.tb_empregados;
       loja01          postgres    false    219    233         �           2606    32819    tb_codigo_barras fk_cod_id_item    FK CONSTRAINT     �   ALTER TABLE ONLY loja01.tb_codigo_barras
    ADD CONSTRAINT fk_cod_id_item FOREIGN KEY (id_item) REFERENCES loja01.tb_item(id_item);
 I   ALTER TABLE ONLY loja01.tb_codigo_barras DROP CONSTRAINT fk_cod_id_item;
       loja01          postgres    false    2936    211    208         �           2606    32830    tb_estoque fk_est_id_item    FK CONSTRAINT        ALTER TABLE ONLY loja01.tb_estoque
    ADD CONSTRAINT fk_est_id_item FOREIGN KEY (id_item) REFERENCES loja01.tb_item(id_item);
 C   ALTER TABLE ONLY loja01.tb_estoque DROP CONSTRAINT fk_est_id_item;
       loja01          postgres    false    212    2936    208         �           2606    32796    tb_pedido fk_ped_id_cliente    FK CONSTRAINT     �   ALTER TABLE ONLY loja01.tb_pedido
    ADD CONSTRAINT fk_ped_id_cliente FOREIGN KEY (id_cliente) REFERENCES loja01.tb_cliente(id_cliente);
 E   ALTER TABLE ONLY loja01.tb_pedido DROP CONSTRAINT fk_ped_id_cliente;
       loja01          postgres    false    2934    204    209         �           2606    32806    tb_item_pedido fk_ped_id_item    FK CONSTRAINT     �   ALTER TABLE ONLY loja01.tb_item_pedido
    ADD CONSTRAINT fk_ped_id_item FOREIGN KEY (id_item) REFERENCES loja01.tb_item(id_item);
 G   ALTER TABLE ONLY loja01.tb_item_pedido DROP CONSTRAINT fk_ped_id_item;
       loja01          postgres    false    210    2936    208         �           2606    32811    tb_item_pedido fk_ped_id_pedido    FK CONSTRAINT     �   ALTER TABLE ONLY loja01.tb_item_pedido
    ADD CONSTRAINT fk_ped_id_pedido FOREIGN KEY (id_pedido) REFERENCES loja01.tb_pedido(id_pedido);
 I   ALTER TABLE ONLY loja01.tb_item_pedido DROP CONSTRAINT fk_ped_id_pedido;
       loja01          postgres    false    2938    209    210                  3098.dat                                                                                            0000600 0004000 0002000 00000000005 14605045620 0014252 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3095.dat                                                                                            0000600 0004000 0002000 00000000005 14605045620 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3086.dat                                                                                            0000600 0004000 0002000 00000002626 14605045620 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	Sr  	Andrei	Junqueira	Rua Tabaiares	1024	\N	30150 040	Belo Horizonte	BH	3676 1209	8876 4543	1
3	Sr  	Alex	Matheus	Rua Eva Terpins	s/n	\N	05327 030	São Paulo	SP	6576 0099	9358 7676	1
4	Sr  	Andre	Lopes	Rua Fortaleza	552	\N	11436 360	Guarujá	SP	5654 4343	9821 4321	1
5	Sr  	Vitor	Silva	Estrada Aguá Chata	s/n	Rodovia 356	07251 000	Guarulhos	SP	4343 6712	831 3411	1
6	Sr  	Claudinei	Safra	Avenida José Osvaldo Marques	1562	\N	14173 010	Sertãozinho	SP	3698 8100	8131 6409	1
7	Sr  	Ricardo	Ferreira	Alameda Assunta Barizani Tienghi	88	\N	18046 705	Sorocaba	SP	6534 7099	9988 1251	1
8	Sra 	Anna	Kelly	Rua das Acacias	1089	\N	13187 042	Hortolândia	SP	6432 440043	9465 0023	1
9	Sra 	Cristiane	Hickman	Rua Agenir Martinhon Scachetti	300	\N	13341 633	Indaiatuba	SP	3512 1243	9987 0001	1
10	Sr  	Marcos	Augusto	Avenida Australia	s/n	\N	06852 100	Itapecerica da Serra	SP	3623 8821	8891 2333	1
11	Sr  	David	Silva	Rua Arcy Prestes Ruggeri	24	Esquina do Mercado	18201 720	Itapetininga	SP	4565 9240	7765 4029	1
12	Sr  	Ricardo	Cunha	Rua Jose Fortunato de Godoy	889	\N	13976 121	Itapira	SP	5467 1959	9244 9584	1
13	Sra 	Laura	Batista	Rua Villa Lobos	76	\N	13976 018	Ribeirão Preto	SP	2111 8710	9991 2324	1
14	Sr  	Valmil	Feliciano	Rua Professor Emilton Amaral	961	Loteamento Novo Horizonte	58053 223	João Pessoa	PB	4431 8740	9766 0033	1
1	Sra 	Jessica	Silva	Avenida Acelino de Leao	89	\N	68900 300	Macapá	MG	3565 1243	8765 8999	1
\.


                                                                                                          3093.dat                                                                                            0000600 0004000 0002000 00000000005 14605045620 0014245 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3099.dat                                                                                            0000600 0004000 0002000 00000000057 14605045620 0014262 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        João	1500.98
Pedro	3452.76
Marta	3745.65
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 3100.dat                                                                                            0000600 0004000 0002000 00000000241 14605045620 0014234 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        I	postgres	2024-03-11 11:33:34.899717	João	1500.98
I	postgres	2024-03-11 11:33:34.899717	Pedro	3452.76
I	postgres	2024-03-11 11:33:34.899717	Marta	3745.65
\.


                                                                                                                                                                                                                                                                                                                                                               3094.dat                                                                                            0000600 0004000 0002000 00000000044 14605045620 0014251 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	12
2	2
4	8
5	3
7	8
8	18
10	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            3090.dat                                                                                            0000600 0004000 0002000 00000000503 14605045620 0014245 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	Quebra-cabeça de Madeira	15.23	21.95	1
2	Cubo X	7.45	11.49	1
3	CD Linux	1.99	2.49	1
4	Tecidos	2.11	3.99	1
5	Moldura	7.54	9.95	1
6	Ventilador Pequeno	9.23	15.75	1
7	Ventilador Grande	13.36	19.95	1
8	Escova de Dentes	0.75	1.45	1
9	Papel A4	2.34	2.45	1
10	Saco de Transporte	0.01	0.00	1
11	Alto-Falantes	19.73	25.32	1
\.


                                                                                                                                                                                             3092.dat                                                                                            0000600 0004000 0002000 00000000116 14605045620 0014247 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        4	1	1
7	1	1
9	1	1
1	2	1
10	2	1
7	2	2
4	2	2
2	3	1
1	3	1
5	4	2
1	5	1
3	5	1
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                  3096.dat                                                                                            0000600 0004000 0002000 00000000005 14605045620 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        \.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                           3091.dat                                                                                            0000600 0004000 0002000 00000000406 14605045620 0014250 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        1	1	2013-03-12 00:00:00	2013-03-17 00:00:00	2.99	1
2	8	2013-06-23 00:00:00	2013-06-24 00:00:00	0.00	1
3	14	2013-02-09 00:00:00	2013-12-09 00:00:00	3.99	1
4	13	2013-03-02 00:00:00	2013-10-09 00:00:00	2.99	1
5	8	2013-07-21 00:00:00	2013-07-21 00:00:00	0.00	1
\.


                                                                                                                                                                                                                                                          3102.dat                                                                                            0000600 0004000 0002000 00000000035 14605045620 0014237 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        2	John	900
1	David	1100
\.


                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   restore.sql                                                                                         0000600 0004000 0002000 00000051306 14605045620 0015373 0                                                                                                    ustar 00postgres                        postgres                        0000000 0000000                                                                                                                                                                        --
-- NOTE:
--
-- File paths need to be edited. Search for $$PATH$$ and
-- replace it with the path to the directory containing
-- the extracted data files.
--
--
-- PostgreSQL database dump
--

-- Dumped from database version 13.13
-- Dumped by pg_dump version 16.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE empresa;
--
-- Name: empresa; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE empresa WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'Portuguese_Brazil.1252';


ALTER DATABASE empresa OWNER TO postgres;

\connect empresa

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: loja01; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA loja01;


ALTER SCHEMA loja01 OWNER TO postgres;

--
-- Name: fn_categoria(integer, character varying, integer, character); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_categoria(p_id_categoria integer, p_descricao character varying, p_flag integer, p_opcao character) RETURNS integer
    LANGUAGE plpgsql
    AS $$
	DECLARE 
    	v_id_categoria loja01.tb_categoria.id_categoria%TYPE;
    BEGIN
    	IF p_opcao = 'I' THEN
        	SELECT nextval('loja01.sq_categoria') INTO v_id_categoria;
            INSERT INTO loja01.tb_categoria(id_categoria,ds_categoria,
            fg_ativo) VALUES (v_id_categoria, p_descricao, p_flag);
            RETURN v_id_categoria;        
        ELSIF p_opcao = 'U' THEN
        	UPDATE loja01.tb_categoria SET ds_categoria = p_descricao 
            WHERE id_categoria = p_id_categoria;
        	RETURN v_id_categoria;
        ELSIF p_opcao = 'D' THEN
        	DELETE FROM loja01.tb_categoria 
            WHERE id_categoria = p_id_categoria;
            RETURN 0;
        ELSE
        	RETURN 100;
        END IF;
        EXCEPTION WHEN OTHERS THEN RETURN -1;
    END  
$$;


ALTER FUNCTION loja01.fn_categoria(p_id_categoria integer, p_descricao character varying, p_flag integer, p_opcao character) OWNER TO postgres;

--
-- Name: sq_pk_tb_cliente; Type: SEQUENCE; Schema: loja01; Owner: postgres
--

CREATE SEQUENCE loja01.sq_pk_tb_cliente
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE loja01.sq_pk_tb_cliente OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: tb_cliente; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_cliente (
    id_cliente integer DEFAULT nextval('loja01.sq_pk_tb_cliente'::regclass) NOT NULL,
    titulo character(4),
    nome character varying(32) NOT NULL,
    sobrenome character varying(32) NOT NULL,
    endereco character varying(62) NOT NULL,
    numero character varying(5) NOT NULL,
    complemento character varying(62),
    cep character varying(10),
    cidade character varying(62) NOT NULL,
    estado character(2) NOT NULL,
    fone_fixo character varying(15) NOT NULL,
    fone_movel character varying(15) NOT NULL,
    fg_ativo integer
);


ALTER TABLE loja01.tb_cliente OWNER TO postgres;

--
-- Name: fn_cliente_estado(character); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_cliente_estado(pestado character) RETURNS SETOF loja01.tb_cliente
    LANGUAGE sql
    AS $$
SELECT *
FROM loja01.tb_cliente
WHERE estado = pestado;
$$;


ALTER FUNCTION loja01.fn_cliente_estado(pestado character) OWNER TO postgres;

--
-- Name: fn_empregado_auditoria(); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_empregado_auditoria() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
	BEGIN
    	IF(tg_op = 'DELETE') THEN
           	INSERT INTO loja01.tb_empregados_auditoria
            SELECT 'E', user, now(),OLD.*;
            RETURN OLD;
    	ELSIF(tg_op = 'UPDATE') THEN
           	INSERT INTO loja01.tb_empregados_auditoria
            SELECT 'A', user, now(),NEW.*;
            RETURN NEW;
    	ELSIF(tg_op = 'INSERT') THEN
           	INSERT INTO loja01.tb_empregados_auditoria
            SELECT 'I', user, now(),NEW.*;
            RETURN NEW;
        END IF;
        RETURN NULL;                   
    END
$$;


ALTER FUNCTION loja01.fn_empregado_auditoria() OWNER TO postgres;

--
-- Name: fn_loop_basico(); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_loop_basico() RETURNS void
    LANGUAGE plpgsql
    AS $$
	DECLARE 
       v_contador integer;
    BEGIN
       v_contador := 0;
       LOOP
          v_contador := v_contador + 1;
          RAISE NOTICE 'Contador: %',v_contador;          
          EXIT WHEN v_contador > 20;
       END LOOP;
       RETURN;
    END;
$$;


ALTER FUNCTION loja01.fn_loop_basico() OWNER TO postgres;

--
-- Name: fn_ret_nome_cliente(integer); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_ret_nome_cliente(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
	DECLARE 
       v_nome loja01.tb_cliente.nome%TYPE;
    
    BEGIN
       SELECT nome INTO v_nome FROM loja01.tb_cliente WHERE id_cliente = $1;
       RETURN 'Nome do cliente: ' ||v_nome;
    END
$_$;


ALTER FUNCTION loja01.fn_ret_nome_cliente(integer) OWNER TO postgres;

--
-- Name: fn_ret_nome_cliente_record(integer); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_ret_nome_cliente_record(integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
	DECLARE 
       v_linha RECORD;    
    BEGIN
       SELECT * INTO v_linha FROM loja01.tb_cliente WHERE id_cliente = $1;
       IF NOT FOUND THEN
       	 RAISE EXCEPTION 'Cliente % não encontrado',$1;
       ELSE
       	 RETURN 'Cliente encontrado!!';
       END IF;
    END
$_$;


ALTER FUNCTION loja01.fn_ret_nome_cliente_record(integer) OWNER TO postgres;

--
-- Name: fn_ret_nome_cliente_tupla(integer); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_ret_nome_cliente_tupla(integer) RETURNS character varying
    LANGUAGE plpgsql
    AS $_$
	DECLARE 
       v_tupla loja01.tb_cliente%ROWTYPE;    
    BEGIN
       SELECT * INTO v_tupla FROM loja01.tb_cliente WHERE id_cliente = $1;
       RETURN 'Tupla (linha): ' ||v_tupla;
    END
$_$;


ALTER FUNCTION loja01.fn_ret_nome_cliente_tupla(integer) OWNER TO postgres;

--
-- Name: fn_soma(real, real); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_soma(pvar1 real, pvar2 real) RETURNS real
    LANGUAGE plpgsql
    AS $$
  BEGIN
  	RETURN pvar1 + pvar2;
  END
$$;


ALTER FUNCTION loja01.fn_soma(pvar1 real, pvar2 real) OWNER TO postgres;

--
-- Name: fn_soma2_ret_string(real, real); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_soma2_ret_string(pvar1 real, pvar2 real) RETURNS character varying
    LANGUAGE plpgsql
    AS $$
  DECLARE 
    pSoma real;
  BEGIN
    pSoma = pvar1 + pvar2;
  	RETURN 'O valor da soma -> ' || pSoma;
  END
$$;


ALTER FUNCTION loja01.fn_soma2_ret_string(pvar1 real, pvar2 real) OWNER TO postgres;

--
-- Name: fn_teste(real); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_teste(real) RETURNS real
    LANGUAGE plpgsql
    AS $_$
  DECLARE 
  	v_subtotal ALIAS FOR $1;
  BEGIN
  	RETURN v_subtotal * 0.06;
  END
$_$;


ALTER FUNCTION loja01.fn_teste(real) OWNER TO postgres;

--
-- Name: fn_teste2(real); Type: FUNCTION; Schema: loja01; Owner: postgres
--

CREATE FUNCTION loja01.fn_teste2(real) RETURNS real
    LANGUAGE plpgsql
    AS $_$
  BEGIN
  	RETURN $1 * 0.06;
  END
$_$;


ALTER FUNCTION loja01.fn_teste2(real) OWNER TO postgres;

--
-- Name: sq_pk_tb_item; Type: SEQUENCE; Schema: loja01; Owner: postgres
--

CREATE SEQUENCE loja01.sq_pk_tb_item
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE loja01.sq_pk_tb_item OWNER TO postgres;

--
-- Name: sq_pk_tb_pedido; Type: SEQUENCE; Schema: loja01; Owner: postgres
--

CREATE SEQUENCE loja01.sq_pk_tb_pedido
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE loja01.sq_pk_tb_pedido OWNER TO postgres;

--
-- Name: tb_item; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_item (
    id_item integer DEFAULT nextval('loja01.sq_pk_tb_item'::regclass) NOT NULL,
    ds_item character varying(64) NOT NULL,
    preco_custo numeric(7,2),
    preco_venda numeric(7,2),
    fg_ativo integer
);


ALTER TABLE loja01.tb_item OWNER TO postgres;

--
-- Name: tb_item_pedido; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_item_pedido (
    id_item integer NOT NULL,
    id_pedido integer NOT NULL,
    quantidade integer
);


ALTER TABLE loja01.tb_item_pedido OWNER TO postgres;

--
-- Name: tb_pedido; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_pedido (
    id_pedido integer DEFAULT nextval('loja01.sq_pk_tb_pedido'::regclass) NOT NULL,
    id_cliente integer NOT NULL,
    dt_compra timestamp without time zone,
    dt_entrega timestamp without time zone,
    valor numeric(7,2),
    fg_ativo integer
);


ALTER TABLE loja01.tb_pedido OWNER TO postgres;

--
-- Name: situacao_cliente; Type: VIEW; Schema: loja01; Owner: postgres
--

CREATE VIEW loja01.situacao_cliente AS
 SELECT pedido.id_pedido,
    pedido.id_cliente,
    ( SELECT cliente.nome
           FROM loja01.tb_cliente cliente
          WHERE (cliente.id_cliente = pedido.id_cliente)) AS nome,
    ( SELECT sum(((item_pedido.quantidade)::numeric * item.preco_venda)) AS "Total Pedido"
           FROM loja01.tb_item_pedido item_pedido,
            loja01.tb_item item
          WHERE ((item_pedido.id_item = item.id_item) AND (pedido.id_pedido = item_pedido.id_pedido))
          GROUP BY item_pedido.id_pedido
          ORDER BY item_pedido.id_pedido) AS "Total Pedido"
   FROM loja01.tb_pedido pedido;


ALTER VIEW loja01.situacao_cliente OWNER TO postgres;

--
-- Name: situacao_cliente_join; Type: VIEW; Schema: loja01; Owner: postgres
--

CREATE VIEW loja01.situacao_cliente_join AS
 SELECT pedido.id_pedido,
    cliente.id_cliente,
    cliente.nome,
    item_pedido.id_item,
    item.ds_item,
    item_pedido.quantidade,
    (item.preco_venda * (item_pedido.quantidade)::numeric) AS valor_total
   FROM (((loja01.tb_pedido pedido
     JOIN loja01.tb_item_pedido item_pedido ON ((pedido.id_pedido = item_pedido.id_pedido)))
     JOIN loja01.tb_cliente cliente ON ((pedido.id_cliente = cliente.id_cliente)))
     JOIN loja01.tb_item item ON ((item_pedido.id_item = item.id_item)));


ALTER VIEW loja01.situacao_cliente_join OWNER TO postgres;

--
-- Name: sq_categoria; Type: SEQUENCE; Schema: loja01; Owner: postgres
--

CREATE SEQUENCE loja01.sq_categoria
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE loja01.sq_categoria OWNER TO postgres;

--
-- Name: sq_pk_tb_estoque; Type: SEQUENCE; Schema: loja01; Owner: postgres
--

CREATE SEQUENCE loja01.sq_pk_tb_estoque
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE loja01.sq_pk_tb_estoque OWNER TO postgres;

--
-- Name: tb_categoria; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_categoria (
    id_categoria integer NOT NULL,
    ds_categoria character varying(40) NOT NULL,
    fg_ativo integer NOT NULL
);


ALTER TABLE loja01.tb_categoria OWNER TO postgres;

--
-- Name: tb_cidades; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_cidades (
    nome character varying(50),
    populacao double precision,
    altitude integer
);


ALTER TABLE loja01.tb_cidades OWNER TO postgres;

--
-- Name: tb_codigo_barras; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_codigo_barras (
    codigo_barras integer NOT NULL,
    id_item integer NOT NULL
);


ALTER TABLE loja01.tb_codigo_barras OWNER TO postgres;

--
-- Name: tb_empregados; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_empregados (
    nome character varying NOT NULL,
    salario numeric
);


ALTER TABLE loja01.tb_empregados OWNER TO postgres;

--
-- Name: tb_empregados_auditoria; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_empregados_auditoria (
    operacao character(1) NOT NULL,
    usuario character varying NOT NULL,
    dt_hr timestamp without time zone NOT NULL,
    nome character varying NOT NULL,
    salario numeric
);


ALTER TABLE loja01.tb_empregados_auditoria OWNER TO postgres;

--
-- Name: tb_estoque; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_estoque (
    id_item integer DEFAULT nextval('loja01.sq_pk_tb_estoque'::regclass) NOT NULL,
    quantidade integer
);


ALTER TABLE loja01.tb_estoque OWNER TO postgres;

--
-- Name: tb_log; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.tb_log (
    nome character varying(30),
    data_hora timestamp without time zone
);


ALTER TABLE loja01.tb_log OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: loja01; Owner: postgres
--

CREATE TABLE loja01.users (
    id integer NOT NULL,
    name character varying(50),
    gems numeric(10,0)
);


ALTER TABLE loja01.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: loja01; Owner: postgres
--

CREATE SEQUENCE loja01.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE loja01.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: loja01; Owner: postgres
--

ALTER SEQUENCE loja01.users_id_seq OWNED BY loja01.users.id;


--
-- Name: users id; Type: DEFAULT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.users ALTER COLUMN id SET DEFAULT nextval('loja01.users_id_seq'::regclass);


--
-- Data for Name: tb_categoria; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_categoria (id_categoria, ds_categoria, fg_ativo) FROM stdin;
\.
COPY loja01.tb_categoria (id_categoria, ds_categoria, fg_ativo) FROM '$$PATH$$/3098.dat';

--
-- Data for Name: tb_cidades; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_cidades (nome, populacao, altitude) FROM stdin;
\.
COPY loja01.tb_cidades (nome, populacao, altitude) FROM '$$PATH$$/3095.dat';

--
-- Data for Name: tb_cliente; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_cliente (id_cliente, titulo, nome, sobrenome, endereco, numero, complemento, cep, cidade, estado, fone_fixo, fone_movel, fg_ativo) FROM stdin;
\.
COPY loja01.tb_cliente (id_cliente, titulo, nome, sobrenome, endereco, numero, complemento, cep, cidade, estado, fone_fixo, fone_movel, fg_ativo) FROM '$$PATH$$/3086.dat';

--
-- Data for Name: tb_codigo_barras; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_codigo_barras (codigo_barras, id_item) FROM stdin;
\.
COPY loja01.tb_codigo_barras (codigo_barras, id_item) FROM '$$PATH$$/3093.dat';

--
-- Data for Name: tb_empregados; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_empregados (nome, salario) FROM stdin;
\.
COPY loja01.tb_empregados (nome, salario) FROM '$$PATH$$/3099.dat';

--
-- Data for Name: tb_empregados_auditoria; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_empregados_auditoria (operacao, usuario, dt_hr, nome, salario) FROM stdin;
\.
COPY loja01.tb_empregados_auditoria (operacao, usuario, dt_hr, nome, salario) FROM '$$PATH$$/3100.dat';

--
-- Data for Name: tb_estoque; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_estoque (id_item, quantidade) FROM stdin;
\.
COPY loja01.tb_estoque (id_item, quantidade) FROM '$$PATH$$/3094.dat';

--
-- Data for Name: tb_item; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_item (id_item, ds_item, preco_custo, preco_venda, fg_ativo) FROM stdin;
\.
COPY loja01.tb_item (id_item, ds_item, preco_custo, preco_venda, fg_ativo) FROM '$$PATH$$/3090.dat';

--
-- Data for Name: tb_item_pedido; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_item_pedido (id_item, id_pedido, quantidade) FROM stdin;
\.
COPY loja01.tb_item_pedido (id_item, id_pedido, quantidade) FROM '$$PATH$$/3092.dat';

--
-- Data for Name: tb_log; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_log (nome, data_hora) FROM stdin;
\.
COPY loja01.tb_log (nome, data_hora) FROM '$$PATH$$/3096.dat';

--
-- Data for Name: tb_pedido; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.tb_pedido (id_pedido, id_cliente, dt_compra, dt_entrega, valor, fg_ativo) FROM stdin;
\.
COPY loja01.tb_pedido (id_pedido, id_cliente, dt_compra, dt_entrega, valor, fg_ativo) FROM '$$PATH$$/3091.dat';

--
-- Data for Name: users; Type: TABLE DATA; Schema: loja01; Owner: postgres
--

COPY loja01.users (id, name, gems) FROM stdin;
\.
COPY loja01.users (id, name, gems) FROM '$$PATH$$/3102.dat';

--
-- Name: sq_categoria; Type: SEQUENCE SET; Schema: loja01; Owner: postgres
--

SELECT pg_catalog.setval('loja01.sq_categoria', 1, false);


--
-- Name: sq_pk_tb_cliente; Type: SEQUENCE SET; Schema: loja01; Owner: postgres
--

SELECT pg_catalog.setval('loja01.sq_pk_tb_cliente', 7, true);


--
-- Name: sq_pk_tb_estoque; Type: SEQUENCE SET; Schema: loja01; Owner: postgres
--

SELECT pg_catalog.setval('loja01.sq_pk_tb_estoque', 1, false);


--
-- Name: sq_pk_tb_item; Type: SEQUENCE SET; Schema: loja01; Owner: postgres
--

SELECT pg_catalog.setval('loja01.sq_pk_tb_item', 11, true);


--
-- Name: sq_pk_tb_pedido; Type: SEQUENCE SET; Schema: loja01; Owner: postgres
--

SELECT pg_catalog.setval('loja01.sq_pk_tb_pedido', 5, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: loja01; Owner: postgres
--

SELECT pg_catalog.setval('loja01.users_id_seq', 4, true);


--
-- Name: tb_estoque pk_est_id_item; Type: CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_estoque
    ADD CONSTRAINT pk_est_id_item PRIMARY KEY (id_item);


--
-- Name: tb_cliente pk_id_cliente; Type: CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_cliente
    ADD CONSTRAINT pk_id_cliente PRIMARY KEY (id_cliente);


--
-- Name: tb_item pk_id_item; Type: CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_item
    ADD CONSTRAINT pk_id_item PRIMARY KEY (id_item);


--
-- Name: tb_pedido pk_id_pedido; Type: CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_pedido
    ADD CONSTRAINT pk_id_pedido PRIMARY KEY (id_pedido);


--
-- Name: tb_item_pedido pk_item_pedido; Type: CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_item_pedido
    ADD CONSTRAINT pk_item_pedido PRIMARY KEY (id_item, id_pedido);


--
-- Name: tb_categoria tb_categoria_pkey; Type: CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_categoria
    ADD CONSTRAINT tb_categoria_pkey PRIMARY KEY (id_categoria);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: tb_empregados tg_empregado_auditoria; Type: TRIGGER; Schema: loja01; Owner: postgres
--

CREATE TRIGGER tg_empregado_auditoria AFTER INSERT OR DELETE OR UPDATE ON loja01.tb_empregados FOR EACH ROW EXECUTE FUNCTION loja01.fn_empregado_auditoria();


--
-- Name: tb_codigo_barras fk_cod_id_item; Type: FK CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_codigo_barras
    ADD CONSTRAINT fk_cod_id_item FOREIGN KEY (id_item) REFERENCES loja01.tb_item(id_item);


--
-- Name: tb_estoque fk_est_id_item; Type: FK CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_estoque
    ADD CONSTRAINT fk_est_id_item FOREIGN KEY (id_item) REFERENCES loja01.tb_item(id_item);


--
-- Name: tb_pedido fk_ped_id_cliente; Type: FK CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_pedido
    ADD CONSTRAINT fk_ped_id_cliente FOREIGN KEY (id_cliente) REFERENCES loja01.tb_cliente(id_cliente);


--
-- Name: tb_item_pedido fk_ped_id_item; Type: FK CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_item_pedido
    ADD CONSTRAINT fk_ped_id_item FOREIGN KEY (id_item) REFERENCES loja01.tb_item(id_item);


--
-- Name: tb_item_pedido fk_ped_id_pedido; Type: FK CONSTRAINT; Schema: loja01; Owner: postgres
--

ALTER TABLE ONLY loja01.tb_item_pedido
    ADD CONSTRAINT fk_ped_id_pedido FOREIGN KEY (id_pedido) REFERENCES loja01.tb_pedido(id_pedido);


--
-- Name: SCHEMA loja01; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON SCHEMA loja01 TO user1;


--
-- PostgreSQL database dump complete
--

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          