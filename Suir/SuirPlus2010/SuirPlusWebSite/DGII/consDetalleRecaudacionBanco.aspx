<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDetalleRecaudacionBanco.aspx.vb" Inherits="DGII_consDetalleRecaudacionBanco" title="Consulta Detalle Recaudación por Banco" %>
<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header" align="left">Detalle Recaudación por Banco</div><br />

			<TABLE class="td-content" id="Table1" cellSpacing="1" cellPadding="1" border="0" style="width: 333px">
				<TR>
					<TD colspan="4" valign="top">
                        <asp:label id="lblBanco" runat="server">Banco:</asp:label>
                        <asp:label id="lbltxtBanco" runat="server" Font-Bold="True" Width="88%" Font-Underline="True"></asp:label></TD>
				</TR>
                <tr>
                    <td align="right">
                    </td>
                    <td colspan="3">
                    </td>
                </tr>
				<TR>
					<TD align="center">
                        &nbsp;<asp:label id="lblDesde" runat="server" Font-Underline="True">Desde</asp:label></TD>
					<TD align="center">
                        <asp:label id="lblHasta" runat="server" Font-Underline="True">Hasta</asp:label></TD>
                    <td align="center">
						<asp:label id="lblPagos" runat="server" Font-Underline="True">Pagos</asp:label></td>
                    <td align="center">
                        <asp:label id="lblAclaracion" runat="server" Font-Underline="True">Aclaraciones</asp:label></td>
				</TR>
                <tr>
                    <td align="center">
                        &nbsp;<asp:label id="lbltxtDesde" runat="server" Font-Bold="True"></asp:label></td>
                    <td align="center">
                        &nbsp;
                        <asp:label id="lbltxtHasta" runat="server" Font-Bold="True"></asp:label></td>
                    <td align="center">
                        &nbsp;
                        <asp:label id="lbltxtPagos" runat="server" Font-Bold="True"></asp:label></td>
                    <td align="center">
                        <asp:label id="lbltxtAclaracion" runat="server" Font-Bold="True"></asp:label></td>
                </tr>
			</TABLE>
			<TABLE id="tblDetalle" cellSpacing="1" cellPadding="1" border="0" width="550">
				<TR>
					<TD colSpan="3" style="width: 456px" align="right">
					<asp:GridView id="gvDetalle" runat="server" AutoGenerateColumns="False" Width="100%" CellPadding="3">
							
							<Columns>
								<asp:Boundfield DataField="ID_REFERENCIA_ISR" HeaderText="No. Liquidaci&#243;n">
                                    <ItemStyle HorizontalAlign="Center" />
                                    <HeaderStyle Wrap="False" />
                                </asp:Boundfield>
								<asp:Boundfield DataField="razon_social" HeaderText="Raz&#243;n social">
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    <HeaderStyle Wrap="False" />
                                </asp:Boundfield>
								<asp:Boundfield DataField="total_importe" HeaderText="Importe" DataFormatString="{0:c}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="total_recargo" HeaderText="Recargos" DataFormatString="{0:c}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="total_intereses" HeaderText="Intereses" DataFormatString="{0:c}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="sub_total" HeaderText="Total" DataFormatString="{0:c}" HtmlEncode="False">
									<ItemStyle HorizontalAlign="Right"></ItemStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="STATUS" HeaderText="Tipo">
									<ItemStyle HorizontalAlign="Center"></ItemStyle>
								</asp:Boundfield>
							</Columns>
                        <HeaderStyle Wrap="True" />
							
						</asp:GridView>
                        <br />
                        <uc1:ucexportarexcel id="ucExpExcel" runat="server"></uc1:ucexportarexcel></TD>
				</TR>
			</TABLE>

</asp:Content>

