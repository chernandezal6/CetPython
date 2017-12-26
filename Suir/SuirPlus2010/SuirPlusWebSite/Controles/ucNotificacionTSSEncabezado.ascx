<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucNotificacionTSSEncabezado.ascx.vb" Inherits="Controles_ucNotificacionTSSEncabezado" %>
<asp:Panel ID="pnlNotificacion" runat="server" Visible="False">
    <table class="td-content" style="width: 412pt">
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Label ID="Label1" runat="server" CssClass="subHeader" Text="Notificación de Pago"></asp:Label><br />
                <br />
            </td>
        </tr>
        <tr>
            <td align="right">Referencia</td>
            <td>
                <asp:Label ID="lblNoReferencia" runat="server" CssClass="labelData"></asp:Label></td> 
          
        </tr>
        <tr>
            <td align="right">Periodo</td>
            <td style="width: 158px">
                <asp:Label ID="lblPeriodo" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">RNC/Cédula</td>
            <td>
                <asp:Label ID="lblRnc" runat="server" CssClass="labelData"></asp:Label></td>
            

        </tr>
        <tr>
            <td align="right">Razón Social</td>
            <td colspan="3">
                <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
             <td align="right">Estatus</td>
            <td style="width: 158px">
                <asp:Label ID="lblEst" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr id="trAviso" visible="false" runat="server">
               <td align="right">Observación</td>
            <td colspan="2">
                 <asp:Label ID="lblPagoBanco" runat="server" CssClass="error"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">Nómina</td>
            <td colspan="3">
                <asp:Label ID="lblNomina" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">Tipo Nómina</td>
            <td colspan="3">
                <asp:Label ID="lblTipoNomina" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">Dirección</td>
            <td colspan="3">
                <asp:Label ID="lblDireccion" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">Municipio</td>
            <td>
                <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">Total de Trabajadores</td>
            <td style="width: 158px">
                <asp:Label ID="lblTotalTrabajadores" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">Fecha de Emisión</td>
            <td>
                <asp:Label ID="lblFechaEmision" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">Fecha Límite de Pago</td>
            <td style="width: 158px">
                <asp:Label ID="lblFechaLimitePago" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">Teléfono(s)</td>
            <td>
                <asp:Label ID="lblTelefono" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">Origen de Pago</td>
            <td style="width: 158px">
                <asp:Label ID="lblOrigenPago" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">Tipo de Notificación</td>
            <td>
                <asp:Label ID="lblTipo" runat="server" CssClass="labelData"></asp:Label>
            </td>
            <td align="right">Número de Oficio</td>
            <td style="width: 158px">
                <asp:Label ID="lblNumOficio" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td colspan="4" style="height: 6px"></td>
        </tr>
        <tr>
            <td colspan="4" align="center" style="height: 16px">
                <asp:HyperLink ID="hlnkDetalle" runat="server"><img src="../images/detalle.gif" style="border:0px" alt="" />&nbsp;Detalle Empleados</asp:HyperLink>&nbsp;&nbsp;
            <asp:HyperLink ID="hlnkDetalleAjuste" runat="server"><img src="../images/detalle.gif" style="border:0px" alt="" />&nbsp;Detalle Ajuste</asp:HyperLink>&nbsp;&nbsp;
				<asp:HyperLink ID="hlnkDependiente" runat="server"><img src="../images/detalle.gif" style="border:0px" alt="" />&nbsp;Dependientes Adicionales</asp:HyperLink>&nbsp;
                <asp:HyperLink ID="hlnkPagosARS" runat="server"><img src="../images/detalle.gif" style="border:0px" alt="" />&nbsp;Pagos ARS</asp:HyperLink>
                &nbsp;
				<asp:HyperLink ID="hlnkImprimir" runat="server" Target="_blank"><img src="../images/printv.gif" style="border:0px" alt="" />&nbsp;Imprimir Notificación</asp:HyperLink>
            </td>
        </tr>
    </table>
    <asp:Panel ID="pnlEstatus" runat="server" Visible="false" Width="550">
        <asp:Label ID="lblEstatus" runat="server" CssClass="label-Resaltado"></asp:Label>
    </asp:Panel>
    <asp:Panel ID="pnlOficio" runat="server" Visible="false" Width="550">
        <asp:Label ID="lblMotivo" Text="Motivo Oficio" CssClass="listItem" runat="server"></asp:Label><br />
        <asp:Label ID="lblMotivoOficio" runat="server" CssClass="labelData"></asp:Label>
    </asp:Panel>
    <br />
    <table class="tableLineasFinas" style="border-color: #4882ca" cellspacing="0" cellpadding="0" border="1" id="tblRenglones" width="550pt">
        <tr>
            <td colspan="2" class="listHeader">&nbsp;Totales
            </td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%">&nbsp;Retención a Trabajadores SFS
            </td>
            <td align="right">
                <asp:Label ID="lblRetTrabSFS" runat="server"></asp:Label>
            </td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%; height: 13px;">&nbsp;Contribución del Empleador SFS
            </td>
            <td align="right" style="height: 13px">
                <asp:Label ID="lblContrEmplSFS" runat="server"></asp:Label>
            </td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%; height: 13px;">&nbsp;Pagos Per Cápita adicional
            </td>
            <td align="right" style="height: 13px">
                <asp:Label ID="lblPagoPerCapitaAdic" runat="server"></asp:Label>
            </td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%">&nbsp;Intereses SFS
            </td>
            <td align="right">
                <asp:Label ID="lblInteresSFS" runat="server"></asp:Label>
            </td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%">&nbsp;Recargos SFS
            </td>
            <td align="right">
                <asp:Label ID="lblRecargoSFS" runat="server"></asp:Label>
            </td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%">&nbsp;Retención a Trabajadores Pensión (SVDS)
            </td>
            <td align="right">
                <asp:Label ID="lblRetTrabPension" runat="server"></asp:Label>
            </td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%">&nbsp;Contribución del Empleador Pensión (SVDS)
            </td>
            <td align="right">
                <asp:Label ID="lblContEmplPension" runat="server"></asp:Label></td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%">&nbsp;Aportes Voluntarios Ordinarios</td>
            <td align="right">
                <asp:Label ID="lblAportesVoluntariosOrd" runat="server"></asp:Label></td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%">&nbsp;Intereses Pensión (SVDS)</td>
            <td align="right">
                <asp:Label ID="lblInteresPension" runat="server"></asp:Label></td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%">&nbsp;Recargos Pensión (SVDS)</td>
            <td align="right">
                <asp:Label ID="lblRecargoPension" runat="server"></asp:Label></td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%">&nbsp;Seguro de Riesgos Laborales (SRL)</td>
            <td align="right">
                <asp:Label ID="lblSRL" runat="server"></asp:Label></td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%">&nbsp;Intereses Seguro de Riesgo Laborales (SRL)</td>
            <td align="right">
                <asp:Label ID="lblInteresSRL" runat="server"></asp:Label></td>
        </tr>
        <tr class="listItem">
            <td style="width: 65%">&nbsp;Recargos Seguro de Riesgo Laborales (SRL)</td>
            <td align="right">
                <asp:Label ID="lblRecargosSRL" runat="server"></asp:Label></td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%;">&nbsp;Monto Ajuste</td>
            <td align="right">
                <asp:Label ID="lblSubsidios" runat="server"></asp:Label>
            </td>
        </tr>
        <tr class="listAltItem">
            <td style="width: 65%; font-weight: bold">&nbsp;Total Aportes a Pagar</td>
            <td align="right">
                <asp:Label ID="lblTotalGral" runat="server" Font-Bold="true"></asp:Label>
            </td>
        </tr>
    </table>
</asp:Panel>
&nbsp;<br />
<asp:Panel ID="pnlError" runat="server" Visible="False" Width="550">
    <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
</asp:Panel>
