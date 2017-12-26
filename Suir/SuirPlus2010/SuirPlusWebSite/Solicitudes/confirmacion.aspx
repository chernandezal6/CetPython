<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="confirmacion.aspx.vb" Inherits="Solicitudes_confirmacion" title="Confirmación - Tesoreria de la Seguridad Social" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
		
<br />
	       <div align="center" class="header">Confirmación de Solicitud</div>

	<table align="center" class="td-content" id="table2" cellSpacing="3" cellPadding="0" width="400" border="0">
		<TR>
		<TD>
		
			<TABLE class="td-note" id="Table1" cellSpacing="1" cellPadding="1" width="100%" border="0">
				<TR>
					<TD class="LabelDataGreen" align="center">
						<asp:Label cssclass="label-Resaltado" id="lblSolicitud" runat="server"></asp:Label></TD>
				</TR>
				<TR>
					<TD height="5">&nbsp;</TD>
				</TR>
				<TR>
					<TD height="5">
						<div align="justify">
							<asp:Label id="lblAdios" runat="server" Font-Bold="True" EnableViewState="False">¿Sr./Sra. ______ algo más en lo que le pueda ayudar?</asp:Label></div>
					</TD>
				</TR>
				<TR>
					<TD height="5">&nbsp;</TD>
				</TR>
				<TR>
					<TD height="5">Si la respuesta es si, dar las informaciones de lugar, de lo 
						contrario:</TD>
				</TR>
				<TR>
					<TD height="5">&nbsp;</TD>
				</TR>
				<TR>
					<TD height="5">
						<div align="justify">
							<asp:Label id="lblAgente" runat="server" Font-Bold="True" EnableViewState="False">___________ le asistió tenga un feliz resto del día!</asp:Label></div>
					</TD>
				</TR>
				<TR>
					<TD height="5">&nbsp;</TD>
				</TR>
				<TR>
					<TD align="center"><INPUT type="button" onclick="javascript:location.href='Solicitudes.aspx'" value="Nueva Solicitud" class="Button">&nbsp;
						<INPUT type="button" runat="server" id="btnConsultar" value="Consultar" class="Button"></TD>
				</TR>
				<TR>
					<TD align="center" height="8"></TD>
				</TR>
			</TABLE>

	</TD>
	</TR>
	</TABLE>
</asp:Content>

