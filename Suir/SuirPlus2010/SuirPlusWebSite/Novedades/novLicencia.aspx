<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="novLicencia.aspx.vb" Inherits="Novedades_novLicencia" title="Novedades - Licencia" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc3" %>
<%@ Register Src="~/Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc1" %>
<%@ Register Src="~/Controles/UC_DatePicker.ascx" TagName="UC_DatePicker" TagPrefix="uc2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
        <script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
                Me.RoleRequerido = 31
			End Sub
		</script>

    &nbsp;<uc3:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <table id="table4" width="620">
				<tr>
					<td valign="bottom"><asp:label id="lblTitulo1" runat="server" CssClass="header" EnableViewState="False">Registro de Licencias y Vacaciones</asp:label></td>
					<td align="right">
						<asp:panel id="pnlPendiente" Runat="server" Visible="False">
							<table class="td-note" id="table5">
								<tr>
									<td class="subheader">Tiene Novedades Pendientes</td>
								</tr>
							</table>
						</asp:panel></td>
				</tr>
			</table>
			<asp:label id="lblMsg" runat="server" CssClass="error"></asp:label><br />
			<table class="td-content" id="table1" cellspacing="0" cellpadding="0" width="620" border="0">
				<tr>
					<td class="error" align="left" colspan="4" height="7"></td>
				</tr>
				<asp:panel id="pnlNuevaInfoGeneral" Runat="server"></asp:panel><asp:panel id="pnlInfoGeneral" Runat="server"></asp:panel>
				<tr>
					<td align="right">Nómina</td>
					<td colspan="3"><asp:dropdownlist id="ddNomina" runat="server" CssClass="dropdowns"></asp:dropdownlist></td>
				</tr>
				<tr>
					<td align="right"></td>
					<td class="subHeader" colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td style="HEIGHT: 16px" align="right">&nbsp;</td>
					<td class="subHeader" style="HEIGHT: 16px" colspan="3">Nuevo Empleado</td>
				</tr>
				<tr>
					<td align="right"></td>
					<td colspan="3"><uc1:ucciudadano id="ucEmpleado" runat="server"></uc1:ucciudadano></td>
				</tr>
				<tr>
					<td align="right"></td>
					<td class="error" colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="4">
						<table id="table3" cellspacing="1" cellpadding="1" width="100%" border="0">
							<tr>
								<td style="WIDTH: 214px">Tipo de Licencia o Vacación</td>
								<td><asp:dropdownlist id="ddTipoNovedad" runat="server" CssClass="dropdowns"></asp:dropdownlist>&nbsp;
									<asp:CompareValidator id="CompareValidator1" runat="server" ErrorMessage="Seleccione un tipo." ControlToValidate="ddTipoNovedad"
										ValueToCompare="-1" Operator="NotEqual"></asp:CompareValidator></td>
							</tr>
							<tr>
								<td style="WIDTH: 214px">Fecha Inicio</td>
								<td><uc2:uc_datepicker id="ucFechaIni" runat="server"></uc2:uc_datepicker></td>
							</tr>
							<tr>
								<td style="WIDTH: 214px">Fecha Fin</td>
								<td><uc2:uc_datepicker id="ucFechaFin" runat="server"></uc2:uc_datepicker></td>
							</tr>
						</table>
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<hr size="1" />
					</td>
				</tr>
				<tr>
					<td colspan="4">
						<table id="table2" width="100%">
							<tr>
								<td valign="top" align="left" width="80%"><font color="red">*</font> Información 
									obligatoria.
								</td>
								<td align="right"><asp:button id="btnAceptar" runat="server" Text="Insertar"></asp:button>&nbsp;
									<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button>&nbsp; 
									&nbsp;<br />
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br />
			<table id="table6" width="620">
				<tr>
					<td>
						<asp:label id="lblPendientes" runat="server" CssClass="header">Licencias Pendientes de Aplicar</asp:label></td>
					<td align="right">
						<asp:Button id="btnAplicar" runat="server" Text="Aplicar Novedades" CausesValidation="False"></asp:Button></td>
				</tr>
			</table>
        <asp:GridView ID="gvNovedades" runat="server" autoGenerateColumns="False" cellpadding="4">
			<Columns>
			    <asp:BoundField DataField="NO_DOCUMENTO" HeaderText="Documento"></asp:BoundField>
				<asp:BoundField DataField="NOMBRE" HeaderText="Nombre"></asp:BoundField>
				<asp:BoundField DataField="ID_NOMINA" HeaderText="N&#243;mina"></asp:BoundField>
				<asp:BoundField DataField="TIPO_NOVEDAD_DES" HeaderText="Novedad"></asp:BoundField>
				<asp:BoundField DataField="FECHA_INICIO" HeaderText="Fecha Inicio"></asp:BoundField>
				<asp:BoundField DataField="FECHA_FIN" HeaderText="Fecha Fin"></asp:BoundField>
				<asp:TemplateField>
					<ItemTemplate>
						<asp:ImageButton CausesValidation="False" id="iBtnBorrar" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
							CommandName="Borrar" BorderWidth="0px"></asp:ImageButton>&nbsp;
						<asp:Label id="lblIdMov" runat="server" Text='<%# Eval("ID_MOVIMIENTO") %>' Visible="False">
						</asp:Label>
						<asp:Label id="lblIdLinia" runat="server" Text='<%# Eval("ID_LINEA") %>' Visible="False">
						</asp:Label>
					</ItemTemplate>
				</asp:TemplateField>
			</Columns>    
    </asp:GridView>
</asp:Content>