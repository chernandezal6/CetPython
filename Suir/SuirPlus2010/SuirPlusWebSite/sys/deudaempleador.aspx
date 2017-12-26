<%@ Page Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="deudaempleador.aspx.vb" Inherits="sys_deudaempleador" title="Consulta Deuda por Empleador" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    		<span class="header">Consulta Deuda por Empleador</span><br/><br/>
			<table cellspacing="0" cellpadding="0" border="0">
				<tr>
					<td>
						<table class="td-content" id="tblConsulta">
							<tr>
								<td valign="top"><img src="../images/deuda.jpg" alt="Deuda" width="220" height="89"/></td>
								<td align="center">
									<table id="Table2">
										<tr>
											<td align="right">RNC/Cédula&nbsp;
											</td>
											<td><asp:textbox id="txtRNC" runat="server" MaxLength="16"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Debe ingresar un RNC o Cédula."
													ControlToValidate="txtRNC">*</asp:requiredfieldvalidator></td>
										</tr>
										<tr>
											<td colspan="2" align="center">
												<asp:button id="btBuscar" runat="server" Text="Buscar"></asp:button>
											</td>
										</tr>
									</table>
									<asp:regularexpressionvalidator id="regExpRncCedula" runat="server" ErrorMessage="RNC o Cédula invalido." ControlToValidate="txtRNC"
										ValidationExpression="^(\d{9}|\d{11})$" CssClass="error" Display="Dynamic"></asp:regularexpressionvalidator></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
				</tr>
				<tr>
					<td align="center"><asp:label id="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:label></td>
				</tr>
			</table>
			<asp:panel id="pnlConsulta" Visible="False" Runat="server">
				<table>
					<tr>
						<td>
							<table class="td-content" cellpadding="2" cellspacing="1">
								<tr>
									<td align="right">Razón Social:</td>
									<td>
										<asp:label id="lblRazonSocial" runat="server" CssClass="labelData" EnableViewState="False"></asp:label></td>
								</tr>
								<tr>
									<td align="right">Nombre Comercial:</td>
									<td>
										<asp:label id="lblNombreComercial" runat="server" CssClass="labelData" EnableViewState="False"></asp:label></td>
								</tr>
							</table>
							<asp:Label id="lblMovimiento" runat="server" EnableViewState="False" cssclass="label-Resaltado"></asp:Label></td>
					</tr>
					<tr>
						<td>
							<asp:gridview id="dgFacturas" runat="server" EnableViewState="False" Visible="False" ShowFooter="True" AutoGenerateColumns="False">
								<Columns>
									<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia"></asp:BoundField>
									<asp:BoundField DataField="STATUS" HeaderText="Estatus">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="FECHA_EMISION" HeaderText="Fecha Emisi&#243;n" DataFormatString="{0:d}">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="FECHA_LIMITE_PAGO" HeaderText="Fecha L&#237;mite" DataFormatString="{0:d}">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Center"></ItemStyle>
									</asp:BoundField>
									<asp:BoundField DataField="TOTAL_GENERAL_FACTURA" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="False">
										<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
										<ItemStyle HorizontalAlign="Right"></ItemStyle>
									</asp:BoundField>
								</Columns>
							</asp:gridview></td>
					</tr>
				</table>
			</asp:panel>
</asp:Content>

