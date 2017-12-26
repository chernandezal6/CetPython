<%@ Page Title="Archivos Recibidos" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsArchivosRecibidos.aspx.vb" Inherits="Finanzas_ConsArchivosRecibidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
     $(function() {

                // Datepicker
                $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

                $("#ctl00_MainContent_txtDesde").datepicker($.datepicker.regional['es']);
                $("#ctl00_MainContent_txtHasta").datepicker($.datepicker.regional['es']);

            });
    </script>
    <div class="header">Reporte de Archivos Recibidos</div>
    <br />
    <asp:UpdatePanel ID="udpBuscar" runat="server" UpdateMode="Conditional">
        <ContentTemplate>    
            <table class="td-content" style="width: 250px" cellpadding="1" cellspacing="0">

        <tr>
            <td align="right" nowrap="nowrap">
                <br />
                Tipo de Archivo</td>
            <td>
                <br />
                &nbsp;<asp:DropDownList ID="ddlTipoArchivo" runat="server" CssClass="dropDowns" 
                    AutoPostBack="True">
                    <asp:ListItem Value="Todos">Todos</asp:ListItem>
                    <asp:ListItem Value="Concentracion">Concentración</asp:ListItem>
                    <asp:ListItem Value="Liquidacion">Liquidación</asp:ListItem>
                </asp:DropDownList>
                &nbsp;</td>
         </tr>
                <tr>
                    <td align="right" nowrap="nowrap">
                        Fecha Desde:
                    </td>
                    <td>
                        &nbsp;<asp:TextBox ID="txtDesde" runat="server" width="69px"></asp:TextBox>
                      
                     </td>
                </tr>
        <tr>
            <td align="right">
                Fecha Hasta:</td>
            <td align="left" colspan="1" nowrap="nowrap">
                &nbsp;<asp:TextBox ID="txtHasta" runat="server" width="69px"></asp:TextBox>
             
            </td>
        </tr>
                <tr>
                    <td align="left" colspan="2" nowrap="nowrap" style="text-align: center">
                        &nbsp;<br />
                        <asp:Button ID="btnBuscar" runat="server" CausesValidation="False" 
                            Text="Buscar" />
                        &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
                        <br />
                        <br />
                    </td>
                </tr>

    </table> <br />
    <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
     <asp:Panel ID="pnlNavegacion" runat="server" Visible="False">
            <asp:GridView ID="gvArchivos" runat="server" AutoGenerateColumns="False" 
                Width="600px" Wrap="False">
                  <Columns>
                      <asp:BoundField DataField="TIPOARCHIVO" HeaderText="Tipo Archivo">
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="False" />
                      </asp:BoundField>
 
                      <asp:BoundField DataField="NOMBREARCHIVO" HeaderText="Nombre Archivo">
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="ESTATUS" HeaderText="Status" >
                          <ItemStyle HorizontalAlign="left" Wrap="False"/>
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="False" />
                      </asp:BoundField> 
                      <asp:BoundField DataField="MENSAJE" HeaderText="Mensaje" >
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                      </asp:BoundField>

                      <asp:BoundField DataField="FechaRecogido" DataFormatString="{0:d}" HeaderText="Fecha Recogido" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>                        
                                                                 
                      <asp:TemplateField HeaderText="Detalle">
                          <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                        <ItemTemplate>
                            <asp:LinkButton ID="lbDetalle" runat="server" CommandName="DET" CommandArgument='<%# eval("NOMBREARCHIVO") & "|" & eval("TIPOARCHIVO")%>'>Ver Detalle </asp:LinkButton>
                                         
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
                </td>
            </tr>
            </table>
            </asp:Panel>
            <br />
        
        </ContentTemplate>

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

