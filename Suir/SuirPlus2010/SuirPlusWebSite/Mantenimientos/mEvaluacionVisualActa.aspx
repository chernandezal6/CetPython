<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="mEvaluacionVisualActa.aspx.vb" Inherits="Mantenimientos_mEvaluacionVisualActa" %>

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
    <div class="header" align="left">
        Evaluación Visual Acta<br />
        <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="10pt" Text="lblMsg"
            Visible="False"></asp:Label><br />
        <asp:Panel ID="pnlGeneral" runat="server" Visible="true">
            <table border="0" cellpadding="0" cellspacing="0" width="600px">
             <tr>
                 <td align="right" style="color: Blue"><strong>Motivo Rechazo:&nbsp;</strong></td>
                 <td>
             <asp:Label ID="lblDescError" runat="server"  ForeColor="Red" CssClass="labelData"></asp:Label>
           </td>
             </tr>
                <table>
                     <tr>
                        <td>
                         <fieldset style="width: 550px">
                          <legend>Evaluación Visual</legend>
                                <table>
                                    <tr>
                                        <td align="right">
                                            NSS:
                                        </td>
                                        <td style="height: 16px">
                                            <asp:Label ID="LblNss1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Nro. Cédula:
                                        </td>
                                        <td style="height: 16px">
                                            <asp:Label ID="lblCedula1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Nombres:
                                        </td>
                                        <td class="sel">
                                            <asp:Label ID="lblNombres1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Primer Apellido:
                                        </td>
                                        <td class="sel">
                                            <asp:Label ID="lblPrimerApellido1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Segundo Apellido
                                        </td>
                                        <td class="sel">
                                            <asp:Label ID="lblSegundoApellido1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Sexo:
                                        </td>
                                        <td align="left">
                                            <asp:Label ID="lblSexo1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Fecha Nacimiento:
                                        </td>
                                        <td style="height: 14px">
                                            <asp:Label ID="lblFechaNac1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Municipio:
                                        </td>
                                        <td class="sel">
                                            <asp:Label ID="lblMunicipio1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Oficialia:
                                        </td>
                                        <td class="sel">
                                            <asp:Label ID="lblOficialia1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Libro:
                                        </td>
                                        <td align="left">
                                            <asp:Label ID="lblLibro1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Folio:
                                        </td>
                                        <td align="left">
                                            <asp:Label ID="lblFolio1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Nro Acta:
                                        </td>
                                        <td>
                                            <asp:Label ID="lblNroActa1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Año:
                                        </td>
                                        <td>
                                            <asp:Label ID="lblAno1" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    </table>          
                            </fieldset>
                        </td> 
                                                                       
                        <td>
                         <fieldset style="width: 550px">
                          <legend>Datos Ciudadanos</legend>
                            <table>                                   
                                       <tr>
                                            <td align="right">
                                                NSS:
                                            </td>
                                            <td style="height: 16px">
                                                <asp:Label ID="lblNss" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Nro. Cédula:
                                            </td>
                                            <td style="height: 16px">
                                                <asp:Label ID="lblCedula" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Nombres:
                                            </td>
                                            <td class="sel">
                                                <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Primer Apellido:
                                            </td>
                                            <td class="sel">
                                                <asp:Label ID="lblPrimerApellido" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Segundo Apellido
                                            </td>
                                            <td class="sel">
                                                <asp:Label ID="lblSegundoApellido" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Sexo:
                                            </td>
                                            <td align="left">
                                                <asp:Label ID="lblSexo" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Fecha Nacimiento:
                                            </td>
                                            <td style="height: 14px">
                                                <asp:Label ID="lblFechaNacimiento" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Municipio:
                                            </td>
                                            <td class="sel">
                                                <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Oficialia:
                                            </td>
                                            <td class="sel">
                                                <asp:Label ID="lblOficialia" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Libro:
                                            </td>
                                            <td align="left">
                                                <asp:Label ID="lblLibro" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Folio:
                                            </td>
                                            <td align="left">
                                                <asp:Label ID="lblFolio" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Nro Acta:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblNroActa" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       <tr>
                                            <td align="right">
                                                Año:
                                            </td>
                                            <td>
                                                <asp:Label ID="lblAno" runat="server" CssClass="labelData"></asp:Label>
                                            </td>
                                        </tr>
                                       
                                  </table>
                            </fieldset>
                        </td>
                    </tr>
                </table>
                      <div class="header" align="left">
        Imagen Acta de Nacimiento:</div> 
                          
              </table>
                <table>
                 <tr>
                   <td>
                    <table>
                   <tr>
                <td colspan="2">
                     <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False">
                        <Fields>
                            <asp:ImageField DataImageUrlField="idRow" 
                                DataImageUrlFormatString="~/Mantenimientos/MostrarImagenEvaluar.aspx?id={0}" 
                                NullDisplayText="No Tiene Imagen" ReadOnly="True" ShowHeader="False">
                                <ItemStyle Height="350px" Width="567px" />
                                <ControlStyle Height="350px" Width="567px" />
                                <FooterStyle Height="350px" Width="567px" />
                                <HeaderStyle Height="350px" Width="567px" />
                            </asp:ImageField>
                        </Fields>
                    </asp:DetailsView>
                    </td>

                </tr>
                </table>
                   </td>
                   <td>
                    <table>
                <tr>
                    <td colspan="2">
                              <asp:DetailsView ID="DetailsView2" runat="server" AutoGenerateRows="False">
                            <Fields>
                                <asp:ImageField DataImageUrlField="id_nss" 
                                    DataImageUrlFormatString="~/Mantenimientos/MostrarImagenCiudadano.aspx?id={0}" 
                                    NullDisplayText="No Tiene Imagen" ReadOnly="True" ShowHeader="False">
                                    <ItemStyle Height="350px" Width="567px" />
                                    <ControlStyle Height="350px" Width="567px" />
                                    <FooterStyle Height="350px" Width="567px" />
                                    <HeaderStyle Height="350px" Width="567px" />
                                </asp:ImageField>
                            </Fields>
                        </asp:DetailsView>
                    </td>
                </tr>
                </table>
                   </td>
                 </tr>

                </table>
                <table>
                  <tr>
                  <td>
                   <asp:Button ID="btnActualiza" runat="server" Text="Aceptar" Width="89px" />
                  </td>
                  <td>
                   <asp:Button ID="btnRechazar" runat="server" Text="Rechazar" Width="87px" />
                  </td>
                  <td>
                   <asp:Button ID="bntSalir" runat="server" Text="Cancelar" Width="87px" />
                  </td>
                  <td align="right">
                                            Motivo Rechazo:
                                        </td>
                  <td colspan="1" nowrap="nowrap" >
                    <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="dropDowns">
                    </asp:DropDownList>
                </td>

                </tr>
                <tr>
                    <td colspan="5">
                        <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false"></asp:Label>
                    </td>
                </tr>
            </table>

        </asp:Panel>
     </div>
</asp:Content>

