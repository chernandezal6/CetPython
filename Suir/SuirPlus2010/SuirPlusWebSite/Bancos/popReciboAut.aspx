<%@ Page Language="VB" AutoEventWireup="false" CodeFile="popReciboAut.aspx.vb" Inherits="Bancos_popReciboAut" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Autorización de Referencia de Pago</title>
</head>
<body onload="window.print();">
    <form id="form1" runat="server">
    <div>
    <TABLE id="Table1" style="HEIGHT: 58px" cellSpacing="1" cellPadding="1" width="650" border="0">
				<TR>
					<TD>
						<TABLE id="Table2" cellSpacing="1" cellPadding="1" width="100%" border="0">
							<TR>
								<TD colSpan="2"><IMG id="imgTitle" runat="server"></TD>
							</TR>
							<TR>
								<TD class="subHeader">
									<asp:Label class="header" id="lblInstitucionAutoriza" runat="server"></asp:Label></TD>
								<TD>
								</TD>
							</TR>
							<TR>
								<TD colSpan="2" align="right">&nbsp;&nbsp;&nbsp; Nro. de Referencia:
									<asp:Label id="lblNroDeReferencia" runat="server" Font-Size="X-Small" Font-Bold="True"></asp:Label>
								</TD>
							</TR>
							<TR>
								<TD>
									<asp:Label class="header" id="lblTituloV" runat="server" Font-Bold="True" Font-Size="Small">Volante de Pago de la Seguridad Social</asp:Label></TD>
								<TD>
									Fecha:
										<asp:Label id="lblFecha" runat="server" Font-Bold="True"></asp:Label>
								</TD>
							</TR>
							<TR>
								<TD colSpan="2">&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD colSpan="2">
									<TABLE id="Table3" cellSpacing="2" cellPadding="2" width="100%" border="0">
										<TR>
											<TD>Clave Autorizacion</TD>
											<TD>
												
													<asp:Label id="lblNroAut" runat="server" Font-Size="X-Small" Font-Bold="True"></asp:Label>
											</TD>
											<td rowspan="7" style="BORDER-RIGHT: black solid; BORDER-TOP: black solid; BORDER-LEFT: black solid; BORDER-BOTTOM: black solid"
												vAlign="top" borderColor="black" width="210">
												Sello de Caja
											</td>
										</TR>
										<TR>
											<TD>Importe a Pagar</TD>
											<TD>
												
													<asp:Label id="lblImportePagar" runat="server" Font-Size="X-Small" Font-Bold="True"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>
												RNC ó Cedula</TD>
											<TD>
												
													<asp:Label id="lblRNC" runat="server"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>Razón Social</TD>
											<TD><asp:Label id="lblRazonSocial" runat="server"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>Periodo Pagado</TD>
											<TD><asp:Label id="lblPeriodo" runat="server" Font-Bold="True" Font-Size="X-Small"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>
												<asp:Label id="lblNominaText" runat="server">Nomina</asp:Label></TD>
											<TD><asp:Label id="lblNomina" runat="server"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>
												<asp:Label id="lblTxtTipoFactura" runat="server">Tipo de Factura</asp:Label></TD>
											<TD><asp:Label id="lblTipoFactura" runat="server"></asp:Label>
											</TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
							<TR>
								<TD colSpan="2">&nbsp;
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
				<TR>
					<TD id="tablaPrincipal">
<br /><br /><br />
---------------------------------------------------------------------------------------------------------------------------------
<br /><br /><br />
					</TD>
				</TR>
				<TR>
					<TD>
						<TABLE id="Table4" cellSpacing="1" cellPadding="1" width="100%" border="0">
							<TR>
								<TD colSpan="2"><IMG id="imgTitle2" runat="server"></TD>
							</TR>
							<TR>
								<TD class="subHeader" style="HEIGHT: 31px">
									<asp:Label class="header" id="lblInstitucionAutoriza2" runat="server"></asp:Label></TD>
								<TD style="HEIGHT: 31px">
								</TD>
							</TR>
							<TR>
								<TD colSpan="2" align="right">&nbsp;&nbsp;&nbsp; Nro. de Referencia:
									<asp:Label id="lblNroDeReferencia2" runat="server" Font-Size="X-Small" Font-Bold="True"></asp:Label>
								</TD>
							</TR>
							<TR>
								<TD>
									<asp:Label class="header" id="lblTituloV2" runat="server" Font-Bold="True" Font-Size="Small">Volante de Pago de la Seguridad Social</asp:Label></TD>
								<TD>Fecha:
										<asp:Label id="lblFecha2" runat="server" Font-Bold="True"></asp:Label>
								</TD>
							</TR>
							<TR>
								<TD colSpan="2">&nbsp;&nbsp;</TD>
							</TR>
							<TR>
								<TD colSpan="2">
									<TABLE id="Table5" cellSpacing="2" cellPadding="2" width="100%" border="0">
										<TR>
											<TD style="HEIGHT: 26px">Clave Autorizacion</TD>
											<TD style="HEIGHT: 26px">
												
													<asp:Label id="lblNroAut2" runat="server" Font-Size="X-Small" Font-Bold="True"></asp:Label>
											</TD>
											<td rowspan="7" style="BORDER-RIGHT: black solid; BORDER-TOP: black solid; BORDER-LEFT: black solid; BORDER-BOTTOM: black solid"
												vAlign="top" borderColor="black" width="210">
												Sello de Caja
											</td>
										</TR>
										<TR>
											<TD>Importe a Pagar</TD>
											<TD><asp:Label id="lblImportePagar2" runat="server" Font-Size="X-Small" Font-Bold="True"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>
												RNC ó Cedula</TD>
											<TD><asp:Label id="lblRNC2" runat="server"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>Razón Social</TD>
											<TD><asp:Label id="lblRazonSocial2" runat="server"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>Periodo Pagado</TD>
											<TD><asp:Label id="lblPeriodo2" runat="server" Font-Bold="True" Font-Size="X-Small"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>
												<asp:Label id="lblNominaText2" runat="server">Nomina</asp:Label></TD>
											<TD><asp:Label id="lblNomina2" runat="server"></asp:Label>
											</TD>
										</TR>
										<TR>
											<TD>
												<asp:Label id="lblTxtTipoFactura2" runat="server">Tipo de Factura</asp:Label></TD>
											<TD><asp:Label id="lblTipoFactura2" runat="server"></asp:Label>
											</TD>
										</TR>
									</TABLE>
								</TD>
							</TR>
							<TR>
								<TD colSpan="2">&nbsp;
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
    </div>
    </form>
</body>
</html>
