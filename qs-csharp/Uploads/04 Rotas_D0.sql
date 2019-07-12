print '############################################################################################################'
print '##################################   Rotas padrao    ##########################################################'
--------------------------------- VARIAVEL DE SEGURANCA ------------------------------------------
DECLARE @SERVER VARCHAR(20)
SET @SERVER	= 'MS10PROSQL'

IF @@SERVERNAME = @SERVER
BEGIN 
	PRINT 'ERRO -- ESTE SCRIPT EST� SENDO EXECUTADO EM UM SERVIDOR PRODUCAO' 
	PRINT '**** CUIDADO ISSO PODE CAUSAR INDISPONIBILIDADE NO AMBIENTE DE PRODUCAO ****'
	RETURN
END 
GO
----------------------------------------------------------------------------------------------------
set nocount on;
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS alc_seguranca_cliente - INICIO
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..alc_seguranca_cliente -- '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..alc_seguranca_cliente
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP..alc_seguranca_cliente SET dcr_chave_cliente = '080C579E-943D-46FC-B7A8-39FA9FA8A62A' WHERE cod_cliente = 'INT'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..alc_seguranca_cliente
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..alc_seguranca_cliente -- '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
-- ROTAS alc_seguranca_cliente - FIM

--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS alc_seguranca_cliente - INICIO
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..alc_seguranca_cliente -- '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..alc_seguranca_cliente
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP..alc_seguranca_cliente SET dcr_chave_cliente = 'F0E826C3-E219-472C-B887-8B027744EB95' WHERE cod_cliente = 'MPS'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..alc_seguranca_cliente
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..alc_seguranca_cliente -- '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
-- ROTAS alc_seguranca_cliente - FIM
--------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------- tkgs_corp.COB.tb_cob_config_arquivo -----------------------------------------------------------------------------
print '############################################################################################################'
print '##################################   IMPORTANTE   ##########################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp.COB.tb_cob_config_arquivo --'
print '# redirecionamento de pastas dos arquivos de movimentacao banc�ria - FINNET'
print '# INICIO'
print SYSDATETIME () 
print '############################################################################################################'
print '#### select parametros Antes ####'
select * from tkgs_corp.COB.tb_cob_config_arquivo
print ''

update tkgs_corp.COB.tb_cob_config_arquivo
  set ds_caminho_sucesso = replace(ds_caminho_sucesso, 'MSPFSS01V', 'MSD0WEB03V'),
      ds_caminho_erro = replace(ds_caminho_erro, 'MSPFSS01V', 'MSD0WEB03V'),
	  ds_caminho_retorno = replace(ds_caminho_retorno, 'MSPFSS01V', 'MSD0WEB03V'),
	  ds_caminho = replace(ds_caminho, 'MSPFSS01V', 'MSD0WEB03V')


print '#### Script de Rotas para sistema do Sinistro'	  
UPDATE tkgs_corp.dbo.TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://mshobsapp01v/AppServer/Service.asmx' WHERE NM_KEY = 'ONBASE_APPSERVERURL'
UPDATE tkgs_corp.dbo.TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'ttfonseca' WHERE NM_KEY = 'ONBASE_USERNAME'
UPDATE tkgs_corp.dbo.TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'SENHA' WHERE NM_KEY = 'ONBASE_PASSWORD'
UPDATE tkgs_corp.dbo.TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = '0' WHERE NM_KEY = 'ESB_UTILIZA_VALIDACAO_AD'
UPDATE tkgs_corp.dbo.TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://portalsinistros-d0/login' WHERE NM_KEY = 'URL_PORTAL_SEGURADO'
UPDATE tkgs_corp.dbo.TB_ALC_URL SET NM_URL = REPLACE(NM_URL,'mssweb/', 'mssweb-d0/')
UPDATE tkgs_corp.dbo.TB_PTD_DADOS_GERAIS set DS_EMAIL = 'ms10_AmbienteTeste@ms-seg.com.br' where IsNull(DS_EMAIL, '') != ''
UPDATE tkgs_corp.dbo.TB_PTD_GRUPO_EMAIL set DS_EMAIL = 'ms10_AmbienteTeste@ms-seg.com.br' where IsNull(DS_EMAIL, '') != ''

DELETE FROM TKGS_CORP.DBO.TB_ONBASE_DOM_USUARIO

insert into TKGS_CORP.DBO.TB_ONBASE_DOM_USUARIO (USERNAME,PASSWORD,CONECTADO,DT_INICIO,EXCLUSIVO_SISTEMA)
values ('ttfonseca','SENHA','N',getdate(),NULL)
	
UPDATE TKGS_CORP.DBO.TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = '0' WHERE NM_KEY = 'ESB_SINIVEM_LIGADO' AND NM_SISTEMA = 'ESB'	  

--MASCARAMENTO EMAIL COMUNICANTE/SEGURADO
UPDATE tkgs_corp.sin.TB_SIN_AvisoSinistro set DS_EMAILCOMUNICANTE = 'ms10_AmbienteTeste@ms-seg.com.br' where DS_EMAILCOMUNICANTE is not null
UPDATE tkgs_corp.sin.TB_SIN_AvisoSinistro set DS_EMAIL_SEGURADO = 'ms10_AmbienteTeste@ms-seg.com.br' where DS_EMAIL_SEGURADO is not null


--Parametro processo job de pesquisa de satisfacao
UPDATE tkgs_corp.dbo.TB_GEN_ParametrosProcesso set vl_parametro = '224524644' where id_processo = 156 and nm_parametro = 'ID_COLETOR_OFICINA'
UPDATE tkgs_corp.dbo.TB_GEN_ParametrosProcesso set vl_parametro = '56060212' where id_processo = 156 and nm_parametro = 'ID_MENSAGEM_TEMPLATE_OFICINA'
UPDATE tkgs_corp.dbo.TB_GEN_ParametrosProcesso set vl_parametro = '09:00' where id_processo = 156 and nm_parametro = 'HORA_AGENDAMENTO_ENVIO'
UPDATE tkgs_corp.dbo.TB_GEN_ParametrosProcesso set vl_parametro = '164806114' where id_processo = 156 and nm_parametro = 'ID_FORMULARIO_OFICINA'
	  
print '#### select parametros Antes ####'
select * from tkgs_corp.COB.tb_cob_config_arquivo
print ''

print '############################################################################################################'
print '##################################   IMPORTANTE   ##########################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp.COB.tb_cob_config_arquivo --'
print '# redirecionamento de pastas dos arquivos de movimentacao banc�ria FINNET'
print '# INICIO'
print SYSDATETIME () 
print '############################################################################################################'

------------------------------------------- tkgs_infraestrutura..IFE_CONEXOES -----------------------------------------------------------------------------
print '############################################################################################################'
print '##################################   IMPORTANTE   ##########################################################'
print '# -- Script de atualiza��o das rotas    tkgs_infraestrutura..IFE_CONEXOES --'
print '# redirecionamento das conexoes de banco'
print '# INICIO'
print SYSDATETIME () 
print '############################################################################################################'

use tkgs_infraestrutura;

Update tkgs_infraestrutura..IFE_CONEXOES set des_txt_cnx = replace(des_txt_cnx, 'MS10PROSQL', 'MSSQLD0') Where des_txt_cnx like '%MS10PROSQL%';

print '#### select parametro de sites ####'
select * from tkgs_infraestrutura..IFE_CONEXOES
print''

print '############################################################################################################'
print '##################################   IMPORTANTE   ##########################################################'
print '# -- Script de atualiza��o das rotas    tkgs_infraestrutura..IFE_CONEXOES --'
print '# redirecionamento das conexoes de banco'
print '# FIM'
print SYSDATETIME () 
print '############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------- MSS_RNS.RNS.TB_PARAMETRO -----------------------------------------------------------------------------
print '############################################################################################################'
print '##################################   IMPORTANTE   ##########################################################'
print '# -- Incluuido por IR76217 e IR76252  --'
print '# -- Script de atualiza��o das rotas    MSS_RNS.RNS.TB_PARAMETRO --'
print '# redirecionamento do link de acesso ao rns e autentica��o do usu�rio e senha para acesso ao RNS'
print '# INICIO'
print SYSDATETIME () 
print '############################################################################################################'

