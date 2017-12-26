<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucLiquidacionInfotepDet.ascx.vb" Inherits="Controles_ucLiquidacionInfotepDet" %>

<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="ucExportarExcel.ascx" %>
<table id="table1" cellSpacing="0" cellPadding="0" width="590" border="0">
	<tr>
		<td style="height: 66px">
			<div class="header2">Detalle Liquidación INFOTEP Nro.
				<asp:label id="lblNoReferencia" runat="server" CssClass="subHeaderContrast"></asp:label></div>
			<div class="header2">Total de la Liquidación :
				<asp:label id="lblTotalFactura" runat="server" CssClass="subHeaderContrast"></asp:label></div>
			<div class="header2">Periodo de la Liquidación :
				<asp:label id="lblPeriodoFactura" runat="server" CssClass="subHeaderContrast"></asp:label></div><br />
            <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label></td>
	</tr>
	<tr>
		<td>
			<asp:gridview id="gvDetalle" runat="server" EnableViewState="False" AutoGenerateColumns="False" Width="590px">
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
					<asp:BoundField Visible="False" DataField="periodo_aplicacion" HeaderText="Per&#237;odo"></asp:BoundField>
					<asp:BoundField DataField="salario" HeaderText="Salario" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle Wrap="False" HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="Pago_Infotep" HeaderText="Infotep" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle Wrap="False" HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
				</Columns>
			</asp:gridview>			
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
        <td style="height: 12px">
            Total de Empleados&nbsp;
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
        </td>
    </tr>
</table>
<br />
<br />
<img src="../images/detalle.gif" alt="" />&nbsp;<a href="javascript:history.back()">Encabezado</a>&nbsp;|
    <uc1:ucExportarExcel ID="UcExp" runat="server" />

