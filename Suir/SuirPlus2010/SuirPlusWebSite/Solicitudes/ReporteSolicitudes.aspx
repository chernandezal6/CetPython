<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ReporteSolicitudes.aspx.vb" Inherits="Solicitudes_ReporteSolicitudes" title="Reporte de Solicitudes" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

 <script language="javascript" type="text/javascript">
     $(function () {
         $("#ctl00_MainContent_txtDesde").datepicker();
         $("#ctl00_MainContent_txtHasta").datepicker();
     });
 </script>   

    <asp:UpdatePanel ID="upReporteSolicitudes" runat="server">
        <ContentTemplate>
            <table cellpadding="0" cellspacing="0" width="500px">
        <tr>
            <td>
            <div  id="divRepSolicitudes" runat="server" >
            <fieldset> 
                <legend>Reporte de Solicitudes Trabajadas</legend><br /> 
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td rowspan="4" style="height: 91px"><img height="89" src="../images/EnLinea.jpg">
					    </td>
                        <td align="right" valign="top">
                            &nbsp;&nbsp;
                            Fecha Inicial2
                        </td>
                        <td valign="top">
                            &nbsp;<asp:TextBox ID="txtDesde" CssClass="fecha" class="fecha" runat="server"></asp:TextBox>
                          </td>
                     </tr>
                    <tr>
                        <td align="right" valign="top">
                            Fecha Final </td>
                        <td valign="top">
                            &nbsp;<asp:TextBox ID="txtHasta" CssClass="fecha" class="fecha" runat="server"></asp:TextBox>
                          <br />
                        </td>
                     </tr>
                    <tr>
                        <td align="right" valign="top">
                            &nbsp;</td>
                        <td valign="top">
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" 
                                ControlToValidate="txtDesde" Display="Dynamic" 
                                ErrorMessage="El formato correcto es &quot;dd/mm/yyyy&quot;" 
                                ValidationExpression="(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d"></asp:RegularExpressionValidator>
                            <br />
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" 
                                ControlToValidate="txtHasta" Display="Dynamic" 
                                ErrorMessage="El formato correcto es &quot;dd/mm/yyyy&quot;" 
                                ValidationExpression="(0[1-9]|[12][0-9]|3[01])[- /.](0[1-9]|1[012])[- /.](19|20)\d\d"></asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>

                        <td colspan="2" align="center">
                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CausesValidation="False" />
                            &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" 
                                CausesValidation="False" /></td>
                    </tr>

                </table>
                <br />
                 
            </fieldset></div>
            </td>
        </tr>
        
        <tr>
            <td>
            <div><asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" 
                    EnableViewState="False" Visible="False"></asp:Label></div>
            </td>
        </tr>
        <tr>
            <td>
            
                 <asp:Panel ID="pnlInfoEncabezado" runat="server" Visible="false" Width="648px"> 
           
                 <fieldset>
                 <legend>Solicitudes Trabajadas por Tipo de Solicitud</legend>
                 <table>
                 <tr>
                    <td>
                        <asp:GridView ID="gvInfoEncabezado" runat="server" AutoGenerateColumns="False" 
                         HorizontalAlign="Left" ShowFooter="false">
                         <FooterStyle Height="25px" HorizontalAlign="Center" VerticalAlign="Bottom" Wrap="False"  />
                     <Columns>
                     
                         <asp:BoundField DataField="id_tipo_solicitud" HeaderText="id_tipo_solicitud" Visible="false">
                             <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                             <ItemStyle HorizontalAlign="Left" Wrap="False" />
                         </asp:BoundField>
                        
                         <asp:BoundField DataField="descripcion" HeaderText="Tipo Solicitud">
                             <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                             <ItemStyle HorizontalAlign="Left" Wrap="False" />
                         </asp:BoundField>
                         <asp:BoundField DataField="solicitudes trabajadas" DataFormatString="{0:0,0}" 
                             HeaderText="Total Trabajadas">
                             <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                             <ItemStyle HorizontalAlign="Center" Wrap="False" />
                         </asp:BoundField>
                         
                        <asp:TemplateField HeaderText="">
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemTemplate>                        
                        <asp:LinkButton ID="lbDetalleSolicitud" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("id_tipo_solicitud") & "|" & eval("descripcion") %>'>Ver Detalle</asp:LinkButton>
                        </ItemTemplate>
                      </asp:TemplateField>  
                     </Columns>
                 </asp:GridView>
                    </td>
                 </tr>
                 
                        <tr>
                            <td>
                                <br />
                                Total de Registros:
                                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                                <br />
                                Total Solicitudes Trabajadas:
                                <asp:Label ID="lblTotalSolTrabajadas" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                 
                 </table>   
                 </fieldset>
                    <br />
                    <br />
                
             </asp:Panel>
        <br />
            <asp:Panel ID="pnlInfoDetSolicitudes" runat="server" Visible="false" Width="648px"> 
           
                 <fieldset>
                 <legend>Detalle Solicitud</legend>
                 <table>
                 <tr>
                    <td>Solicitud:</td>  
                    <td><asp:Label ID="lblSolicitud" runat="server" CssClass="labelData"></asp:Label></td>                
                 </tr>
                 
                                      
                 </table>

                         <table>
                         <tr>
                             <td colspan="2">
                                 <asp:GridView ID="gvDetSolicitudes" runat="server" AutoGenerateColumns="False" 
                                     HorizontalAlign="Left">
                                     <Columns>
                                         <asp:BoundField DataField="fecha_registro" HeaderText="Fecha Registro" 
                                             DataFormatString="{0:d}" HtmlEncode="False">
                                             <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                         <asp:BoundField DataField="Hora_Registro" HeaderText="Hora Registro" />
                                         <asp:BoundField DataField="Fecha_cierre" HeaderText="Fecha Cierre" 
                                             DataFormatString="{0:d}" HtmlEncode="False">
                                             <ItemStyle HorizontalAlign="Center" />
                                         </asp:BoundField>
                                          <asp:BoundField DataField="Hora_Cierre" HeaderText="Hora Cierre" />
                                          <asp:BoundField DataField="operador" HeaderText="Operador">
                                             <ItemStyle HorizontalAlign="Left" />
                                         </asp:BoundField>                                        
                                     </Columns>
                                 </asp:GridView>
                             </td>
                         </tr>
                         <tr>
                             <td>
                                 <asp:Panel ID="pnlNavegacion2" runat="server" Height="70px" Visible="False" 
                                     width="550px">
                                     <table cellpadding="0" cellspacing="0" width="550px">
                                         <tr>
                                             <td colspan="2" style="height: 24px">
                                                 <asp:LinkButton ID="btnLnkFirstPage2" runat="server" CommandName="First" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" 
                                                     Text="&lt;&lt; Primera"></asp:LinkButton>
                                                 &nbsp;|
                                                 <asp:LinkButton ID="btnLnkPreviousPage2" runat="server" CommandName="Prev" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" Text="&lt; Anterior"></asp:LinkButton>
                                                 &nbsp; Página [<asp:Label ID="lblCurrentPage2" runat="server"></asp:Label>
                                                 ] de
                                                 <asp:Label ID="lblTotalPages2" runat="server"></asp:Label>
                                                 &nbsp;
                                                 <asp:LinkButton ID="btnLnkNextPage2" runat="server" CommandName="Next" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" Text="Próxima &gt;"></asp:LinkButton>
                                                 &nbsp;|
                                                 <asp:LinkButton ID="btnLnkLastPage2" runat="server" CommandName="Last" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" 
                                                     Text="Última &gt;&gt;"></asp:LinkButton>
                                                 &nbsp;
                                                 <asp:Label ID="lblPageSize2" runat="server" Visible="False"></asp:Label>
                                                 <asp:Label ID="lblPageNum2" runat="server" Visible="False"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td>
                                                 Total de Registros:
                                                 <asp:Label ID="lblTotalRegistros2" runat="server" CssClass="error"></asp:Label>
                                                 &nbsp;&nbsp;
                                                 <br />
                                                 <br />
                                                 <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                                                 &nbsp;&nbsp;&nbsp;&nbsp;
                                                 <asp:LinkButton ID="lbVolverEncabezado" runat="server">volver al encabezado</asp:LinkButton>
                                                 <br />
                                             </td>
                                         </tr>
                                     </table>
                                 </asp:Panel>
                                 <br />
                             </td>
                         </tr>
       
                 </table>   
                 </fieldset>
                    <br />
                    <br />
                
             </asp:Panel>

            </td>
        </tr>
     </table>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="ucExportarExcel1" />
        </Triggers>
    </asp:UpdatePanel>

</asp:Content>