USE MSS_RNS

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
select * from MSS_RNS.RNS.TB_PARAMETRO
print''
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO', NM_PARAMETRO = 'CD_USUARIO', DS_PARAMETRO = 'CODIGO DO USUARIO', VL_PARAMETRO = 'TESTE' WHERE CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO' AND NM_PARAMETRO = 'CD_USUARIO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO', NM_PARAMETRO = 'DV_USUARIO', DS_PARAMETRO = 'DV DO USUARIO', VL_PARAMETRO = 'MITSUI' WHERE CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO' AND NM_PARAMETRO = 'DV_USUARIO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO', NM_PARAMETRO = 'SENHA', DS_PARAMETRO = 'SENHA DO USUARIO', VL_PARAMETRO = '1234' WHERE CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO' AND NM_PARAMETRO = 'SENHA'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO', NM_PARAMETRO = 'SUB_CODIGO', DS_PARAMETRO = 'SUB CODIGO', VL_PARAMETRO = '6602' WHERE CD_GRUPO = 'WS_PATRIMONIAL_AUTENTICACAO' AND NM_PARAMETRO = 'SUB_CODIGO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_PATRIMONIAL_URL', NM_PARAMETRO = 'URL_SERVICO', DS_PARAMETRO = 'URL DO WEB-SERVICE PARA PATRIMONIAL', VL_PARAMETRO = 'http://rnsweb-hmlg.ceser.org.br/WsPatrOperacoesWeb/WsPatrOperacoes.jws' 
WHERE CD_GRUPO = 'WS_PATRIMONIAL_URL' AND NM_PARAMETRO = 'URL_SERVICO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_AUTO_AUTENTICACAO', NM_PARAMETRO = 'CD_USUARIO',	DS_PARAMETRO = 'CODIGO DO USUARIO',	VL_PARAMETRO = 'TESTE' WHERE CD_GRUPO = 'WS_AUTO_AUTENTICACAO' AND NM_PARAMETRO = 'CD_USUARIO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_AUTO_AUTENTICACAO', NM_PARAMETRO = 'DV_USUARIO', DS_PARAMETRO = 'DV DO USUARIO',	VL_PARAMETRO = 'MITSUI' WHERE CD_GRUPO = 'WS_AUTO_AUTENTICACAO' AND NM_PARAMETRO = 'DV_USUARIO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_AUTO_AUTENTICACAO', NM_PARAMETRO = 'SENHA', DS_PARAMETRO = 'SENHA DO USUARIO', VL_PARAMETRO = '1234' WHERE CD_GRUPO = 'WS_AUTO_AUTENTICACAO' AND NM_PARAMETRO = 'SENHA'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_AUTO_AUTENTICACAO', NM_PARAMETRO = 'SUB_CODIGO', DS_PARAMETRO = 'SUB CODIGO', VL_PARAMETRO = '6602' WHERE CD_GRUPO = 'WS_AUTO_AUTENTICACAO' AND NM_PARAMETRO = 'SUB_CODIGO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_AUTO_URL', NM_PARAMETRO = 'URL_SERVICO', DS_PARAMETRO = 'URL DO WEB-SERVICE PARA AUTO', VL_PARAMETRO = 'http://rnsweb-hmlg.ceser.org.br/WsOperacoesWeb/WsOperacoes.jws' 
WHERE CD_GRUPO = 'WS_AUTO_URL' AND NM_PARAMETRO = 'URL_SERVICO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO', NM_PARAMETRO = 'CD_USUARIO',	DS_PARAMETRO = 'CODIGO DO USUARIO',	VL_PARAMETRO = 'TESTE' WHERE CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO' AND NM_PARAMETRO = 'CD_USUARIO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO', NM_PARAMETRO = 'DV_USUARIO', DS_PARAMETRO = 'DV DO USUARIO',	VL_PARAMETRO = 'MITSUI' WHERE CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO' AND NM_PARAMETRO = 'DV_USUARIO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO', NM_PARAMETRO = 'SENHA', DS_PARAMETRO = 'SENHA DO USUARIO', VL_PARAMETRO = '1234' WHERE CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO' AND NM_PARAMETRO = 'SENHA'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO', NM_PARAMETRO = 'SUB_CODIGO', DS_PARAMETRO = 'SUB CODIGO', VL_PARAMETRO = 'TESTE' WHERE CD_GRUPO = 'WS_TRANSPORTE_AUTENTICACAO' AND NM_PARAMETRO = 'SUB_CODIGO'
UPDATE RNS.TB_PARAMETRO SET	CD_GRUPO = 'WS_TRANSPORTE_URL', NM_PARAMETRO = 'URL_SERVICO', DS_PARAMETRO = 'URL DO WEB-SERVICE PARA TRANSPORTE', VL_PARAMETRO = 'http://rnsweb-hmlg.ceser.org.br/WsTranspOperacoesWeb/WsTranspOperacoes.jws' 
WHERE CD_GRUPO = 'WS_TRANSPORTE_URL' AND NM_PARAMETRO = 'URL_SERVICO'
UPDATE RNS.TB_PARAMETRO SET VL_PARAMETRO = REPLACE(VL_PARAMETRO,'MSPFSS01V','MSHFSS01V') WHERE CD_GRUPO = 'ARQUIVO_XML'


print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
select * from MSS_RNS.RNS.TB_PARAMETRO
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

print '############################################################################################################'
print '##################################   IMPORTANTE   ##########################################################'
print '# -- Script de atualiza��o das rotas    MSS_RNS.RNS.TB_PARAMETRO --'
print '# redirecionamento do link de acesso ao rns e autentica��o do usu�rio e senha para acesso ao RNS'
print '# FIM'
print SYSDATETIME () 
print '############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
------------------------------------------- tkgs_corp..Tb_Ems_PathArquivo -----------------------------------------------------------------------------
print '############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..Tb_Ems_PathArquivo --'
print '# redirecionamento Onbase-DIP e FTP-MSPFTP01V'
print '# INICIO'
print SYSDATETIME () 
print '############################################################################################################'
use tkgs_corp

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
select * from tkgs_corp..Tb_Ems_PathArquivo
print''
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_dip = REPLACE(ds_path_dip,'MSONBASEPROFILE', 'MSHOBSFILE01V') WHERE ds_path_dip LIKE '%\\MSONBASEPROFILE\%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_dip = REPLACE(ds_path_dip,'ONBASEPROFILE', 'MSHOBSFILE01V') WHERE ds_path_dip LIKE '%\\ONBASEPROFILE\%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_dip = REPLACE(ds_path_dip,'MSAPP07', 'MSHOBSFILE01V') WHERE ds_path_dip LIKE '%\\MSAPP07\%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Linces$', '\\MSD0WEB03V\ftp$\LocalUser\Linces') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Linces$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Linces$', '\\MSD0WEB03V\ftp$\LocalUser\Linces') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Linces$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Linces$', '\\MSD0WEB03V\ftp$\LocalUser\Linces') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Linces$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Revisauto$', '\\MSD0WEB03V\ftp$\LocalUser\Revisauto') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Revisauto$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Revisauto$', '\\MSD0WEB03V\ftp$\LocalUser\Revisauto') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Revisauto$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Revisauto$', '\\MSD0WEB03V\ftp$\LocalUser\Revisauto') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Revisauto$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Sultec$', '\\MSD0WEB03V\ftp$\LocalUser\Sultec') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Sultec$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Sultec$', '\\MSD0WEB03V\ftp$\LocalUser\Sultec') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Sultec$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Sultec$', '\\MSD0WEB03V\ftp$\LocalUser\Sultec') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Sultec$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Previcar$', '\\MSD0WEB03V\ftp$\LocalUser\Previcar') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Previcar$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Previcar$', '\\MSD0WEB03V\ftp$\LocalUser\Previcar') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Previcar$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Previcar$', '\\MSD0WEB03V\ftp$\LocalUser\Previcar') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Previcar$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Bone$', '\\MSD0WEB03V\ftp$\LocalUser\Bone') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Bone$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Bone$', '\\MSD0WEB03V\ftp$\LocalUser\Bone') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Bone$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Bone$', '\\MSD0WEB03V\ftp$\LocalUser\Bone') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Bone$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Styllus$', '\\MSD0WEB03V\ftp$\LocalUser\Styllus') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Styllus$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Styllus$', '\\MSD0WEB03V\ftp$\LocalUser\Styllus') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Styllus$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Styllus$', '\\MSD0WEB03V\ftp$\LocalUser\Styllus') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Styllus$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\VPPagtoRE$', '\\MSD0WEB03V\ftp$\LocalUser\VPPagtoRE') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\VPPagtoRE$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\VPPagtoRE$', '\\MSD0WEB03V\ftp$\LocalUser\VPPagtoRE') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\VPPagtoRE$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\VPPagtoRE$', '\\MSD0WEB03V\ftp$\LocalUser\VPPagtoRE') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\VPPagtoRE$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSD0WEB03V\VPPagtoRE$', '\\MSD0WEB03V\ftp$\LocalUser\VPPagtoRE') WHERE ds_path_prestadora LIKE '%\\MSD0WEB03V\VPPagtoRE$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSD0WEB03V\VPPagtoRE$', '\\MSD0WEB03V\ftp$\LocalUser\VPPagtoRE') WHERE ds_path_trabalho LIKE '%\\MSD0WEB03V\VPPagtoRE$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSD0WEB03V\VPPagtoRE$', '\\MSD0WEB03V\ftp$\LocalUser\VPPagtoRE') WHERE ds_path_evidencia LIKE '%\\MSD0WEB03V\VPPagtoRE$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Alpha$', '\\MSD0WEB03V\ftp$\LocalUser\Alpha') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Alpha$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Alpha$', '\\MSD0WEB03V\ftp$\LocalUser\Alpha') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Alpha$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Alpha$', '\\MSD0WEB03V\ftp$\LocalUser\Alpha') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Alpha$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Soltel$', '\\MSD0WEB03V\ftp$\LocalUser\Soltel') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Soltel$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Soltel$', '\\MSD0WEB03V\ftp$\LocalUser\Soltel') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Soltel$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Soltel$', '\\MSD0WEB03V\ftp$\LocalUser\Soltel') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Soltel$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Braga$', '\\MSD0WEB03V\ftp$\LocalUser\Braga') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Braga$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Braga$', '\\MSD0WEB03V\ftp$\LocalUser\Braga') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Braga$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Braga$', '\\MSD0WEB03V\ftp$\LocalUser\Braga') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Braga$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\Vipper$', '\\MSD0WEB03V\ftp$\LocalUser\Vipper') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\Vipper$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\Vipper$', '\\MSD0WEB03V\ftp$\LocalUser\Vipper') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\Vipper$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\Vipper$', '\\MSD0WEB03V\ftp$\LocalUser\Vipper') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\Vipper$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora,'\\MSPFTP01V\bonevistoria$', '\\MSD0WEB03V\ftp$\LocalUser\bonevistoria') WHERE ds_path_prestadora LIKE '%\\MSPFTP01V\bonevistoria$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho,'\\MSPFTP01V\bonevistoria$', '\\MSD0WEB03V\ftp$\LocalUser\bonevistoria') WHERE ds_path_trabalho LIKE '%\\MSPFTP01V\bonevistoria$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia,'\\MSPFTP01V\bonevistoria$', '\\MSD0WEB03V\ftp$\LocalUser\bonevistoria') WHERE ds_path_evidencia LIKE '%\\MSPFTP01V\bonevistoria$%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_evidencia = REPLACE(ds_path_evidencia, 'MSPFTP01V', 'MSD0WEB03V') WHERE ds_path_evidencia LIKE '%MSPFTP01V%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_trabalho = REPLACE(ds_path_trabalho, 'MSPFTP01V', 'MSD0WEB03V') WHERE ds_path_trabalho LIKE '%MSPFTP01V%';
UPDATE tkgs_corp..Tb_Ems_PathArquivo SET ds_path_prestadora = REPLACE(ds_path_prestadora, 'MSPFTP01V', 'MSD0WEB03V') WHERE ds_path_prestadora LIKE '%MSPFTP01V%';

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
select * from tkgs_corp..Tb_Ems_PathArquivo
print''
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

