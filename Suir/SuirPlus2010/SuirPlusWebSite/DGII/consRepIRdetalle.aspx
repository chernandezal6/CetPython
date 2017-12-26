<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" EnableEventValidation="false" CodeFile="consRepIRdetalle.aspx.vb" Inherits="DGII_consRepIRdetalle" title="Consulta de Declaración Jurada del IR-4" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc2" %>


<%@ Register TagPrefix="uc1" TagName="ucExportarExcel" Src="../Controles/ucExportarExcel.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

			<div class="header" align="left">Declaración IR-4 por período</div>
    <uc2:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
   
    <br />
				<TABLE class="td-content" id="tblConsulta" cellpadding="0" cellspacing="0" border="0">
					<TR>
						<TD>
                            <strong><span style="font-size: 8pt">
                                <br />
                                Seleccione el período para presentar el detalle:</span></strong></TD>
						<TD>
                            <br />
                            <asp:dropdownlist id="drpPeriodo" runat="server" CssClass="dropDowns" Enabled="False"></asp:dropdownlist></TD>
					</TR>
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <br />
                            <asp:button id="btnConsultar" runat="server" Text="Consultar" Enabled="False"></asp:button>
                            <br />
                            <br />
                            <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Font-Size="10pt"
                                Visible="False"></asp:Label></td>
                    </tr>
            
				</TABLE>               
    <br />
    <asp:UpdatePanel ID="udpDetalle" runat="server">
        <ContentTemplate>
		    <asp:Panel ID="pnlMostrar" runat="server" Visible="false">
		        <table id="tblDetalle" cellpadding="0" cellspacing="0" border="0">		        
			 <tr>
			<td colspan="2">

			<asp:GridView id="gvResumenIR13" runat="server" AutoGenerateColumns="False" Width="100%">

					<Columns>
                        <asp:Boundfield DataField="NO_DOCUMENTO" HeaderText="Nro. Documento">
							<HeaderStyle HorizontalAlign="Center" Wrap="False"></HeaderStyle>
                  		</asp:Boundfield>
						<asp:Boundfield DataField="Apellidos" HeaderText="Apellidos">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
						<ItemStyle Wrap="False" />
						</asp:Boundfield>
						<asp:Boundfield DataField="Nombres" HeaderText="Nombres">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
						<ItemStyle Wrap="False" />
						</asp:Boundfield>
						<asp:Boundfield DataField="SALARIO_ISR" HeaderText="Sueldos Pagados" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField="REMUNERACION_ISR_OTROS" HeaderText="Remuneracion &lt;br&gt; Otros Agentes"
							DataFormatString="{0:n}" HtmlEncode="false">
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>						
						<asp:Boundfield DataField="INGRESOS_EXENTOS_ISR" HeaderText="Ingresos &lt;br&gt; Exentos" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField="TOTAL_PAGADO" HeaderText="Total Pagado" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField="RETENCION_SS" HeaderText="Retenci&#243;n S.S." DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField="TOTAL_SUJETO_RETENCION" HeaderText="Sueldo y otros Pagos &lt;br&gt;Sujetos a Retenci&#243;n"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>
						<asp:Boundfield DataField="ISR" HeaderText="ISR" DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>						
						<asp:Boundfield DataField="IMPUESTO_A_PAGAR" HeaderText="Impuesto Retenido &lt;br&gt; y Pagado"
							DataFormatString="{0:n}" HtmlEncode="false">
							<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
							<ItemStyle HorizontalAlign="Right"></ItemStyle>
						</asp:Boundfield>												
					    <asp:BoundField DataField="Tipo_Trabajador" HeaderText="Tipo Trabajador" />
					</Columns>
				</asp:GridView>
			</td>
                <td>
                </td>
			</tr>
			
		            <tr>
        <td colspan="2">
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
            <td>
            </td>
    </tr>
    
                    <tr>
        <td style="width: 584px">
            Total Registros:
            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>&nbsp;
        </td>
    </tr>				
	</table>
                <br />
            <uc1:ucExportarExcel id="UcExcel" runat="server" Visible="true"></uc1:ucExportarExcel>
                <br />
	</asp:Panel>
            &nbsp;<br />
            <br />
        </ContentTemplate>
        <Triggers>
        <asp:PostBackTrigger ControlID="UcExcel" />
        </Triggers>
    </asp:UpdatePanel>
    &nbsp;<br />
    &nbsp;
</asp:Content>
