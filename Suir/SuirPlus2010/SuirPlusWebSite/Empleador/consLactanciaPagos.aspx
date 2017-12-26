<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consLactanciaPagos.aspx.vb" Inherits="Empleador_consLactanciaPagos" title="Reporte Pago Lactancia" %>


<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>


<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc2" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
            <uc2:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
            <br />

            <div class="header">Reporte Pago Lactancia</div>            
            <br />
                <table class="td-content" id="Table1" style="width: 550px"  cellspacing="0" cellpadding="0">
				<tr>
					<td>
					<br />
						<table style="margin-left: 60px">
							<tr>
								<td>Cédula:</td>
								<td><asp:textbox id="txtCedula" runat="server" Width="100px" MaxLength="11"></asp:textbox>
                                    <asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" 
                                        ControlToValidate="txtCedula" Display="Dynamic" ValidationGroup="filtro">*</asp:requiredfieldvalidator></td>
								<td align="right"><asp:button id="btnConsultar" runat="server" Text="Buscar" 
                                        ValidationGroup="filtro"></asp:button>
									<asp:button id="btnLimpiar" runat="server" Text="Limpiar" 
                                        CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2">
                                    <asp:RegularExpressionValidator ID="regExpRncCedula0" runat="server" 
                                        ControlToValidate="txtCedula" Display="Dynamic" 
                                        ErrorMessage="Cédula inválida." Font-Bold="True" 
                                        ValidationExpression="^[0-9]+$" ValidationGroup="filtro"></asp:RegularExpressionValidator>
                                </td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
            <asp:Label ID="lblMensaje" CssClass="error" runat="server"></asp:Label>
            <br />
    <asp:UpdatePanel ID="upInfoPagoLactancia" runat="server">
        <ContentTemplate>        
        <table cellpadding="1" cellspacing="0" style="width:60%">
           <tr>
            <td>
                <table width="450px">
              <tr>
                <td>
            
                <div style="FLOAT: left; MARGIN-RIGHT: 10px; width: 806px;" id="divPagoLactancia" 
                    runat="server" visible="false">
                <fieldset  style="width:800px;"> 
                <legend>Pago Lactancia</legend> 
                <br />
                <asp:GridView ID="gvPagoLactancia" runat="server" AutoGenerateColumns="False" Width="758px">
                    <Columns>
                        <asp:BoundField DataField="Nombre" HeaderText="Nombre">
                            <ItemStyle HorizontalAlign="Left" Wrap="False" />
                        </asp:BoundField>
                       
                        <asp:templatefield headertext="Cédula">
                          <ItemTemplate>
                              <asp:Label ID="Label1" runat="server" Text='<%# formateaCedula(Eval("Cedula")) %>'></asp:Label>
                          </ItemTemplate>
                            <itemstyle horizontalalign="Center" Wrap="False" />
                            <headerstyle horizontalalign="Center" />
						</asp:templatefield>
                        
                        <asp:BoundField HeaderText="Banco" DataField="Banco">
                            <ItemStyle HorizontalAlign="Left" Wrap="False" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Nro_Cuenta" HeaderText="Nro. Cuenta">
                            <HeaderStyle Wrap="False" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Cuota" HeaderText="Cuota" />
                        <asp:BoundField DataField="Monto_del_Subsidio" DataFormatString="{0:c}" 
                            HeaderText="Monto Subsidio" HtmlEncode="False">
                            <HeaderStyle Wrap="False" />
                            <ItemStyle HorizontalAlign="Right" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Fecha_Pago" DataFormatString="{0:d}" 
                            HeaderText="Fecha Pago" HtmlEncode="False">
                            <HeaderStyle Wrap="False" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>    
            </fieldset>
                </div> 
         
                </td>
		      </tr>
		      <tr>
		        <td>
		          <asp:Panel ID="pnlNavegacion" runat="server" Height="50px">
                    <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td style="height: 24px">
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
                        <td>Total de Registros:
                            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                            &nbsp;<uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                        </td>
                    </tr>
                
                    </table>
                    </asp:Panel>
		         </td>
		      </tr>
	        </table>
	        </td>
	       </tr>
          <tr>
            <td> 
                <table width="500px">
                <tr>
                    <td>
                    <div style="FLOAT: left; MARGIN-RIGHT: 10px" id="divPagoLactanciaError" 
                    runat="server" visible="false">
                         <fieldset style="width:900px;">
                            <legend>Pago Lactancia con Error</legend>
                            <br />
                            <asp:GridView ID="gvPagoLactanciaError" runat="server" AutoGenerateColumns="False" Width="854px">
                                <Columns>
                                    <asp:BoundField DataField="Nombre" HeaderText="Nombre">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    </asp:BoundField>
                                    
                                    <asp:templatefield headertext="Cédula">
                                      <ItemTemplate>
                                          <asp:Label ID="Label1" runat="server" Text='<%# formateaCedula(Eval("Cedula")) %>'></asp:Label>
                                      </ItemTemplate>
                                        <itemstyle horizontalalign="Center" Wrap="False" />
                                        <headerstyle horizontalalign="Center" />
						            </asp:templatefield>
						            
                                    <asp:BoundField DataField="Banco" HeaderText="Banco">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Nro_Cuenta" HeaderText="Nro. Cuenta">
                                        <HeaderStyle Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Cuota" HeaderText="Cuota" />
                                    <asp:BoundField DataField="Monto_del_Subsidio" DataFormatString="{0:c}" 
                                        HeaderText="Monto Subsidio" HtmlEncode="False">
                                        <HeaderStyle Wrap="False" />
                                        <ItemStyle HorizontalAlign="Right" />
                                    </asp:BoundField>

                                    <asp:templatefield headertext="Período">
                                      <ItemTemplate>
                                          <asp:Label ID="Label1" runat="server" Text='<%# formateaPeriodo(Eval("Periodo")) %>'></asp:Label>
                                      </ItemTemplate>
                                        <itemstyle horizontalalign="Center" />
                                        <headerstyle horizontalalign="Center" />
						            </asp:templatefield>
                                                
                                    
                                    <asp:BoundField DataField="Fecha_del_Error" DataFormatString="{0:d}" 
                                        HeaderText="Fecha Error">
                                        <HeaderStyle Wrap="False" />
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Error" HeaderText="Error">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </fieldset>
                    </div>
                    </td>
		        </tr> 
		        <tr>
		        <td>
		            <asp:Panel ID="pnlNavegacion2" runat="server" Height="50px">
                    <table cellpadding="0" cellspacing="0">
                <tr>
                    <td style="height: 24px">
                        <asp:LinkButton ID="btnLnkFirstPage2" runat="server" CommandName="First2" CssClass="linkPaginacion"
                            OnCommand="NavigationLink2_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                        <asp:LinkButton ID="btnLnkPreviousPage2" runat="server" CommandName="Prev2" CssClass="linkPaginacion"
                            OnCommand="NavigationLink2_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                        [<asp:Label ID="lblCurrentPage2" runat="server"></asp:Label>] de
                        <asp:Label ID="lblTotalPages2" runat="server"></asp:Label>&nbsp;
                        <asp:LinkButton ID="btnLnkNextPage2" runat="server" CommandName="Next2" CssClass="linkPaginacion"
                            OnCommand="NavigationLink2_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                        <asp:LinkButton ID="btnLnkLastPage2" runat="server" CommandName="Last2" CssClass="linkPaginacion"
                            OnCommand="NavigationLink2_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                        <asp:Label ID="lblPageSize2" runat="server" Visible="False"></asp:Label>
                        <asp:Label ID="lblPageNum2" runat="server" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>Total de Registros:
                        <asp:Label ID="lblTotalRegistros2" runat="server" CssClass="error"></asp:Label>
                        <uc1:ucExportarExcel ID="ucExportarExcel2" runat="server" />
                    </td>
                </tr>
                </table>
                </asp:Panel>
		        </td>
		    </tr>
	        </table>
            </td>
          </tr>
        </table>       
    
        </ContentTemplate>
        <Triggers>
        <asp:PostBackTrigger ControlID="ucExportarExcel1" />
        <asp:PostBackTrigger ControlID="ucExportarExcel2" />
        </Triggers>
    </asp:UpdatePanel>

</asp:Content>

