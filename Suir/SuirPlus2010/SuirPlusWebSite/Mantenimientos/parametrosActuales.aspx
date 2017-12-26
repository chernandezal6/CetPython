<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="parametrosActuales.aspx.vb" Inherits="Mantenimientos_parametrosActuales" title="Untitled Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

	<script language="vb" runat="server">
		Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
			Me.PermisoRequerido = 141
			
		End Sub
	</script>

	<table id="Table2" cellspacing="0" cellpadding="0" border="0">
	    <tr>
	        <td class="header" style="height: 22px">Consulta de parámetros actuales</td>
	        <td>&nbsp;&nbsp;&nbsp;</td>
			<td class="header">Rangos ISR</td>
	    </tr>
		<tr>
			<td valign="top">
			    <asp:gridview id="dgParametros" runat="server" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="CATEGORIA" HeaderText="Categoría"></asp:BoundField>
						<asp:BoundField DataField="PARAMETRO" HeaderText="Parámetro"></asp:BoundField>
						<asp:BoundField DataField="VALOR" HeaderText="Valor">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:gridview>
			</td>
			<td>&nbsp;&nbsp;&nbsp;</td>
			<td valign="top">
				<asp:gridview id="dgRangosISR" runat="server" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="rni_desde" HeaderText="RNI Desde">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="rni_hasta" HeaderText="RNI Hasta">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="impuesto_fijo" HeaderText="Imp. Fijo">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="porciento_excedente" HeaderText="% Excedente">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:gridview>
				<br />
				<span class="header">Rangos ISR Pensionado</span>
				<br />
		        <asp:gridview id="dgRangosPEN" runat="server" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="rni_desde" HeaderText="RNI Desde">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="rni_hasta" HeaderText="RNI Hasta">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="impuesto_fijo" HeaderText="Imp. Fijo">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="porciento_excedente" HeaderText="% Excedente">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:gridview>				
			</td>
		</tr>
	</table>
</asp:Content>