print '############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..Tb_Ems_PathArquivo --'
print '# redirecionamento Onbase-DIP e FTP-MSPFTP01V'
print '# FIM'
print SYSDATETIME () 
print '############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS TB_GEN_CONFIGURACAO
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..TB_GEN_CONFIGURACAO -- '
print '# redirecionamento Onbase, FILE SHARED - GOIANIA, MS10PROAPP, --UNIDADE D:\ PARA E:\-- e REPORT '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..TB_GEN_CONFIGURACAO
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'msonbaseprofile', 'MSHOBSFILE01V') WHERE VL_CONFIGURACAO LIKE '%msonbaseprofile%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'GOiania', 'MSD0WEB03V') WHERE VL_CONFIGURACAO LIKE '%GOiania%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'mspfss01v', 'mshfss01v') WHERE VL_CONFIGURACAO LIKE '%mspfss01v%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'MS10PROAPP', 'MSD0WEB03V') WHERE VL_CONFIGURACAO LIKE '%MS10PROAPP%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'MSPFTP01V', 'MSD0WEB03V') WHERE VL_CONFIGURACAO LIKE '%MSPFTP01V%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'http://MS10', 'http://MS10-D0') WHERE VL_CONFIGURACAO LIKE '%http://MS10%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'd:\', 'e:\') WHERE VL_CONFIGURACAO LIKE '%d:\%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'http://report/', 'http://report-d0/') WHERE VL_CONFIGURACAO LIKE '%http://report/%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://wsoscilacaocambial-d0/OscilacaoCambialServico.asmx' WHERE NM_KEY = '20';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'http://msssrv/', 'http://msssrv-d0/') WHERE VL_CONFIGURACAO LIKE '%http://msssrv/%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'https://www4.msig.com.br', 'http://www4-d0k') WHERE VL_CONFIGURACAO LIKE '%https://www4.msig.com.br%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'http://MS10-PRD', 'http://MS10-D0') WHERE VL_CONFIGURACAO LIKE '%http://MS10-PRD%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'http://wscalculo-prd', 'http://wscalculo-d0') WHERE VL_CONFIGURACAO LIKE '%http://wscalculo-prd%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'http://wsemissaofront-prd', 'http://wsemissaofront-d0') WHERE VL_CONFIGURACAO LIKE '%http://wsemissaofront-prd%';
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = '\\MSD0WEB03V\tmp\' WHERE NM_KEY = 'CAMINHO_PLANILHA_VIDA_MS10'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'ms10-d0' WHERE NM_KEY = 'SMTP_SERVER'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = '/viradaversao_homologacao' WHERE NM_KEY = 'CAMINHO_ARQUIVO_ZIP_FTP'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'REDE' WHERE NM_KEY = 'TIPO_TRANSFERENCIA'
update TKGS_CORP..TB_GEN_CONFIGURACAO set VL_CONFIGURACAO = 'http://ws.hom.dfe.fitsistemas.com.br/WSFit_dfe4/NfeApiWSBean' where NM_KEY = 'URL_SERVICO_FIT'
update TKGS_CORP..TB_GEN_CONFIGURACAO set VL_CONFIGURACAO = 'MITSUIWS@0694' where NM_KEY = 'LOGIN_SERVICO_FIT'
update TKGS_CORP..TB_GEN_CONFIGURACAO set VL_CONFIGURACAO = 'tm_xNx637Kk7' where NM_KEY = 'SENHA_SERVICO_FIT'
update TKGS_CORP..TB_GEN_CONFIGURACAO set VL_CONFIGURACAO = 0 where NM_SISTEMA = 'VDV' and ID_CONFIGURACAO = 792

-- Precificador - Release 1
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/sgr' WHERE NM_KEY = 'URL_SEGURANCA_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'https://msssrv-d0/calculo-api' WHERE NM_KEY = 'URL_CALCULO_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://wsint-d0/IntegracaoCrivo.asmx' WHERE NM_KEY = 'URL_WEB_SERVICE_INTEGRACAO_CONTROLADORA_SOAP'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'https://msssrv-d0/ftg' WHERE NM_KEY = 'URL_FEATURE_TOGGLE_API'
-- Precificador - Release 2
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO set vl_configuracao = 'http://mshifst02v/Core/SoapRules' where NM_KEY = 'URL_WEB_SERVICE_INTEGRACAO_FICO_SOAP'
  
--Cart�o de cr�dito
-- Credenciais CIELO
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'https://apiquerysandbox.cieloecommerce.cielo.com.br' WHERE NM_KEY = 'URL_API_CIELO_CONSULTA'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'https://apisandbox.cieloecommerce.cielo.com.br' WHERE NM_KEY = 'URL_API_CIELO_REQUISICAO'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'c7cbc822-e83c-4af3-9c98-ec7f94ccd5b5' WHERE NM_KEY = 'MERCHANT_ID_API_CIELO'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'MQLQYPERIEPOUUBWATCPKRCNINMPENEKJFVIZVOR' WHERE NM_KEY = 'MERCHANT_KEY_API_CIELO'

