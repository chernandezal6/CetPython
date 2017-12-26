<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consEmpresasRepresentante.aspx.vb" Inherits="Consultas_consEmpresasRepresentante" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#<%=btnBuscar.ClientID%>").button();
            $("#<%=btnLimpiar.ClientID%>").button();


        });

        function entero(e) {
            var caracter
            caracter = e.keyCode
            status = caracter

            if (caracter > 47 && caracter < 58) {
                return true
            }
            return false

        }
    </script>
    <span class="header">Consulta Empresas con Representante</span>
    <br />
    <br />
    <fieldset style="width: 325px; height: 45px; border: 1px solid #DBEAF3; background-color: #F8FBFC;">
        <table cellpadding="0" width="320px">
            <tr>
                <td align="right">
                    Cédula:
                </td>
                <td>
                    <asp:TextBox ID="txtCedula" runat="server" EnableViewState="False" MaxLength="11"></asp:TextBox>
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" Style="font-size: 11px" />
                    <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" Text="Limpiar"
                        Style="font-size: 11px" />
                </td>
            </tr>
            <tr>
                <td align="center" colspan="2">
                    <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCedula"
                        Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$"
                        SetFocusOnError="True" EnableViewState="False">Cédula Inválida</asp:RegularExpressionValidator>
                </td>
            </tr>
            <%--
            <tr>
                <td align="center" colspan="2">
                    &nbsp;</td>
            </tr>--%>
        </table>
    </fieldset>
    <div>
        <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"
            Visible="False"></asp:Label>
    </div>
    <br />
    <asp:Panel runat="server" ID="pnlEmpresasRepresentante" Visible="false">
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table cellpadding="3" cellspacing="0" id="tblInfoEmpleador" runat="server" style="width: 350px"
                        class="td-content">
                        <tr id="Tr1" runat="server">
                            <td id="Td1" align="right" style="text-align: left" colspan="2" runat="server">
                                <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Representante:"></asp:Label>
                            </td>
                        </tr>
                        <tr id="Tr2" runat="server">
                            <td id="Td2" align="right" style="width: 94px" runat="server">
                                <asp:Label ID="Label2" runat="server" Text="Nombre:"></asp:Label>
                            </td>
                            <td id="Td3" runat="server">
                                <asp:Label ID="lblNombre" runat="server" Font-Bold="True"></asp:Label>
                            </td>
                        </tr>
                        <tr id="Tr3" runat="server">
                            <td id="Td4" align="right" style="width: 94px" runat="server">
                                <asp:Label ID="Label1" runat="server" Text="NSS:"></asp:Label>
                            </td>
                            <td id="Td5" runat="server">
                                <asp:Label ID="lblNSS" runat="server" Font-Bold="True"></asp:Label>
                            </td>
                        </tr>                  
                    </table>
                     <br />
                </td>
            </tr>
            <tr>
                <td>
                    <asp:GridView ID="gvEmpresasRepresentante" runat="server" AutoGenerateColumns="False"
                        CellPadding="0" Style="width: 590px;">
                        <Columns>
                            <asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="nombre_comercial" HeaderText="Nombre Comercial">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="status" HeaderText="Estatus">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ult_fecha_act" HeaderText="Ultima Fecha Actualizada">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
        </table>
       
    </asp:Panel>
</asp:Content>
