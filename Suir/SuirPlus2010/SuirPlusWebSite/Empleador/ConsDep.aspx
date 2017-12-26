<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="ConsDep.aspx.vb" Inherits="Empleador_ConsDep" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <asp:UpdatePanel ID="udpBuscar" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table class="td-content" id="Table2" cellspacing="0" cellpadding="0" style="width: 100%">
                <tr>
                    <td class="header" colspan="2">
                        Detalle Dependientes Adicionales
                        <br />
                        <br />
                    </td>
                </tr>
                <tr>
                    <td>
                        <uc2:ucExportarExcel ID="ucExportarExcel" runat="server" />
                        <br />
                        <asp:GridView ID="gvDetalleDependiente" runat="server" Width="80%" AutoGenerateColumns="False">
                            <Columns>
                                <asp:TemplateField HeaderText="Ced. Titular">
                                    <ItemTemplate>
                                        <asp:Label ID="Label1" runat="server" Text='<%# SuirPlus.Utilitarios.Utils.FormatearCedula(Eval("cedulatitular"))   %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="nombretitular" HeaderText="Nombre del Titular">
                                    <HeaderStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Ced. Dependiente">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# SuirPlus.Utilitarios.Utils.FormatearCedula(Eval("ceduladep")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="nombredependiente" HeaderText="Nombre del Dependiente" />
                                <asp:BoundField DataField="percapita" HeaderText="Per capita" DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                                <asp:BoundField DataField="montoadicional" HeaderText="Monto Res.265-01" DataFormatString="{0:n}">
                                    <ItemStyle HorizontalAlign="Right" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                        <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
                            <table cellpadding="0" cellspacing="0" width="550px">
                                <tr>
                                    <td style="height: 24px">
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
                        <br />
                    </td>
                </tr>
            </table>
            <asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
        </ContentTemplate>
        <Triggers>
         <asp:PostBackTrigger ControlID="UcExportarExcel" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
