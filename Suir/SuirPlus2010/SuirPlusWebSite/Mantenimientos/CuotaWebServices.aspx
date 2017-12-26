<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false" CodeFile="CuotaWebServices.aspx.vb" Inherits="Mantenimientos_CuotaWebServices" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <%-- <style type="text/css">
        .auto-style2 {
            width: 72px;
        }

        .auto-style3 {
            width: 64px;
        }
    </style>--%>
    <%--    <style type="text/css">
        .auto-style1 {
            width: 137px;
        }
    </style>--%>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">

    <div class="header">Mantenimiento de Cuotas Web Services</div>

    <fieldset style="width: 300px">
        <legend>Gestión de Usuario</legend>
        <table id="Table3" cellspacing="2" cellpadding="2" border="0">
            <tr>
                <td class="auto-style2">
                    <strong>Usuario:</strong>
                </td>
                <td class="auto-style1">
                    <asp:TextBox ID="txtSrchUserName" runat="server" MaxLength="35" Style="text-transform: uppercase; width: 150px;"></asp:TextBox>
                    &nbsp;
                    <asp:ImageButton ID="ImgBuscar" runat="server" ImageUrl="../images/buscar.gif" BorderWidth="0px" OnClick="ImgBuscar_Click"></asp:ImageButton>
                </td>
            </tr>
            <tr>
                <td></td>
                <td>
                    <asp:Label ID="lblNombreUsuario" runat="server" CssClass="label-Blue"></asp:Label></td>
            </tr>
            <tr>
                <td class="auto-style2"><strong>Servicio Web: </strong></td>
                <td class="auto-style1">
                    <asp:DropDownList ID="ddlServicioWeb" runat="server" CssClass="dropDowns" Width="155px"></asp:DropDownList></td>
            </tr>
            <tr>
                <td class="auto-style2"><strong>Cuota:</strong></td>
                <td class="auto-style1">
                    <asp:TextBox ID="txtCuota" runat="server" Style="width: 150px;" MaxLength="8"></asp:TextBox><br />
                    <asp:RegularExpressionValidator Display="Dynamic" ControlToValidate="txtCuota" ID="RegularExpressionValidator1" ValidationExpression="^[0-9]*$" runat="server" ErrorMessage="Indicar el valor de las cuotas en números."></asp:RegularExpressionValidator>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right;"></td>
            </tr>
        </table>
        <div style="text-align: right; width: 230px;">
            <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" OnClick="btnAceptar_Click" />&nbsp;&nbsp;
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" OnClick="btnCancelar_Click" />
        </div>

    </fieldset>
    <br />
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="false"></asp:Label>

    <asp:GridView ID="gvListado" runat="server" AutoGenerateColumns="false" CssClass="td-content" OnRowCommand="gvListado_RowCommand">
        <Columns>
             <asp:BoundField DataField="Servicio" HeaderText="Servicio Web" HeaderStyle-HorizontalAlign="Center" />
            <asp:BoundField DataField="Usuario" HeaderText="Usuario" HeaderStyle-HorizontalAlign="Center" />
            <asp:BoundField DataField="Cuota" HeaderText="Cuota" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" />
             <asp:BoundField DataField="Consumo" HeaderText="Cuota Restante" ItemStyle-HorizontalAlign="Right" HeaderStyle-HorizontalAlign="Center" />
            <asp:TemplateField>
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                <ItemTemplate>
                    <asp:LinkButton ID="lnkEliminar" CommandName="Remover" CommandArgument='<%#Container.DataItem("Id") & "|" & Container.DataItem("Usuario")  %>' runat="server">Remover Cuota</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>
            <%--<asp:TemplateField>
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                <ItemTemplate>
                    <asp:LinkButton ID="lnkEditar" CommandName="Editar" CommandArgument='<%#Container.DataItem("Servicio") & "|" & Container.DataItem("Usuario")  %>' runat="server">Actualizar Cuota</asp:LinkButton>
                </ItemTemplate>
            </asp:TemplateField>--%>
        </Columns>
    </asp:GridView>

</asp:Content>

