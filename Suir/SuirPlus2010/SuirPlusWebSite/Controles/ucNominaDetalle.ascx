<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucNominaDetalle.ascx.vb" Inherits="Controles_ucNominaDetalle" %>
<%@ Register Src="ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>
&nbsp;<br />
<table id="tblDetalle" cellspacing="0" cellpadding="0"  runat="server">
        <tr>
            <td>
                <asp:Label ID="lblTitulo" runat="server" Font-Bold="True" Font-Size="11pt" ForeColor="#006699"
                        Width="335px">Detalle de la Nómina</asp:Label><br />
                <br />
                &nbsp;<asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False" font-size="9pt"></asp:Label></td>
        </tr>
    <tr>
        <td>
        
            <asp:dropdownlist id="ddlBusqueda" runat="server" CssClass="dropDowns">
                <asp:ListItem Value="A">Apellidos</asp:ListItem>
                <asp:ListItem Value="D">Documento</asp:ListItem>
            </asp:dropdownlist>
            <asp:textbox id="txtCriterio" runat="server" Width="185px"></asp:textbox>
            <asp:button id="btnBuscar" runat="server" Text="Buscar"></asp:button>
        </td>
    </tr>
    
 </table> 
  
 <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
  <table id="Table1" cellspacing="0" cellpadding="0" style="width:80%" runat="server"> 
    <tr>
        <td>
            <asp:GridView ID="gvNomina" runat="server" Width="100%" EnableViewState="False" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="Nombre_Completo" HeaderText="Nombre" />                        
                    <asp:TemplateField HeaderText="Documento">
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        <ItemTemplate>
                            <asp:Label id="Label2" runat="server" Text='<%# formateaDocumento(Eval("no_documento")) %>' />                           
                        </ItemTemplate>
                    </asp:TemplateField>                       
                    <asp:TemplateField HeaderText="NSS">
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        <ItemTemplate>
                            <asp:Label id="Label1" runat="server" Text='<%# formateaNSS(Eval("id_nss")) %>' />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="fecha_ingreso" DataFormatString="{0:d}" 
                        HeaderText="Fecha Ingreso">
                    <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="salario_ss" HeaderText="Sal. SS" DataFormatString="{0:n}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="salario_isr" HeaderText="Sal. ISR" DataFormatString="{0:n}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="salario_infotep" DataFormatString="{0:n}" HeaderText="Sal. INF" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" />
                    </asp:BoundField>
                    <asp:BoundField DataField="tipo_ingreso" HeaderText="Tipo Remuneración" />
                    <asp:BoundField DataField="otras_remuneraciones" HeaderText="O. R" DataFormatString="{0:n}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="saldo_a_favor_del_periodo" HeaderText="S.F" DataFormatString="{0:n}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="ingresos_extentos_del_periodo" HeaderText="I.E" DataFormatString="{0:n}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="remuneraciones_otros_agentes" HeaderText="R.O.A" DataFormatString="{0:n}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                    </asp:BoundField>
                    <asp:BoundField DataField="agente_retencion_isr" HeaderText="R.A.U.R.">
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
            <br />
         </td>
    </tr>
    <tr>
        <td>
            <asp:linkbutton id="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
	            CommandName="First" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
            <asp:linkbutton id="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion" Text="< Anterior"
	            CommandName="Prev" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;
            Página
	            [<asp:label id="lblCurrentPage" runat="server"></asp:label>] de
            <asp:label id="lblTotalPages" runat="server"></asp:label>&nbsp;
            <asp:linkbutton id="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
	            CommandName="Next" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
            <asp:linkbutton id="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
	            CommandName="Last" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;                    
            <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
        </td>                 
    </tr>           
    <tr>
        <td>
            <br />
            Total de empleados&nbsp;
            <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server"/>
        </td>
    </tr>
    <tr>
        <td>
            <br />
        </td>
    </tr>
   

    <tr>
	    <td>
		    <table class="td-note" id="Table2" cellspacing="0" cellpadding="0" style="width:430px;">
			    <tr>
				    <td colspan="2">
					    <div class="centered"><span class="LabelDataGreen">Leyenda</span></div>
				    </td>
			    </tr>
			    <tr>
				    <td>
					    <table cellspacing="1" cellpadding="1" style="width:100%;">
						    <tr>
							    <td style="width:20%;">NSS</td>
							    <td>Número de Seguridad Social.</td>
						    </tr>
						    <tr>
							    <td style="width:20%;">Sal. S.S.</td>
							    <td>Salario Cotizable para la Seguridad Social.</td>
						    </tr>
						    <tr>
							    <td style="width:20%;">Sal. ISR</td>
							    <td>Salario Cotizable para el ISR.</td>
						    </tr>
                            <tr>
                                <td style="width: 20%">
                                    Sal. INF</td>
                                <td>
                                    Salario Cotizable para el INFOTEP</td>
                            </tr>
						    <tr>
							    <td style="width:20%;">O. R</td>
							    <td>Otras Remuneraciones que cotizan para ISR.</td>
						    </tr>
						    <tr>
							    <td style="width:20%; height:3px;">S.F</td>
							    <td style="height: 3px">Saldos a Favor del período.</td>
						    </tr>
						    <tr>
							    <td style="width:20%;">I.E</td>
							    <td>Ingresos Exentos del período.</td>
						    </tr>
						    <tr>
							    <td style="width:20%;">R.O.A</td>
							    <td>Remuneraciones Otros Agentes</td>
						    </tr>
						    <tr>
							    <td style="width:20%;">R.A.U.R.</td>
							    <td>RNC. Agente Unico de Retención.</td>
						    </tr>
					    </table>
				    </td>
				    <td rowspan="8">
                        <uc1:ucExportarExcel ID="UcExportarExcel" runat="server" EnableViewState="false" />            
	                    &nbsp;</td>							    				    
			    </tr>
		    </table>
	    </td>
    </tr>
</table>

 </asp:Panel>