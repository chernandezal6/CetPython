<%@ Page Language="VB" AutoEventWireup="false" CodeFile="popupEstatusArchivos.aspx.vb" Inherits="Empleador_popupEstatusArchivos" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Estatus de Archivo</title>
</head>
<body>
    <form id="form1" runat="server">
        <div style="padding-left:5px;">
        <table id="Table3" cellspacing="0" style="width: 485px;" class="td-note">
            <tr>
                <td class="subHeader" colspan="3">
                    &nbsp;</td>
            </tr>
            <tr>
                <td class="header" colspan="3">
                    Estatus envío de archivo
                    <hr/>
                </td>
            </tr>
            <tr>
                <td colspan="3">
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td width="15%">
                    &nbsp;<img height="55" src="../images/status_files.jpg" width="82"></td>
                <td colspan="2">
                    <table id="table2" border="0" cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td align="right" width="30%">
                                Número de Envío:
                            </td>
                            <td>
                                <asp:Label ID="lblNumeroArchivo" runat="server"  CssClass="subHeader"></asp:Label></td>
                        </tr>
                        <tr>
                            <td width="30%" align="right">
                                &nbsp;<span>Nombre del Archivo:</span></td>
                            <td>
                                &nbsp;<asp:Label ID="lblNombreArchivo" runat="server" CssClass="subHeader"></asp:Label></td>
                        </tr>
                        <tr>
                            <td width="30%" align="right">
                                &nbsp;<span>Fecha de Carga:</span></td>
                            <td>
                                &nbsp;<asp:Label ID="lblFechaCarga" runat="server" CssClass="subHeader"></asp:Label></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td width="277">
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
                <td>
                    &nbsp;</td>
            </tr>
            <tr>
                <td colspan="3">
                    &nbsp;Nota: en&nbsp;15 minutos recibirá un correo electrónico con el estatus de
                    la operación.</td>
            </tr>
        </table>
        <br>
        <table id="Table4" border="0" cellpadding="0" cellspacing="0" class="td-content"  width="485">
            <tr>
                <td>
                        <img height="12" onclick="javascript:window.print();" src="../images/printv.gif" style="cursor: pointer" width="15" alt="print" />
                        <span onclick="javascript:window.print();" style="cursor: pointer">Imprimir página</span>
                </td>
                <td>
                       <img height="12" onclick="javascript:window.close();" src="../images/cancel.gif"
                            style="cursor: pointer" width="13" alt="cancel" />
                        <span onclick="javascript:window.close();" style="cursor: pointer">cerrar ventana</span>
                </td>
            </tr>
        </table>
        </div>
    </form>
</body>
</html>