--Endpoints COB-API
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'https://msssrv-d0/cob-api/rest/CartaoCredito/EfetuarAlteracaoCartao' WHERE NM_KEY = 'URL_EFETUAR_TROCA_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/RecuperarCartoesPorCpfCnpj' WHERE NM_KEY = 'URL_BUSCA_CARTOES_CPF_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/VerificarDadosApolice' WHERE NM_KEY = 'URL_VERIFICAR_DADOS_APOLICE_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/RecuperarBandeiras' WHERE NM_KEY = 'URL_RECUPERAR_BANDEIRAS_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/RecuperarDadosCartaoCredito/' WHERE NM_KEY = 'URL_RECUPERAR_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'https://msssrv-d0/cob-api/rest/CartaoCredito/Autorizacao/' WHERE NM_KEY = 'URL_AUTORIZAR_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/Cancelamento/' WHERE NM_KEY = 'URL_CANCELAR_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/Titulo/FinalizarAutorizacaoCartaoCredito/' WHERE NM_KEY = 'URL_FINALIZAR_AUTORIZACAO_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/Titulo/AlterarTipoCobranca/' WHERE NM_KEY = 'ALTERAR_TIPO_COBRANCA'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/Captura/' WHERE NM_KEY = 'URL_CAPTURAR_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/Estornar/' WHERE NM_KEY = 'URL_ESTORNAR_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/gbl/GeradorBoleto.svc/GerarBoletoProposta' WHERE NM_KEY = 'URL_GERAR_BOLETO_PROPOSTA_REST'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/EfetivarCapturaPagamentoEmissao/' WHERE NM_KEY = 'URL_EFETIVAR_CAPTURA_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/BaixarStatusPagamento/' WHERE NM_KEY = 'URL_BAIXAR_STATUS_PAGAMENTO_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/AutorizarCartaoCreditoRenovacao/' WHERE NM_KEY = 'URL_AUTORIZAR_RENOVACAO_CARTAO_COB_API'
UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://msssrv-d0/cob-api/rest/CartaoCredito/RecuperarDadosCartaoCredito' WHERE NM_KEY = 'URL_APOLICES_SEGURADO_CARTAO_COB_API'

--Cart�o de cr�dito


print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..TB_GEN_CONFIGURACAO
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

	  
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..TB_GEN_CONFIGURACAO -- '
print '# redirecionamento Onbase, FILE SHARED - GOIANIA, MS10PROAPP, --UNIDADE D:\ PARA E:\-- e REPORT '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------  
-- ROTAS tb_gen_monitoramento
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..tb_gen_monitoramento -- '
print '# redirecionamento FTP-MSPFTP01V VIA IP, MS10PROSQL e MS10PROAPP '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..tb_gen_monitoramento
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP..tb_gen_monitoramento SET DS_PARAMETROS = REPLACE(DS_PARAMETROS, 'MSPFTP01V', 'MSD0WEB03V') WHERE DS_PARAMETROS LIKE '%MSPFTP01V%';
UPDATE TKGS_CORP..tb_gen_monitoramento SET DS_PARAMETROS = REPLACE(DS_PARAMETROS, 'MS10PROSQL', 'MSD0WEB03V') WHERE DS_PARAMETROS LIKE '%MS10PROSQL%';
UPDATE TKGS_CORP..tb_gen_monitoramento SET DS_PARAMETROS = REPLACE(DS_PARAMETROS, 'MS10PROAPP', 'MSD0WEB03V') WHERE DS_PARAMETROS LIKE '%MS10PROAPP%';
  
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..tb_gen_monitoramento
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

  
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas    tkgs_corp..tb_gen_monitoramento -- '
print '# redirecionamento FTP-MSPFTP01V VIA IP, MS10PROSQL e MS10PROAPP '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS tkgs_corp_interface..layout_geral
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp_interface..layout_geral -- '
print '# redirecionamento FTP-MSPFTP01V, MS10PROSQL, MS10PROAPP, MSPFSS01V - FINNET, MANAUS e --D:\ PARA E:\-- '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'
use tkgs_corp_interface;
  
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from tkgs_corp_interface..layout_geral
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

Update layout_geral set CaminhoArquivo = replace(CaminhoArquivo, 'MS10PROSQL', 'MSD0WEB03V') Where CaminhoArquivo like '%\\MS10PROSQL\%';
Update layout_geral set CaminhoArquivo = replace(CaminhoArquivo, 'MSPFTP01V', 'MSD0WEB03V') Where CaminhoArquivo like '%\\MSPFTP01V\%';
Update layout_geral set CaminhoArquivo = replace(CaminhoArquivo, 'MSPFSS01V', 'MSD0WEB03V') Where CaminhoArquivo like '%\\MSPFSS01V\%';
Update layout_geral set CaminhoArquivo = replace(CaminhoArquivo, 'manaus', 'MSD0WEB03V') Where CaminhoArquivo like '%\\manaus\%';
Update layout_geral set CaminhoArquivo = replace(CaminhoArquivo, 'D:\', 'e:\') Where CaminhoArquivo like '%d:\%';

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from tkgs_corp_interface..layout_geral
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp_interface..layout_geral -- '
print '# redirecionamento FTP-MSPFTP01V, MS10PROSQL, MS10PROAPP, MSPFSS01V - FINNET, MANAUS e --D:\ PARA E:\-- '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS tkgs_corp..gen_processa
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp..gen_processa -- '
print '# redirecionamento FTP-MSPFTP01V, MS10PROSQL, MSPFSS01V - FINNET, GOIANIA e Link do crivo'
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'

use tkgs_corp;

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from tkgs_corp..gen_processa
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

Update gen_processa set dcr_parametro = replace(dcr_parametro, 'MS10PROSQL', 'MSD0WEB03V') Where dcr_parametro like '%\\MS10PROSQL\%';
Update gen_processa set dcr_parametro = replace(dcr_parametro, 'GOIANIA', 'MSD0WEB03V') Where dcr_parametro like '%GOIANIA%';
Update gen_processa set dcr_parametro = replace(dcr_parametro, 'MSPFTP01V', 'MSD0WEB03V') Where dcr_parametro like '%MSPFTP01V%';
Update gen_processa set dcr_parametro = replace(dcr_parametro, 'MSPFSS01V', 'MSD0WEB03V') Where dcr_parametro like '%MSPFSS01V%';

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from tkgs_corp..gen_processa
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'


print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp..gen_processa -- '
print '# redirecionamento FTP-MSPFTP01V, MS10PROSQL, MSPFSS01V - FINNET, GOIANIA e Link do crivo'
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS tkgs_corp..TB_CLI_CORRETOR_GRUPO_EMAIL
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp..TB_CLI_CORRETOR_GRUPO_EMAIL -- '
print '# redirecionamento E-MAILS para o grupo do cadastro de PRODUTORES' 
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT DCR_EMAIL from TKGS_CORP..TB_CLI_CORRETOR_GRUPO_EMAIL
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

update TKGS_CORP..TB_CLI_CORRETOR_GRUPO_EMAIL set DCR_EMAIL = 'ms10_AmbienteTeste@ms-seg.com.br' 

print '-------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### Atencao, se o valor de alterado for diferente do cadastrado, favor avaliar o script ####'
print '-------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### Select parametro de email ####'
print''
select count (*) DCR_EMAIL from tkgs_corp..TB_CLI_CORRETOR_GRUPO_EMAIL
print '#### Select parametro de Total cadastrado ####'
print''
select count (*) from tkgs_corp..TB_CLI_CORRETOR_GRUPO_EMAIL where DCR_EMAIL = 'ms10_AmbienteTeste@ms-seg.com.br'
print '#### Select parametro de Total alterado ####'
print '-------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### Atencao, se o valor de alterado for diferente do cadastrado, favor avaliar o script ####'
print '-------------------------------------------------------------------------------------------------------------------------------------------------'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT DCR_EMAIL from TKGS_CORP..TB_CLI_CORRETOR_GRUPO_EMAIL
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'


print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp..TB_CLI_CORRETOR_GRUPO_EMAIL -- '
print '# redirecionamento E-MAILS para o grupo do cadastro de PRODUTORES' 
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS tkgs_corp..TB_GEN_ParametrosProcesso
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp..TB_GEN_ParametrosProcesso -- '
print '# redirecionamento E-MAILS, FTP-MSPFTP01V, MS10PROSQL, BRASIL - FINNET e GOIANIA, MS10PROAPP, SHAREPOINT, CEDE,' 
print '# MSPWB05F, MSPFSS01V - NOVO FILE SHARED, ONBASE, MSPWB01F, WS-CALCULO-INTERNO, WS-INTEGRA-INTERNO, SSC, '
print '# EXTRATO-COMISSAO, REPORT, DISCO D:\ PARA E:\ e Desativacao da consulta do CRIVO'
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..TB_GEN_ParametrosProcesso
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro = 33;
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro = 250;
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro = 302;
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro = 303;
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro IN (305,306,307,308);
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro IN (309,310,311,312,321,322,323,324);
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro IN (313,314,315,316);
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro = 54;
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro IN (309,310,311,312,321,322,323,324);
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE id_parametro IN (317,318,319,320);
UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_AmbienteTeste@ms-seg.com.br' WHERE vl_parametro like '%@ms%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'MSPFTP01V','MSD0WEB03V')  WHERE vl_parametro like '%MSPFTP01V%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'ms10prosql','MSD0WEB03V')  WHERE vl_parametro like '%ms10prosql%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'mspwb05f','MSD0WEB03V')  WHERE vl_parametro like '%mspwb05f%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'MSPFSS01V','MSHFSS01V')  WHERE vl_parametro like '%MSPFSS01V%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'ms10proapp','MSD0WEB03V')  WHERE vl_parametro like '%ms10proapp%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'mspshpt01v','mshshp01v') WHERE vl_parametro like '%mspshpt01v%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'mspcede01v','mshcede01v') WHERE vl_parametro like '%mspcede01v%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'msonbaseprofile','MSHOBSFILE01V')  WHERE vl_parametro like '%msonbaseprofile%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'\\MSPFSS01V\','\\MSD0WEB03V\') WHERE vl_parametro like '%\\MSPFSS01V\%';
update TKGS_CORP..TB_GEN_ParametrosProcesso set ds_parametro = REPLACE(ds_parametro,'\\MSPFSS01V\','\\MSD0WEB03V\') WHERE ds_parametro like '%\\MSPFSS01V\%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'MSPDB04BL','MSD0WEB03V') WHERE vl_parametro like '%MSPDB04BL%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'GOiania','MSD0WEB03V') WHERE vl_parametro like '%GOiania%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'MS10PROWSKIT','wskit-d0') WHERE vl_parametro like '%MS10PROWSKIT%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'ms10prowsint','wsint-d0') WHERE vl_parametro like '%ms10prowsint%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'MSPWB01F','MSD0WEB03V') WHERE vl_parametro like '%MSPWB01F%';
update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'//report/','//report-d0/') WHERE vl_parametro like '%//report/%';
update TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'d:\','e:\') WHERE vl_parametro like '%d:\%';
update TB_GEN_ParametrosProcesso set vl_parametro = 'http://cppro-hi:2500/IntegradorCpproMS10.dll/soap/IIntegradorCPProMS10' where id_processo = 201 and nm_parametro = 'URL_CPPRO'

UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = '\\MSD0WEB03V\TKGS_Mitsui\TKGS_Job\Arquivos\BMK\' WHERE ID_PROCESSO = 209 AND ID_PARAMETRO = 627

-- SFT
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '\\MSHFSS01V\SFT$\OUT\'				WHERE id_processo = 275 AND nm_parametro = 'TransformConfiguration:NetworkFilePath'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '\\MSHFSS01V\SFT$\OUT\PROCESSADOS\'	WHERE id_processo = 275 AND nm_parametro = 'TransformConfiguration:NetworkFilePathProcessed'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '\\MSHFSS01V\SFT$\OUT\ERRO\'			WHERE id_processo = 275 AND nm_parametro = 'TransformConfiguration:NetworkFilePathError'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = 'ms10_ambienteteste@ms-seg.com.br'	WHERE id_processo = 275 AND nm_parametro = 'ParametroProcesso:EmailTo'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '000.000.00.000'	WHERE id_processo = 275 AND nm_parametro = 'LoadConfiguration:Host'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '22'				WHERE id_processo = 275 AND nm_parametro = 'LoadConfiguration:Port'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = 'password'		WHERE id_processo = 275 AND nm_parametro = 'LoadConfiguration:Password'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = 'sftusername'		WHERE id_processo = 275 AND nm_parametro = 'LoadConfiguration:UserName'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '0'				WHERE id_processo = 275 AND nm_parametro = 'LoadConfiguration:Enabled'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '0'				WHERE id_processo = 275 AND nm_parametro = 'ExtractConfiguration:BoaVistaEnabled'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = 'crivouser'		WHERE id_processo = 275 AND nm_parametro = 'ExtractConfiguration:CrivoUser'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = 'crivopassword'	WHERE id_processo = 275 AND nm_parametro = 'ExtractConfiguration:CrivoPassword'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '0'				WHERE id_processo = 275 AND nm_parametro = 'ExtractConfiguration:CrivoEnabled'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = 'HTTP://VITORIA/CRIVO/'	WHERE id_processo = 275 AND nm_parametro = 'ExtractConfiguration:CrivoUrlEndpoint'
UPDATE TKGS_CORP.dbo.TB_GEN_ParametrosProcesso SET vl_parametro = '\\mspftp01v\ftp\LocalUser\orion\HOMOLOGACAO\Retorno\'	WHERE id_processo = 275 AND nm_parametro = 'TransformConfiguration:NetworkPathBudgetPhotos'

print '##################  Links dos servi�os wcf dos servidores x64 incluido por MITP-8992 do Projeto de emissao ################'

update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'//msssrv/','//msssrv-d0/') WHERE vl_parametro like '%//msssrv/%';
update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'//mssweb/','//mssweb-d0/') WHERE vl_parametro like '%//mssweb/%';
update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'//mssweb02/','//mssweb02-d0/') WHERE vl_parametro like '%//mssweb02/%';

--Central de Bonus
print '##################  Link Central de Bonus ################'

UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = 'http://ms10-d0/FWSGB/WSIntegracao/IntegracaoBonus.svc' WHERE NM_kEY = 'URL_CENTRAL_BONUS'
--UPDATE TKGS_CORP..TB_GEN_CONFIGURACAO SET VL_CONFIGURACAO = REPLACE(VL_CONFIGURACAO, 'http://ms10-prd/FWSGB/WSIntegracao/IntegracaoBonus.svc', 'http://ms10-d0/FWSGB/WSIntegracao/IntegracaoBonus.svc') WHERE VL_CONFIGURACAO LIKE '%http://ms10-prd/FWSGB/WSIntegracao/IntegracaoBonus.svc%';  

--SSC
print '##################  Link SSC e Kit ################'

update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = 'http://ssc-d0/Autentica.aspx' WHERE id_parametro='517' and id_processo='107' AND nm_parametro = 'URL_ACESSO';
update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = 'http://extratocomissao-d0.msig.com.br/' WHERE id_parametro='507' and id_processo='15';
update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = 'http://www4-d0k/kitonline/vida/workflow/Gerenciador.aspx' WHERE id_parametro='673' and id_processo='217';
update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = 'http://www4-d0k/kitonline/' WHERE id_parametro='675' and id_processo='217';

-- Link do sistema de VIDA da GTI - Workflow
print '##################  Link do sistema de VIDA da GTI - Workflow ################'

update TKGS_CORP..TB_GEN_PARAMETROSPROCESSO set vl_parametro = 'http://www4-d0k/kitonline/vida/workflow/Gerenciador.aspx' where nm_parametro = 'URL_COTADOR_GTI' and id_processo = 217

--[MITP-17294] - 26/04/2016 - Removendo url do VistoriaWeb
update dbo.TB_GEN_ParametrosProcesso set vl_parametro = '' WHERE id_processo = 231 and nm_parametro in ('URL_AGENDAMENTO_VISTORIA_WEB' , 'URL_CANCELAMENTO_VISTORIA_WEB')

print '##################  Links dos servi�os a aplicados dos servidores kit ################'

UPDATE TKGS_CORP..TB_GEN_ParametrosProcesso SET vl_parametro = REPLACE(vl_parametro, 'https://www4.msig.com.br', 'http://www4-d0k') WHERE vl_parametro LIKE '%https://www4.msig.com.br%';

update TKGS_CORP..TB_GEN_ParametrosProcesso set vl_parametro = REPLACE(vl_parametro,'-prd/','-d0/') WHERE vl_parametro like '%-prd/%';

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..TB_GEN_ParametrosProcesso
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

-- Crivo Desativacao
--CRIVO
-- ########### Incluido por SR19568 - 19-02-2015
print '##################  Parametros de desaticao do CRIVO alteracao do link ################'
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..TB_GEN_ParametrosProcesso where id_processo = 200
SELECT * from TKGS_CORP..TB_GEN_Processos where id_processo = 200
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TB_GEN_Processos SET ds_executavel = 'HTTP://VITORIA/CRIVO/' where id_processo = 200

print '##################  Parametros de desativacao do CRIVO Login, senha e modo de consulta ################'

use tkgs_corp;
UPDATE tb_gen_parametrosprocesso SET vl_parametro = 'N' where id_processo = 200 AND nm_parametro = 'CONSULTA_CRIVO'
UPDATE tb_gen_parametrosprocesso SET vl_parametro = '****'  where id_processo = 200  AND nm_parametro = 'CONSULTA_CRIVO_LOGIN'
UPDATE tb_gen_parametrosprocesso SET vl_parametro = '*****'  where id_processo = 200 AND nm_parametro = 'CONSULTA_CRIVO_SENHA'
update TKGS_CORP..cli_corretor set IN_CONSULTA_CRIVO = 0;

