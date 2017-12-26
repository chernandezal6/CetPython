<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consFacturasTSS.aspx.vb" Inherits="Empleador_consFacturasTSS" Title="Consulta de Notificaciones de Pago - TSS" %>

<%@ Register Src="../Controles/ucDetalleAjuste.ascx" TagName="ucDetalleAjuste" TagPrefix="uc8" %>
<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc7" %>
<%@ Register Src="../Controles/ucNotificacionTSSDetalleAuditoria.ascx" TagName="ucNotificacionTSSDetalleAuditoria"
    TagPrefix="uc6" %>
<%@ Register Src="../Controles/UCDetalleDependientesReferencia.ascx" TagName="UCDetalleDependientesReferencia"
    TagPrefix="uc5" %>
<%@ Register Src="../Controles/UCDetalleDependientesAdicionales.ascx" TagName="UCDetalleDependientesAdicionales"
    TagPrefix="uc4" %>
<%@ Register Src="../Controles/ucNotificacionTSSDetalle.ascx" TagName="ucNotificacionTSSDetalle"
    TagPrefix="uc3" %>
<%@ Register Src="../Controles/ucEncabezadoTSS.ascx" TagName="ucEncabezadoTSS" TagPrefix="uc2" %>
<%@ Register Src="../Controles/ucNotificacionTSSEncabezado.ascx" TagName="ucNotificacionTSSEncabezado"
    TagPrefix="uc1" %>
<%@ Register src="../Controles/ucNotificacionTSSDetalleSIPEN.ascx" tagname="ucNotificacionTSSDetalleSIPEN" tagprefix="uc9" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <br />
    <uc2:ucEncabezadoTSS ID="UcEncabezadoTSS1" runat="server" />
    <uc1:ucNotificacionTSSEncabezado ID="ucNotEncTSS" runat="server" Visible="false" />
    <uc3:ucNotificacionTSSDetalle ID="ctrlNotificacionTSSDetalle" runat="server" Visible="false" />
    <uc6:ucNotificacionTSSDetalleAuditoria ID="ctrlNotificacionTSSDetalleAuditoria" runat="server"
        Visible="false" />



    <uc9:ucNotificacionTSSDetalleSIPEN ID="ctrlNotificacionTSSDetalleSIPEN" runat="server" Visible="false" />



    <br />
    <uc5:UCDetalleDependientesReferencia ID="ucDetalleDep" runat="server" />
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <asp:Panel ID="pnPagosARS" runat="server" Width="100%" Visible="False">
                <span class="header">Pagos realizados a las ARS<br />
                </span>
                <br />
                <asp:Label ID="lblMensaje" runat="server" ForeColor="Red"></asp:Label><br />
                <uc7:ucExportarExcel ID="UcExportarExcel" runat="server" />
                <br />
                <asp:GridView ID="gvDetallesARS" runat="server" AutoGenerateColumns="false">
                    <Columns>
                        <asp:BoundField DataField="nss_titular" HeaderText="NSS Titular" />
                        <asp:BoundField DataField="nombre_titular" HeaderText="Nombre Titular" />
                        <asp:BoundField DataField="nss_dependiente" HeaderText="NSS" />
                        <asp:BoundField DataField="nombre_dependiente" HeaderText="Nombre" />
                        <asp:BoundField DataField="parentesco_desc" HeaderText="Parentesco" />
                        <asp:BoundField DataField="ars_des" HeaderText="ARS" />
                    </Columns>
                </asp:GridView>
                <table id="TABLE1" runat="server">
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
                        <td style="height: 12px">
                            Total de Empleados
                            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                        </td>
                    </tr>
                </table>
            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="UcExportarExcel" />
        </Triggers>
    </asp:UpdatePanel>
    <br />
    <asp:Panel ID="pnlDetalleAjuste" runat="server" Width="100%" Visible="False">
        
        <br />
        <uc8:ucDetalleAjuste ID="ucDetalleAjuste1" runat="server" Visible="false" />
    </asp:Panel>
</asp:Content>
