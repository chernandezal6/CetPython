<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="InformacionGeneral.aspx.vb" Inherits="Solicitudes_InformacionGeneral" title="Solicitud de información general" %>
<%@ Register TagPrefix="uc1" TagName="UCTelefono" Src="../Controles/UCTelefono.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
				<br />
	            <div align="center" class="header">Solicitud General</div>
                <br />
	<TABLE align="center" class="td-content" id="table2" cellSpacing="0" cellPadding="0" width="550" border="0">
		<TR>
			<TD>

				
			<TABLE class="td-content" id="Table1" cellSpacing="2" cellPadding="1" width="550" border="0">
				<TR>
					<TD align="right" width="25%">Solicitud&nbsp;</TD>
					<TD colSpan="3">
						<asp:label cssClass="labelData" id="lblSolicitud" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">RNC&nbsp;</TD>
					<TD colSpan="3">
						<asp:label cssClass="labelData" id="lblRNC" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Razon Social&nbsp;</TD>
					<TD colSpan="3">
						<asp:label cssClass="labelData" id="lblRazonSocial" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Nombre Comercial&nbsp;</TD>
					<TD colSpan="3">
						<asp:label cssClass="labelData" id="lblNombreComercial" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Cédula Representante&nbsp;</TD>
					<TD colSpan="3">
						<asp:label cssClass="labelData" id="lblCedRepresentante" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Representante&nbsp;</TD>
					<TD colSpan="3">
						<asp:label cssClass="labelData" id="lblRepresentante" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD align="right">Provincia&nbsp;</TD>
					<TD colSpan="3">
						<asp:label cssClass="labelData" id="lblProvincia" runat="server"></asp:label></TD>
				</TR>
				<TR>
					<TD nowrap="nowrap">Un teléfono donde contactarle:</TD>
					<TD colSpan="3">
						<uc1:UCTelefono id="ctrlTelefono" runat="server"></uc1:UCTelefono></TD>
				</TR>
				<TR>
					<TD nowrap="nowrap">Tiene otro número de teléfono:</TD>
					<TD colSpan="3">
						<uc1:UCTelefono id="ctrlFax" runat="server"></uc1:UCTelefono></TD>
				</TR>
				<TR>
					<TD align="right">Motivo Solicitud&nbsp;</TD>
					<TD colSpan="3">
						<asp:TextBox id="txtMotivo" runat="server" TextMode="MultiLine" Width="376px" Height="56px"></asp:TextBox></TD>
				</TR>
				<TR>
					<TD align="center" colSpan="4">
                        <br />
						<asp:button id="btnEnviar" runat="server" Text="Aceptar"></asp:button>&nbsp;<INPUT id="btnCancelar" onclick="javascript:location.href='Solicitudes.aspx'" type="button"
							value="Cancelar" name="btnCancelar" class="Button"><br />
                    </TD>
				</TR>
			</TABLE>
			<div align="center">
			<asp:Label cssClass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:Label>
			</div>
			</TD>
		</TR>
	</TABLE>
</asp:Content>

