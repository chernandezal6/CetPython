<%@ Page Language="VB" AutoEventWireup="false" CodeFile="oficioDoc.aspx.vb" Inherits="Oficios_oficioDoc1" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Documento del Oficio</title>
</head>
<body onload="javascript:print()">
    <form id="form1" runat="server">
    <div>
	    <table style="height: 100%" cellspacing="0" cellpadding="0" width="100%" border="0">
		    <tr>
			    <td valign="top">
				    <table cellspacing="0" cellpadding="0" width="100%" border="0">
					    <tr>
						    <td><img height="60" src="../images/logoTSShorizontal.gif" width="185" alt="" />
						    </td>
						    <td align="right">
							    <div style="text-align: center"></div>
						    </td>
					    </tr>
				    </table>
			    </td>
		    </tr>
		    <tr>
			    <td valign="top" align="center" style="height: 0px">
				    <hr style="width:100%;"/>
				    <br />
				    <span class="header">MEMORANDUM</span><br />
				    <asp:label id="lblEstatus" runat="server" Font-Size="X-Large" Font-Bold="True"></asp:label><br />
				    <hr style="width:100%"/>
			    </td>
		    </tr>
		    <tr>
			    <td valign="top" style="height: 0px">
				    <table cellspacing="0" cellpadding="0" width="100%" border="0">
					    <tr>
						    <td valign="top" style="width:9%; height:31px; font-size:12px"><strong>A:</strong></td>
						    <td valign="top" style="width:91%; font-size:12px"><asp:label id="lblTesorero" runat="server"></asp:label><br />
								    <asp:label id="lblTesoreroPuesto" runat="server"></asp:label></td>
					    </tr>
					    <tr>
						    <td valign="top" colspan="2" style="height:4px"></td>
					    </tr>
					    <tr>
						    <td valign="top" style="font-size:12px"><strong>DE:</strong></td>
						    <td valign="top" style="font-size:12px"><asp:label id="lblUsuario" runat="server"></asp:label><br />
								    <asp:label id="lblDpto" runat="server"></asp:label></td>
					    </tr>
					    <tr>
						    <td valign="top" colspan="2" style="height:4px"></td>
					    </tr>
					    <tr>
						    <td style="HEIGHT: 20px; font-size:12px" valign="top"><strong>ASUNTO:</strong></td>
						    <td style="HEIGHT: 20px; font-size:14px" valign="top"><strong>SOLICITUD DE</strong>
							    <asp:label id="lblAccion" runat="server" Font-Size="Medium" Font-Bold="True"></asp:label>,<strong style="font-size:14px">&nbsp;OFICIO&nbsp;NO.&nbsp;</strong>
							    <asp:label id="lblNoOficio" runat="server" Font-Size="Medium" Font-Bold="True"></asp:label>&nbsp;&nbsp;
						    </td>
					    </tr>
					    <tr>
						    <td valign="top" colspan="2" style="height:4px"></td>
					    </tr>
					    <tr>
						    <td valign="top" style="font-size:12px"><strong>FECHA</strong></td>
						    <td valign="top" style="font-size:12px"><asp:label id="lblFecha" runat="server"></asp:label></td>
					    </tr>
					    <tr>
						    <td valign="top" colspan="2" style="height:4px"></td>
					    </tr>
					    <tr>
						    <td valign="top" style="font-size:12px"><strong>ANEXO</strong></td>
						    <td valign="top" style="font-size:12px">EXPEDIENTE DE SOLICITUD</td>
					    </tr>
				    </table>
				    <hr style="SIZE:1px; width:100%;" />
			    </td>
		    </tr>
		    <tr>
			    <td valign="top" style="height:0px; font-size:12px"><asp:label id="lblTextoAccion" runat="server"></asp:label>
				   <br /><br />Esta solicitud se hace atendiendo que: &nbsp;
						    <asp:label id="lblTextoMotivo" runat="server"></asp:label>
			    </td>
		    </tr>
		    <tr>
			    <td valign="top" style="font-size:12px; height: 81px;"><br />
			        <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
				    <table cellspacing="0" cellpadding="0" width="600" style="text-align:left" border="0">
					    <tr>
						    <td style="font-size:10px; height: 12px;"><b>Notificación de Pago</b></td>
						    <td style="font-size:10px; height: 12px;"><b>Nómina</b></td>
						    <td align="right" style="font-size:10px; height: 12px;"><b>Monto Original (RD$)</b></td>
						    <td align="right" style="font-size:10px; height: 12px;"><b>Recargos (RD$)</b></td>
					    </tr>
					    
					    <asp:datalist id="dlNotificaciones" runat="server" RepeatDirection="Horizontal" RepeatLayout="Flow">
						    <ItemTemplate>
							    <tr>
								    <td>
									    <%# DataBinder.Eval(Container.DataItem,"ID_REFERENCIA") %>
								    </td>
								    <td>
									    &nbsp;<%# DataBinder.Eval(Container.DataItem,"NOMINADES") %></td>
								    <td align="right">
									    <%# formatnumber(DataBinder.Eval(Container.DataItem,"MONTO_ORIGINAL"))%>
								    </td>
								    <td align="right">
									    <%# formatnumber(DataBinder.Eval(Container.DataItem,"RECARGOS")) %>
								    </td>
							    </tr>
						    </ItemTemplate>
					    </asp:datalist></table>
					    </asp:Panel>
                    <br />
			    </td>
		    </tr>
		    <tr>
			    <td style="HEIGHT: 57px">
                    <br />
                    <br />
                    <br />
                    <br />
					    <asp:Label ID="labelRevisadoPor" runat="server">REVISADO POR:</asp:Label>____________________________________________________________________<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Label ID="lblRevisadoPor" runat="server" Font-Names="Tahoma" Font-Size="9pt" Visible="False"></asp:Label><br />
                    <br />
                </td>
		    </tr>
		    <tr>
			    <td valign="top" style="height: 84px">
				    <br /><br />
					    OBSERVACIONES:<br />
                    <br />
                    <asp:Label ID="lblObservaciones" runat="server" Font-Names="Tahoma" Font-Size="9pt"></asp:Label><br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
				   
			    </td>
		    </tr>
		    <tr>
			    <td valign="bottom" style="height: 136px"><asp:Label ID="labelAutorizadoPor" runat="server">AUTORIZADO POR:</asp:Label> 
				    __________________________________________________________________<br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;<asp:Label
                        ID="lblAutorizadoPor" runat="server" Font-Names="Tahoma" Font-Size="9pt"></asp:Label><br />
				    <br />
                    <br />
                    <br />
                    <br />
                    <br />
                    <br />
				    <br />
				    <asp:Label ID="labelProcesadoPor" runat="server">PROCESADO POR:</asp:Label> __________________________________________________________________<span style="font-size:12px"><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <asp:Label ID="lblprocesadoPor" runat="server" Font-Names="Tahoma" Font-Size="9pt" Visible="False"></asp:Label></td>
		    </tr>
		    <tr>
			    <td  align="center"><br />
				    <hr style="width: 100%" />
			    </td>
		    </tr>
		    <tr>
			    <td align="center">
				    <strong>NO HAY NADA ESCRITO DEBAJO DE ESTA LINEA</strong>
			    </td>
		    </tr>
	    </table>    
    </div>
    </form>
</body>
</html>
