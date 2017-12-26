<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ManejodeCartera.aspx.vb" Inherits="ManejodeCartera" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
     <div class="header">
         Manejo de Carteras
    </div>
    <table style="width: 50%">
        <tr>
            <td class="subHeader">
                <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="subHeader">
                Pendientes</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td colspan="2">
                <table cellpadding="0" cellspacing="0" class="tblWithImagen" 
                    style="width:650px%">
                    <tr>
                        <td class="listheadermultiline" colspan="2" style="width:650px%">
                            &nbsp;Notificaciones </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:DataList ID="dlUltimosRegistros" runat="server"  
                                RepeatDirection="Horizontal" Width="650px">
                                <ItemTemplate>
                                    <tr class="listItem">
                                        <td class="listItem" style="width:25%">
                                                     CRM Caso: <%#Eval("ASUNTO")%>     
                                                    
                                        </td>
                                        <td class="listItem" colspan="3">
                                          Recuerde comunicarse con <b><%#Eval("CONTACTO")%></b> 
                                          de la empresa <b><%#Eval("RAZON_SOCIAL")%></b>, 
                                          RNC no. <b><%#Eval("RNC_O_CEDULA")%></b> 
                                          al telefono <b><%#Eval("TELEFONOS")%></b> 
                                          en referencia al caso <b><%#Eval("ASUNTO")%></b> 
                                          registrado en fecha <b><%#Eval("FECHA_REGISTRO")%></b>.
                                          <br><br>Nota:<br><b><%#Eval("REGISTRO_DES")%></b>
                                        </td>
                                    </tr>
                                </ItemTemplate>
                                <AlternatingItemTemplate>
                                    <tr class="listItem">
                                        <td class="listItem" style="width:25%">
                                                     CRM Caso: <%#Eval("ASUNTO")%>     
                                                    
                                        </td>
                                        <td class="listItem" colspan="3">
                                          Recuerde comunicarse con <b><%#Eval("CONTACTO")%></b> 
                                          de la empresa <b><%#Eval("RAZON_SOCIAL")%></b>, 
                                          RNC no. <b><%#Eval("RNC_O_CEDULA")%></b> 
                                          al telefono <b><%#Eval("TELEFONOS")%></b> 
                                          en referencia al caso <b><%#Eval("ASUNTO")%></b> 
                                          registrado en fecha <b><%#Eval("FECHA_REGISTRO")%></b>.
                                          <br><br>Nota:<br><b><%#Eval("REGISTRO_DES")%></b>
                                        </td>
                                    </tr>
                                </AlternatingItemTemplate>
                            </asp:DataList>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td class="subHeader">
                Empleadores</td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td class="subHeader">
                Usted esta trabajando con la cartera #
                <asp:Label ID="lblNoCartera" runat="server" Font-Bold="True" ForeColor="Red"></asp:Label>
            </td>
            <td>
                &nbsp;</td>
        </tr>
        <tr>
            <td colspan="2">
                <table style="width: 100%">
                    <tr>
                        <td style="text-align: right">
                            RNC:</td>
                        <td>
                            <asp:TextBox ID="txtRnc" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            Razon Social:</td>
                        <td>
                            <asp:TextBox ID="txtRazonSocial" runat="server" Width="316px"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            No Seguimiento:</td>
                        <td>
                            <asp:DropDownList ID="ddlNoSeguimientos" runat="server" CssClass="dropDowns">
                                <asp:ListItem Value="-1">Todos</asp:ListItem>
                                <asp:ListItem>0</asp:ListItem>
                                <asp:ListItem>1</asp:ListItem>
                                <asp:ListItem>2</asp:ListItem>
                                <asp:ListItem>3</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center">
                            <asp:Button ID="btnFiltrar" runat="server" Text="Filtrar" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">
                <asp:GridView ID="gvEmpresas" runat="server" AutoGenerateColumns="False" 
                                EmptyDataText="No existen registros para este filtro.">
                    <Columns>
                        <asp:TemplateField HeaderText="RNC">                          
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" Text='<%#formateaRNC( container.dataitem("rnc_o_cedula")) %>'></asp:Label>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Left" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="razon_social" HeaderText="Empresa" />
                        <asp:BoundField DataField="cantidad_seguimiento" HeaderText="No Seguimiento" >
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
<%--                         <asp:TemplateField HeaderText="Acuerdo de Pago">
                             <ItemTemplate>   
                                 <asp:Label ID="lblAcuerdo" Text='<%# Container.DataItem("status_cobro") & "|" & Container.DataItem("id_motivo_cobro")%>' runat="server"></asp:Label>
                             </ItemTemplate>
                             <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>--%>
                        <asp:TemplateField HeaderText="Acuerdo de Pago">
                             <ItemTemplate>   
                                 <asp:Label ID="lblAcuerdo" Text='<%# Container.DataItem("tiene_Acuerdo")%>' runat="server"></asp:Label>
                             </ItemTemplate>
                             <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>                        
                         <asp:TemplateField headertext="Acciones">
					    <itemtemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CommandName="Trabajar" commandargument='<%# Container.Dataitem("rnc_o_cedula") & "|" & Container.Dataitem("id_cartera") & "|" & Container.Dataitem("NUM") & "|" & Container.Dataitem("RECORDCOUNT")   %>'>Realizar Gestion</asp:LinkButton>                            
						 </itemtemplate>
						     <ItemStyle HorizontalAlign="Center" />
						</asp:TemplateField>
                    </Columns>
                </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            &nbsp;</td>
                        <td>
                            &nbsp;</td>
                    </tr>
                </table>
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:Panel ID="pnlNavigation" runat="server" Visible="False">
                    <table style="width: 100%">
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="&lt;&lt; Primera"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="&lt; Anterior"></asp:LinkButton>
                                &nbsp; Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>
                                ] de
                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                &nbsp;
                                <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="Próxima &gt;"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="Última &gt;&gt;"></asp:LinkButton>
                                &nbsp;
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Total de archivos&nbsp;
                                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
</asp:Content>

