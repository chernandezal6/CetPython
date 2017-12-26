<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consMenores.aspx.vb" Inherits="Consultas_consMenores" title="Consulta Menores de Edad" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">
        Consulta Menores de Edad<br /> <br />
    </div>
      
   <script language="javascript" type="text/javascript">
	function checkNum()
	    {
            var carCode = event.keyCode;
            
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
         } 
    </script>        
    <asp:UpdatePanel ID="udpBuscar" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table cellpadding="1" cellspacing="0" class="td-content" style="width: 337px">
        <tr>
            <td style="width: 25%; height:5px;"></td>
            <td style="width: 251px"></td>
        </tr>
        <tr>
            <td align="right">
                NSS:</td>
            <td style="width: 251px">

                <asp:TextBox ID="txtNSS" onKeyPress="checkNum()" runat="server" EnableViewState="False" MaxLength="10" ></asp:TextBox>&nbsp;

           </td>                          
        </tr>
        <tr>
            <td align="right">
                Nro. Documento:</td>
            <td style="width: 251px">
                <asp:TextBox ID="txtDocumento" onKeyPress="checkNum()" runat="server" EnableViewState="False" MaxLength="11" />
            </td>
        </tr>
        
        <tr>
            <td align="right" style="height: 20px">
            </td>
            <td style="height: 20px; width: 251px;">
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="Ciudadano" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;<asp:LinkButton ID="lnkVolver" runat="server"
                    OnClick="lnkVolver_Click" Width="97px">Volver a Ciudadanos</asp:LinkButton></td>
        </tr>
        <tr>
            <td style="height: 5px;" align="center" colspan="2"></td>
        </tr>
    </table>
    
    <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label><br />
    
    <table cellpadding="1" cellspacing="0" width="400">
         <tr>
            <td>
    
    <div style="FLOAT: left; WIDTH: 441px; MARGIN-RIGHT: 10px" id="divInfoMenor" runat="server" 
                    visible="false">
        <Fieldset> 
            <Legend>Información Del Menor</Legend><BR /> 
                       
             <table cellpadding="1" cellspacing="0" width="400" class="td-content">
                            
                            <tr>
                                <td style="width: 100px">
                                    NSS</td>
                                <td>
                                    <asp:Label ID="lblNSS" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            <tr>
                                <td style="width: 100px">
                                    No. Documento</td>
                                <td>
                                    <asp:Label ID="lblNoDocumento" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            <tr>
                                <td style="width: 100px">
                                    Tipo</td>
                                <td>
                                    <asp:Label ID="lblTipoDoc" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                                                        
                            <tr>
                                <td style="width: 100px">
                                    Nombres</td>
                                <td>
                                    <asp:Label ID="lblNombresMenor" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Apellidos</td>
                                <td>
                                    <asp:Label ID="lblApellidosMenor" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Fecha Nacimiento</td>
                                <td>
                                    <asp:Label ID="lblFechaNac" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            <tr>
                                <td style="width: 100px">
                                    ARS Registro
                                </td>
                                <td>
                                    <asp:Label ID="lblIdARSREGISTRO" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            <tr>
                                <td style="width: 100px">
                                    ARS
                                </td>
                                <td>
                                    <asp:Label ID="lblARSMenor" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                             
                            <tr>
                                <td style="width: 100px">
                                    Fecha Carga</td>
                                <td>
                                    <asp:Label ID="lblFechaCarga" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            <tr>
                                <td style="width: 100px">
                                    Lote</td>
                                <td>
                                    <asp:Label ID="lblLote" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Lote No.</td>
                                <td>
                                    <asp:Label ID="lblLoteNo" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>  
                            
                            <tr>
                                <td style="width: 100px">
                                    Lote Secuencia.</td>
                                <td>
                                    <asp:Label ID="lblSecuenciaReg" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>                         
                            
                            <tr>
                                <td style="width: 100px">
                                    ID ARS Actual</td>
                                <td>
                                    <asp:Label ID="lblIdARSActual" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            <tr>
                                <td style="width: 100px">
                                    ARS Actual</td>
                                <td>
                                    <asp:Label ID="lblARSActual" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Status Afiliación</td>
                                <td>
                                    <asp:Label ID="lblStatusActual" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Tipo Afiliación</td>
                                <td>
                                    <asp:Label ID="lblTipoAfiliacion" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                </td>
                                <td>
                                </td>
                            </tr>
                        </table><br />


                   
        </Fieldset>
     </DIV>
     
        </td>
      </tr>             
      <tr>
        <td>
    <div style="FLOAT: left; WIDTH: 441px; MARGIN-RIGHT: 10px" id="divInfoActa" 
                runat="server" visible="false">
        <Fieldset> 
            <Legend>Información Acta Nacimiento</Legend><BR /> 

                 <table cellpadding="1" cellspacing="0" width="400" class="td-content">

                            <tr>
                                <td style="width: 100px" align="center">
                                    Municipio</td>
                                <td style="width: 100px" align="center">
                                    Oficilía</td>
                                <td style="width: 100px" align="center">
                                    Libro</td>
                                <td style="width: 100px" align="center">
                                    Folio</td>
                                <td style="width: 100px" align="center">
                                    Año</td>
                                <td style="width: 100px" align="center">
                                    Acta No.</td>
                            </tr>
                            <tr>
                                <td style="width: 100px; height: 14px;" align="center">
                                    <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label></td>
                                <td style="width: 100px; height: 14px;" align="center">
                                    <asp:Label ID="lblOficialia" runat="server" CssClass="labelData"></asp:Label></td>
                                <td style="width: 100px; height: 14px;" align="center">
                                    <asp:Label ID="lblLibro" runat="server" CssClass="labelData"></asp:Label></td>
                                <td style="width: 100px; height: 14px;" align="center">
                                    <asp:Label ID="lblFolio" runat="server" CssClass="labelData"></asp:Label></td>
                                <td style="width: 100px; height: 14px;" align="center">
                                    <asp:Label ID="lblAno" runat="server" CssClass="labelData"></asp:Label></td>
                                <td style="width: 100px; height: 14px;" align="center">
                                    <asp:Label ID="lblActaNo" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px; height: 14px;" colspan="6">
                                </td>
                            </tr>
                        </table><br />
                   
        </Fieldset>
     </DIV> 
          </td>
      </tr>             
      <tr>
        <td>   
     <div style="FLOAT: left; WIDTH: 441px; MARGIN-RIGHT: 10px" id="divInfoTitular" 
                runat="server" visible="false">
        <Fieldset> 
            <Legend>Información Titular</Legend><BR /> 
                       
                  <table cellpadding="1" cellspacing="0" width="400" class="td-content">
                            
                           <tr>
                                <td style="width: 100px">
                                    NSS Titular</td>
                                <td>
                                    <asp:Label ID="lblNSSTitular" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Nombres</td>
                                <td>
                                    <asp:Label ID="lblNombresTitular" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Apellidos</td>
                                <td>
                                    <asp:Label ID="lblApellidosTitular" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 100px">
                                    Cédula</td>
                                <td>
                                    <asp:Label ID="lblCedulaTitular" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            <tr>
                                <td style="width: 100px">
                                </td>
                                <td>
                                </td>
                            </tr>
                        </table><br />

                   
        </Fieldset>
     </DIV>   
           
        <td style="height: 5px;" align="center" colspan="2"></td>
      </tr>
    </table>       
        </ContentTemplate>
    </asp:UpdatePanel>
    &nbsp; &nbsp;&nbsp;

        
  <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 17px; bottom: 0%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>  

</asp:Content>

