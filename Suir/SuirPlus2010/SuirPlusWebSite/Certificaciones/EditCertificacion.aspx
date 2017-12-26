<%@ Page Language="VB" AutoEventWireup="false" CodeFile="EditCertificacion.aspx.vb" Inherits="Certificaciones_EditCertificacion" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >

<head runat="server">
    <title>Actualizar Certificación</title>
</head>

<div class="header">Actualizar Certificación # 
    <asp:label id="lblIdCert" runat="server"></asp:label>
    <br />
</div>


<body>
   
    <form id="form1" runat="server">

     <div id="divActualizar" align="center" runat="server"><br />
        <fieldset id="fsActualizarCertificacion" style="width:auto"><br /><br />
            <legend>Actualizar Certificación</legend>
		    <TABLE id="Table1" cellSpacing="0" cellPadding="0" border="0" align="center" 
                width="70%">

					<TR align="left" valign="top">
						<TD align="right" valign="top"><strong>Firmas Actual:</strong></TD>					
					    <td valign="top">
                            &nbsp;
                            <asp:Label ID="lblFirmaActual" runat="server" CssClass="labelData"></asp:Label>
                            <br />
                        </td>
					</TR>
									
					<TR align="left" valign="top">
						<TD align="right" valign="middle"><strong>Nueva Firma:</strong></TD>					
					    <td valign="middle">
                            &nbsp;
                            <asp:DropDownList ID="dlFirmaResponsable" runat="server">
                            </asp:DropDownList>
                        &nbsp;</td>
					</TR>
									
					<TR align="left" valign="top">
						<TD align="right" valign="middle">&nbsp;</TD>					
					    <td valign="middle">
                            &nbsp;</td>
					</TR>
									
                    <tr align="left" valign="top">
                        <td align="right" nowrap="nowrap">
                            <strong>Cargar Documentos:</strong></td>
                        <td>
                            &nbsp;
                            <asp:FileUpload ID="flCargarImagenCert" runat="server" />
                            </td>
                    </tr>
                    <tr align="left" valign="top">
                        <td align="right" nowrap="nowrap">
                            &nbsp;</td>
                        <td >
                            &nbsp;</td>
                    </tr>
									
                    <tr align="left" valign="top">
                        <td align="right" nowrap="nowrap">
                            &nbsp;</td>
                        <td >
                            &nbsp;</td>
                    </tr>
									
				    <tr>
                        <td align="center" colspan="2">
                            <asp:Button ID="btnGuardar" runat="server" Text="Guardar Cambios" />
                            &nbsp;
                        </td>
                    </tr>
									
				</TABLE>
        </fieldset>
    </div>

<asp:label id="lblMsg" runat="server" visible="False" CssClass="error" ></asp:label>    
    </form>
</body>
</html>
