<%@ Page Language="VB" AutoEventWireup="false" CodeFile="VerReclamacion.aspx.vb" Inherits="Operaciones_VerReclamacion" %>

<%@ Register src="../Controles/UCTelefono.ascx" tagname="UCTelefono" tagprefix="uc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <style type="text/css">
        .style1
        {
            width: 100%;
        }
        .style2
        {
            width: 65px;
        }
        .style3
        {
            width: 186px;
        }
        .style4
        {
            width: 46px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
     <!--Encabezado de la certificacion-->
			<table cellSpacing="0" cellPadding="0" width="100%" border="0">
				<tr>
				
					<td vAlign="top" align="center" height="86">
						<asp:label id="lblEslogan" Font-Bold="True" Font-Size="Medium" Runat="Server"></asp:label>
						<br/><br/><br/>
						<FONT size="3pt"><A style="textdecorator: none" onclick="javascript:print()" href="#"> 
                        Reclamacion No: <strong>
							<asp:label id="lblNoReclamacion" runat="server"></asp:label></strong></A></FONT>
                        <br />
						<FONT size="2pt"><A style="textdecorator: none" onclick="javascript:print()" href="#"> 
                        Tipo de Reclamacion: <strong>
							<asp:label id="lblTipoReclamacion" runat="server"></asp:label></strong></A></FONT><br>
							
							<FONT size="2pt" color="navy">
                        <asp:Label ID="lblCertificacion" runat="server" ></asp:Label>
                        </FONT>
                        <br />
						<br/>
							<br/>
							<br/>
					</td>
				</tr>
			</table>
                <table cellspacing="2" cellpadding="0" width="500px" align="center">
				    <tr>
                        <td  nowrap="nowrap">
                            <table class="style1" runat="server" id="tblEmpleador">
                                <tr>
                                    <td class="style2">
                                        Razon Social:</td>
                                    <td colspan="3">
                            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        Telefono:</td>
                                    <td class="style3">
                            <asp:Label ID="lblTelefono" runat="server"></asp:Label>
                                    </td>
                                    <td class="style4">
                                        Ext:</td>
                                    <td>
                            <asp:Label ID="lblExt" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        Contacto:</td>
                                    <td class="style3">
                            <asp:Label ID="lblContacto" runat="server"></asp:Label>
                                    </td>
                                    <td class="style4">
                                        Cargo:</td>
                                    <td>
                            <asp:Label ID="lblCargo" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        Email:</td>
                                    <td class="style3">
                            <asp:Label ID="lblEmail" runat="server"></asp:Label>
                                    </td>
                                    <td class="style4">
                                        Fax</td>
                                    <td>
                            <asp:Label ID="lblFax" runat="server"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="style2">
                                        &nbsp;</td>
                                    <td class="style3">
                                        &nbsp;&nbsp;</td>
                                    <td class="style4">
                                        &nbsp;</td>
                                    <td>
                                        &nbsp;</td>
                                </tr>
                            </table>
                            <TABLE id="tblCiudadano" runat="server" visible="false" cellSpacing="0" cellPadding="0" Width="100%" border="0">

						<TR vAlign="top">
							<TD width="105px">
								<DIV  style="text-align: left">Nombre del individuo:&nbsp;</DIV>
							</TD>
							<TD >
                                <asp:Label cssclass="labelData" id="lblNombre" runat="server"></asp:Label></TD>
						</TR>
						<TR vAlign="top">
							<TD  >
								<DIV style="text-align: left">NSS:&nbsp;
								</DIV>
							</TD>
							<TD  >
                                <asp:Label cssclass="labelData" id="lblNSS" runat="server"></asp:Label></TD>
						</TR>
						
						<TR vAlign="top">
							<TD  >
								<DIV  style="text-align: left">Cédula:&nbsp;</DIV>
							</TD>
							<TD >
                                <asp:Label cssclass="labelData" id="lblCedulaCiudadano" runat="server"></asp:Label></TD>
						</TR>
						</TABLE>
                        </td>
                    </tr>
                    <tr>
                        <td class="labelData" style="text-align: left">
                            <asp:Label ID="lblDetalleNP" runat="server" Visible="False">Notificaciones de Pagos a Afectar:</asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: left">
                            <asp:GridView ID="gvNotPagadas" runat="server" AutoGenerateColumns="False">
                                <Columns>
                                    <asp:BoundField DataField="id_referencia" HeaderText="Notificaciones de pago">
                                    <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                            <br />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
			<asp:Panel ID="pnlFirmas" runat="server">
				<table cellspacing="0" cellpadding="0" width="520px">
				<tr>
					<td style="text-align: left">
                        <asp:Label ID="lblTituloMotivo" runat="server" CssClass="labelData">Motivo de su solicitud:</asp:Label>
                        <br />
                        <br />
                        <asp:Label ID="lblMotivo" runat="server"></asp:Label>
					</td>
				</tr>
				
				</table>	
			
			    <br />
		        <br />
		        <br />			
	            <table cellspacing="0" cellpadding="0" width="520px">
				<tr>
					<td>
						<table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">

							<tr>
								<td align="center"><strong>
                                    <asp:label id="lblSolicitante" runat="server" 
                                        CssClass="labelData">Solicitante</asp:label></strong>
							    </td>
							</tr>
							<tr>
								<td align="left" style="width:9">
								    <br />
								<asp:label id="lblFirma" runat="server">Firma:</asp:label>								
								    &nbsp; _______________________________________</td>
								
							</tr>
							 
							<tr>	
								<td align="left" style="width:9">
                                    <br />
                                    <asp:label id="lblCedula" runat="server" >Cédula:</asp:label>
								    _______________________________________</td>
								
							</tr>														
						</table>
					</td>
                    
                       
                            <td>
                            
						<table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">

							<tr>
								<td align="center"><strong>
                                    <asp:label id="lblRepresentate" runat="server" 
                                        CssClass="labelData">Representante</asp:label>
							    </td>
							</tr>

							<tr>
								<td align="left" style="width:9">
								    <br />
								<asp:label id="lblFirmaRep" runat="server">Firma:</asp:label>								
								    &nbsp; _______________________________________</td>
								
							</tr>
							 
							<tr>	
								<td align="left" style="width:9">
                                    <br />
                                    <asp:label id="lblCedulaRep" runat="server" >Cédula:</asp:label>
								    _______________________________________</td>
								
							</tr>																
						</table>                            
 
                            </td>
                        </tr>
			</table>	
			
				<br />
		        <br />
		        <br />
				<table cellspacing="0" cellpadding="0" width="520px">
				
				    <tr>
                        <td style="text-align:center">
                            <strong style="text-align: center">NO HAY NADA ESCRITO DEBAJO DE ESTA LINEA</strong>&nbsp;</td>
                    </tr>
				
				</table>			
			</asp:Panel>			
			
				
				
			            </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                    </tr>
				</table>
				
    </form>
</body>
</html>
