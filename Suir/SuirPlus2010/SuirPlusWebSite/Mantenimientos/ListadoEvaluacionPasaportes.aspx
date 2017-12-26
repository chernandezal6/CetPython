<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ListadoEvaluacionPasaportes.aspx.vb" Inherits="Mantenimientos_ListadoEvaluacionPasaportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div class="header" align="left">
        Listado de Pasaportes para Evaluación Visual<br />
        <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false"></asp:Label>
        <br />
        <fieldset id="fsCasosEvaluacion" style="width: 300px">
            <legend>Casos a Evaluar</legend>
            <table>
                <tr>
                    <td align="right">Estatus:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlEstatus" runat="server" CssClass="dropDowns">
                            <asp:ListItem Value="PE" Text="Pendientes"></asp:ListItem>
                            <asp:ListItem Value="RE" Text="Rechazados"></asp:ListItem>
                            <asp:ListItem Value="AP" Text="Aprobados"></asp:ListItem>
                            <asp:ListItem Value="T" Text="Todos" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td>Pasaporte</td>
                    <td>
                        <asp:TextBox ID="txtPasaporte" runat="server"></asp:TextBox></td>
                    <td>Nombres</td>
                    <td>
                        <asp:TextBox ID="txtNombres" runat="server"></asp:TextBox></td>
                </tr>
                <tr>
                    <td>Primer Apellido:</td>
                    <td>
                        <asp:TextBox ID="txtPrimerApellido" runat="server"></asp:TextBox>
                    </td>
                    <td>Segundo Apellido:</td>
                    <td>
                        <asp:TextBox ID="txtsegundoApellido" runat="server"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td>Fecha Desde:</td>
                    <td>
                        <asp:TextBox ID="txtFechaDesde" runat="server" CssClass="date"></asp:TextBox></td>
                    <td>Fecha Hasta:</td>
                    <td>
                        <asp:TextBox ID="txtFechaHasta" runat="server" CssClass="date"></asp:TextBox></td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="button" Style="font-size: 9pt;" /></td>

                </tr>
            </table>
        </fieldset>
        <br />
        <%--<asp:GridView ID="gvListado" runat="server" AutoGenerateColumns="False" Width="600px">--%>
        <asp:GridView ID="gvListado" runat="server" AutoGenerateColumns="False">
            <Columns>

                <asp:BoundField DataField="PASAPORTE" HeaderText="Numero Pasaporte" />
                <asp:BoundField DataField="NOMBRES" HeaderText="Nombres" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Justify" />
                <asp:BoundField DataField="PRIMER_APELLIDO" HeaderText="Primer Apellido" ItemStyle-HorizontalAlign="Justify" />
                <asp:BoundField DataField="SEGUNDO_APELLIDO" HeaderText="Segundo Apellido" ItemStyle-HorizontalAlign="Justify" />
                <asp:BoundField DataField="FECHA_NACIMIENTO" HeaderText="Fecha de Nacimiento" DataFormatString="{0:dd-MM-yyyy}" />
                <asp:BoundField DataField="SEXO_DES" HeaderText="Sexo" ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="FECHA_REGISTRO" HeaderText="Fecha Registro" DataFormatString="{0:dd-MM-yyyy}">

                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="status" HeaderText="Resultado Evaluación" ItemStyle-HorizontalAlign="center" />
                <asp:TemplateField>
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:ImageButton ID="ibPasaporteEvaluar" runat="server" Visible="false" ImageUrl="~/images/kappfinder.gif" CommandName="E" CommandArgument='<%# Eval("id_solicitud")%>' />
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>

        </asp:GridView>

        <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
            <table cellpadding="0" cellspacing="0" width="550px">
                <tr>
                    <td>
                        <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                            OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                    [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                    <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                    <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                        <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                    </td>
                </tr>
            </table>
        </asp:Panel>
    </div>
</asp:Content>

