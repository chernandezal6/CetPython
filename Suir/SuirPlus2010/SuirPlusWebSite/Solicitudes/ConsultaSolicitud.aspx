<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaSolicitud.aspx.vb" Inherits="Solicitudes_ConsultaSolicitud" title="Consulta de Solicitud en Línea - TSS" %>
<%@ Register TagPrefix="uc1" TagName="ucSolicitud" Src="../Controles/ucSolicitud.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<br />

	       <div class="header">Consulta de solicitud en línea</div>
	       <br />
	<table  id="table4" cellSpacing="3" cellPadding="0" width="550" border="0">
		<TR>
		<TD><br />
						<TABLE id="Table2" class="td-content">
							<TR>
								<TD>&nbsp;</TD>
							</TR>
							<TR>
								<TD align="left" valign="middle">Nro. Solicitud: <asp:textbox id="txtIDSolicitud" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtIDSolicitud" Display="Dynamic">*</asp:requiredfieldvalidator>&nbsp;
                                    <asp:button id="btnConsultar" runat="server" Text="Consultar" Width="66px"></asp:button>&nbsp;<asp:button 
                                        id="btnCancelar" tabIndex="1" runat="server" Text="Cancelar" Width="63px"></asp:button></TD>
							</TR>
							<TR>
								<TD align="left"><asp:label cssClass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:label>
                                    <br />
                                </TD>
							</TR>
						</TABLE>
			<br />
			<br>
			<uc1:ucsolicitud id="ctrlSolicitud" runat="server" EnableViewState="False" Visible="False"></uc1:ucsolicitud><br>
	</TD>
	</TR>
	</TABLE>		
</asp:Content>