Print '########### Altarado pelo SR19568 ###############'

update TKGS_CORP..TB_GEN_ParametrosProcesso
   set vl_parametro = ' 31001, 31020, 31030, 14001, 16001, 18001, 18014'
where id_parametro = 603

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..TB_GEN_ParametrosProcesso where id_processo = 200
SELECT * from TKGS_CORP..TB_GEN_Processos where id_processo = 200
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

print '##################  Parametros de desativacao do CRIVO Login, senha e modo de consulta ################'

--GO
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_corp..TB_GEN_ParametrosProcesso -- '
print '# redirecionamento EMAILS, FTP-MSPFTP01V, MS10PROSQL, BRASIL - FINNET e GOIANIA, MS10PROAPP, SHAREPOINT, CEDE,' 
print '# MSPWB05F, MSPFSS01V - NOVO FILE SHARED, ONBASE, MSPWB01F, WS-CALCULO-INTERNO, WS-INTEGRA-INTERNO, SSC, '
print '# EXTRATO-COMISSAO, REPORT e DISCO D:\ PARA E:\ '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################'
--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro -- '
print '# redirecionamento MSPFOE01V, FTP-MSPFTP01V, MS10PROSQL, BRASIL - FINNET e GOIANIA, FENASEG e LOGINS TERCEIROS' 
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTAENVIO = REPLACE(NM_ROTAENVIO,'MS10PROSQL','MSD0WEB03V') WHERE NM_ROTAENVIO LIKE '%MS10PROSQL%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTAENVIO = REPLACE(NM_ROTAENVIO,'MSPFOE01V','MSD0WEB03V') WHERE NM_ROTAENVIO LIKE '%MSPFOE01V%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTAENVIO = REPLACE(NM_ROTAENVIO,'BRASIL','MSD0WEB03V') WHERE NM_ROTAENVIO LIKE '%BRASIL%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTAENVIO = REPLACE(NM_ROTAENVIO,'MSPFTP01V','MSD0WEB03V') WHERE NM_ROTAENVIO LIKE '%MSPFTP01V%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTARETORNO = REPLACE(NM_ROTARETORNO,'MSPFTP01V','MSD0WEB03V') WHERE NM_ROTARETORNO LIKE '%MSPFTP01V%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTARETORNO = REPLACE(NM_ROTARETORNO,'MS10PROSQL','MSD0WEB03V') WHERE NM_ROTARETORNO LIKE '%MS10PROSQL%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTARETORNO = REPLACE(NM_ROTARETORNO,'MSPFOE01V','MSD0WEB03V') WHERE NM_ROTARETORNO LIKE '%MSPFOE01V%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTARETORNO = REPLACE(NM_ROTARETORNO,'BRASIL','MSD0WEB03V') WHERE NM_ROTARETORNO LIKE '%BRASIL%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTARETORNO = REPLACE(NM_ROTARETORNO,'MSPAUDA01V','MSD0WEB03V') WHERE NM_ROTARETORNO LIKE '%MSPAUDA01V%';
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
--Desativado em 16/06/2015 - por solicitacao do Leandro Duraes - alterado o GOiania para MSPFSS01V
--UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTARETORNO = REPLACE(NM_ROTARETORNO,'GOIANIA','MSD0WEB03V') WHERE NM_ROTARETORNO LIKE '%GOIANIA%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_ROTARETORNO = REPLACE(NM_ROTARETORNO,'MSPFSS01V','MSD0WEB03V') WHERE NM_ROTARETORNO LIKE '%MSPFSS01V%';
----------------------------------------------------------------------------------------------------------------------------------------------------------------------
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_URLTERCEIRO = REPLACE(NM_URLTERCEIRO,'BRASIL','VITORIA') WHERE NM_URLTERCEIRO LIKE '%BRASIL%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_URLTERCEIRO = REPLACE(NM_URLTERCEIRO,'rnsweb.fenaseg.quality.com.br','rnsweb-hmlg.ceser.org.br') WHERE NM_URLTERCEIRO LIKE '%rnsweb.fenaseg.quality.com.br%';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET NM_LOGINTERCEIRO = 'XXXXXXXX';
UPDATE TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro SET CD_SENHATERCEIRO = 'XXXXXXXX';

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
select CD_PESSOA,CD_PRODUTO,NM_LOGINTERCEIRO,CD_SENHATERCEIRO,NM_URLTERCEIRO,NM_ROTAENVIO,NM_ROTARETORNO from TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro
print''
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP.SIN.TB_SIN_ParametrosTerceiro -- '
print '# redirecionamento MSPFOE01V, FTP-MSPFTP01V, MS10PROSQL, MSPFSS01V - FINNET e GOIANIA, FENASEG e LOGINS TERCEIROS' 
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 
-------------------------------------------------------------------------------------------------------------------------------------------------- 
 
-- ROTAS tkgs_comissao..CMS_CADASTRO_PAGAMENTO e CMS_CADASTRO_PAGAMENTO_OUTROS
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_comissao..CMS_CADASTRO_PAGAMENTO -- '
print '# redirecionamento de e-mail do cadastro de pagamento CMS' 
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 
use tkgs_comissao;

alter table tkgs_comissao..CMS_CADASTRO_PAGAMENTO_OUTROS disable trigger all;
Update tkgs_comissao..CMS_CADASTRO_PAGAMENTO_OUTROS set cod_eml = 'ms10_AmbienteTeste@ms-seg.com.br' Where not cod_eml is null;
Update tkgs_comissao..CMS_CADASTRO_PAGAMENTO set cod_eml = 'ms10_AmbienteTeste@ms-seg.com.br' Where not cod_eml is null;
alter table tkgs_comissao..CMS_CADASTRO_PAGAMENTO_OUTROS enable trigger all;

print '#### Select parametro de email ####'
print''
select COUNT (*) from tkgs_comissao..CMS_CADASTRO_PAGAMENTO_OUTROS where COD_EML like '%ms10_AmbienteTeste@ms-seg.com.br%'
select COUNT (*) from tkgs_comissao..CMS_CADASTRO_PAGAMENTO where COD_EML like '%ms10_AmbienteTeste@ms-seg.com.br%'
print''

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  tkgs_comissao..CMS_CADASTRO_PAGAMENTO -- '
print '# redirecionamento de e-mail do cadastro de pagamento CMS' 
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 

--  TKGS_CORP..TKGS_CORP..gen_dominio
---------------------------------------------------------------------------------------------------------------------------
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..gen_dominio -- '
print '# Altera e-mail  '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 

update TKGS_CORP..gen_dominio 
set dcr_sub_domin = 'msambiente@msig.com.br' 
where cod_domin='emailscarroreserva'

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..gen_dominio -- '
print '# Alterou e-mail  '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 
---------------------------------------------------------------------------------------------------------------------------------------
-- Incluido por MITD-357
use TKGS_CORP
--GO
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..gen_dominio -- '
print '#-- Incluido por MITD-357'
print '# Altera parametros BOAVISTA - remove os usuarios de producao, insere o usuario padrao  '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 
DELETE FROM TB_CONFIG_BOAVISTA
--GO

-- N�O DEFINIDO
INSERT INTO TB_CONFIG_BOAVISTA (COD_PERF, COD_OBJ, CD_CLASSIFICACAO, USUARIO, SENHA)
VALUES ('PADRAO', 'PADRAO', '', '07670761190', '8363')
--GO
-- Incluido por MITD-357

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..gen_dominio -- '
print '#-- Incluido por MITD-357'
print '# Alterou parametros BOAVISTA - remove os usuarios de producao, insere o usuario padrao  '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 

--- SD-IR46978 ----
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..alc_modulo -- '
print '#-- Incluido por IR46978'
print '# Altera parametros do sistema de comissao, produtor e migracao de sinistro '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 

USE TKGS_CORP;
--GO
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..alc_modulo
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP..alc_modulo SET dcr_func_modul = 'http://sinistro-d0/MS10PLUS/Cobranca/ConciliacaoBancaria/ConsultarConciliacaoBancaria.aspx' WHERE cod_modul = '2431';
UPDATE TKGS_CORP..alc_modulo SET dcr_func_modul = REPLACE(dcr_func_modul, 'http://mssweb/', 'http://mssweb-d0/') WHERE dcr_func_modul LIKE '%http://mssweb/%'
UPDATE TKGS_CORP..alc_modulo SET dcr_func_modul = REPLACE(dcr_func_modul, 'http://mssweb02/', 'http://mssweb02-d0/') WHERE dcr_func_modul LIKE '%http://mssweb02/%'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..alc_modulo
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

