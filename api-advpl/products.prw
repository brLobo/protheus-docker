#include "totvs.ch"
#include "restful.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} products
Declara��o do ws producs
@author Anderson Toledo
@since 25/04/2019
@version 1.0
/*/
//-------------------------------------------------------------------
WSRESTFUL products DESCRIPTION 'endpoint products API' FORMAT "application/json,text/html"
    WSDATA Page     AS INTEGER OPTIONAL
    WSDATA aQueryString AS ARRAY OPTIONAL
    
 	WSMETHOD GET ProdList;
	    DESCRIPTION "Retorna uma lista de produtos";
	    WSSYNTAX "/api/v1/products" ;
        PATH "/api/v1/products" ;
	    PRODUCES APPLICATION_JSON
 	
END WSRESTFUL
//-------------------------------------------------------------------
/*/{Protheus.doc} GET ProdList
M�todo GET com id ProdList
@author Anderson Toledo
@since 25/04/2019
@version 1.0
/*/
//-------------------------------------------------------------------
WSMETHOD GET ProdList QUERYPARAM Page WSREST products
Return getPrdList(self)
//-------------------------------------------------------------------
/*/{Protheus.doc} GET getPrdList
Fun��o para tratamento da requisi��o GET
@author Anderson Toledo
@since 25/04/2019
@version 1.0
/*/
//-------------------------------------------------------------------
Static Function getPrdList( oWS )
   Local lRet  as logical
   Local oProd as object
   DEFAULT oWS:Page      := 1  
   lRet        := .T.
   //PrdAdapter ser� nossa classe que implementa fornecer os dados para o WS
   // O primeiro parametro indica que iremos tratar o m�todo GET
   oProd := PrdAdapter():new( 'GET' )
  
   //o m�todo setPage indica qual p�gina deveremos retornar
   //ex.: nossa consulta tem como resultado 100 produtos, e retornamos sempre uma listagem de 10 itens por p�gina.
   // a p�gina 1 retorna os itens de 1 a 10
   // a p�gina 2 retorna os itens de 11 a 20
   // e assim at� chegar ao final de nossa listagem de 100 produtos 
   oProd:setPage(oWS:Page)
   // setPageSize indica que nossa p�gina ter� no m�ximo 10 itens
   oProd:setPageSize(10)
   // Esse m�todo ir� processar as informa��es
   //Ir� transferir as informa��es de filtros da url para o objeto
   oProd:SetUrlFilter( oWS:aQueryString )
   oProd:GetListProd()
   //Se tudo ocorreu bem, retorna os dados via Json
   If oProd:lOk
       oWS:SetResponse(oProd:getJSONResponse())
   Else
   //Ou retorna o erro encontrado durante o processamento
       SetRestFault(oProd:GetCode(),oProd:GetMessage())
       lRet := .F.
   EndIf
   //faz a desaloca��o de objetos e arrays utilizados
   oProd:DeActivate()
   oProd := nil
   
Return lRet
