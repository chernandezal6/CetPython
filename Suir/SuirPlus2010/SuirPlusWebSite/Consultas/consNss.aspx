<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="true"
    CodeFile="consNss.aspx.vb" Inherits="Consultas_consNss" Title="Consulta de NSS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript">

        if (top != self) top.location.replace(location.href);

    </script>
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;

            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }
    </script>
    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <div class="header">Consulta de NSS</div><br />
    <table class="consultaTabla" cellspacing="1" cellpadding="1" border="0" style="width: 350px">
        <tr>
            <td>
                <table id="Table1" cellspacing="0" cellpadding="0" class="td-content">
                    <tr>
                        <td colspan="2">
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td nowrap="nowrap" align="right">No Documento:&nbsp;</td>
                        <td align="left">
                            <asp:TextBox ID="txtnodocumento" runat="server" onkeypress="checkNum()" MaxLength="11"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" align="center" style="height: 18px">
                            <br />
                            <asp:Button ID="btBuscarRef" runat="server" EnableViewState="False" Enabled="True"
                                Text="Buscar"></asp:Button>
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False"></asp:Button>
                            <br />
                            <br />
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>

    <table id="tblDetalle1" cellspacing="1" cellpadding="1" border="0">
        <tr>
            <td align="center" colspan="2" style="height: 18px"><br />
                <asp:GridView ID="dgDetalle" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="id_nss" HeaderText="NSS">
                            <HeaderStyle Width="100px"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="nombres" HeaderText="Nombres">
                            <HeaderStyle Width="150px" HorizontalAlign="Left"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="apellidos" HeaderText="Apellidos">
                            <HeaderStyle Width="150px" HorizontalAlign="Left"></HeaderStyle>
                            <ItemStyle HorizontalAlign="Left"></ItemStyle>
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
    </table>

    <asp:RequiredFieldValidator ControlToValidate="txtnodocumento" ID="RequiredFieldValidator1" runat="server" ErrorMessage="El campo 'No Documento' es Requerido!!" Display="Dynamic"></asp:RequiredFieldValidator>
    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtnodocumento"
    CssClass="error" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{11})$">Documento Inválido</asp:RegularExpressionValidator>
    <asp:Label ID="lblFijo" runat="server" CssClass="error"></asp:Label>
    <asp:Label ID="lblFormError" runat="server" CssClass="error"></asp:Label>
</asp:Content>
