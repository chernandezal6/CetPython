<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="updatecatriesgo.aspx.vb" Inherits="Externos_updatecatriesgo" title="Actualización de Categoria de Riesgo - TSS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		
		<script language="vb" runat="server">
		
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
		        'PermisoRequerido = 93
			End Sub
			
		</script>
			<table>
				<tr>
					<td class="header">Actualización de Categoría de Riesgo</td>
				</tr>
				<tr>
					<td height="5"></td>
				</tr>
			</table>
			<TABLE class="td-content" id="Table1" cellSpacing="0" cellPadding="0">
				<TR>
					<TD rowSpan="4"><IMG src="../images/upcatriesgo.jpg" width="169" height="89">
					</TD>
					<TD>
						<TABLE id="Table2">
							<TR>
								<TD>RNC:</TD>
								<TD><asp:textbox id="txtRNC" runat="server" MaxLength="11" Width="100px"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ErrorMessage="Debe ingresar un RNC o Cédula."
										ControlToValidate="txtRNC">*</asp:requiredfieldvalidator></TD>
							</TR>
							<TR>
								<TD align="center" colSpan="2"><asp:button id="btnConsultar" runat="server" Text="Consultar"></asp:button>&nbsp;<asp:button id="btnCancelar" runat="server" Text="Cancelar"></asp:button></TD>
							</TR>
							<TR>
								<TD align="center" colSpan="2"><asp:regularexpressionvalidator id="regExpRncCedula" runat="server" ErrorMessage="RNC o Cédula invalido." ControlToValidate="txtRNC"
										ValidationExpression="^(\d{9}|\d{11})$" Display="Dynamic"></asp:regularexpressionvalidator></TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			<br>
			<asp:label id="lblMsg" Runat="server" EnableViewState="False" cssclass="error"></asp:label>
			
			<asp:panel class="td-content" id="pnlConsulta" Width="600px" Runat="server" Visible="False">
				<TABLE id="table3" style="BORDER-COLLAPSE: collapse" cellSpacing="1" cellPadding="0" width="100%"
					border="0">
					<TR>
						<TD width="18%">RNC</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblRnc" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Nombre Comercial</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblNomComercial" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Razón Social</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Registro Patronal</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblRegPatronal" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">
                            Categoría de Riesgo</TD>
						<TD colSpan="3">&nbsp;
						
							<asp:DropDownList id="drpCategoria" runat="server" cssclass="dropDowns" AutoPostBack="True"></asp:DropDownList>
							<asp:Button id="btnActualizar" runat="server" Text="Actualizar categoría" Enabled="False"></asp:Button></TD>
					</TR>
					<TR>
						<TD width="18%">Actividad Económica</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblActEconomica" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Tipo de Empresa</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblTipoEmpresa" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Estatus</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblEstatus" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">&nbsp;</TD>
						<TD colSpan="3">&nbsp;</TD>
					</TR>
					<TR>
						<TD width="18%">Email</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblEmail" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%" style="height: 12px">Teléfono1</TD>
						<TD width="20%" style="height: 12px">&nbsp;
							<asp:Label id="lblTelefono1" runat="server" CssClass="labelData"></asp:Label></TD>
						<TD width="5%" style="height: 12px">Ext1</TD>
						<TD width="32%" style="height: 12px; text-align: left">&nbsp;
							<asp:Label id="lblExt1" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Teléfono2</TD>
						<TD width="20%">&nbsp;
							<asp:Label id="lblTelefono2" runat="server" CssClass="labelData"></asp:Label></TD>
						<TD width="5%">Ext2</TD>
						<TD style="HEIGHT: 12px; text-align: left;" width="32%">&nbsp;
							<asp:Label id="lblExt2" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Fax</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblFax" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Calle</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblCalle" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Número</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblNumero" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Edificio</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblEdificio" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Piso</TD>
						<TD width="20%">&nbsp;
							<asp:Label id="lblPiso" runat="server" CssClass="labelData"></asp:Label></TD>
						<TD width="5%">
                            Apto.</TD>
						<TD width="32%">&nbsp;
							<asp:Label id="lblApto" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Sector</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblSector" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Municipio</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblMunicipio" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Provincia</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblProvincia" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
					<TR>
						<TD width="18%">Fecha de Registro</TD>
						<TD colSpan="3">&nbsp;
							<asp:Label id="lblFechaRegistro" runat="server" CssClass="labelData"></asp:Label></TD>
					</TR>
				</TABLE>
			</asp:panel>


</asp:Content>

