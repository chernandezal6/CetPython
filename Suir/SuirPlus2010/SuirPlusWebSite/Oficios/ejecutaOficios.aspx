<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ejecutaOficios.aspx.vb" Inherits="Oficios_ejecutaOficios" title="Aplicación de Oficios" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		
	        Me.PermisoRequerido = 58
			
	    End Sub
	</script>
	<span class="header">Aplicación de Oficios</span>
	<br />
	<asp:UpdatePanel runat="server" ID="Up1">
	<ContentTemplate>
	<asp:Label id="lblMsg" runat="server" CssClass="error" Font-Size="Small"></asp:Label><br />
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
				<td class="listHeader" style="width: 468px;">Esta seguro que desea procesar este oficio?</td>
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
                            <td valign="top" colspan="2">
                                <table style="width: 100%" runat="server" id="tblRepresentantes" visible="false">
                                    <tr>
                                        <td class="listHeader">
                                            Seleccione del listado los representantes a activar</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="gvRepresentante" Width="400" runat="server" AutoGenerateColumns="False">
                                                <Columns>
                                                    <asp:BoundField DataField="NOMBRE" HeaderText="Nombre" />
                                                    <asp:BoundField DataField="NO_DOCUMENTO" HeaderText="No. Documento" />
                                                    <asp:TemplateField HeaderText="Activar">
                                                        <ItemTemplate>
                                                            <asp:Label ID="lblNssRep" runat="server" Text='<%# Eval("id_nss") %>' Visible="false"></asp:Label>
                                                            <asp:CheckBox ID="chkActivar" Checked='<%# IIF(Eval("status") = "A",true,false) %>' runat="server" />
                                                        </ItemTemplate>
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:TemplateField>
                                                </Columns>
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                        </tr>
						<tr>
							<td colspan="2"><br />
								<asp:button id="btnCancelarOficio2" runat="server" Text="Aplicar Oficio"></asp:button>
								<asp:button id="btnCancelar2" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>
							</td>
						</tr>
					</table>
					<br />
				</td>
			</tr>
		</table>
	</asp:Panel>
	</ContentTemplate>
	</asp:UpdatePanel>
	 <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Procesando...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

