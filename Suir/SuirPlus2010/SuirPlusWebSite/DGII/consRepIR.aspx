<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>
<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consRepIR.aspx.vb" Inherits="DGII_consRepIR" title="Consulta de IR13" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
			<asp:label id="Label2" runat="server" CssClass="header"> Declaración Jurada del IR-13</asp:label><br />
    <uc2:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <br/>
    <strong>
			Estatus:</strong>
			<asp:label id="lblStatus" runat="server" CssClass="subHeader"></asp:label>
            
            <br />
    <br/>
			
			<asp:panel id="pnlHechasEnDGII" runat="server" Visible="False" Width="578px">
					<div class="label-Resaltado">Usted&nbsp; ha&nbsp;pagado los siguientes periodos a 
						través de la DGII.<br/>
                        Debe cargar su nómina rectificativa&nbsp;en el SUIR&nbsp;para que se genere el 
						IR-13 electrónico.
					</div>
					<asp:GridView id="gvIR13Pendiente" runat="server" AutoGenerateColumns="False">
						
						<Columns>
							<asp:BoundField  DataField="PERIODO_PAGO" HeaderText="Periodo"></asp:BoundField>
							<asp:BoundField DataField="TIPO_DECLARACION" HeaderText="Tipo Declaraci&#243;n"></asp:BoundField>
							<asp:BoundField DataField="FECHA_PRESENTACION" HeaderText="Fecha Presentaci&#243;n"></asp:BoundField>
							<asp:BoundField DataField="FECHA_PAGO" HeaderText="Fecha Pago"></asp:BoundField>
							<asp:BoundField DataField="TOTAL_PAGADO" HeaderText="Total Pagado" DataFormatString="{0:c}" HtmlEncode="false"></asp:BoundField>
						</Columns>
					</asp:GridView>
				</asp:panel>

				<table id="Table2" cellspacing="1" cellpadding="1" width="100%" border="0">
					<tr valign="top">
						<td><asp:panel id="pnlIR3Nulas" runat="server" Visible="False">
								<table id="Table3" cellspacing="0" cellpadding="0" border="0" style="width: 125%">
									<tr>
										<td style="width: 182px">
											<asp:Label cssclass="error" id="Label1" runat="server" Width="155px">**Debe realizar el pago de este período en DGII antes de realizar su declaración.</asp:Label></td>
									</tr>
									<tr>
										<td style="width: 182px">
											<asp:GridView id="gvIR13Nulo" runat="server">
											</asp:GridView>
										</td>
									</tr>
								</table>
							</asp:panel></td>
						<td><asp:panel id="pnlPeriodosOmisos" runat="server" Visible="False">
								<table id="Table4" cellspacing="0" cellpadding="0" width="100%" border="0">
									<tr>
										<td>
											<asp:Label cssclass="error" id="Label3" runat="server">**Los períodos siguientes no aparecen reportados.</asp:Label>
										</td>
									</tr>
									<tr>
										<td>
											<asp:GridView id="gvPeriodosOmisos" runat="server" Visible="False">
											</asp:GridView>
										</td>
									</tr>
								</table>
							</asp:panel></td>
						<td><asp:panel id="pnlPeriodosVencidos" runat="server" Visible="False">
								<table id="Table5" cellspacing="0" cellpadding="0" width="100%" border="0">
									<tr>
										<td>
											<asp:Label cssclass="error" id="Label4" runat="server">**El banco no ha reportado el pago correspondiente a los periodos:</asp:Label>
										</td>
									</tr>
									<tr>
										<td>
											<asp:GridView id="gvPeriodosVencidos" runat="server">
											</asp:GridView>
										</td>
									</tr>
								</table>
							</asp:panel></td>
					</tr>
				</table>
    <br />
            
            <asp:LinkButton ID="lnkVerDetalleIR13"  runat="server" Font-Size="12pt" Width="149px">Ver Detalle del IR13</asp:LinkButton><br />
    <br />
    <asp:UpdatePanel ID="updResumenir13" runat="server">
    <ContentTemplate>
    
            <br />
			<br/>
			<asp:label cssclass="label-Resaltado" id="lblSaldoFavorDGII" runat="server"
				Visible="False">**Tiene valores en la columna de Saldo a Favor  DGII por lo que debe hacer las rectificativas correspondientes.</asp:label><br>
			<asp:panel id="pnlIR13" runat="server" Visible="False">
			    <asp:GridView id="gvResumenIR13" runat="server" AutoGenerateColumns="False" Width="100%">
					
					<Columns>
						<asp:BoundField DataField="Apellidos" HeaderText="Apellidos">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Nombres" HeaderText="Nombres">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALARIO_ISR" HeaderText="Sueldos Pagados" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="REMUNERACION_ISR_OTROS" HeaderText="Remuneracion Otros Agentes"
							DataFormatString="{0:n}" HtmlEncode="false">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="OTRAS_REMUN" HeaderText="Otras &lt;br&gt; Remuneraciones" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="INGRESOS_EXENTOS_ISR" HeaderText="Ingresos &lt;br&gt; Exentos" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="TOTAL_PAGADO" HeaderText="Total Pagado" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="RETENCION_SS" HeaderText="Retenci&#243;n S.S." DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="TOTAL_SUJETO_RETENCION" HeaderText="Sueldo y otros Pagos &lt;br&gt;Sujetos a Retenci&#243;n"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="ISR" HeaderText="ISR" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALDO_FAVOR_ANTERIOR" HeaderText="Saldo a favor &lt;br&gt; anterior"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="IMPUESTO_A_PAGAR" HeaderText="Impuesto Retenido &lt;br&gt; y Pagado"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALDO_FAVOR_EMPLEADO" HeaderText="Saldo a Favor &lt;br&gt; Empleado"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="SALDO_FAVOR_DGII" HeaderText="Saldo a Favor &lt;br&gt; DGII" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:BoundField>
					</Columns>
				</asp:GridView>
				
				
		<table style="width: 580px">
				
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
                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
           </td>
            </tr>
            <tr>
                <td>
                    Total Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
    
    </table>
                <br />
			<uc1:ucexportarexcel id="ucExcel" runat="server"></uc1:ucexportarexcel>
			</asp:panel>
				
				
		<br>
			</ContentTemplate>
			<Triggers>
			<asp:PostBackTrigger ControlID="ucExcel" />
			</Triggers>
    </asp:UpdatePanel>

			
				<table id="Table1" cellspacing="1" cellpadding="1" width="100%" border="0">
					<tr>
						<td class="td-note">
							<div style="text-align:center"><asp:button id="btDeclarar" runat="server" Text="Realizar Declaración" Enabled="False" Visible="False"></asp:button>
							</div>
						</td>
					</tr>
				</table>
			
</asp:Content>

