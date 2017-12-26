<%@ Page Title="Gestión Cobros" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="GestionCobros.aspx.vb" Inherits="Cobro_GestionCobros" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
   <div class="header">Gestión Cobros</div>
   <br />
    <asp:UpdatePanel ID="upGestionCobros" runat="server">
        <ContentTemplate>
        <table cellpadding="0" cellspacing="0" width="600px">
        <tr>
            <td>
            <div  id="divGestionCobros" runat="server" >
            <fieldset style="height:110px; width:450px"> 
                <br />
                <table cellpadding="0" cellspacing="0" width="400px">
                    <tr>
                        <td valign="middle" rowspan="4" style="height: 91px"><img height="89" src="../images/EnLinea.jpg">
					    </td>
                        <td align="right" valign="top" nowrap="nowrap">
                            Usuario:
                        </td>
                        <td valign="top">
                            &nbsp;<asp:DropDownList ID="ddlUsuariosCartera" runat="server" CssClass="dropDowns"></asp:DropDownList>
                          </td>
                     </tr>
                    <tr>

                        <td align="right" valign="top">
                            Desde:
                        </td>
                        <td valign="top">
                            &nbsp;<asp:DropDownList ID="ddlPeriodoDesde" runat="server" 
                                CssClass="dropDowns" AutoPostBack="True">
                            </asp:DropDownList>
                          </td>
                     </tr>
                    <tr id="trPeriodoHasta" runat="server" visible="false">
                        <td align="right" valign="top">
                            Hasta:</td>
                        <td valign="top">
                            &nbsp;<asp:DropDownList ID="ddlPeriodoHasta" runat="server" CssClass="dropDowns">
                            </asp:DropDownList>
                        </td>
                     </tr>

                    <tr>

                        <td colspan="2" align="center">
                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CausesValidation="False" CssClass="botones" />
                            &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" 
                                CausesValidation="False" /></td>
                    </tr>

                </table>
                 
            </fieldset>
            </div>
            </td>
        </tr>
        </table>
            <div><asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" 
                    EnableViewState="False" Visible="False"></asp:Label></div>
              <br />
              <asp:Panel ID="pnlInfoGestionCobros" runat="server" Visible="false" Width="648px"> 
                <div class="subHeader">Resumen Gestión Cobros<br /> </div>
                <div>

                 <table>
                 <tr>
                    <td colspan="2">
                        <asp:GridView ID="gvInfoGestionCobros" runat="server" AutoGenerateColumns="False" 
                         HorizontalAlign="Left">
                         <FooterStyle Height="25px" HorizontalAlign="Center" VerticalAlign="Bottom" Wrap="False"  />
                     <Columns>
                    
                         <asp:BoundField DataField="ID_CARTERA" HeaderText="Cartera">
                             <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                             <ItemStyle HorizontalAlign="Left" Wrap="False" />
                         </asp:BoundField>
                        
                         <asp:BoundField DataField="ID_USUARIO" HeaderText="Usuario Asignado">
                             <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                             <ItemStyle HorizontalAlign="Left" Wrap="False" />
                         </asp:BoundField>

                         <asp:BoundField DataField="PERIODO_GENERACION" HeaderText="Generació">
                             <HeaderStyle HorizontalAlign="center" Wrap="False" />
                             <ItemStyle HorizontalAlign="center" Wrap="False" />
                         </asp:BoundField>

                         <asp:BoundField DataField="EMPLEADORES_ASIGNADOS" DataFormatString="{0:n}" 
                             HeaderText="Empleadores Asignados" HtmlEncode="False">
                             <HeaderStyle HorizontalAlign="right" Wrap="False" />
                             <ItemStyle HorizontalAlign="right" Wrap="False" />
                         </asp:BoundField>

                         <asp:BoundField DataField="EMPLEADORES_CONTACTADOS" DataFormatString="{0:n}" 
                             HeaderText="Empleadores Contactados" HtmlEncode="False">
                             <HeaderStyle HorizontalAlign="right" Wrap="False" />
                             <ItemStyle HorizontalAlign="right" Wrap="False" />
                         </asp:BoundField>

                         <asp:BoundField DataField="EMPLEADORES_PAGARON" DataFormatString="{0:0,0}" 
                             HeaderText="Empleadores Pagaron">
                             <HeaderStyle HorizontalAlign="right" Wrap="False" />
                             <ItemStyle HorizontalAlign="right" Wrap="False" />
                         </asp:BoundField>

                         <asp:BoundField DataField="TOTAL_PAGADO" DataFormatString="{0:c}" 
                             HeaderText="Total Pagado" HtmlEncode="False">
                             <HeaderStyle HorizontalAlign="right" Wrap="False" />
                             <ItemStyle HorizontalAlign="right" Wrap="False" />
                         </asp:BoundField>
                         
                        <asp:TemplateField HeaderText="">
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemTemplate>                        
                        <asp:LinkButton ID="lbDetalleGestionCobros" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("ID_CARTERA") & "|" & eval("ID_USUARIO")& "|" & eval("PERIODO_GENERACION") %>'>Ver Detalle</asp:LinkButton>
                        </ItemTemplate>
                      </asp:TemplateField>  
                     </Columns>
                 </asp:GridView>
                    </td>
                 </tr> 
                 <tr>
                 <td> 
                     </td>
                     <td>
                         </td>
                 </tr>    
                 
                     <tr>
                         <td>
                         </td>
                         <td style="text-align: right">
                             <asp:Label ID="lblRegistros" runat="server" CssClass="LabelDataGreen" 
                                 Text="Total Registos:"></asp:Label>
                             &nbsp;<asp:Label ID="lblcantRegistros" runat="server" CssClass="labelData">0</asp:Label>
                                &nbsp;
                             <asp:Label ID="lblMonto" runat="server" CssClass="LabelDataGreen" 
                                 Text="Monto Total:"></asp:Label>
                             &nbsp;<asp:Label ID="lblMontoTotal" runat="server" CssClass="labelData">0.00</asp:Label>
                         </td>
                     </tr>
                 </table>   

                </div>
              </asp:Panel>
       
              <asp:Panel ID="pnlDetGestionCobros" runat="server" Visible="false" Width="648px"> 
              <div class="subHeader">Detalle Gestión Cobros<br /> </div>
              <div>
               <table>
                       <tr>
                        <td>Cartera:</td>  
                        <td><asp:Label ID="lblCartera" runat="server" CssClass="labelData"></asp:Label></td>                
                            <td>
                                |</td>
                            <td>
                                Período:</td>
                            <td>
                                <asp:Label ID="lblPeriodo" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                           <td>
                               |</td>
                           <td>
                               Usuario:</td>
                           <td>
                               <asp:Label ID="lblUsuario" runat="server" CssClass="labelData"></asp:Label>
                           </td>
                        </tr>
                       
                      </table>

               <table>
                <tr>
                    <td>
                    <asp:GridView ID="gvDetGestionCobros" runat="server" AutoGenerateColumns="False" 
                        HorizontalAlign="Left">
                        <Columns>
                                     
                        <asp:BoundField DataField="ID_CARTERA" HeaderText="Cartera" Visible="false">
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                                         
                            <asp:BoundField DataField="RNC_O_CEDULA" HeaderText="RNC">
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>

                            <asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
                                <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                <ItemStyle HorizontalAlign="center" Wrap="False" />
                            </asp:BoundField>

                            <asp:BoundField DataField="TOTAL_GENERAL_FACTURA" DataFormatString="{0:0,0}" 
                                HeaderText="Monto">
                                <HeaderStyle HorizontalAlign="right" Wrap="False" />
                                <ItemStyle HorizontalAlign="right" Wrap="False" />
                            </asp:BoundField>                                                                                                                           
                                         
                            <asp:BoundField DataField="FECHA_LIMITE_PAGO" HeaderText="Limite Pago" 
                                DataFormatString="{0:d}" HtmlEncode="False">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>

                            <asp:BoundField DataField="FECHA_PAGO" HeaderText="Fecha Pago" 
                                DataFormatString="{0:d}" HtmlEncode="False">
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                                                                                
                        </Columns>
                    </asp:GridView>
                     </td>            
                </tr>
                <tr>
                    <td>
                    <asp:Panel ID="pnlNavegacion2" runat="server" Height="70px" Visible="False" width="550px">
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
                                    <asp:LinkButton ID="lbVolverEncabezado" runat="server">
                                    <img  src="../images/retornar.gif">
                                    volver al encabezado</asp:LinkButton>
                                    <br />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                     </td>            
                </tr> 

                </table>                     
              </div>
                
             </asp:Panel>

            </td>
        </tr>
     </table>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="ucExportarExcel1" />
        </Triggers>
    </asp:UpdatePanel>

        <br />
    <br />
    <br />
    &nbsp;&nbsp;&nbsp;
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>