--- SD-IR46978 ----
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..alc_modulo -- '
print '#-- Incluido por IR46978'
print '# Alterou parametros do sistema de comissao, produtor e migracao de sinistro'
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 
-- Incluido por MITD-321
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..TB_ALC_URL -- '
print '#-- Incluido por MITD-321'
print '# Altera parametros do sistema de migracao de sinistro '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 

USE TKGS_CORP;
--GO
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select ANTES ####'
print''
SELECT * from TKGS_CORP..TB_ALC_URL
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'

UPDATE TKGS_CORP..TB_ALC_URL SET NM_URL = REPLACE(NM_URL, 'http://mssweb/', 'http://mssweb-d0/') WHERE NM_URL LIKE '%http://mssweb/%'
UPDATE TKGS_CORP..TB_ALC_URL SET NM_URL = REPLACE(NM_URL, 'http://mssweb02/', 'http://mssweb02-d0/') WHERE NM_URL LIKE '%http://mssweb02/%'

print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'
print '#### select DEPOIS ####'
print''
SELECT * from TKGS_CORP..TB_ALC_URL
print '------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------'


--- SD-IR46978 ----
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..TB_ALC_URL -- '
print '#-- Incluido por MITD-321'
print '# Alterou parametros do sistema de migracao de sinistro'
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 

--------------------------------------------------------------------------------------------------------------------------------------------------
-- ROTAS TKGS_CORP..cli_endereco
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..cli_endereco -- '
print '# Desabilita trigger cli_pessoa e redireciona os e-mail�s  '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 

use TKGS_CORP;

disable trigger all on cli_pessoa;

Alter table cli_endereco disable trigger all;
Update cli_endereco set dcr_email = 'ms10_AmbienteTeste@ms-seg.com.br' Where not dcr_email is null;
Alter table cli_endereco enable trigger all;

-- ROTAS TKGS_CORP..cli_endereco
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..cli_endereco -- '
print '# Mantem desabilitado a trigger cli_pessoa e redireciona os e-mail�s  '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 
--------------------------------------------------------------------------------------------------------------------------------------------------

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..alc_usuario -- '
print '# Altera senha dos usuarios para mitsui, muda status e ocorrencias - MS10 '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 
update alc_usuario
-- Para Servidor de Homologa��o
-- mitsui
set dcr_senh = 'E=LGM=', sts_usr = 'A'
-- Para Servidor de Fechamento
-- fecha
-- set dcr_senh = '^Y[\Y'
-- fecha02
--set dcr_senh = '^Y[\Y$*';

Insert alc_ocorrenciasxusuario
Select cod_ocorr, '0001', '2007-01-01', null, 'ms10',null
From alc_ocorrencias a
Where not exists (Select 1 from alc_ocorrenciasxusuario b
Where a.cod_ocorr = b.cod_ocorr
and b.cod_usr = '0001');

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..alc_usuario -- '
print '# Altera senha dos usuarios para mitsui, muda status e ocorrencias - MS10 '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 
--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..cli_pessoa -- '
print '# A trigger cli_pessoa continua desabilitada '
print '# Altera senha dos usuarios para mitsui - KIT '
print '# Altera dados nas seguintes tabelas: alc_usuario, cli_entidade, cli_corretor, cli_grupopess e cli_corretorprod'
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 
set   nocount on

declare     @cod_pess varchar(8)    ,     @cod_pess_novo varchar(8)    ,     @nom_pess varchar(50)       ,
            @cod_usr varchar(4)          ,     @cod_usr_novo varchar(4)     ,      @cod_login_usr varchar(20)   ,
            @dcr_senh varchar(50)   ,     @cod_corr varchar(7)         ,     @cod_corr_novo varchar(7)

--
--Alterado dia 08-11-2013 devido a implantacao do MITD-74 ---
--select  top 1 @cod_pess = cod_pess from dbo.cli_pessoa (nolock) where nom_pess like ('%CORRETOR%TESTE%';)
--Alterado dia 08-11-2013 devido a implantacao do MITD-74 ---
select  top 1 @cod_pess = cod_pess from dbo.cli_pessoa (nolock) where nom_pess like ('%CORRETOR%TESTE%KIT')
select      @cod_usr          = cod_usr from alc_usuario where cod_pess = @cod_pess
select      @cod_corr         = cod_corr from cli_corretor where cod_pess = @cod_pess
select      @cod_pess_novo    = right('00000000' + convert(varchar(8), (max(cod_pess)+1)), 8) from cli_pessoa where cod_pess < '88000001'
select      @cod_usr_novo     = right('00000000' + convert(varchar(4), (max(cod_usr)+1)), 4) from alc_usuario where cod_usr < '9998'
select      @cod_corr_novo    = right('00000000' + convert(varchar(7), (max(cod_corr)+1)), 7) from cli_corretor
select      @nom_pess         = 'CORRETOR TESTE KIT'
select      @cod_login_usr    = 'KIT'
select      @dcr_senh         = 'E=LGM='

