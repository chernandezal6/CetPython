<%@ Page Title="Módulo de Devolución de Aportes" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="DevolucionAportes.aspx.vb" Inherits="Finanzas_DevolucionAportes" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script language="javascript" type="text/javascript">

            function Valida(e)
       	    {
       	          
             var carCode = (window.event) ? window.event.keyCode : e.which;

                if ((carCode < 48) || (carCode > 57))
                {                     
                    
                     if (window.event) //IE       
                     window.event.returnValue = null;     
                     else //Firefox       
                     e.preventDefault(); 
     
	            }

            }

            $(function() {

                // Datepicker
                $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

                $("#ctl00_MainContent_txtDesde").datepicker($.datepicker.regional['es']);
                $("#ctl00_MainContent_txtHasta").datepicker($.datepicker.regional['es']);

            });

    </script>
    
    <div class="header">Módulo de Devolución de Aportes</div>
    <br />
    <asp:UpdatePanel ID="udpBuscar" runat="server" UpdateMode="Conditional">
        <ContentTemplate>    
            <table class="td-content" style="width: 385px" cellpadding="1" cellspacing="0">
        <tr>
            <td align="right" style="width: 21%" nowrap="nowrap" valign="top">
                Nro. Reclamación:
            </td>
            <td valign="top">
                <asp:TextBox ID="txtReclamacion" 
                    runat="server" EnableViewState="False" width="88px" MaxLength="16"></asp:TextBox>
            </td>
            <td align="right" valign="top">
                RNC:
            </td>
            <td style="width: 125px; " valign="top">
                <asp:TextBox ID="txtRNC" runat="server" EnableViewState="False" MaxLength="11" width="95px"></asp:TextBox>
                <br />
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                    Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$" SetFocusOnError="True" EnableViewState="False">RNC o Cédula Inválido</asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td align="right" style="width: 21%" nowrap="nowrap">
                Fecha Desde:
            </td>
            <td>
                <asp:TextBox ID="txtDesde" runat="server" width="69px"></asp:TextBox>
             </td>
            <td align="right" nowrap="nowrap">
                Fecha Hasta:</td>
            <td>
                <asp:TextBox ID="txtHasta" runat="server" width="69px"></asp:TextBox>
            </td>
         </tr>
        <tr>
            <td align="right" style="width: 21%">
                Estatus:</td>
            <td>
            <asp:dropdownlist cssclass="dropDowns" id="ddlStatus" runat="server">
                </asp:dropdownlist></td>
            <td>
            </td>
            
        </tr>
        <tr>
        <td align="right" colspan="4" nowrap="nowrap">
                &nbsp;<asp:Button ID="btnBuscar" runat="server" 
                    Text="Buscar" CssClass="botones" />
                &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" 
                    CausesValidation="False" CssClass="botones" />
            </td>
        </tr>
        <tr>
            <td colspan="4" style="height: 15px">
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            </td>
        </tr>
    </table> 
     <asp:Panel ID="pnlNavegacion" runat="server" Visible="False">
            <asp:GridView ID="gvDevoluciones" runat="server" AutoGenerateColumns="False" 
                Width="600px" Wrap="False">
                  <Columns>
                      <asp:BoundField DataField="nro_reclamacion" HeaderText="Reclamacion">
                          <ItemStyle HorizontalAlign="center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="rnc" HeaderText="RNC">
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="razon_social" HeaderText="Razon Social" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="estatus" HeaderText="Estatus"  HtmlEncode="False" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>
                      <asp:BoundField DataField="cantidad_registros" HeaderText="Registros Ok" >
                          <ItemStyle HorizontalAlign="Right" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="monto_total" HeaderText="Monto Total" 
                          DataFormatString="{0:n}" >
                          <ItemStyle HorizontalAlign="Right" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>                      
                      <asp:BoundField DataField="fecha_solicitud" DataFormatString="{0:d}" HeaderText="Reclamación" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>                                        
                       <asp:BoundField DataField="fecha_envio" DataFormatString="{0:d}" HeaderText="Envío" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>  
                      <asp:BoundField DataField="fecha_respuesta" DataFormatString="{0:d}" HeaderText="Respuesta" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>                        
                      <asp:BoundField DataField="fecha_cancelacion" DataFormatString="{0:d}" HeaderText="Cancelación" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>   
                      <asp:BoundField DataField="fecha_devolucion" DataFormatString="{0:d}" HeaderText="Devolución" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>                        
                                                                 
                      <asp:TemplateField HeaderText="Opciones">
                          <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                        <ItemTemplate>
                        <asp:Label ID="lblIdStatus" runat="server" Visible="false" Text='<%# eval("id_status")%>'> </asp:Label>

                            <asp:LinkButton ID="lbDetalle" runat="server" CommandName="DET" CommandArgument='<%# eval("nro_reclamacion") & "|" & eval("rnc") & "|" & eval("razon_social")& "|" & eval("estatus")%>'>Ver Detalle </asp:LinkButton>
                            <asp:LinkButton ID="lbCancelar" runat="server" CommandName="CAN" CommandArgument='<%# eval("nro_reclamacion") & "|" & eval("rnc") & "|" & eval("razon_social")& "|" & eval("estatus")%>'>| Cancelar </asp:LinkButton>  
                            <asp:LinkButton ID="lbCompletado" runat="server" CommandName="COM" CommandArgument='<%# eval("nro_reclamacion") & "|" & eval("rnc") & "|" & eval("razon_social")& "|" & eval("estatus")%>'>| Completado </asp:LinkButton>  
                            <asp:LinkButton ID="lbAprobado" runat="server" CommandName="APR" CommandArgument='<%# eval("nro_reclamacion") & "|" & eval("rnc") & "|" & eval("razon_social")& "|" & eval("estatus")%>'>| Aprobado </asp:LinkButton>  
                            <asp:LinkButton ID="lbEnviar" runat="server" CommandName="ENV" CommandArgument='<%# eval("nro_reclamacion") & "|" & eval("rnc") & "|" & eval("razon_social")& "|" & eval("estatus")%>'>| Enviar a UNIPAGO</asp:LinkButton>
                                           
                        </ItemTemplate>                       
                      </asp:TemplateField>  
                    
                  </Columns>
              </asp:GridView>
            <br />
            
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
                    &nbsp;
                    <br />
                    <br />
                    <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                </td>
            </tr>
            </table>
            </asp:Panel>
            <br />
        
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="ucExportarExcel1" />
            <asp:PostBackTrigger ControlID="gvDevoluciones" />
        </Triggers>
    </asp:UpdatePanel>
    &nbsp; &nbsp;&nbsp;

        
  <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>  
           
</asp:Content>

