<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="mEvaluarFallecido.aspx.vb" Inherits="Mantenimientos_mEvaluarFallecido" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
 <script language="javascript" type="text/javascript">
     function checkNum() {
         var carCode = event.keyCode;
         if ((carCode < 48) || (carCode > 57)) {
             event.cancelBubble = true
             event.returnValue = false;
         }
     }

     $('#theDiv').prepend('<img id="theImg" src="theImg.png" />')
          
    </script>
<div class="header" align="left">Fallecidos<br /></div>
  <br />
   <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false" Font-Size="Small"></asp:Label>
     
        <table>
            <div id="divDatosCiudadano" runat ="server">
                <tr>
                    <td style="width: 400px" >
                        <fieldset style="height:380px;  width: 400px">
                            <legend>Datos Ciudadano Fallecido</legend>
                            <asp:Label ID="LblNovedad" Visible="false" runat="server" CssClass="labelData" ></asp:Label>
                            <table>
                                <tr>
                                    <td align="right" style="width: 121px; font-size:small" >
                                        NSS:
                                    </td>
                                    <td style="height: 16px">
                                        <asp:Label ID="lblNss" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 117px ; font-size:small">
                                        Municipio:
                                    </td>
                                    <td class="sel">
                                        <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 121px; font-size:small">
                                        NroCédula:
                                    </td>
                                    <td style="height: 16px">
                                        <asp:Label ID="lblCedula" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 117px; font-size:small">
                                        Oficialia:
                                    </td>
                                    <td class="sel">
                                        <asp:Label ID="lblOficialia" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 121px; font-size:small">
                                        Nombres:
                                    </td>
                                    <td class="sel">
                                        <asp:Label ID="lblNombres" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 117px; font-size:small">
                                        Libro:
                                    </td>
                                    <td align="left">
                                        <asp:Label ID="lblLibro" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 121px; font-size:small">
                                        Primer Apellido:
                                    </td>
                                    <td class="sel">
                                        <asp:Label ID="lblPrimerApellido" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                              
                                <tr>
                                    <td align="right" style="width: 121px; font-size:small">
                                        Segundo Apellido
                                    </td>
                                    <td class="sel">
                                        <asp:Label ID="lblSegundoApellido" runat="server" CssClass="labelData" nowrap="true" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                  <tr>
                                    <td align="right" style="width: 117px; font-size:small">
                                        Folio:
                                    </td>
                                    <td align="left">
                                        <asp:Label ID="lblFolio" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 117px; font-size:small">
                                        Nro Acta:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblNroActa" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 121px; font-size:small">
                                        Sexo:
                                    </td>
                                    <td align="left">
                                        <asp:Label ID="lblSexo" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 117px; font-size:small">
                                        Año:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblAno" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 121px; font-size:small">
                                        Fecha Nacimiento:
                                    </td>
                                    <td style="height: 14px">
                                        <asp:Label ID="lblFechaNacimiento" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" style="width: 117px; font-size:small">
                                        Fecha Defuncion:
                                    </td>
                                    <td style="height: 14px">
                                        <asp:Label ID="LblFechaDefuncion" runat="server" CssClass="labelData" font-size="small"></asp:Label>
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                    <td>
                    </td>
                    
                    <td>
                        <div id="divImagenActa" runat="server">
                           <%-- <div class="header" align="left">
                                Imagen Acta de Defunción:</div>--%>
                                <%-- DataImageUrlFormatString="/Mantenimientos/MostrarEvaluacionFallecido.aspx" --%>
                               
                        </div>
                        <table>
                            <tr>
                <td colspan="2">
                     <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False" Width="600px" nowrap = "nowrap">
                        <Fields>
                           <asp:ImageField  DataImageUrlField="imagen_acta_defuncion"
                                DataImageUrlFormatString="/Mantenimientos/MostrarEvaluacionFallecido.aspx"
                                NullDisplayText="No Tiene Imagen" ReadOnly="true" ShowHeader="False">
                                <ItemStyle Height="357px" Width="567px" />
                                <ControlStyle Height="357px" Width="567px" />
                                <FooterStyle Height="357px" Width="567px" />
                                <HeaderStyle Height="357px" Width="567px" />
                            </asp:ImageField>
                        </Fields>
                    </asp:DetailsView>
                    </td>

                </tr>
                            <tr>
                                <td>
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" Width="89px" />
                                            </td>
                                            <td>
                                                <asp:Button ID="btnRechazar" runat="server" Text="Rechazar" Width="87px" />
                                            </td>

                                            <td>
                                                <asp:Button ID="btnDescargar" runat="server" Text="Descargar imagen" Width="91px" />
                                            </td>
                                            <td align="right">
                                                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Motivo Rechazo:
                                            </td>
                                            <td colspan="1" nowrap="nowrap">
                                                <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="dropDowns">
                                                </asp:DropDownList>
                                                <asp:Label ID="Lblmsj" runat="server" CssClass="error" Visible="false"></asp:Label>
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </div>
        </table>
    <%--</asp:Panel>
    --%>


    </br>
     </br>
      </br>
</asp:Content>
