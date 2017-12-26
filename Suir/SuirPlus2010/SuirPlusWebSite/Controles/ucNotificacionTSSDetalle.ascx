<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucNotificacionTSSDetalle.ascx.vb" Inherits="Controles_ucNotificacionTSSDetalle" %>
<%@ Register Src="ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>

<table id="Table3" cellpadding="0" cellspacing="0" style="width: 90%">
    <tr>
        <td style="height: 48px">
            <div class="header2">
                Detalle Notificación Seguridad Social Nro.
                <asp:Label ID="lblNoReferencia" runat="server" CssClass="subHeaderContrast"></asp:Label></div>
            <div class="header2">
                Total de la Notificación:
                <asp:Label ID="lblTotalFactura" runat="server" CssClass="subHeaderContrast"></asp:Label></div>
            <div class="header2">
                Periodo de la Notificación:
                <asp:Label ID="lblPeriodoFactura" runat="server" CssClass="subHeaderContrast"></asp:Label></div><br />
                <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <asp:GridView ID="gvDetalle" runat="server" EnableViewState="False" AutoGenerateColumns="False" Width="100%">
				<Columns>
					<asp:BoundField DataField="no_documento" HeaderText="C&#233;dula"></asp:BoundField>
					<asp:BoundField DataField="id_nss" HeaderText="NSS"></asp:BoundField>
					<asp:BoundField DataField="nombres" HeaderText="Nombre"></asp:BoundField>
					<asp:BoundField Visible="False" DataField="periodo_aplicacion" HeaderText="Per&#237;odo"></asp:BoundField>
					<asp:BoundField DataField="salario_ss" HeaderText="Salario" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="salario_ss_reportado" DataFormatString="{0:n}" 
                        HeaderText="Salario Reportado" HtmlEncode="False">
                    <HeaderStyle Wrap="False" />
                    <ItemStyle HorizontalAlign="Right" Width="100px" />
                    </asp:BoundField>
					<asp:BoundField DataField="aporte_afiliados_sfs" HeaderText="R.S.F.S" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="aporte_empleador_sfs" HeaderText="C.S.F.S" DataFormatString="{0:n}" HtmlEncode="false" >
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="aporte_afiliados_svds" HeaderText="R.P" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="aporte_empleador_svds" HeaderText="C.P" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="aporte_srl" HeaderText="S.R.L" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="aporte_voluntario" HeaderText="A.V" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="per_capita_adicional" HeaderText="P.C.A" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="total_intereses_recargos" HeaderText="I.R" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="monto_ajuste" HeaderText="C.R." DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>					
					<asp:BoundField DataField="total_general_det_factura" HeaderText="Total" DataFormatString="{0:n}" HtmlEncode="false">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
				</Columns>
				   
            </asp:GridView>
        </td>
    </tr>
    <tr>
        <td>
            <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
            <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
            [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
            <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
            <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
            <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
            <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label></td>
    </tr>
    <tr>
        <td style="height: 12px">
            Total de Empleados
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
        </td>
    </tr>
</table>
<div style="height:15px;"></div>
<table cellpadding="0" cellspacing="0" style="width:550px;">
<tr>
    <td style="width:70%;">
        <table id="Table2" cellpadding="0" cellspacing="0" class="td-note" style="width:100%;">
            <tr>
                <td>
                    <div class="centered"><span class="LabelDataGreen">Leyenda</span></div>
                </td>
            </tr>
            <tr>
                <td>
                    <table cellpadding="0" cellspacing="0" width="100%">
                        <tr>
                            <td width="20%">
                                R.S.F.S</td>
                            <td>
                                Retención Seguro Familiar de Salud.</td>
                        </tr>
                        <tr>
                            <td width="20%">
                                C.S.F.S</td>
                            <td>
                                Contribución Seguro Familiar de Salud.</td>
                        </tr>
                        <tr>
                            <td width="20%">
                                R.P</td>
                            <td>
                                Retención Pensión.</td>
                        </tr>
                        <tr>
                            <td width="20%">
                                C.P</td>
                            <td>
                                Contribución Pensión.</td>
                        </tr>
                        <tr>
                            <td width="20%">
                                S.R.L</td>
                            <td>
                                Seguro de Riesgo Laboral.</td>
                        </tr>
                        <tr>
                            <td width="20%">
                                A.V</td>
                            <td>
                                Aporte Voluntarios.</td>
                        </tr>
                        <tr>
                            <td width="20%">
                                P.C.A</td>
                            <td>
                                Per Cápita Adicional.</td>
                        </tr>
                        <tr>
                            <td width="20%">
                                I.R</td>
                            <td>
                                Intereses y Recargos.</td>
                        </tr>
                      <tr>
                            <td width="20%">
                                C.R</td>
                            <td>
                                Crédito.</td>
                        </tr>                        
                        <tr>
                            <td width="20%">
                                Total</td>
                            <td>
                                Total General.</td>
                        </tr>
                        <tr>
                            <td>
                            </td>
                            <td>
                            </td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </td>
    <td>
        <div style="height:5px;">
            <img alt="detalle.gif" border="0" src="../images/detalle.gif">&nbsp;<a href="javascript:history.back()">Encabezado</a>
        </div>
        <div style="height: 5px;">
            <br />
            <uc1:ucExportarExcel ID="UcExp" runat="server" />
        </div>     
    </td>
</tr>
</table>
