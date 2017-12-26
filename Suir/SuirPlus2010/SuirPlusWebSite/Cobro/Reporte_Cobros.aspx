<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Reporte_Cobros.aspx.vb" Inherits="ReporteCobros" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;

            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }
    </script>
         
     <div id = "divprincipal" class="header">
         Reportes Gestión de Cobros
     </div>
     <br />
         <asp:UpdatePanel ID="upBotones" runat="server" UpdateMode="Conditional">
          <ContentTemplate>
          <table>
          <tr>
          <td valign="top">
          
         <table>
                      <tr>
                         <td>
                         <fieldset>
                            Usuarios:
                             <asp:DropDownList ID="ddlusuarios" runat="server" CssClass="dropDowns">
                                 <asp:ListItem Value="-1">Todos</asp:ListItem>
                             </asp:DropDownList>
                             <asp:Button ID="btnBuscar" runat="server" CssClass="Button" Text="Buscar" />
                             <asp:Button ID="btncancelar" runat="server" CssClass="Button" Text="Cancelar" />
                             
                          </fieldset>
                            
                         </td>
                     </tr>
                  <%--   <tr>
                         <td>
                             <asp:Button ID="btnBuscar" runat="server" CssClass="Button" Text="Buscar" />
                             <asp:Button ID="btncancelar" runat="server" CssClass="Button" Text="Cancelar" />
                         </td>
                     
                     </tr>--%>
                    
                   <tr>
                         <td>
                             <asp:Label ID="lblMensaje" runat="server" CssClass="error" visible="false"></asp:Label>
                         </td>
                     </tr>
                 <tr>
                     <td>
                         <div ID="divcarteraasignadas" runat="server" align="center" Visible="false">
                             <fieldset>
                                 <legend>Empresas Asignadas</legend>
                                 <br />
                                 <asp:GridView ID="gvCobros" runat="server" AutoGenerateColumns="False" 
                                     Width="379px">
                                     <Columns>
                                         <asp:BoundField DataField="Cartera" HeaderText="Cartera">
                                         <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                         <asp:BoundField DataField="EmpresasAsignadas" DataFormatString="{0}" 
                                             HeaderText="Empresas Asignadas">
                                         <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                         <asp:BoundField DataField="EmpresasConSeguimiento" DataFormatString="{0}" 
                                             HeaderText="Empresas Con Seguimiento">
                                         <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                         <asp:TemplateField headertext="Detalle">
                                             <itemtemplate>
                                                 <asp:LinkButton ID="lkverseguimiento" runat="server" 
                                                     commandargument='<%# Container.Dataitem("Cartera") %>' 
                                                     CommandName="DetalleSeguimieto">Ver</asp:LinkButton>
                                             </itemtemplate>
                                             <ItemStyle HorizontalAlign="Center" />
                                         </asp:TemplateField>
                                     </Columns>
                                 </asp:GridView>
                             </fieldset>
                         </div>
                     </td>
                 </tr>
                 <tr>
                     <td>
                         <div ID="divdetseguimiento" runat="server" align="center">
                             <fieldset>
                                 <legend>Detalle Seguimiento Usuario</legend>
                                 <br />
                                 <asp:GridView ID="gvdetalleseguimiento" runat="server" 
                                     AutoGenerateColumns="False" Width="379px">
                                     <Columns>
                                         <asp:BoundField DataField="cartera" HeaderText="Cartera">
                                         <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                         <asp:BoundField DataField="usuario" HeaderText="Usuario">
                                         <ItemStyle HorizontalAlign="left" />
                                         </asp:BoundField>
                                         <asp:BoundField DataField="EmpresasConSeguimiento" DataFormatString="{0}" 
                                             HeaderText="Empresas Con Seguimiento">
                                         <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                         <asp:BoundField DataField="TotalSeguimientos" DataFormatString="{0}" 
                                             HeaderText="Total Seguimientos">
                                         <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                         <asp:TemplateField headertext="Detalle">
                                             <itemtemplate>
                                                 <asp:LinkButton ID="lkverseguimiento" runat="server" 
                                                     commandargument='<%# Container.Dataitem("cartera") & "|" & Container.Dataitem("usuario")  %>' 
                                                     CommandName="DetalleUsuario">Ver Seguimientos</asp:LinkButton>
                                             </itemtemplate>
                                             <ItemStyle HorizontalAlign="Center" />
                                         </asp:TemplateField>
                                     </Columns>
                                 </asp:GridView>
                                 <br />
                             </fieldset>
                         </div>
                     </td>
                 </tr>
            
        </table>        
    
                 
          </td>
          
          <td valign="top">
         <%--  <br />--%>
     <br />
    <table>
      <%-- <tr>
           <td></td>
       </tr>   
        <tr>
            <td></td>
        </tr>
        <tr>
            <td></td>
        </tr>        
        <tr>
            <td></td>
        </tr>   
        
        <tr>
            <td></td>
        </tr> 
        
             
        <tr>
            <td>
               </td>
        </tr>--%>
           <tr>
               <td>
                   <asp:Panel ID="pnlNavigation" runat="server" Visible="False">
                    <table>
                        <tr>
                            <td style="width: 400px">
                                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" 
                                    CssClass="linkPaginacion"  
                                    Text="&lt;&lt; Primera"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" 
                                    CssClass="linkPaginacion" Text="&lt; Anterior"></asp:LinkButton>
                                &nbsp; Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>
                                ] de
                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                &nbsp;
                                <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" 
                                    CssClass="linkPaginacion"  Text="Próxima &gt;"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" 
                                    CssClass="linkPaginacion" Text="Última &gt;&gt;">
                                </asp:LinkButton>
                                &nbsp;
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 400px">
                                Total de archivos: 
                                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error" />
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
              </td>
            </tr>
             
        <tr>
            <td>
                <div id="divcrmseguimiento" runat="server" align="center">
                     <fieldset>
                        <legend>Detalle Seguimiento CRM</legend>
                            <br />                         
                        <asp:GridView ID="gvcrmseguimiento" runat="server" AutoGenerateColumns="False" 
                            Width="913px">
                            <Columns>
                                <asp:BoundField DataField="ID_REGISTRO_CRM" HeaderText="CRM ID" DataFormatString="{0}" >
                                   <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="Razon_Social" HeaderText="Razon Social"  >
                                <ItemStyle HorizontalAlign="left" />
                                </asp:BoundField>
                                 
                                 <asp:BoundField DataField="contacto" HeaderText="Contacto"  >
                                <ItemStyle HorizontalAlign="left" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="REGISTRO_DES" HeaderText="Comentario"  >
                                <ItemStyle HorizontalAlign="left" />
                                </asp:BoundField>
                                
                                <asp:BoundField DataField="Estatus_Cobro" HeaderText="Estatus Cobros" >
                                 <ItemStyle HorizontalAlign="left" />
                                 
                                </asp:BoundField>
                                <asp:BoundField DataField="FECHA_REGISTRO" HeaderText="Fecha Contacto" />
                             
                              </Columns>
                                </asp:GridView>
                              
                     <br />
                        
                    </fieldset>
                </div>
            </td>
         
           
        </tr>
    </table>          
          </td>
          </tr>
          </table>
            
        
             
          </ContentTemplate>
         </asp:UpdatePanel>
         
     <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    
    
    
   
</asp:Content>

