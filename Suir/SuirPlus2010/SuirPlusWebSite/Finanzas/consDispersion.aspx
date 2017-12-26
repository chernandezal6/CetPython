<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master"  AutoEventWireup="false" CodeFile="consDispersion.aspx.vb" Inherits="Finanzas_consDispersion" title="Consulta de Dispersión por ARS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="javascript" type="text/javascript">
	    function checkNum()
	    {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57))
            {
                event.cancelBubble = true	
                event.returnValue = false;	
            }
        }
    </script>


<asp:updatepanel id="updMain" runat="server" updatemode="Conditional">
        <contenttemplate>
            <div class="header">
                Dispersión por ARS
            </div>
            <asp:label id="lblMensaje" runat="server" cssclass="label-Resaltado"></asp:label><br />
             <asp:Panel ID="PanelRegistrosDisp" runat="server">
                            <table width="650px" cellpadding="0" cellspacing="0" border="0">
                                <tr>
                                    <td>
                                        <asp:GridView ID="gvDipersionesCompletados" runat="server" AutoGenerateColumns="False" PageSize="15" OnRowCommand="gvDipersionesCompletados_RowCommand">
                                            <Columns>
                                                <asp:BoundField DataField="ID_CARGA" HeaderText="ID Carga" >
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="FECHA" HeaderText="Fecha" />
                                                <asp:BoundField DataField="STATUS" HeaderText="Estado" >
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="VISTA" HeaderText="Vista" />
                                                <asp:BoundField DataField="REGISTROS_OK" HeaderText="Registros OK" 
                                                    DataFormatString="{0:n}" HtmlEncode="False" >
                                                    <ItemStyle HorizontalAlign="Right" />
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                <asp:BoundField DataField="REGISTROS_ERROR" HeaderText="Registro Errores" DataFormatString="{0:n}" HtmlEncode="False" >
                                                    <ItemStyle HorizontalAlign="Right" />
                                                    <HeaderStyle HorizontalAlign="Center" />
                                                </asp:BoundField>
                                                 <asp:TemplateField HeaderText="Resumen">               
                                                    <ItemTemplate>
                                                        <asp:LinkButton CommandArgument='<%# container.dataitem("ID_CARGA")%>' CommandName="VerDetalle" ID="lnkVer" runat="server" Text="[Ver]"/>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:LinkButton ID="btnLnkFirstPageDisp" runat="server" CommandName="First" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="<< Primera"></asp:LinkButton>
                                        |
                                        <asp:LinkButton ID="btnLnkPreviousPageDisp" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                                        [<asp:Label ID="lblCurrentPageDisp" runat="server"></asp:Label>] de
                                        <asp:Label ID="lblTotalPagesDisp" runat="server"></asp:Label>&nbsp;
                                        <asp:LinkButton ID="btnLnkNextPageDisp" runat="server" CommandName="Next" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="Próxima >"></asp:LinkButton>
                                        |
                                        <asp:LinkButton ID="btnLnkLastPageDisp" runat="server" CommandName="Last" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                                        <asp:Label ID="lblPageSizeDisp" runat="server" Visible="False"></asp:Label>
                                        <asp:Label ID="lblPageNumDisp" runat="server" Visible="False"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;<asp:Label ID="lblTotalRegistrosDisp" CssClass="error" runat="server" Visible="False"/>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
            &nbsp;&nbsp;&nbsp; 
            <br />
            <asp:Panel ID="pnlDetalleDispersion" runat="server" Visible="False" Width="650px">
            
            
            <table width="100%" cellpadding="0" cellspacing="0" border="0" >
            <tr>
              <td>
                 <asp:Label CssClass="header" ID="lblDetalleDispersion" runat="server" Text="Detalle de la Dispersión" Visible="true"></asp:Label></td>            
            </tr>
            <tr>
              <td align="right">
                 <asp:LinkButton ID="lnkExportExcel" runat="server" OnClick ="lnkExportExcel_Click"><img src="../images/excel.jpg" border="0">Exportar a Excel</asp:LinkButton>
              </td>  
                      
            </tr>            
            
            <tr>
              <td>
               <asp:gridview id="gvDispersion" runat="server" autogeneratecolumns="False" showfooter="True" cellpadding="1" onrowdatabound="gvDispersion_RowDataBound" Width="650px">
                <columns>
                    <asp:boundfield datafield="ID" headertext="ARS" >
                        <ItemStyle HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:boundfield>
                    <asp:boundfield datafield="NOMBRE" headertext="Nombre ARS" >
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle Wrap="False" HorizontalAlign="Left" />
                    </asp:boundfield>
                    <asp:boundfield datafield="titulares" headertext="Titulares" 
                        DataFormatString="{0:0,0}">
                        <ItemStyle HorizontalAlign="Right" Width="90px" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:boundfield>
                    <asp:boundfield datafield="dependientes" headertext="Dependientes" 
                        DataFormatString="{0:0,0}" >
                        <ItemStyle HorizontalAlign="Right" Width="90px" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:boundfield>
                    <asp:boundfield datafield="adicionales" headertext="Adicionales" 
                        htmlencode="False" DataFormatString="{0:0,0}" >
                        <ItemStyle HorizontalAlign="Right" Width="90px" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:boundfield>
                    <asp:boundfield datafield="total" headertext="Total" 
                        DataFormatString="{0:0,0}" >
                        <ItemStyle HorizontalAlign="Right" Width="90px" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:boundfield>
                    <asp:boundfield datafield="pago" headertext="Monto Pagado" 
                        dataformatstring="{0:c}" htmlencode="False" >
                        <ItemStyle HorizontalAlign="Right" Width="100px" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:boundfield>
                </columns>
                <HeaderStyle HorizontalAlign="Center" VerticalAlign="Middle" />
                <FooterStyle Font-Names="2" Height="25px" VerticalAlign="Bottom" />
            </asp:gridview>
              </td>            
            </tr>       
                               
            </table>
            </asp:Panel>
        
 </contenttemplate> 
        <Triggers>
           <asp:PostBackTrigger ControlID= "lnkExportExcel" />
        </Triggers>      
    </asp:updatepanel>

    &nbsp;<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 5px; bottom: 0%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>   
    
        

</asp:Content>

