<%@ Page Language="VB" AutoEventWireup="false" CodeFile="sfsDetalleSubsidiado.aspx.vb" Inherits="sfsDetalleSubsidiado" title="Detalle del Afiliado - TSS" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">

   <%-- <span class="error">Esta consulta no esta disponible.</span>--%>
			<table runat="server" id="tblGeneral" visible="true" height="430" cellSpacing="0" cellPadding="0" width="430" align="left">
				<tr>
					<td vAlign="top" style="width: 432px">
						<br>
						<table cellSpacing="0" cellPadding="0" width="430">
							<tr>
								<td class="listHeader">Información General</td>
							</tr>
						</table>
						<table class="td-content" cellSpacing="0" cellPadding="0" width="430">
							<tr>
								<td width="30%">Número Solicitud</td>
								<td><asp:label cssclass="labelData" id="lblNroSolicitud" runat="server"></asp:label></td>
							</tr>
							
							<tr>
								<td width="30%">Cédula</td>
								<td><asp:label cssclass="labelData" id="lblCedula" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Nombre</td>
								<td><asp:label cssclass="labelData" id="lblNombre" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Estatus</td>
								<td><asp:label cssclass="error" id="lblStatus" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">PIN</td>
								<td><asp:label cssclass="labelData" id="lblPin" runat="server"></asp:label></td>
							</tr>
							
							<tr>
								<td width="30%">Fecha Registro</td>
								<td><asp:label cssclass="labelData" id="lblFechaRegistro" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Fecha Respuesta</td>
								<td><asp:label cssclass="labelData" id="lblFechaRespuesta" runat="server"></asp:label></td>
							</tr>
							</table>
                            <br />
						<asp:label cssclass="error" id="lblMsg" runat="server"></asp:label>
						
						<TABLE class="td-content"  cellSpacing="0" cellPadding="0" width="100%" border="0">
							<tr>
								<td>
                                
                 <asp:GridView ID="gvDetalle" width="430px" runat="server" 
                     AutoGenerateColumns="False">
                     <Columns>
                         <asp:BoundField DataField="Cuota" HeaderText="Cuota" >
                             <HeaderStyle HorizontalAlign="Center" />
                             <ItemStyle HorizontalAlign="Center" />
                         </asp:BoundField>
                          <asp:BoundField DataField="Monto" HeaderText="Monto"  DataFormatString="{0:n}" 
                             HtmlEncode="False">
                             <HeaderStyle HorizontalAlign="Center" />
                             <ItemStyle HorizontalAlign="Right" />
                         </asp:BoundField>
                         <asp:BoundField DataField="Periodo" HeaderText="Período" >
                             <HeaderStyle HorizontalAlign="Center" />
                             <ItemStyle HorizontalAlign="Center" />
                         </asp:BoundField>
                         <asp:BoundField DataField="Estatus" HeaderText="Estatus Cuota" >  
                          <HeaderStyle HorizontalAlign="Center" />
                         </asp:BoundField>
                          <asp:BoundField DataField="Tipo_Calculo" HeaderText="Tipo Cálculo" >                        
                         <HeaderStyle HorizontalAlign="Center" />
                         </asp:BoundField>
                     </Columns>
                 </asp:GridView>
								</td>
							</tr>
						</table>
						<TABLE class="td-content" id="Table2" cellSpacing="0" cellPadding="0" width="430" border="0">
							<TR>
								<TD>
									<div align="left"><IMG style="CURSOR: pointer" onclick="javascript:window.print();" src="../images/printv.gif"
											border="0">
										<asp:Label id="lblImprimirPagina" style="CURSOR: pointer" onclick="javascript:window.print();"
											runat="server" EnableViewState="False">Imprimir página</asp:Label></div>
								</TD>
								<TD style="height: 38px">
									<div align="left"><IMG style="CURSOR: pointer" onclick="javascript:window.close();" src="../images/cancel.gif"
											border="0">
										<asp:Label id="lblCerrarVentana" style="CURSOR: pointer" onclick="javascript:window.close();"
											runat="server" EnableViewState="False">Cerrar Ventana</asp:Label></div>
									
								</TD>
							</TR>
						</TABLE>
					</td>
				</tr>
				<tr valign="bottom">
					<td background="../images/barrabot-bg.jpg" style="height: 12px; width: 432px;"><font color="#ffffff">(c) 2002-2007
							Derechos Reservados Tesorería de la Seguridad Social</font></td>
				</tr>
			</table>

</form>
</body>
</html>

