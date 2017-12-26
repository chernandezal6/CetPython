<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucPlanillasMDTdetalle.ascx.vb" Inherits="Controles_ucPlanillasMDTdetalle" %>

<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="ucExportarExcel.ascx" %>
<table id="table1" cellspacing="0" cellpadding="0" width="590" border="0">
    <tr>
        <td style="height: 66px">
            <div class="header2">
                Detalle Formulario Ministerio de Trabajo Nro.
				<asp:Label ID="lblNoReferencia" runat="server" CssClass="subHeaderContrast"></asp:Label>
            </div>
            <div class="header2">
                Total de la Liquidación :
				<asp:Label ID="lblTotalFactura" runat="server" CssClass="subHeaderContrast"></asp:Label>
            </div>
            <div class="header2">
                Periodo de la Liquidación :
				<asp:Label ID="lblPeriodoFactura" runat="server" CssClass="subHeaderContrast"></asp:Label>
            </div>
            <br />
            <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label></td>
    </tr>
    <tr>
        <td>
            <asp:GridView ID="gvDetalle" runat="server" EnableViewState="False" AutoGenerateColumns="False" Width="880px">
                <Columns>
                    <asp:BoundField DataField="no_documento" HeaderText="C&#233;dula">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="id_nss" HeaderText="NSS">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="nombres" HeaderText="Nombre">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="ocupacion_desc" HeaderText="Ocupación">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="localidad_desc" HeaderText="Establecimiento">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="turno_desc" HeaderText="Turno">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="novedad_desc" HeaderText="Tipo de Novedad">
                        <HeaderStyle HorizontalAlign="Left"></HeaderStyle>
                    </asp:BoundField>
                    <asp:BoundField Visible="False" DataField="periodo_aplicacion" HeaderText="Per&#237;odo"></asp:BoundField>
                    <asp:BoundField DataField="salario" HeaderText="Salario" DataFormatString="{0:n}" HtmlEncode="false">
                        <ItemStyle Wrap="False" HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="fecha_ingreso" HeaderText="Fecha Ingreso" DataFormatString="{0:d}"></asp:BoundField>
                </Columns>
            </asp:GridView>
        </td>
    </tr>
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
            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label></td>
    </tr>
    <tr>
        <td style="height: 12px">Total de Empleados&nbsp;
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
        </td>
    </tr>
</table>
<br />

<%--<img src="../images/detalle.gif" alt="" />&nbsp;<a href="javascript:history.back()">Encabezado</a>&nbsp;|--%>
<uc1:ucExportarExcel ID="UcExp" runat="server" />
