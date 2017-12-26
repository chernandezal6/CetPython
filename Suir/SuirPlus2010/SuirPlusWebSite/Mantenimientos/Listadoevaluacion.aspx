<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Listadoevaluacion.aspx.vb" Inherits="Mantenimientos_Listadoevaluacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <div class="header" align="left">
        Listado de Actas para Evaluación Visual<br />
        <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false"></asp:Label>
        <br />
        <fieldset id="fsCasosEvaluacion" style="height:60px; width: 300px">
            <legend>Casos a Evaluar</legend>
            <table>
                <tr>
                    <td align="right">Evaluar:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlCasosEvaluacion" runat="server" CssClass="dropDowns" AutoPostBack="True">
                            <asp:ListItem Value="S" Text="Extranjeros"></asp:ListItem>
                            <asp:ListItem Value="N" Text="No Extranjeros"></asp:ListItem>
                            <asp:ListItem Value="C" Text="Actualizaciones"></asp:ListItem>
                            <asp:ListItem Value="T" Text="Todos" Selected="True"></asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
            </table>
        </fieldset><br />
<asp:GridView ID="gvListado" runat="server" AutoGenerateColumns="False"
            Width="580px">
            <Columns>
                <asp:BoundField DataField="id" Visible="false" />
                <asp:BoundField DataField="IdRow" Visible="false" />
                <asp:BoundField DataField="Asignacion" HeaderText="Tipo">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="fecha_registro" HeaderText="Fecha Registro" DataFormatString="{0:d}">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="idNSS" HeaderText="Nss">
                    <HeaderStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="NOMBRES" HeaderText="Nombres">
                    <HeaderStyle HorizontalAlign="Center" />
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="PRIMER_APELLIDO" HeaderText="Primer Apellido">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="SEGUNDO_APELLIDO" HeaderText="Segundo Apellido">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Desc_Error" HeaderText="Motivo Evaluación">
                    <HeaderStyle HorizontalAlign="Center" Wrap="True" />
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:TemplateField>
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:Label ID="lblId" runat="server" Visible="false" Text='<%# eval("Id") %>'></asp:Label>
                        <asp:ImageButton ID="ibAsignarNss" runat="server" Visible="false" ImageUrl="~/images/kappfinder.gif" CommandName="A" CommandArgument='<%# Eval("id_solicitud")%>' />
                        <asp:ImageButton ID="ibEvaluarCiudadanos" runat="server" Visible="false" ImageUrl="~/images/kappfinder.gif" CommandName="E" CommandArgument='<%# Eval("IdRow")%>' />
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

