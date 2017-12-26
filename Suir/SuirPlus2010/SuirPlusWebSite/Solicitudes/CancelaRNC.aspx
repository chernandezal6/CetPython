<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CancelaRNC.aspx.vb" Inherits="Solicitudes_CancelaRNC" title="Solicitud de Cancelación de Registro" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<br />
<br />
	       <div align="center" class="header">Solicitud de Cancelación de Registro</div>
	<table align="center" class="td-content" id="table2" cellSpacing="3" cellPadding="0" width="550" border="0">
		<TR>
		<TD>
<br />
			<TABLE class="td-content" id="table1" cellSpacing="3" cellPadding="0" width="550" border="0">
				<TR>
					<TD class="subHeader" align="left" width="20%" colSpan="4">Información General</TD>
				</TR>
				<TR>
					<TD align="right" width="20%" height="5"></TD>
					<TD colSpan="3" height="5"></TD>
				</TR>
				<TR>
					<TD align="right" width="20%">Solicitud</TD>
					<TD colSpan="3"><asp:label cssClass="labelData" id="lblSolicitud" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right" width="15%">Razón Social</TD>
					<TD colSpan="3"><asp:label cssClass="labelData" id="lblRazonSocial" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">RNC&nbsp;</TD>
					<TD width="40%"><asp:label cssClass="labelData" id="lblRNC" runat="server"></asp:label></TD>
					<TD align="right" width="10%">&nbsp;Teléfono</TD>
					<TD><uc1:uctelefono id="ctrlTelefono" runat="server"></uc1:uctelefono></TD>
				</TR>
				<TR>
					<TD align="right">Email&nbsp;</TD>
					<TD><asp:textbox id="txtEmail" runat="server" Width="150px"></asp:textbox><asp:regularexpressionvalidator id="RegularExpressionValidator1" runat="server" Display="Dynamic" ErrorMessage="Email inválido"
							ControlToValidate="txtEmail" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">*</asp:regularexpressionvalidator><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" Display="Dynamic" ErrorMessage="El email es requerido."
							ControlToValidate="txtEmail">*</asp:requiredfieldvalidator></TD>
					<TD align="right">&nbsp;Fax</TD>
					<TD><uc1:uctelefono id="ctrlFax" runat="server"></uc1:uctelefono></TD>
				</TR>
				<TR>
					<TD align="right">Contacto</TD>
					<TD><asp:label cssClass="labelData" id="lblContacto" runat="server"></asp:label></TD>
					<TD align="right" width="5%">&nbsp;Cargo</TD>
					<TD><asp:textbox id="txtCargo" runat="server" Width="150px"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator2" runat="server" Display="Dynamic" ErrorMessage="El cargo es requerido."
							ControlToValidate="txtCargo">*</asp:requiredfieldvalidator></TD>
				</TR>
				<TR>
					<TD class="labelData" align="right">RNC a Cancelar&nbsp;</TD>
					<TD><asp:textbox id="txtRNC" runat="server" Width="150px" MaxLength="11"></asp:textbox></TD>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD class="subHeader" colSpan="4" height="10"></TD>
				</TR>
				<TR>
					<TD class="subHeader" colSpan="4">Motivo de la Solicitud</TD>
				</TR>
				<TR>
					<TD></TD>
					<TD></TD>
					<TD></TD>
					<TD></TD>
				</TR>
				<TR>
					<TD colSpan="4"><asp:textbox id="txtMotivo" runat="server" Width="408px" Height="56px" TextMode="MultiLine"></asp:textbox></TD>
				</TR>
				<TR>
					<TD colSpan="4"><asp:label cssClass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:label></TD>
				</TR>
				<TR>
					<TD colSpan="4"><asp:validationsummary id="ValidationSummary1" runat="server" Width="100%"></asp:validationsummary></TD>
				</TR>
				<TR>
					<TD align="center" colSpan="4"><asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>&nbsp;<INPUT onclick="javascript:location.href='Solicitudes.aspx'" type="button" value="Cancelar" class="Button"></TD>
				</TR>
			</TABLE>
			
	</TD>
	</TR>
	</TABLE>			
</asp:Content>

