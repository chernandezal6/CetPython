<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consFacturas.aspx.vb" Inherits="Bancos_consFacturas" title="Autorización de Referencias" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
		<script language="javascript" type="text/javascript">
			function BorrarRNC()
			{
				if (document.aspnetForm.ctl00$MainContent$txtReferencia.value !== "")
				{
					document.aspnetForm.ctl00$MainContent$txtRNC.value = "";
					document.aspnetForm.ctl00$MainContent$btTraerNominas.disabled = true;
					document.aspnetForm.ctl00$MainContent$btBuscar.disabled = false;					
				}
			
			}
			function BorrarRef()
			{
				if (document.aspnetForm.ctl00$MainContent$txtRNC.value !== "")
				{
					document.aspnetForm.ctl00$MainContent$txtReferencia.value = "";
					document.aspnetForm.ctl00$MainContent$btTraerNominas.disabled = false;
					document.aspnetForm.ctl00$MainContent$btBuscar.disabled = true;
				}
			}
			function HabilitarBuscar()
			{
					document.aspnetForm.ctl00$MainContent$btBuscar.disabled = false;
			}
		</script>
			<P class="header">Autorización de Referencias de Pago</P>
			
				<TABLE id="Table1" cellSpacing="1" cellPadding="1" border="0">
					<TR>
						<TD><asp:label id="lbltxtRNC" runat="server">RNC / Cédula:</asp:label>
						</TD>
						<TD><asp:textbox id="txtRNC" runat="server" MaxLength="11"></asp:textbox><asp:regularexpressionvalidator id="regExpRncCedula" runat="server" Display="Dynamic" CssClass="error" ErrorMessage="RNC o Cédula no registrado en la Tesoreria."
								ValidationExpression="^(\d{9}|\d{11})$" ControlToValidate="txtRNC"></asp:regularexpressionvalidator></TD>
						<td rowSpan="3"><IMG id="imgLogo" runat="server"></td>
					</TR>
					<TR>
						<TD><asp:label id="lblReferencia" runat="server">Número de Referencia:</asp:label>
						</TD>
						<TD><asp:textbox id="txtReferencia" runat="server" MaxLength="16"></asp:textbox><asp:regularexpressionvalidator id="rev" runat="server" Display="Dynamic" ErrorMessage="*" ValidationExpression="\d*"
								ControlToValidate="txtReferencia"></asp:regularexpressionvalidator></TD>
					</TR>
					<TR>
						<TD colSpan="2"><asp:button id="btTraerNominas" runat="server" EnableViewState="False" Enabled="False" Text="Traer Nominas"></asp:button>&nbsp;<asp:button id="btBuscar" runat="server" EnableViewState="False" Enabled="False" Text="Buscar Facturas"></asp:button><BR>
						</TD>
					</TR>
					<TR>
						<TD colSpan="3">
							<BR>
								<asp:label id="lblMensajeError" runat="server" CssClass="error" EnableViewState="False" Font-Size="Small"
									Font-Bold="True" Visible="False"></asp:label>
						</TD>
					</TR>
				</TABLE>
				<BR>
				<TABLE class="td-content" id="Table2" cellSpacing="1" cellPadding="1" border="0">
					<TR>
						<TD>
							<asp:label id="lbltxtRNC2" runat="server" Visible="False">RNC o Cédula:</asp:label>
						</TD>
						<TD><asp:label id="lblRNC" runat="server" Font-Bold="True" Visible="False"></asp:label></TD>
					</TR>
					<TR>
						<TD><asp:label id="label8" runat="server" Visible="False">Razon Social:</asp:label>
						</TD>
						<TD><asp:label id="lblRazonSocial" runat="server" Font-Bold="True" Visible="False"></asp:label></TD>
					</TR>
					<TR>
						<TD><asp:label id="lblTXTNombreComercial" runat="server" Visible="False">Nombre Comercial:</asp:label>
						</TD>
						<TD><asp:label id="lblNombreComercial" runat="server" Font-Bold="True" Visible="False"></asp:label></TD>
					</TR>
					<TR>
						<TD><asp:label id="Label1" runat="server" Visible="False">Nomina:</asp:label>
						</TD>
						<TD><asp:dropdownlist id="ddlNominas" runat="server" CssClass="dropDowns" Visible="False"></asp:dropdownlist></TD>
					</TR>
				</TABLE>
			
			<br>
			<asp:button id="btnCancelar" Text="Cancelar" Visible="False" Runat="server"></asp:button><br />
    <asp:GridView ID="dgFacturas" AutoGenerateColumns="false" runat="server">
    <Columns>
					<asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
						<ItemStyle HorizontalAlign="Center"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="Nomina_Des" HeaderText="Nomina"></asp:BoundField>
					<asp:BoundField DataField="Periodo_Factura" HeaderText="Periodo">
						<ItemStyle HorizontalAlign="Center"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="Total_General" HeaderText="Total" HtmlEncode=False DataFormatString="{0:c}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:TemplateField>
						<ItemStyle HorizontalAlign="Center"></ItemStyle>
						<ItemTemplate>
							<asp:Label id=lblID runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.id_referencia") %>' Visible="False">
							</asp:Label>
							<asp:Label id=lblNomina runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.id_nomina") %>' Visible="False">
							</asp:Label>
							<asp:Button id="btAutorizar" runat="server" Text="Autorizar" CommandName="SelectCommand" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.id_referencia") %>'></asp:Button>
						</ItemTemplate>
					</asp:TemplateField>
				</Columns>
    </asp:GridView>
		
</asp:Content>