--
if not exists ( select  1
                        from  cli_pessoa
                        where nom_pess = 'CORRETOR TESTE KIT')
 begin
      begin tran

      --
      print 'Insere na cli_pessoa...'
      insert      dbo.cli_pessoa (cod_pess, tip_pess, nom_pess, sts_pess, ind_cpf_propr, nro_cpf, dta_nasc, tip_est_civil, tip_sexo, nro_rg, dcr_emis_rg, nom_contt, nro_tel_contt, nro_inscr_mun, nro_inss, nro_cnh, dta_venc_cnh, dta_incl, nom_usr_incl, nom_usr_alt, cod_ddd_cont, cod_identif, cod_ativ, dta_emis_rg, dcr_natureza_rg, dta_alt, nro_centro_custo, frm_dsh, DS_NACIONALIDADE, DS_PROFISSAO)
      select      @cod_pess_novo as cod_pess   ,     tip_pess          ,     @nom_pess as nom_pess    ,
                  sts_pess                           ,     ind_cpf_propr     ,     nro_cpf                             ,
                  dta_nasc                           ,     tip_est_civil     ,     tip_sexo                        ,
                  nro_rg                                   ,     dcr_emis_rg       ,      nom_contt                    ,
                  nro_tel_contt                      ,     nro_inscr_mun     ,     nro_inss                        ,
                  nro_cnh                                  ,     dta_venc_cnh      ,      dta_incl                     ,
                  nom_usr_incl                       ,     nom_usr_alt       ,      cod_ddd_cont                 ,
                  cod_identif                        ,     cod_ativ          ,     dta_emis_rg                        ,
                  dcr_natureza_rg                    ,     dta_alt                 ,      nro_centro_custo        ,
                  frm_dsh                     , DS_NACIONALIDADE  , DS_PROFISSAO
      from  cli_pessoa
      where cod_pess = @cod_pess
      if ( select count(*) from cli_pessoa where cod_pess = @cod_pess_novo ) = 0
       begin
            rollback
            return
       end

      --
      print 'Insere na cli_entidade...'
      insert      dbo.cli_entidade
      select      @cod_pess_novo    as cod_pess ,     tip_entd    ,     sts_entd          ,
                  dta_incl                           ,     dta_alt           ,      nom_usr_incl      ,
                  nom_usr_alt
      from  cli_entidade
      where cod_pess = @cod_pess
      if ( select count(*) from cli_entidade where cod_pess = @cod_pess_novo ) = 0
       begin
            rollback
            return
       end

      --
      print 'Insere na cli_endereco...'
      insert      dbo.cli_endereco (cod_pess, tip_entd, cod_cep, tip_ender, dcr_ender_compl, dcr_ender, nro_ender, nom_bairro, nom_cid, cod_uf, cod_cid, dcr_site, dcr_email, sts_ender, dta_incl, dta_alt, nom_usr_incl, nom_usr_alt, DS_EMAIL_RENOVACAO)
      select      @cod_pess_novo    as cod_pess ,     tip_entd          ,     cod_cep           ,
                  tip_ender                          ,     dcr_ender_compl   ,     dcr_ender      ,
                  nro_ender                          ,     nom_bairro        ,     nom_cid            ,
                  cod_uf                                   ,     cod_cid                 ,      dcr_site    ,
                  dcr_email                          ,     sts_ender         ,     dta_incl      ,
                  dta_alt                                  ,     nom_usr_incl      ,      nom_usr_alt , DS_EMAIL_RENOVACAO
      from  cli_endereco
      where cod_pess = @cod_pess
      if ( select count(*) from cli_endereco where cod_pess = @cod_pess_novo ) = 0
       begin
            rollback
            return
       end

      --
      print 'Insere na alc_usuario...'
      insert      dbo.alc_usuario (cod_usr, nom_usr, cod_login_usr, cod_perf, dcr_senh, sts_usr, dta_incl, cod_pess, dta_alt, nom_usr_incl, nom_usr_alt, tip_entd, ind_especial, flg_tp_situacao, in_senha_kit, in_senha_broker)
            select      @cod_usr_novo     as cod_usr  ,     @nom_pess         as nom_usr  ,      @cod_login_usr    as cod_login_usr,
                  cod_perf                           ,     @dcr_senh         as dcr_senh ,      sts_usr                                        ,
                  dta_incl                           ,     @cod_pess_novo    as cod_pess ,      dta_alt                                        ,
                  nom_usr_incl                       ,     nom_usr_alt                        ,     tip_entd                                 ,
                  ind_especial                       ,     flg_tp_situacao                    ,     in_senha_kit                             ,
                  in_senha_broker
      from  alc_usuario
      where cod_usr = @cod_usr
      if ( select count(*) from alc_usuario where cod_usr = @cod_usr_novo ) = 0
       begin
            rollback
            return
       end
      
      --
      print 'Insere na cli_corretor...'
      insert      dbo.cli_corretor (cod_corr, tip_corr, cod_pess, cod_seg, nom_pess, cod_corr_susep, sts_corr, dta_incl, dta_alt, nom_usr_incl, nom_usr_alt, cod_corr_int, cod_corr_vg, caixapostal, tip_corr_layout, cod_externo, TIP_SEGMT, TIP_CANAL, tp_recebimento, in_emissao_automatica, DS_AGRUPAMENTO_CORRETOR, DS_CLASSE_CORRETOR)
      select      @cod_corr_novo    as cod_corr       ,     tip_corr                     ,      @cod_pess_novo    as cod_pess ,
                  cod_seg                                        ,     @nom_pess   as nom_pess      ,     cod_corr_susep                     ,
                  sts_corr                                 ,     dta_incl                      ,     dta_alt                                  ,
                  nom_usr_incl                             ,     nom_usr_alt                   ,     cod_corr_int                       ,
                  cod_corr_vg                              ,     caixapostal                   ,     tip_corr_layout                    ,
                  @cod_login_usr    as cod_externo    ,     tip_segmt                    ,      tip_canal                          ,
                  tp_recebimento                           ,     in_emissao_automatica   ,   DS_AGRUPAMENTO_CORRETOR     , DS_CLASSE_CORRETOR
      from  cli_corretor
      where cod_corr = @cod_corr
      if ( select count(*) from cli_corretor where cod_corr = @cod_corr_novo ) = 0
       begin
            rollback
            return
       end

      --
      print 'Insere na cli_grupopess...'
      insert      dbo.cli_grupopess
      select      cod_grupo         ,     @cod_pess_novo as cod_pess   ,     sts_grupo         ,
                  dta_incl          ,     dta_alt                                  ,      nom_usr_incl      ,
                  nom_usr_alt       ,     tip_entid                          ,      @cod_corr_novo as cod_interno
      from  cli_grupopess
      where cod_pess = @cod_pess
      if ( select count(*) from cli_grupopess where cod_pess = @cod_pess_novo ) = 0
       begin
            rollback
            return
       end

      --
      print 'Insere na cli_corretorprod...'
      if ( select count(*) from cli_corretorprod where cod_corr = @cod_corr_novo ) = 0
    begin
       insert     dbo.cli_corretorprod
         select DISTINCT @cod_corr_novo as cod_corr  ,     
						 cod_prod,     
						 dta_ini_vig ,
						  dta_fim_vig,
						  dta_incl,     
						  dta_alt,
						  nom_usr_incl,     
						  nom_usr_alt,
						  ASSESSORIA_PERCT_CMS,
						  ASSESSORIA_FORMA_APURACAO,
						  COD_PESS,
						  TP_RENOVACAO_AUTOMATICA
          from    cli_corretorprod
          where   cod_corr = @cod_corr 
      END
      
      if ( select count(*) from cli_corretorprod where cod_corr = @cod_corr_novo ) = 0
       begin
            rollback
            return
       end

      commit
      -- rollback

 end

set nocount off

use TKGS_CORP;

enable trigger all on cli_pessoa;

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas  TKGS_CORP..cli_pessoa -- '
print '# Ativa trigger cli_pessoa  '
print '# Alterou senha dos usuarios para mitsui - KIT '
print '# Alterou dados nas seguintes tabelas: alc_usuario, cli_entidade, cli_corretor, cli_grupopess e cli_corretorprod'
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 
--------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------
print '#############################################################################################################'
print '# -- SR178598 --'
print '# -- Script de atualiza��o das rotas TKGS_CORP.alc_perfil_acao -- '
print '# Adiciona ao perfil de administrador acesso full a a��es do TRP'
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 

USE TKGS_CORP

BEGIN

	DECLARE 
			@cod_sist VARCHAR(2) = '10', 
			@cod_acao VARCHAR(2) = '4',
			@cod_perf VARCHAR(2) = '01',
			@sts_acao VARCHAR(1) = 'A'

	INSERT INTO alc_perfil_acao (COD_PERF,  COD_SIST, COD_MODUL, COD_ACAO,  STS_ACAO) 
	SELECT 	@cod_perf, @cod_sist, cod_modul, @cod_acao, @sts_acao
	FROM dbo.alc_modulo modu
	WHERE COD_MODUL LIKE '90%'
		AND NOT EXISTS (	SELECT 1 
							FROM ALC_PERFIL_ACAO acao 
							WHERE 
								acao.cod_sist = @cod_sist AND 
								acao.cod_modul = modu.cod_modul AND 
								acao.cod_acao = @cod_acao AND
								acao.cod_perf = @cod_perf)
END

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas TKGS_CORP.alc_perfil_acao -- '
print '# Adiciona ao perfil de administrador acesso full a a��es do TRP'
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 

---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

print '#############################################################################################################'
print '# -- SR178598 --'
print '# -- Script de atualiza��o de rotas MSS_TRP.tb_param_sistema, MSS_TRP.tb_assinatura -- '
print '# Atualiza o caminho de rede utilizado na importa��o de planilha do TRP'
print '# Atualiza as assinaturas com a imagem existente no ambiente.'
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 

USE MSS_TRP

SET NOCOUNT ON

UPDATE tb_assinatura SET nm_arquivo_assinatura = 'PY.JPG'
GO 

UPDATE tb_param_sistema SET txt_param = '\\MSHFSS01V\Transporte$\D0\planilha\' WHERE ds_param = 'PROCESSAMENTO EM LOTE - PROCESSAR PLANILHA - CAMINHO ARQUIVO REDE'
GO

print '#############################################################################################################'
print '# -- Script de atualiza��o das rotas MSS_TRP.tb_param_sistema, MSS_TRP.tb_assinatura -- '
print '# Atualiza o caminho de rede utilizado na importa��o de planilha do TRP'
print '# Atualiza as assinaturas com a imagem existente no ambiente.'
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 


---------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------

print '#############################################################################################################'
print '# -- Script de atualiza��o de rotas MSS_CNF.tb_publico_seguranca -- '
print '# Atualiza a chave de seguran�a utilizada pelo Kit '
print '# Atualiza a chave de seguran�a utilizada pelo MS10 '
print '# Atualiza a chave de seguran�a utilizada pelo WS '
print '# INICIO '
print SYSDATETIME () 
print '#############################################################################################################' 

USE MSS_CNF

SET NOCOUNT ON

-- Precificador - Release 1
UPDATE tb_publico_seguranca SET dc_chave64 = '23097edsfhds9dsf89dfshfds98fsdh98dsf7hf777d' WHERE dc_sistema = 'Mitsui.MS10PlusKit'
UPDATE tb_publico_seguranca SET dc_chave64 = 'dklfhds90d98sdf980sdf09098908ds990921211RTT' WHERE dc_sistema = 'Mitsui.MS10.Asp'
UPDATE tb_publico_seguranca SET dc_chave64 = '9834263829iuyewiurey93287239erw9r87892UUY89' WHERE dc_sistema = 'Mitsui.WSCalculo'
-- Precificador - Release 1

GO 

print '#############################################################################################################'
print '# -- Script de atualiza��o de rotas MSS_CNF.tb_publico_seguranca -- '
print '# Atualiza a chave de seguran�a utilizada pelo Kit '
print '# Atualiza a chave de seguran�a utilizada pelo MS10 '
print '# Atualiza a chave de seguran�a utilizada pelo WS '
print '# FIM '
print SYSDATETIME () 
print '#############################################################################################################' 