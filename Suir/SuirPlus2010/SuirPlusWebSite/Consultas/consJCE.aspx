<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consJCE.aspx.vb" Inherits="Consultas_consJCE" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

         
    </script>
    <div class="header" align="left">
        Consulta de Ciudadanos<br />
        <br />        
        <asp:Panel ID="pnlGeneral" runat="server">
        <asp:HiddenField ID="hfCodSex" runat="server" />
        <asp:HiddenField ID="hfCedulaJCE" runat="server" />
        <asp:HiddenField ID="hfCedulaTSS" runat="server" />
        <asp:HiddenField ID="hfNombreJCE" runat="server" />
        <asp:HiddenField ID="hfNombreTSS" runat="server" />
        <asp:HiddenField ID="hfNSS" runat="server" />
        <asp:HiddenField ID="hfFechaCancelacion" runat="server" />
            <table border="0" cellpadding="0" cellspacing="0"`>
                 <tr>
                    <td align="left">
                        Nro. Documento:
                        <asp:TextBox ID="txtDocumento" onKeyPress="checkNum()" runat="server" MaxLength="11"
                            EnableViewState="False" />&nbsp;<asp:Button ID="btnBuscar" runat="server" Text="Buscar"/>
                            &nbsp;&nbsp;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar" />
                        <br /><br />
                    </td>
                    <td id="tdNssDuplicados" runat="server" align="left" visible="false">
                        Registros encontrados:
                        <asp:DropDownList ID="ddlNSSDuplicados" runat="server" CssClass="dropDowns" AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                 <tr>
                     <td colspan="2">
                         <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>
                         <br /><br />
                     </td>
                 </tr>
                     <tr>
                         <td valign="top">
                           <fieldset id="fsJCE" runat="server" visible="false" 
                                 style="height:auto; width:450px">
                            <legend>Datos Ciudadanos JCE</legend>
                            <asp:Panel ID="pnlInfoJCE" runat="server" Visible="false">                
                            
                                 <table width="445px">
                                         <tr>
                                             <td align="right" nowrap="nowrap" style="height: 19px">
                                                 Nro. Cédula:</td>
                                             <td style="height: 19px">
                                                 <asp:Label ID="lblCedula" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                             <td rowspan="3" align="right">
                                                 <img src="../images/LogoJCEhorizontal.png" />
                                                 <br />
                                                 &nbsp;</td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap" style="height: 16px">
                                                 Nombres:
                                             </td>
                                             <td style="height: 16px">
                                                 <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap" style="height: 17px">
                                                 Primer Apellido:
                                             </td>
                                             <td style="height: 17px">
                                                 <asp:Label ID="lblPrimerApellido" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap">
                                                 Segundo Apellido:
                                             </td>
                                             <td colspan="2">
                                                 <asp:Label ID="lblSegundoApellido" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap" style="height: 16px">
                                                 Fecha Nacimiento:</td>
                                             <td align="left" colspan="2" style="height: 16px">
                                                 <asp:Label ID="lblFechaNac" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <asp:Panel ID="pnlMasInfoJCE" runat="server">
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Sexo:
                                                 </td>
                                                 <td align="left" colspan="2">
                                                     <asp:Label ID="lblSexo" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Datos Acta:</td>
                                                 <td colspan="2" nowrap="nowrap">
                                                     Oficialia:<asp:Label ID="lblOficialia" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Libro:<asp:Label ID="lblLibro" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Folio:<asp:Label ID="lblFolio" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Nro Acta:<asp:Label ID="lblNroActa" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Año:<asp:Label ID="lblAno" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     &nbsp;</td>
                                                 <td colspan="2">
                                                     Municipio:<asp:Label ID="lblCodMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Cod Sangre:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblCodSangre" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblSangre" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Cod Nación:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblCodNacion" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblNacionalidad" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Estado Civil:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblEstadoCivil" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Tipo Causa:
                                                 </td>
                                                 <td align="left" colspan="2">
                                                     <asp:Label ID="lblTipoCausa" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Cod Causa:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblCodCausa" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblCausaInhabilidad" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Estatus:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblEstatusDesc" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Padre:
                                                 </td>
                                                 <td align="left" colspan="2">
                                                     <asp:Label ID="lblPadreNombre" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblCedulaP" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Madre:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblMadreNombres" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblCedulaM" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                         </asp:Panel>
                                     </table>                                
                            </asp:Panel>
                            <div id="divmsgJCE" align="center" runat="server" visible="false" 
                                   style="height: auto">
                                <img src="../images/LogoJCEhorizontal.png" />
                                <br />
                                <br />
                            <asp:Label ID="lblmsgJCE" runat="server" CssClass="error" Font-Size="Medium"></asp:Label>
                                <br />
                                <br />
                            </div>
                            </fieldset>                        
                         </td>
                         <td valign="top">
                            <fieldset id="fsTSS" runat="server" visible="false"  
                                 style="height:auto; width:450px">
                                <legend>Datos Ciudadanos TSS</legend>
                             <asp:Panel ID="pnlInfoTSS" runat="server" Visible="false">
                                <table width="445">
                                         <tr>
                                             <td align="right" nowrap="nowrap">
                                                 Nro. Cédula:
                                             </td>
                                             <td>
                                                 <asp:Label ID="lblCedula1" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                             <td rowspan="3" align="right">
                                                 <img src="../images/logoTSShorizontalsmaller.gif" />
                                             </td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap">
                                                 Nombres:
                                             </td>
                                             <td>
                                                 <asp:Label ID="lblNombres1" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap">
                                                 Primer Apellido:
                                             </td>
                                             <td>
                                                 <asp:Label ID="lblPrimerApellido1" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap">
                                                 Segundo Apellido
                                             </td>
                                             <td colspan="2">
                                                 <asp:Label ID="lblSegundoApellido1" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td align="right" nowrap="nowrap" style="height: 18px">
                                                 Fecha Nacimiento:</td>
                                             <td align="left" colspan="2" style="height: 18px">
                                                 <asp:Label ID="lblFechaNacimiento1" runat="server" CssClass="labelData"></asp:Label>
                                             </td>
                                         </tr>
                                         <asp:Panel ID="pnlMasInfoTSS" runat="server">
                                         <tr>
                                         
                                         </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Sexo:
                                                 </td>
                                                 <td colspan="2" align="left">
                                                     <asp:Label ID="lblSexo1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Datos Acta:
                                                 </td>
                                                 <td colspan="2" nowrap="nowrap">
                                                     Oficialia:<asp:Label ID="lblOficialia1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Libro:<asp:Label ID="lblLibro1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Folio:<asp:Label ID="lblFolio1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Nro Acta:<asp:Label ID="lblNroActa1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;Año:<asp:Label ID="lblAno1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     &nbsp;
                                                 </td>
                                                 <td colspan="2">
                                                     Municipio:<asp:Label ID="lblCodMunicipio1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblMunicipio1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Cod Sangre:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblCodSangre1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblSangre1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Cod Nación
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblCodNacion1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblNacionalidad1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Estado Civil:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblEstadoCivil1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Tipo Causa:
                                                 </td>
                                                 <td align="left" colspan="2">
                                                     <asp:Label ID="lblTipoCausa1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Cod Causa:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblCodCausa1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblCausaInhabilidad1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Estatus:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblEstatus1" runat="server" CssClass="labelData"></asp:Label>
                                                     &nbsp;<asp:Label ID="lblEstatusDesc1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Padre:
                                                 </td>
                                                 <td align="left" colspan="2">
                                                     <asp:Label ID="lblPadreNombre1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                             <tr>
                                                 <td align="right" nowrap="nowrap">
                                                     Madre:
                                                 </td>
                                                 <td colspan="2">
                                                     <asp:Label ID="lblMadreNombres1" runat="server" CssClass="labelData"></asp:Label>
                                                 </td>
                                             </tr>
                                         </asp:Panel>
                                     </table>
                            </asp:Panel>  
                             <div id="divmsgTSS" align="center" runat="server" visible="false" style="height: auto">
                                    <img src="../images/logoTSShorizontalsmaller.gif" />
                                    <br />
                                    <br />
                                    <asp:Label ID="lblmsgTSS" runat="server" CssClass="error" Font-Size="Medium"></asp:Label>
                            </div>

                            </fieldset>   
                         </td>
                     </tr>
                     <tr>
                         <td align="right" colspan="2">
                             <br />
                             <asp:Button ID="btnActualizar" runat="server" Text="Actualizar" />
                             &nbsp;&nbsp;
                             <asp:Button ID="btnInsertar" runat="server" Text="Insertar" />
<%--                             &nbsp;&nbsp;
                             <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" />--%>
                             <br />
                         </td>
                     </tr>
            </table>
        </asp:Panel>
    </div>
</asp:Content>
