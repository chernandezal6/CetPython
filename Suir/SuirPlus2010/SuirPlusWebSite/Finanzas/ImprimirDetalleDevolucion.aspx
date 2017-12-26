<%@ Page Title="Imprimir Detalle Devolución" Language="VB" AutoEventWireup="false"
    CodeFile="ImprimirDetalleDevolucion.aspx.vb" Inherits="Finanzas_ImprimirDetalleDevolucion" %>

<html>
<head id="Head1" runat="server">
</head>
<body onload="javascript:print();">
    <form runat="server" id="form1">
    <!--Encabezado de la devolución-->
    <table cellspacing="0" cellpadding="0" width="100%" border="0">
        <tr>
            <td style="text-align: center">
                <asp:Label ID="lblEslogan" Font-Bold="True" Font-Size="Medium" runat="Server">Detalle Devolución de Aportes</asp:Label>
                <br />
                <br />
                <a style="text-decoration: none; font-size: small" onclick="javascript:print()" href="#">
                    Reclamación No. <strong>
                        <asp:Label ID="lblNroRelamacion" runat="server"></asp:Label></strong></a>
                <br />
                <br />
                <br />
                <asp:Label ID="lblmsg" runat="server" CssClass="error" Visible="False"></asp:Label>
                <br />
            </td>
        </tr>
    </table>
    <br />
    <div id="divInfoEncabezado">
        <table>
            <tr>
                <td style="text-align: right; font-size: 12px">
                    Nro. Reclamación:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblreclamacion" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td style="text-align: right; font-size: 12px">
                    Estatus Devolución:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblEstatus" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right; font-size: 12px">
                    RNC:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblRnc" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td style="text-align: right; font-size: 12px">
                    Razón Social:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right; font-size: 12px">
                    Nro. Cheque:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblNroCheque" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td style="text-align: right; font-size: 12px">
                    Entregado Por:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblEntregadoPorEncabezado" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
            </tr>
            <tr>
                <td style="text-align: right; font-size: 12px">
                    Nro. Documento:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblNroDocumento" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
                <td>
                </td>
                <td>
                </td>
                <td style="text-align: right; font-size: 12px">
                    Nombre Completo:
                </td>
                <td style="text-align: left">
                    <asp:Label ID="lblNombreCompleto" runat="server" CssClass="labelData" Font-Size="12px"></asp:Label>
                </td>
            </tr>
        </table>
    </div>
    <br />
    <div>
        <asp:Label ID="Label1" Font-Size="Medium" runat="Server">Aprobados</asp:Label></div>
    <div>
        <asp:Label ID="lblErrMsgA" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
    </div>
    <div id="divAprobados" runat="server">
        <table cellspacing="0" cellpadding="0" width="100%" border="1">
            <tr style="background-color: #f6f6f6">
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Referencia
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Trabajador
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Salario
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Monto Solicitado
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Total a Devolver
                </td>
            </tr>
            <asp:DataList ID="dlDetDevolucionesA" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                ShowFooter="true">
                <ItemTemplate>
                    <tr style="background-color: #e2edf5">
                        <td style="text-align: center">
                            <%# Eval("ID_REFERENCIA")%>
                        </td>
                        <td style="text-align: left">
                            <%# Eval("Trabajador")%>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblSalarioA" runat="server" Text='<%# FormatCurrency(Eval("SALARIO"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblMontoSolicitadoA" runat="server" Text='<%# FormatCurrency(Eval("MONTO_DEVOLUCION"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalDevolverA" runat="server" Text='<%# FormatCurrency(Eval("Total_Devolver"))%>'></asp:Label>
                        </td>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr style="background-color: #f6f6f6">
                        <td style="text-align: center">
                            <%# Eval("ID_REFERENCIA")%>
                        </td>
                        <td style="text-align: left">
                            <%# Eval("Trabajador")%>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblSalarioA" runat="server" Text='<%# FormatCurrency(Eval("SALARIO"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblMontoSolicitadoA" runat="server" Text='<%# FormatCurrency(Eval("MONTO_DEVOLUCION"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalDevolverA" runat="server" Text='<%# FormatCurrency(Eval("Total_Devolver"))%>'></asp:Label>
                        </td>
                    </tr>
                </AlternatingItemTemplate>
                <FooterStyle Font-Bold="true" />
                <FooterTemplate>
                    <tr style="background-color: #f6f6f6">
                        <td>
                            &nbsp;
                        </td>
                        <%--<td>&nbsp;</td>
                        <td>&nbsp;</td>--%>
                        <td style="text-align: right">
                            Totales:
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalSalarioA" runat="server"></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalMontoSolicitadoA" runat="server"></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalMontoDevolverA" runat="server"></asp:Label>
                        </td>
                    </tr>
                </FooterTemplate>
            </asp:DataList>
        </table>
    </div>
    <br />
    <div>
        <asp:Label ID="Label2" Font-Size="Medium" runat="Server">Rechazados</asp:Label></div>
    <div>
        <asp:Label ID="lblErrMsgR" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
    </div>
    <div id="divRechazados" runat="server">
        <table cellspacing="0" cellpadding="0" width="100%" border="1">
            <tr style="background-color: #f6f6f6">
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Referencia
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Trabajador
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Motivo Rechazo
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Salario
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Monto Solicitado
                </td>
                <%--                <td style="font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma; text-align:center">
                    Aporte Voluntario
                </td>--%>
            </tr>
            <asp:DataList ID="dlDetDevolucionesR" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                ShowFooter="true">
                <ItemTemplate>
                    <tr style="background-color: #e2edf5">
                        <td style="text-align: center">
                            <%# Eval("ID_REFERENCIA")%>
                        </td>
                        <td style="text-align: left">
                            <%# Eval("Trabajador")%>
                        </td>
                        <td style="text-align: left">
                            <asp:Label ID="lblMotivoRechazo" runat="server" Text='<%# Eval("Motivo_rechazo")%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblSalarioR" runat="server" Text='<%# FormatCurrency(Eval("SALARIO"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblMontoDevolucionR" runat="server" Text='<%# FormatCurrency(Eval("MONTO_DEVOLUCION"))%>'></asp:Label>
                        </td>
                        <%--                        <td style="text-align:right"><asp:Label ID="lblAporteVoluntarioR" runat="server" Text='<%# FormatCurrency(Eval("APORTE_VOLUNTARIO"))%>'></asp:Label>
                        </td>--%>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr style="background-color: #f6f6f6">
                        <td style="text-align: center">
                            <%# Eval("ID_REFERENCIA")%>
                        </td>
                        <td style="text-align: left">
                            <%# Eval("Trabajador")%>
                        </td>
                        <td style="text-align: left">
                            <asp:Label ID="lblMotivoRechazo" runat="server" Text='<%# Eval("Motivo_rechazo")%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblSalarioR" runat="server" Text='<%# FormatCurrency(Eval("SALARIO"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblMontoDevolucionR" runat="server" Text='<%# FormatCurrency(Eval("MONTO_DEVOLUCION"))%>'></asp:Label>
                        </td>
                        <%--                        <td style="text-align:right"><asp:Label ID="lblAporteVoluntarioR" runat="server" Text='<%# FormatCurrency(Eval("APORTE_VOLUNTARIO"))%>'></asp:Label>
                        </td>--%>
                    </tr>
                </AlternatingItemTemplate>
                <FooterStyle Font-Bold="true" />
                <FooterTemplate>
                    <tr style="background-color: #f6f6f6">
                        <td>
                            &nbsp;
                        </td>
                        <%--<td>&nbsp;</td>
                        <td>&nbsp;</td>--%>
                        <td>
                            &nbsp;
                        </td>
                        <td style="text-align: right">
                            Totales:
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalSalarioR" runat="server"></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalMontoDevolucionR" runat="server"></asp:Label>
                        </td>
                        <%--                        <td style="text-align:right"><asp:Label ID="lblTotalAporteVoluntarioR" runat="server"></asp:Label>
                        </td>--%>
                    </tr>
                </FooterTemplate>
            </asp:DataList>
        </table>
    </div>
    <br />
    <div>
        <asp:Label ID="Label3" Font-Size="Medium" runat="Server">Generados</asp:Label></div>
    <div>
        <asp:Label ID="lblErrMsgG" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
    </div>
    <div id="divGenerados" runat="server">
        <table cellspacing="0" cellpadding="0" width="100%" border="1">
            <tr style="background-color: #f6f6f6">
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Referencia
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Trabajador
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Salario
                </td>
                <td style="font-weight: bold; font-size: 7pt; font-family: Tahoma; text-align: center">
                    Monto Solicitado
                </td>
                <%--                <td style="font-weight: bold; font-size: 7pt; color: #ffffff; font-family: Tahoma; text-align:center">
                    Aporte Voluntario
                </td>--%>
            </tr>
            <asp:DataList ID="dlDetDevolucionesG" runat="server" RepeatLayout="Flow" RepeatDirection="Horizontal"
                ShowFooter="true">
                <ItemTemplate>
                    <tr style="background-color: #e2edf5">
                        <td align="center">
                            <%# Eval("ID_REFERENCIA")%>
                        </td>
                        <td>
                            <%# Eval("Trabajador")%>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblSalarioG" runat="server" Text='<%# FormatCurrency(Eval("SALARIO"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblMontoDevolucionG" runat="server" Text='<%# FormatCurrency(Eval("MONTO_DEVOLUCION"))%>'></asp:Label>
                        </td>
                        <%--                        <td><asp:Label ID="lblAporteVoluntarioG" runat="server" Text='<%# FormatCurrency(Eval("APORTE_VOLUNTARIO"))%>'></asp:Label>
                        </td>--%>
                    </tr>
                </ItemTemplate>
                <AlternatingItemTemplate>
                    <tr style="background-color: #f6f6f6">
                        <td align="center">
                            <%# Eval("ID_REFERENCIA")%>
                        </td>
                        <td>
                            <%# Eval("Trabajador")%>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblSalarioG" runat="server" Text='<%# FormatCurrency(Eval("SALARIO"))%>'></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblMontoDevolucionG" runat="server" Text='<%# FormatCurrency(Eval("MONTO_DEVOLUCION"))%>'></asp:Label>
                        </td>
                        <%--                        <td style="text-align:right"><asp:Label ID="lblAporteVoluntarioG" runat="server" Text='<%# FormatCurrency(Eval("APORTE_VOLUNTARIO"))%>'></asp:Label>
                        </td>--%>
                    </tr>
                </AlternatingItemTemplate>
                <FooterStyle Font-Bold="true" />
                <FooterTemplate>
                    <tr style="background-color: #f6f6f6">
                        <td>
                            &nbsp;
                        </td>
                        <%--<td>&nbsp;</td>
                        <td>&nbsp;</td>--%>
                        <td style="text-align: right">
                            Totales:
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalSalarioG" runat="server"></asp:Label>
                        </td>
                        <td style="text-align: right">
                            <asp:Label ID="lblTotalMontoDevolucionG" runat="server"></asp:Label>
                        </td>
                        <%--                        <td style="text-align:right"><asp:Label ID="lblTotalAporteVoluntarioG" runat="server"></asp:Label>
                        </td>--%>
                    </tr>
                </FooterTemplate>
            </asp:DataList>
        </table>
    </div>
    <br />
    <div>
        <table border="0" cellpadding="0" cellspacing="0" style="width: 850px; font-size: 11px;">
            <tr>
                <td style="text-align: center">
                    <br />
                    <br />
                    <br />
                    ______________________________________________<br />
                    <asp:Label ID="lblTextoEntrega" runat="server" Font-Bold="True">Entregado Por:</asp:Label><br />
                    <asp:Label ID="lblEntregadoPor" runat="server" Font-Bold="True"></asp:Label><br />
                    <asp:Label ID="lblTSS" runat="server" Font-Bold="True">Tesorería de la Seguridad Social</asp:Label>
                    <br />
                    <br />
                </td>
                <td style="text-align: center">
                    <br />
                    <br />
                    ______________________________________________<br />
                    <asp:Label ID="lblTextoRecibe" runat="server" Font-Bold="True">Recibido Por:</asp:Label><br />
                    <asp:Label ID="lblRecibidoPor" runat="server" Font-Bold="True"></asp:Label><br />
                    <asp:Label ID="lblDocumentoTrabajador" runat="server" Font-Bold="True"></asp:Label>
                    <br />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
</html>
