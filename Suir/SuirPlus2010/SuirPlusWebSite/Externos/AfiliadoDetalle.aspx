<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AfiliadoDetalle.aspx.vb" Inherits="Externos_AfiliadoDetalle" title="Detalle del Afiliado - TSS" %>


<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head id="Head1" runat="server">
    <title></title>
</head>
<body>
    <form id="form1" runat="server">


			<table height="430" cellSpacing="0" cellPadding="0" width="430" align="left">
				<tr>
					<td vAlign="top" style="width: 432px">
						<table id="table1" cellSpacing="0" cellPadding="0" width="430" border="0">
							<tr>
								<td colSpan="2"><asp:label id="lblTrabajador" runat="server" cssclass="subHeader"></asp:label></td>
								<td width="1%" rowSpan="7"><IMG height="80" src="../images/line.gif" width="1" border="0"></td>
								<td width="1%" rowSpan="7"><IMG src="../images/resume.gif" width="93" height="109"></td>
							</tr>
							<tr>
								<td>NSS:</td>
								<td><asp:label id="lblNSS" runat="server" cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td>Cedula:</td>
								<td><asp:label id="lblCedula" runat="server" cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td>Salario:</td>
								<td><asp:label id="lblSalario" runat="server" cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td>Nómina:</td>
								<td><asp:label id="lblNomina" runat="server" cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td >Fecha Ingreso:</td>
								<td ><asp:label id="lblFechaIngreso" runat="server" cssclass="labelData"></asp:label></td>
							</tr>
							<TR>
								<TD >Fecha Reingreso:</TD>
								<TD >
									<asp:Label id="lblFechaReingreso" runat="server" CssClass="labelData"></asp:Label></TD>
							</TR>
							<tr>
								<td >Fecha Registro:</td>
								<td ><asp:label id="lblFechaRegistro" runat="server" cssclass="labelData"></asp:label></td>
							</tr>
							<tr>
								<td >Estatus:</td>
								<td><asp:label id="lblEstatus" runat="server" cssclass="error"></asp:label></td>
							</tr>
						</table>
						<br>
						<table cellSpacing="0" cellPadding="0" width="430">
							<tr>
								<td class="listHeader">Información del empleador</td>
							</tr>
						</table>
						<table class="td-content" cellSpacing="0" cellPadding="0" width="430">
							<tr>
								<td width="30%">Nombre comercial</td>
								<td colSpan="5"><asp:label cssclass="labelData" id="lblNombreComercial" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Razon social</td>
								<td colSpan="5"><asp:label cssclass="labelData" id="lblRazonSocial" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Actividad economica</td>
								<td colSpan="5"><asp:label cssclass="labelData" id="lblActividadEconomica" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Institución</td>
								<td colSpan="5"><asp:label cssclass="labelData" id="lblInsitucion" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Telefono 1</td>
								<td><asp:label cssclass="labelData" id="lblTelefono1" runat="server"></asp:label></td>
								<td width="5%">Ext.</td>
								<td colSpan="3" align="left"><asp:label cssclass="labelData" id="lblExt1" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Telefono 2</td>
								<td><asp:label cssclass="labelData" id="lblTelefono2" runat="server"></asp:label></td>
								<td width="5%">Ext.</td>
								<td colSpan="3" align="left"><asp:label cssclass="labelData" id="lblExt2" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Calle</td>
								<td colSpan="5"><asp:label cssclass="labelData" id="lblCalle" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Edificio</td>
								<td><asp:label cssclass="labelData" id="lblEdificio" runat="server"></asp:label></td>
								<td align="left">Piso</td>
								<td align="left"><asp:label cssclass="labelData" id="lblPiso" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Apartamento</td>
								<td><asp:label cssclass="labelData" id="lblApartamento" runat="server"></asp:label></td>
								<td>Sector</td>
								<td colSpan="3" align="left"><asp:label cssclass="labelData" id="lblSector" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Municipio</td>
								<td colSpan="5"><asp:label cssclass="labelData" id="lblMunicipo" runat="server"></asp:label></td>
							</tr>
							<tr>
								<td width="30%">Provincia</td>
								<td colSpan="5"><asp:label cssclass="labelData" id="lblProvincia" runat="server"></asp:label></td>
							</tr>
						</table>
						<br>
						<TABLE class="td-content"  cellSpacing="0" cellPadding="0" width="100%" border="0">
							<tr>
								<td>
									<asp:GridView id="gvRepresentante" runat="server" AutoGenerateColumns="False" EnableViewState="False" Width="101%">
										<Columns>
											<asp:BoundField DataField="nombre" HeaderText="Representante"></asp:BoundField>

											<asp:TemplateField HeaderText="Tel&#233;fono">
                                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                            <ItemTemplate>
                                            <asp:Label id="Label2" runat="server" Text='<%# formateaTelefono(Eval("telefono")) %>' />                           
                                            </ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" />
								            </asp:TemplateField> 			
											
											<asp:BoundField DataField="email" HeaderText="Email"></asp:BoundField>
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
											runat="server" EnableViewState="False">cerrar ventana</asp:Label></div>
									
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

