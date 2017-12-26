<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CalculoAportes.aspx.vb" Inherits="Solicitudes_CalculoAportes" title="Calculo Aportes" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<TABLE align="center" class="td-content" id="Table2" cellSpacing="2" cellPadding="1" width="550" border="0">
	<tr>
	<td style="height: 273px">

	<div align="center" class="header">Calculo de aporte</div>
			<TABLE class="td-content" id="Table1" cellSpacing="2" cellPadding="1" width="550" border="0">
			   
				<TBODY>
					<TR>
						<TD colSpan="3">
							<P class="labelData" align="justify"><FONT size="2">A usted le deben descontar
									<asp:Label id="lblDescuento" runat="server" Font-Size="X-Small" 
                                    style="font-size: small"></asp:Label>&nbsp;por 
									concepto de seguridad&nbsp;&nbsp;social.&nbsp; Su empleador deberá aportar
									<asp:Label id="lblAporteEmpleador" runat="server" Font-Size="X-Small" 
                                    style="font-size: small"></asp:Label>&nbsp;y 
									su cuenta de capitalización individual tendrá un aporte mensual de
									<asp:Label id="lblAporteMensual" runat="server" Font-Size="X-Small" 
                                    style="font-size: small"></asp:Label></FONT>
							</P>
							<br>
							<STRONG><FONT face="Tahoma" size="2"><EM>Sr./Sra.&nbsp; Algo mas en lo que le pueda ayudar?</EM></FONT></STRONG>
							<br>
							<br>
							<FONT face="Tahoma" size="2">(si la respuesta es si, dar las informaciones de 
								lugar, de lo contrario: </FONT>
							<br>
							<br>
							<STRONG><EM><FONT face="Tahoma" size="2">
										<asp:Label id="lblAgente" runat="server">Label</asp:Label>
										&nbsp;le asistió tenga un feliz resto del día!</FONT></EM></STRONG><br><br><br>
							<div align="center"><INPUT onclick="javascript:location.href='Solicitudes.aspx';" type="button" value="Nueva Solicitud" class="Button"></div>
						</TD>
					</TR>
				</TBODY>
			</TABLE>
			<br />
			<div align="center">
			<asp:Label cssClass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:Label>
			</div>
	</td>
	</tr>
	</TABLE>
</asp:Content>

