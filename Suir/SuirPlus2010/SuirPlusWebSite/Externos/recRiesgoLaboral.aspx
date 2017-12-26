<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="recRiesgoLaboral.aspx.vb" Inherits="Externos_recRiesgoLaboral" title="Recalculo de Riesgo Laboral" %>

<%@ Register Src="../Controles/ucInfoEmpleador.ascx" TagName="ucInfoEmpleador" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
		
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		        'PermisoRequerido = 115
			End Sub
			
		</script>
		
<div class="header">
    Recálculo de Riesgo Laboral</div>
<br />

			<TABLE class="td-content" id="Table1" cellSpacing="0" cellPadding="0">
				<tr>
					<td rowSpan="4"><IMG src="../images/deuda.jpg" width="220" height="89">
					</td>
					<td>
						<table>
							<tr>
								<td>
									No. de referencia:
								</td>
								<td>
									<asp:textbox id="txtReferencia" runat="server" MaxLength="16"></asp:textbox>
									<asp:RequiredFieldValidator id="reqTxtReferencia" runat="server" Display="Dynamic" ControlToValidate="txtReferencia">*</asp:RequiredFieldValidator></td>
							</tr>
							<tr>
								<td>
									Nueva categoría:
								</td>
								<td >
									<asp:DropDownList id="drpCategoria" runat="server" CssClass="dropDowns"></asp:DropDownList></td>
							</tr>
							<tr>
								<td align="center" colSpan="2"><br>
									<asp:button id="btnConsultar" runat="server" Text="Recalcular"></asp:button>
									<asp:button id="btnCancelar" runat="server" Text="Cancelar"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colSpan="2"><asp:regularexpressionvalidator id="regExpRncCedula" runat="server" ControlToValidate="txtReferencia" Display="Dynamic"
										ValidationExpression="^(\d{16})$" ErrorMessage="No. de referencia inválido."></asp:regularexpressionvalidator></td>
							</tr>
						</table>
					</td>
				</tr>
			</TABLE>
			<br>
			<asp:label id="lblMsg" cssclass="error" EnableViewState="False" Runat="server" />
			<asp:panel id="pnlConsulta" Runat="server" Width="541px" Visible="false">
				<TABLE cellSpacing="0" cellPadding="0" border="0" style="width: 541px">
					<TR>
						<TD>
                            <uc1:ucInfoEmpleador ID="UcInfoEmpleador" runat="server" />
                        </TD>
					</TR>
					<TR>
						<TD height="5"></TD>
					</TR>
				</TABLE>
				<asp:GridView id="gvRecalculo" runat="server" AutoGenerateColumns="False">

					<Columns>
						<asp:Boundfield DataField=":B7" HeaderText="Referencia">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField=":B6" HeaderText="Período">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField=":B5" HeaderText="Nómina">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                            <ItemStyle Wrap="False" />
						</asp:Boundfield>
						<asp:Boundfield DataField=":B4" HeaderText="Estatus">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Center"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField=":B3" HeaderText="Monto Original" DataFormatString="{0:c}" HtmlEncode="False">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField=":B2" HeaderText="Monto Recalculado" DataFormatString="{0:c}" HtmlEncode="False">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField=":B1" HeaderText="A favor Empleador">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
					</Columns>
				</asp:GridView>
			</asp:panel>

</asp:Content>

