<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SolicitarAcuerdoPago.aspx.vb" Inherits="Legal_SolicitarAcuerdoPago" title="Generación de Acuerdo de Pag" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">
        Generación de Acuerdo de Pago</div>
     <div class="subHeader">Ley No. 189-07 que facilita el pago a los empleadores con deudas pendientes con el
Sistema Dominicano de Seguridad Social.</div>
        <br />
        <table cellpadding="1" cellspacing="0" class="td-content">
            <tr>
                <td rowspan="7" >
                    <img src="../images/Legal.jpg" /></td>
                <td align="right" style="width: 60px" >
                    </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                    </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                    <asp:Label ID="lbltxtRNC" runat="server" Font-Bold="True" Text="RNC:"></asp:Label></td>
                <td style="width: 273px" >
                    &nbsp;<asp:TextBox ID="txtRNC" runat="server" EnableViewState="False" MaxLength="11"></asp:TextBox>
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                        Display="Dynamic" ErrorMessage="RegularExpressionValidator" SetFocusOnError="True"
                        ValidationExpression="^(\d{9}|\d{11})$">RNC o Cédula Inválido</asp:RegularExpressionValidator>
                    &nbsp;&nbsp;
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                    </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                </td>
                <td style="width: 273px" >
                    &nbsp;</td>
            </tr>
            <tr>
                <td align="right" style="width: 60px" >
                </td>
                <td style="width: 273px" >
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />&nbsp;
                    <asp:Button ID="btnLimpiar" runat="server" Text="Cancelar" /></td>
            </tr>
            <tr>
                <td style="text-align: center;" colspan="2">
                    <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
            </tr>
        </table>
    <br />
    <asp:Label ID="lbltxtInfoAcuerdoPago" runat="server" CssClass="subHeader" Text="Favor completar la siguiente información para continuar con el proceso:"
        Visible="False"></asp:Label><br />
    <br />
    <table cellpadding="3" cellspacing="0" id="tblInfoAcuerdo" runat="server" visible="false">
        <tr>
            <td align="right" style="text-align: left" colspan="2" >
                <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Datos Generales:"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                    <asp:Label ID="lbltxtRazonSocial" runat="server" Text="Razón Social:" Visible="False"></asp:Label></td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                    <asp:Label ID="lbltxtNombreComercial" runat="server" Text="Nombre Comercial:" Visible="False"></asp:Label></td>
            <td>
                <asp:Label ID="lblNombreComercial" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                    <asp:Label ID="lbltxtTelefono" runat="server" Text="Teléfono:" Visible="False"></asp:Label></td>
            <td>
                <asp:Label ID="lblTelefono" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label2" runat="server" Text="Representante Legal:"></asp:Label></td>
            <td>
                <uc1:UCCiudadano ID="ucCiudadano" runat="server" />
            </td>
        </tr>
        <tr>
            <td align="right" >
                <asp:Label ID="Label4" runat="server" Text="Cargo:"></asp:Label>&nbsp;</td>
            <td >
                &nbsp;<asp:TextBox ID="txtCargo" runat="server" Width="140px">Presidente</asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtCargo"
                    Display="Dynamic" ErrorMessage="El Cargo es requerido" ValidationGroup="grupo"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right" >
                <asp:Label ID="Label1" runat="server" Text="Dirección:"></asp:Label></td>
            <td >
                <asp:TextBox ID="txtDireccion" runat="server" Width="471px"></asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtDireccion"
                    Display="Dynamic" ErrorMessage="La Dirección es requerida" ValidationGroup="grupo"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label11" runat="server" Text="Nacionalidad:"></asp:Label></td>
            <td>
                <asp:TextBox ID="txtNacionalidad" runat="server" Width="140px">Dominicano</asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtNacionalidad"
                    Display="Dynamic" ErrorMessage="La nacionalidad es requerida" ValidationGroup="grupo"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label12" runat="server" Text="Estado Civil:"></asp:Label></td>
            <td>
                <asp:TextBox ID="txtEstadoCivil" runat="server" Width="140px">Casado</asp:TextBox>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtEstadoCivil"
                    Display="Dynamic" ErrorMessage="El nacionalidad es requerida" ValidationGroup="grupo"></asp:RequiredFieldValidator></td>
        </tr>
        <tr>
            <td align="right">
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td align="right" style="text-align: left">
                <asp:Label ID="Label5" runat="server" CssClass="subHeader" Text="Cuotas:"></asp:Label></td>
            <td>
            </td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label10" runat="server" Text="Monto total:"></asp:Label></td>
            <td>
                <asp:Label ID="lblMontoTotal" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label6" runat="server" Text="Cant. de Notificaciones:"></asp:Label></td>
            <td>
                <asp:Label ID="lblCantidadNotificaciones" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                <asp:Label ID="Label7" runat="server" Text="Cant. de Meses:"></asp:Label></td>
            <td>
                <asp:Label ID="lblCantidadMeses" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
            </td>
            <td>
            </td>
        </tr>
        <tr>
            <td align="right" colspan="2" style="text-align: left">
                <asp:GridView ID="gvNotificaciones" runat="server" AutoGenerateColumns="False" CellPadding="3">
                    <Columns>
                        <asp:TemplateField HeaderText="Cuota">
                            <ItemTemplate>
                                <asp:DropDownList ID="DropDownList1" runat="server" CssClass="dropDowns">
                                </asp:DropDownList>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="ID_REFERENCIA" HeaderText="# Referencia" >
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Nomina_DES" HeaderText="Nomina" >
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Periodo_FACTURA" HeaderText="Periodo" >
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Total" DataFormatString="{0:c}" HeaderText="Total" HtmlEncode="False" >
                            <ItemStyle HorizontalAlign="Right" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td align="right" colspan="2" style="text-align: center">
                <asp:Button ID="Button1" runat="server" Text="Continuar" ValidationGroup="grupo" />
                <br />
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ValidationGroup="grupo" />
                <br />
                <asp:Label ID="lblMensajeError2" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
        </tr>
    </table>
    &nbsp;<br />
        <br />
        <br />

</asp:Content>

