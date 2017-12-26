<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="empPerfil.aspx.vb" Inherits="Empleador_empPerfil" title="Perfil de la Empresa" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc2" %>

<%@ Register Src="../Controles/UCTelefono.ascx" TagName="UCTelefono" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <uc2:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
<br />
<div class="header">Perfil del Empleador</div>
    <br />
    <asp:Label ID="lblFormMSG" runat="server" CssClass="error"></asp:Label><br />
			<table class="td-content" cellSpacing="2" cellPadding="0" style="width:590px" border="0">
				<TR>
					<TD align="left" colSpan="4"><FONT color="red">*</FONT> Información obligatoria.
					</TD>
				</TR>
				<tr>
					<td colSpan="4" height="10"></td>
				</tr>
				<TR>
					<TD class="subHeader" align="left" colSpan="4">Información General</TD>
				</TR>
				<tr>
					<td colSpan="4" height="10"></td>
				</tr>
				<tr>
					<td align="right">RNC / Cédula&nbsp;
					</td>
					<td colSpan="3"><asp:label id="lblRncCedula" runat="server" Font-Bold="True"></asp:label>
						<asp:label id="lblRNL" runat="server" Font-Bold="True" Visible="False"></asp:label></td>
				</tr>
				<tr>
					<td align="right">Razón Social&nbsp;
					</td>
					<td colSpan="3"><asp:label id="lblRazonSocial" runat="server" Font-Bold="True"></asp:label></td>
				</tr>
				<TR>
					<TD align="right">Categoria de Riesgo&nbsp;
					</TD>
					<TD colSpan="3">
						<asp:label id="lblRiesgo" runat="server" Font-Bold="True"></asp:label></TD>
				</TR>
				<tr>
					<td align="right">Nombre Comercial&nbsp;</td>
					<td class="error" colSpan="3"><asp:textbox id="txtNombreComercial" runat="server" 
                            Width="400px" MaxLength="150" Enabled="False"></asp:textbox><asp:requiredfieldvalidator id="reqFieldNombreComercial" runat="server" CssClass="error" ForeColor=" " Display="Dynamic"
							ControlToValidate="txtNombreComercial" ErrorMessage="Debe introducir el Nombre Comercial.">*</asp:requiredfieldvalidator>*</td>
				</tr>
				<TR>
					<TD align="right">Tipo Empresa&nbsp;
					</TD>
					<TD colSpan="3"><asp:dropdownlist id="ddlTipoEmpresa" runat="server" 
                            CssClass="dropDowns" Enabled="False">
							<asp:ListItem Value="PR" Selected="True">Privada</asp:ListItem>
							<asp:ListItem Value="PU">P&#250;blica</asp:ListItem>
							<asp:ListItem Value="PC">P&#250;blica Centralizada</asp:ListItem>
						</asp:dropdownlist></TD>
				</TR>
				<TR>
					<TD align="right" vAlign="top">Sector Económico&nbsp;</TD>
					<TD class="error" colSpan="3"><asp:dropdownlist id="ddlSectorEconomico" 
                            runat="server" CssClass="dropDowns" Enabled="False"></asp:dropdownlist>*
						<BR>
						<asp:comparevalidator id="CompareValidator2" runat="server" ControlToValidate="ddlSectorEconomico" ErrorMessage="Debe introducir el Sector Económico."
							ValueToCompare="-1" Operator="NotEqual">Debe introducir el Sector Económico.</asp:comparevalidator></TD>
				</TR>
				<tr>
					<td colSpan="4" height="10"></td>
				</tr>
				<TR>
					<TD class="subHeader" align="left" colSpan="4">Dirección</TD>
				</TR>
				<tr>
					<td colSpan="4" height="10"></td>
				</tr>
				<tr>
					<td align="right">Calle&nbsp;
					</td>
					<td class="error" colSpan="3"><asp:textbox id="txtCalle" runat="server" Width="296px" MaxLength="150"></asp:textbox><asp:requiredfieldvalidator id="reqFieldCalle" runat="server" CssClass="error" ForeColor=" " Display="Dynamic"
							ControlToValidate="txtCalle" ErrorMessage="Debe introducir la calle.">*</asp:requiredfieldvalidator>*</td>
				</tr>
				<tr>
					<td align="right">Número&nbsp;
					</td>
					<td class="error"><asp:textbox id="txtNumero" runat="server" Width="69px" MaxLength="12"></asp:textbox><asp:requiredfieldvalidator id="reqFieldNumero" runat="server" CssClass="error" ForeColor=" " Display="Dynamic"
							ControlToValidate="txtNumero" ErrorMessage="Debe introducir el Número.">*</asp:requiredfieldvalidator>*</td>
					<td align="right">Edificio&nbsp;
					</td>
					<td><asp:textbox id="txtEdificio" runat="server" Width="168px" MaxLength="25"></asp:textbox></td>
				</tr>
				<tr>
					<td align="right">Piso&nbsp;
					</td>
					<td><asp:textbox id="txtPiso" runat="server" Width="69px" MaxLength="2"></asp:textbox></td>
					<td align="right">Apartamento&nbsp;
					</td>
					<td><asp:textbox id="txtApartamento" runat="server" Width="120px" MaxLength="10"></asp:textbox></td>
				</tr>
				<TR>
					<TD align="right">Sector&nbsp;
					</TD>
					<TD class="error" colSpan="3"><asp:textbox id="txtSector" runat="server" Width="296px" MaxLength="150"></asp:textbox><asp:requiredfieldvalidator id="reqFieldSector" runat="server" CssClass="error" ForeColor=" " Display="Dynamic"
							ControlToValidate="txtSector" ErrorMessage="Debe introducir el sector.">*</asp:requiredfieldvalidator>*</TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 18px" align="right">Provincia&nbsp;
					</TD>
					<TD class="error" style="HEIGHT: 29px" colSpan="3">
						<asp:dropdownlist id="ddProvincia" runat="server" CssClass="dropDowns" AutoPostBack="True"></asp:dropdownlist>&nbsp;*
						<asp:comparevalidator id="Comparevalidator3" runat="server" ControlToValidate="ddProvincia" ErrorMessage="Debe seleccionar la Provincia."
							ValueToCompare="-1" Operator="NotEqual"> Debe seleccionar la Provincia.</asp:comparevalidator></TD>
				</TR>
				<TR>
					<TD style="HEIGHT: 18px" align="right">Municipio&nbsp;
					</TD>
					<TD class="error" style="HEIGHT: 29px" colSpan="3">
						<asp:dropdownlist id="ddMunicipio" runat="server" CssClass="dropDowns"></asp:dropdownlist>&nbsp;*
						<asp:comparevalidator id="Comparevalidator4" runat="server" ControlToValidate="ddMunicipio" ErrorMessage="Debe seleccionar el Municipio."
							ValueToCompare="-1" Operator="NotEqual"> Debe seleccionar el Municipio.</asp:comparevalidator></TD>
				</TR>
				<tr>
					<td colSpan="4" height="10"></td>
				</tr>
				<TR>
					<TD class="subHeader" align="left" colSpan="4">Información de Contacto</TD>
				</TR>
				<tr>
					<td colSpan="4" height="10"></td>
				</tr>
				<tr>
					<td align="right">Teléfono&nbsp; #1&nbsp;
					</td>
					<td colSpan="3">
                        <uc1:UCTelefono ID="UCTelefono1" runat="server" />
                        ext.
						<asp:textbox id="txtExt1" runat="server" Width="48px" MaxLength="4"></asp:textbox><asp:label id="lblTel1" runat="server" CssClass="error">*</asp:label></td>
				</tr>
				<tr>
					<td align="right">Teléfono&nbsp; #2&nbsp;
					</td>
					<td colSpan="3">
                        <uc1:UCTelefono ID="UCTelefono2" runat="server" />
                        ext.
						<asp:textbox id="txtExt2" runat="server" Width="48px" MaxLength="4"></asp:textbox></td>
				</tr>
				<tr>
					<td align="right">Fax&nbsp;
					</td>
					<td colSpan="3">
                        <uc1:UCTelefono ID="ucFax" runat="server" />
                    </td>
				</tr>
				<TR>
					<TD align="right" vAlign="top">Email&nbsp;</TD>
					<td colSpan="3"><asp:textbox id="txtEmail" runat="server" Width="240px" MaxLength="50"></asp:textbox>
						<asp:regularexpressionvalidator id="RegularExpressionValidator2" runat="server" ErrorMessage="Formato de correo electrónico invalido"
							ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*" Display="Dynamic"></asp:regularexpressionvalidator></td>
				</TR>
				<tr>
					<td colSpan="4">
						<hr SIZE="1">
						<FONT color="red">*</FONT> Información obligatoria.
					</td>
				</tr>
				<tr>
					<td vAlign="top" align="right" colSpan="4">
						<asp:button id="btnActualizar" runat="server" Text="Actualizar"></asp:button>
						<asp:button id="btnDesCambios" runat="server" Text="Deshacer Cambios"></asp:button>&nbsp;&nbsp;&nbsp;<BR>
						&nbsp;
					</td>
				</tr>
			</table>
</asp:Content>

