-- Deletar banco de dados e usuários caso existam iguais--

DROP DATABASE IF EXISTS uvv;
DROP USER IF EXISTS lucas_girelli;

--Criar usuário no postgres--

CREATE USER lucas_girelli
WITH CREATEDB CREATEROLE
ENCRYPTED PASSWORD '202306332';

--Criar banco de dados da loja uvv--
set role lucas_girelli;

CREATE DATABASE uvv
owner = lucas_girelli
template = template0
encoding = 'UTF8'
lc_collate = 'pt_BR.UTF-8'
lc_ctype = 'pt_BR.UTF-8'
allow_connections = true;

--Usar o banco de dados la loja uvv--
\setenv PGPASSWORD '202306332'
\c uvv lucas_girelli

--Criar o schema do banco de dados e autorizala-la--

CREATE SCHEMA lojas
AUTHORIZATION lucas_girelli;

--Definir o esquema lojas como padrão permanentemente para o usuário--

SET SEARCH_PATH TO lojas, "$user", public;
ALTER USER lucas_girelli
SET SEARCH_PATH TO lojas, "$user", public;

--criação da tabela produtos--
CREATE TABLE lojas.produtos (
                produto_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                preco_unitario NUMERIC(10,2),
                detalhes BYTEA,
                imagem BYTEA,
                imagem_mime_type VARCHAR(512),
                imagem_arquivo VARCHAR(512),
                imagem_charset VARCHAR(512),
                imagem_ultima_atualizacao DATE,
                CONSTRAINT produto_id PRIMARY KEY (produto_id),
                CONSTRAINT nome_not_empty CHECK (nome <> '')
--Essa restrição garante que o campo "nome" não possa ser nulo.--

                ,
                CONSTRAINT preco_unitario_non_negative CHECK (preco_unitario >= 0)
--Essa restrição garante que o preço unitário seja maior ou igual a zero.--
                
                ,
                CONSTRAINT imagem_ultima_atualizacao_check CHECK (imagem_ultima_atualizacao <= CURRENT_DATE)
--Essa restrição garante que a data de última atualização da imagem não seja no futuro.--
		    
);
--comentarios da tabela produtos--
COMMENT ON TABLE lojas.produtos IS 'tabela que mostra os detalhes do produto';
COMMENT ON COLUMN lojas.produtos.produto_id IS 'linha que mostra o id dos produtos';
COMMENT ON COLUMN lojas.produtos.nome IS 'linha que mostra os nomes dos produtos';
COMMENT ON COLUMN lojas.produtos.preco_unitario IS 'linha que mostra os precos dos produtos';
COMMENT ON COLUMN lojas.produtos.detalhes IS 'linha que mostra os detalhes dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem IS 'linha que mostra a imagem dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_mime_type IS 'linha que mostra o tipo dos produtos';
COMMENT ON COLUMN lojas.produtos.imagem_arquivo IS 'linha que mostra os arquivos da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_charset IS 'linha que mostra os caracteres da imagem';
COMMENT ON COLUMN lojas.produtos.imagem_ultima_atualizacao IS 'linha que mostra quando foi a ultima attualizacao da imagem do produto';


