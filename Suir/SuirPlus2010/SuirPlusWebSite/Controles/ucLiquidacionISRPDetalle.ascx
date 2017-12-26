<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucLiquidacionISRPDetalle.ascx.vb" Inherits="Controles_ucLiquidacionISRPDetalle" %>
<%@ Register Src="ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>
<table cellpadding="0" cellspacing="0" style="width:950px;">
    <tr>
        <td>
            <asp:Label ID="Label1" runat="server" CssClass="subHeader">Detalle de la pre-liquidación de ISR</asp:Label><br/>
            <asp:Label ID="lblTituloPeriodo" runat="server" CssClass="subheader">Correspondiente al Periodo : </asp:Label><asp:Label
                ID="lblPeriodo" runat="server" CssClass="subHeaderContrast"></asp:Label><br /><br />
        </td>
    </tr>
    <tr>
        <td>
            <div style="height:5px"></div>
            <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label></td>
    </tr>
    <tr>
        <td>
            <asp:GridView ID="gvDetalle" runat="server" autogeneratecolumns="False">
                <Columns>
					<asp:BoundField DataField="no_documento" HeaderText="Documento"></asp:BoundField>
					<asp:BoundField DataField="Nombre" HeaderText="Nombre"></asp:BoundField>
					<asp:BoundField DataField="salario_isr" HeaderText="Salario" HtmlEncode="false" DataFormatString="{0:n}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="otros_ingresos_isr" HeaderText="O.I." HtmlEncode="false" DataFormatString="{0:n}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="INGRESOS_EXENTOS_ISR" HeaderText="I.E." HtmlEncode="false" DataFormatString="{0:n}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="remuneracion_isr_otros" HeaderText="R.O.A." HtmlEncode="false" DataFormatString="{0:n}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="TOTAL_PAGADO" HeaderText="T.P." HtmlEncode="false" DataFormatString="{0:n}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="RETENCION_SS" HeaderText="R.S.S." HtmlEncode="false" DataFormatString="{0:n}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="total_sujeto_retencion" HeaderText="T.S.R." HtmlEncode="false" DataFormatString="{0:n}">
						<ItemStyle HorizontalAlign="Right"></ItemStyle>
					</asp:BoundField>
					<asp:BoundField DataField="saldo_favor_del_periodo" HeaderText="S.F.P." HtmlEncode="false" DataFormatString="{0:n}">
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
        <td>
            Total de empleados
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
        </td>
    </tr>
</table>
<div style="height:10px;"></div>
<table id="Table1" border="0" cellpadding="1" cellspacing="1">    
    <tr>
        <td>
            <table id="tblLeyenda" border="0" cellpadding="1" cellspacing="1" class="td-note"
                width="300">
                <tr>
                    <td colspan="2">
                        <div class="centered"><span class="LabelDataGreen">Leyenda</span></div>
                    </td>
                </tr>
                <tr>
                    <td>
                        O.I.</td>
                    <td>
                        Otros Ingresos</td>
                </tr>
                <tr>
                    <td>
                        I.E.</td>
                    <td>
                        Ingresos Exentos</td>
                </tr>
                <tr>
                    <td>
                        R.O.A.</td>
                    <td>
                        Remuneraciones de Otros Agentes</td>
                </tr>
                <tr>
                    <td>
                        T.P</td>
                    <td>
                        Total Pagado</td>
                </tr>
                <tr>
                    <td>
                        R.S.S</td>
                    <td>
                        Retención Seguridad Social</td>
                </tr>
                <tr>
                    <td>
                        T.S.R</td>
                    <td>
                        Total Sujeto a Retención</td>
                </tr>
                <tr>
                    <td>
                        S.F.P.</td>
                    <td>
                        Saldo a Favor del Periodo</td>
                </tr>
                </table>
        </td>
        <td>
            <img border="0" src="../images/detalle.gif">&nbsp;<a href="javascript:history.back()">Encabezado</a>
            <br>
            <uc1:ucexportarexcel id="ucExpExcel" runat="server"></uc1:ucexportarexcel>
            </td>
    </tr>
</table>
