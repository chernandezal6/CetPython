<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucDependientes.ascx.vb" Inherits="Controles_ucDependientes" %>
<table id="Table1" cellspacing="0" cellpadding="0" width="685" border="0">
	<tr>
		<td>
			<asp:Label ID="lblTitulo" Runat="server" CssClass="subHeader" Visible="False">Dependientes Adicionales</asp:Label>
		</td>
	</tr>
	<tr>
		<td class="height:10"></td>
	</tr>
	<tr>
		<td><asp:gridview id="gvDependientes" runat="server" CssClass="list" AutoGenerateColumns="False">
				<Columns>
					<asp:BoundField DataField="razon_social" HeaderText="Empleador">
					    <headerstyle wrap="false" />
						<ItemStyle HorizontalAlign="Center" wrap="false"></ItemStyle>
					</asp:BoundField>
                    <asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC">
					    <headerstyle wrap="false" />
						<ItemStyle HorizontalAlign="Center" wrap="false"></ItemStyle>
					</asp:BoundField>
                 	<asp:BoundField DataField="nomina_des" HeaderText="Nómina">
					    <headerstyle wrap="false" />					
						<ItemStyle HorizontalAlign="Center" wrap="false"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="documento" HeaderText="Documento">
					    <headerstyle wrap="false" />					
						<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="nombres" HeaderText="Nombres">
					    <headerstyle wrap="false" />					
						<ItemStyle HorizontalAlign="Left" width="150px" wrap="false"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="apellidos" HeaderText="Apellidos">
					    <headerstyle wrap="false" />					
						<ItemStyle HorizontalAlign="Left" width="180px"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="fecha_registro" HeaderText="Fecha Ingreso" DataFormatString="{0:d}" htmlencode="false">
					    <headerstyle wrap="false" />					
						<ItemStyle HorizontalAlign="Center" wrap="false"></ItemStyle>
					</asp:BoundField>
				</Columns>
			</asp:gridview></td>
	</tr>
</table>