--criação da tabela lojas--
CREATE TABLE lojas.lojas (
                loja_id NUMERIC(38) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                endereco_web VARCHAR(100),
                endereco_fisico VARCHAR(512),
                latitude NUMERIC,
                longitude NUMERIC,
                logo BYTEA NOT NULL,
                logo_mime_type VARCHAR(512),
                logo_arquivo VARCHAR(512),
                logo_charset VARCHAR(512),
                logo_ultima_atualizacao DATE,
                CONSTRAINT loja_id PRIMARY KEY (loja_id)
                CONSTRAINT nome_not_empty CHECK (nome <> '')
--Essa restrição garante que o campo "nome" não possa ser nulo.--
                ,
                CONSTRAINT latitude_range CHECK (latitude >= -90 AND latitude <= 90),
                CONSTRAINT longitude_range CHECK (longitude >= -180 AND longitude <= 180)
--Essas restrições garantem que os valores de latitude e longitude estejam dentro dos intervalos válidos.--
                ,
                CONSTRAINT logo_ultima_atualizacao_check CHECK (logo_ultima_atualizacao <= CURRENT_DATE)
--Essa restrição garante que a data de última atualização do logo não seja no futuro.--
);      
--comentarios da tabela lojas--
COMMENT ON TABLE lojas.lojas IS 'tabela que ostra os detalhes da loja';
COMMENT ON COLUMN lojas.lojas.loja_id IS 'limha que mostra o id da loja';
COMMENT ON COLUMN lojas.lojas.nome IS 'linha que msotra o nome da loja';
COMMENT ON COLUMN lojas.lojas.endereco_web IS 'linha que mostra o endereco da loja via web';
COMMENT ON COLUMN lojas.lojas.endereco_fisico IS 'linha que mostra o endereco fisico da loja';
COMMENT ON COLUMN lojas.lojas.latitude IS 'linha que mostra a latitude da loja';
COMMENT ON COLUMN lojas.lojas.longitude IS 'linha que mostra a longitude da loja';
COMMENT ON COLUMN lojas.lojas.logo IS 'linha que mostra a logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_mime_type IS 'linha que mostra o tipo de logo da loja';
COMMENT ON COLUMN lojas.lojas.logo_arquivo IS 'linha que mostra o arquivo da logo';
COMMENT ON COLUMN lojas.lojas.logo_charset IS 'linha que mostra os caracteres da loja';
COMMENT ON COLUMN lojas.lojas.logo_ultima_atualizacao IS 'linha que mostra quando foi a ultima atualizacao do logo da loja';


--criação da tabela estoques--
CREATE TABLE lojas.estoques (
                estoque_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                produto_id NUMERIC(38) NOT NULL,
                quantidade NUMERIC(38) NOT NULL,
                
);
--comentarios da tabela estoques--
COMMENT ON TABLE lojas.estoques IS 'linha que mostra os detalhes dos estoques';
COMMENT ON COLUMN lojas.estoques.estoque_id IS 'linha que mostra o id dos estoques';
COMMENT ON COLUMN lojas.estoques.loja_id IS 'limha que mostra o id da loja';
COMMENT ON COLUMN lojas.estoques.produto_id IS 'linha que mostra o id dos produtos';
COMMENT ON COLUMN lojas.estoques.quantidade IS 'linha que mostra a quantidade dos produtos';

--criação da tabela clientes--
CREATE TABLE lojas.clientes (
                cliente_id NUMERIC NOT NULL,
                email VARCHAR(255) NOT NULL,
                nome VARCHAR(255) NOT NULL,
                telefone1 VARCHAR(20),
                telefone2 VARCHAR(20),
                telefone3 VARCHAR(20),
                CONSTRAINT pk_clientes PRIMARY KEY (cliente_id),
                CONSTRAINT unique_email UNIQUE (email)
                --Essa restrição garante que o campo "email" seja único na tabela, evitando a duplicação de endereços de e-mail.--
                
);
--comentarios da tabela clientes--
COMMENT ON TABLE lojas.clientes IS 'tabela que mostra os detalhes sobre os clientes';
COMMENT ON COLUMN lojas.clientes.cliente_id IS 'linha que mostra o id do cliente';
COMMENT ON COLUMN lojas.clientes.email IS 'linha que mostra os emails dos clientes';
COMMENT ON COLUMN lojas.clientes.nome IS 'linha que mostra os nomes dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone1 IS 'linha que mostra o telefone dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone2 IS 'linha que mostra o telefone dos clientes';
COMMENT ON COLUMN lojas.clientes.telefone3 IS 'linha que mostra o telefone dos clientes';

