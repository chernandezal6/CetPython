<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsConsSubsidiados.aspx.vb" Inherits="Novedades_sfsConsSubsidiados" title="Solicitudes de Subsidios por Enfermedad Comun" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript">

    function modelesswin(url) {
        //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scroll:no;dialogWidth:460px;dialogHeight:460px")
        window.open(url, "", "width=460px,height=460px").print();
    }
			
			
		</script>
       <uc2:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <div class="header">
        Solicitudes de Subsidios por Enfermedad Común<br />
        <br />
    </div>
             <div>
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
             </div>
            <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False" ></asp:Label>
            <br />
            <div id="divConsulta" runat="server" visible="False">
                
            <br />
            <asp:GridView ID="gvSubsidios" runat="server" AutoGenerateColumns="False" 
                Width="943px" Wrap="False">
                <Columns>
                    <asp:TemplateField HeaderText="Nro Solicitud">
                        <ItemTemplate>
                            <asp:Label ID="lblNoSolicitud" runat="server" Text='<%# Bind("NRO_SOLICITUD") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Cédula">
                        <ItemTemplate>
                            <asp:Label ID="lblCedula" runat="server" Text='<%# Bind("NO_DOCUMENTO") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Nombre">                     
                        <ItemTemplate>
                            <asp:Label ID="lblNombre" runat="server" Text='<%# Bind("NOMBRE") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Estatus">
                        <ItemTemplate>
                            <asp:Label ID="lblStatus" runat="server" Text='<%# Bind("STATUS") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha Registro">                       
                        <ItemTemplate>
                            <asp:Label ID="lblFechaRegistro" runat="server" 
                                Text='<%# Bind("FECHA_REGISTRO", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Fecha Respuesta">                      
                        <ItemTemplate>
                            <asp:Label ID="lblFechaRespuesta" runat="server" 
                                Text='<%# Bind("FECHA_RESPUESTA", "{0:d}") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Descripción">                      
                        <ItemTemplate>
                            <asp:Label ID="lblDescripcion" runat="server" Text='<%# Bind("DESCRIPCION") %>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Left" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                          <asp:Label id="lblPin" Runat="server" Visible="False" text='<%# Eval("PIN") %>' />
                            <asp:HyperLink ID="lnkdetalle" runat="server" CommandName="Detalle">[Ver Detalle]</asp:HyperLink>
                        </ItemTemplate>
                        <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
                <br />
                <asp:Panel ID="pnlNavegacion" runat="server" Height="50px"  Width="66px">
            <table cellpadding="0" cellspacing="0" width="550px">
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
                <td><br />
                    Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
            </table>
            </asp:Panel>
           </div>
            <br />
           
      
</asp:Content>

