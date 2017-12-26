<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucMensajeArchivo.ascx.vb" Inherits="Controles_ucMensajeArchivo" %>

<asp:Panel ID="pnlEstatus" runat="server" Visible="false" Width="450px">        
            <table id="Table3" cellspacing="0" class="tblWithImagen" style="width: 460px;">
                <tr>
                    <td class="HeaderPopup" colspan="2">
                        Estatus de Envio
                    </td>                  
                </tr>               
                <tr>
                    <td style="width: 15%;">
                        &nbsp;<img alt="status.jpg" height="55" src="../images/status_files.jpg" width="82" /></td>
                    <td>
                        <table id="table2" border="0" cellpadding="0" cellspacing="0">
                            <tr>
                                <td align="right" class="style1">
                                    &nbsp;<span>Archivo:</span></td>
                                <td>
                                    <asp:Label ID="lblNombreArchivo" runat="server" CssClass="subHeader"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" class="style1">
                                    No. Envío:
                                </td>
                                <td>
                                    &nbsp;<asp:Label ID="lblNumeroArchivo" runat="server" CssClass="subHeader"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" class="style1">
                                    &nbsp;<span>Fecha Carga:</span></td>
                                <td>
                                    &nbsp;<asp:Label ID="lblFechaCarga" runat="server" CssClass="subHeader"></asp:Label></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        Nota: Verifique los resultados de su envío en 5 minutos.</td>
                </tr>
                <tr>
                    <td colspan="2" style="text-align: center">
                        <asp:LinkButton ID="lnkBtnCerrar" runat="server"><img alt="cancel" height="12" onclientclick="Cerrar()" 
                            src="../images/cancel.gif" />&nbsp;Cerrar Ventana</asp:LinkButton>
                    </td>
                </tr>
            </table>                        
    </asp:Panel> 