--criação da tabela envios--
CREATE TABLE lojas.envios (
                envio_id NUMERIC(38) NOT NULL,
                loja_id NUMERIC(38) NOT NULL,
                cliente_id NUMERIC NOT NULL,
                endereco_entrega VARCHAR(512) NOT NULL,
                status VARCHAR(15) NOT NULL,
                CONSTRAINT envio_id PRIMARY KEY (envio_id)
           
                
);
--comentarios da tabela envios--
COMMENT ON TABLE lojas.envios IS 'tabela que mostra os detalhes do envio';
COMMENT ON COLUMN lojas.envios.envio_id IS 'linha que mostra o id dos envios';
COMMENT ON COLUMN lojas.envios.loja_id IS 'limha que mostra o id da loja';
COMMENT ON COLUMN lojas.envios.cliente_id IS 'linha que mostra o id do cliente';
COMMENT ON COLUMN lojas.envios.endereco_entrega IS 'linha que mostra o endereco dos envios';
COMMENT ON COLUMN lojas.envios.status IS 'linha que mostra os status dos pedidos';

--criação da tabela pedidos--
CREATE TABLE lojas.pedidos (
  pedido_id NUMERIC(38) NOT NULL,
  data_hora TIMESTAMP NOT NULL,
  cliente_id NUMERIC NOT NULL,
  status VARCHAR(15) NOT NULL,
  loja_id NUMERIC(38) NOT NULL,
  CONSTRAINT pedido_id PRIMARY KEY (pedido_id),

);
--comentarios da tabela pedidos--
COMMENT ON TABLE lojas.pedidos IS 'tabela que mostra os detalhes dos pedidos';
COMMENT ON COLUMN lojas.pedidos.pedido_id IS 'linha que mostra o id do pedido';
COMMENT ON COLUMN lojas.pedidos.data_hora IS 'linha que mostra o horario que o pedido foi feito';
COMMENT ON COLUMN lojas.pedidos.cliente_id IS 'linha que mostra o id do cliente';
COMMENT ON COLUMN lojas.pedidos.status IS 'linha que mostra o status do pedido';
COMMENT ON COLUMN lojas.pedidos.loja_id IS 'limha que mostra o id da loja';

--criação da tabela itens--
CREATE TABLE lojas.pedidos_itens (
  pedido_id NUMERIC(38) NOT NULL,
  produto_id NUMERIC(38) NOT NULL,
  numero_da_linha NUMERIC(38) NOT NULL,
  preco_unitario NUMERIC(10,2) NOT NULL,
  quantidade NUMERIC(38) NOT NULL,
  envio_id NUMERIC(38),
  CONSTRAINT pedido_id___produto_id PRIMARY KEY (pedido_id, produto_id),

);
--comentarios da tabela envios--
COMMENT ON TABLE lojas.pedidos_itens IS 'tabela que mostra os pedidos dos itens';
COMMENT ON COLUMN lojas.pedidos_itens.pedido_id IS 'linha que mostra o id dos pedidos';
COMMENT ON COLUMN lojas.pedidos_itens.produto_id IS 'linha que mostra o id dos produtos';
COMMENT ON COLUMN lojas.pedidos_itens.numero_da_linha IS 'linha que mostra o numedo da linha do produto';
COMMENT ON COLUMN lojas.pedidos_itens.preco_unitario IS 'linha que mostra o preco dos produtos';
COMMENT ON COLUMN lojas.pedidos_itens.quantidade IS 'linha que mostra a quantidade de pedidos feitos por produtos';
COMMENT ON COLUMN lojas.pedidos_itens.envio_id IS 'linha que mostra o id dos envios';


ALTER TABLE lojas.estoques ADD CONSTRAINT produtos_estoques_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT produtos_pedidos_itens_fk
FOREIGN KEY (produto_id)
REFERENCES lojas.produtos (produto_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT lojas_envios_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.estoques ADD CONSTRAINT lojas_estoques_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT lojas_pedidos_fk
FOREIGN KEY (loja_id)
REFERENCES lojas.lojas (loja_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos ADD CONSTRAINT clientes_pedidos_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.envios ADD CONSTRAINT clientes_envios_fk
FOREIGN KEY (cliente_id)
REFERENCES lojas.clientes (cliente_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT envios_pedidos_itens_fk
FOREIGN KEY (envio_id)
REFERENCES lojas.envios (envio_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE lojas.pedidos_itens ADD CONSTRAINT pedidos_pedidos_itens_fk
FOREIGN KEY (pedido_id)
REFERENCES lojas.pedidos (pedido_id)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;
