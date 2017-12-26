<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="DetalleIR13.aspx.vb" Inherits="DGII_DetalleIR13" title="Detalle IR13 Periodos Reportados" %>
<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Label ID="lblTitulo" runat="server" CssClass="header">Detalle Declaración IR13</asp:Label><br />
    <strong>
        <br />
        Estatus:</strong>
    <asp:Label ID="lblStatus" runat="server" CssClass="subHeader"></asp:Label>
    &nbsp; &nbsp; &nbsp;&nbsp;

<asp:UpdatePanel ID="updResumenir13" runat="server">
    <ContentTemplate>
    
            <br />
			<asp:label cssclass="label-Resaltado" id="lblSaldoFavorDGII" runat="server"
				Visible="False">**Tiene valores en la columna de Saldo a Favor  DGII por lo que debe hacer las rectificativas correspondientes.</asp:label><br>
			<asp:panel id="pnlIR13" runat="server" Visible="False">
			    <asp:GridView id="gvResumenIR13" runat="server" AutoGenerateColumns="False" Width="100%">
					
					<Columns>
						<asp:BoundField DataField="Apellidos" HeaderText="Apellidos">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Nombres" HeaderText="Nombres">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALARIO_ISR" HeaderText="Sueldos Pagados" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="REMUNERACION_ISR_OTROS" HeaderText="Remuneracion Otros Agentes"
							DataFormatString="{0:n}" HtmlEncode="false">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="OTRAS_REMUN" HeaderText="Otras &lt;br&gt; Remuneraciones" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="INGRESOS_EXENTOS_ISR" HeaderText="Ingresos &lt;br&gt; Exentos" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="TOTAL_PAGADO" HeaderText="Total Pagado" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="RETENCION_SS" HeaderText="Retenci&#243;n S.S." DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="TOTAL_SUJETO_RETENCION" HeaderText="Sueldo y otros Pagos &lt;br&gt;Sujetos a Retenci&#243;n"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="ISR" HeaderText="ISR" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALDO_FAVOR_ANTERIOR" HeaderText="Saldo a favor &lt;br&gt; anterior"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="IMPUESTO_A_PAGAR" HeaderText="Impuesto Retenido &lt;br&gt; y Pagado"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALDO_FAVOR_EMPLEADO" HeaderText="Saldo a Favor &lt;br&gt; Empleado"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALDO_FAVOR_DGII" HeaderText="Saldo a Favor &lt;br&gt; DGII" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:GridView>
				
				
		<table style="width: 580px">
				
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
                    Total Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
    
    </table>
                <br />
			<uc1:ucexportarexcel id="ucExcel" runat="server"></uc1:ucexportarexcel>
			</asp:panel>
				
				
		<br>
			</ContentTemplate>
			<Triggers>
			<asp:PostBackTrigger ControlID="ucExcel" />
			</Triggers>
    </asp:UpdatePanel>

				<table id="Table1" cellspacing="1" cellpadding="1" border="0" style="width: 100%">
					<tr>
						<td class="td-note">
							<div style="text-align:center">
                                &nbsp;<asp:Button ID="btDeclarar" runat="server" Text="Realizar Declaración" />
                                &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;
                                <asp:button id="btnVolver" runat="server" Text="Volver Atras"></asp:button></div>
						</td>
					</tr>
				</table>
</asp:Content>

