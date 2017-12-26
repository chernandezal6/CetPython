<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SolConsultaNSS.aspx.vb" Inherits="Solicitudes_SolConsultaNSS" title="Consulta NSS" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
					<br />
	                  <div align="center" class="header">Consulta de NSS</div>
                    <br />
			<table align="center" class="td-content" id="table2" cellSpacing="0" cellPadding="0" width="550" border="0">
				<tr>
					<td>

				<TABLE align="center" class="td-content" id="Table1" cellSpacing="2" cellPadding="1" width="550" border="0">
					<TR>
						<TD colSpan="3">
							<P>
								<asp:label class="labelData" id="lblInfo" runat="server"></asp:label></P>
							<P>
								<asp:Label id="Label1" runat="server" Font-Bold="True">Algo mas en lo que le pueda ayudar?</asp:Label></P>
							<P>
								<asp:Label id="Label2" runat="server">Si la respuesta es si, dar mas informaciones de lugar, de lo contrario:</asp:Label></P>
							<P>
								<asp:Label id="lblAdios" runat="server" Font-Bold="True">_____ le asistió tenga un feliz resto del día!</asp:Label></P>
							<div align="center"><INPUT id="Button1" onclick="javascript:location.href='Solicitudes.aspx';" type="button"
									value="Nueva Solicitud" name="Button1" runat="server" class="Button"></div>
						</TD>
					</TR>
				</TABLE>
				</TD>
			</TR>
		</TABLE>
			
</asp:Content>

