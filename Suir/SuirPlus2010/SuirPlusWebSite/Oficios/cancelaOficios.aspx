<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="cancelaOficios.aspx.vb" Inherits="Oficios_cancelaOficios" title="Cancelación de Oficios" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		
	        Me.PermisoRequerido = 57
			
	    End Sub
	</script>
	<span class="header">Cancelación de Oficios</span>
	<br />
	<asp:Label id="lblMsg" runat="server" CssClass="error" font-size="Small"></asp:Label><br />
	<br />
	<asp:Panel id="pnlForm" runat="server">
		<table class="td-content" width="450">
			<tr>
				<td class="listHeader" style="width: 445px">Busqueda de oficio</td>
			</tr>
			<tr>
				<td align="left" style="width: 445px">
					<table width="100%" border="0">
						<tr>
							<td style="WIDTH: 166px">Ingrese el número de oficio<span class="error">*</span></td>
							<td style="width: 268px">
								<asp:textbox id="txtCodOficio" runat="server" MaxLength="12" Width="81px"></asp:textbox>&nbsp;
								<asp:RegularExpressionValidator id="RegularExpressionValidator1" runat="server" ErrorMessage="Formato inválido"
									ControlToValidate="txtCodOficio" ValidationExpression="\d*"></asp:RegularExpressionValidator>
							</td>
						</tr>
						<tr>
							<td valign="bottom" colspan="2">
								<table width="100%">
									<tr>
										<td style="color:red; width: 161px;">
            								<asp:RequiredFieldValidator id="RequiredFieldValidator1" runat="server" ErrorMessage="* Información Obligatoria." ControlToValidate="txtCodOficio"></asp:RequiredFieldValidator>
										</td>
										<td align="right" valign="bottom">
											<asp:button id="btnCancelarOficio" runat="server" Text="Consultar"></asp:button>
											<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
										</td>
									</tr>
								</table>
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</asp:Panel>
	<asp:Panel id="pnlResult" runat="server" Visible="False">
		<table id="table1" class="td-content" cellspacing="0" cellpadding="3" width="450" runat="server">
			<tr>
				<td class="listHeader" style="width: 468px;">Esta seguro que desea cancelar este oficio?</td>
			</tr>
			<tr>
				<td align="left">
					<table cellspacing="2" cellpadding="2" width="100%" border="0">
						<tr>
							<td>Oficio Nro.</td>
							<td>
								<asp:Label id="lblOficioNo" runat="server" Font-Bold="True"></asp:Label></td>
						</tr>
						<tr>
							<td>Empleador</td>
							<td>
								<asp:label id="lblRazonSocial" runat="server" Font-Bold="True"></asp:label>
							</td>
						</tr>
						<tr>
							<td>Acción</td>
							<td>
								<asp:Label id="lblAccion" runat="server" Font-Bold="True"></asp:Label>
							</td>
						</tr>
						<tr>
							<td>Generado Por
							</td>
							<td>
								<asp:Label id="lblGeneradoPor" runat="server" Font-Bold="True"></asp:Label>
							</td>
						</tr>
						<tr>
							<td>Observación de solicitud</td>
							<td valign="top">
								<asp:Label id="lblObsSol" runat="server" Font-Bold="True"></asp:Label>
							</td>
						</tr>
						<tr>
							<td valign="top">Observación&nbsp;de cancelación</td>
							<td>
								<asp:TextBox id="txtObs" runat="server" Width="336px" Height="64px" TextMode="MultiLine"></asp:TextBox>
							</td>
						</tr>
						<tr>
							<td colspan="2"><br />
								<asp:button id="btnCancelarOficio2" runat="server" Text="Cancelar Oficio"></asp:button>
								<asp:button id="btnCancelar2" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
							</td>
						</tr>
					</table>
					<br />
				</td>
			</tr>
		</table>
	</asp:Panel>
</asp:Content>

