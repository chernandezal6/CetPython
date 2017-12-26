<%@ Page Language="VB" AutoEventWireup="false" CodeFile="AnexarDocumento.aspx.vb" Inherits="Consultas_AnexarDocumento" StyleSheetTheme="SP" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >

<head id="Head1" runat="server">
    <title>Actualizar Certificación</title>
</head>

<div class="header">Documentos de la Empresa</div>

<body>
   
    <form id="form1" runat="server">

     <div id="divActualizar" align="center" style="width:434px;"><br />
        <fieldset id="fsActualizarCertificacion" style="width:361px"><br /><br />
            <legend>Actualizar Documento</legend>
		    <table id="Table1" cellSpacing="0" cellPadding="0" border="0" align="center" 
                width="300px">

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
                            <asp:FileUpload ID="fuDocumentos" runat="server" />
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
            <br />

<asp:label id="lblMsgDocumento" runat="server" CssClass="error" ></asp:label>    
        </fieldset>
    </div>

    </form>
</body>
</html>
