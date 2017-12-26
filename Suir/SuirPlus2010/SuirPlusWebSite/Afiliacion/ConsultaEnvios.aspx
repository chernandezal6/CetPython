<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaEnvios.aspx.vb" Inherits="Afiliacion_ConsultaEnvios" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
    $(function() {

        // Datepicker
        $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

        $("#ctl00_MainContent_txtDesde").datepicker($.datepicker.regional['es']);
        $("#ctl00_MainContent_txtHasta").datepicker($.datepicker.regional['es']);

    });
    </script>
<div class="header" align="left">Consulta de Envio<br />
&nbsp;</div>
   <table class="td-content" style="width: 385px" cellpadding="1" cellspacing="0">
        <tr>
            <td align="right" style="width: 21%" nowrap="nowrap">
                Fecha Desde:
            </td>
            <td>
                &nbsp;<asp:TextBox ID="txtDesde" runat="server" width="69px"></asp:TextBox>
                

            </td>
            <td align="right" nowrap="nowrap">
                Fecha Hasta:</td>
            <td>
                &nbsp;<asp:TextBox ID="txtHasta" runat="server" width="69px"></asp:TextBox>
                
            </td>
         </tr>
        <tr>
            <td align="right" style="width: 21%">
                Número de Envío:</td>
            <td>
                <asp:TextBox ID="txtNoEnvio" runat="server"></asp:TextBox>
            </td>
            <td>
            </td>
            <td align="left" colspan="1" nowrap="nowrap">
                &nbsp;<asp:Button ID="btnBuscar" runat="server" CausesValidation="False" 
                    Text="Buscar" />
                &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
            </td>
        </tr>
        <tr>
            <td colspan="4" style="height: 15px">
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            </td>
        </tr>
    </table> 
     <asp:Panel ID="panelEncabezado" runat="server" Visible="False">
            <asp:GridView ID="gvEncabezado" runat="server" AutoGenerateColumns="False" 
                Width="600px" Wrap="False">
                  <Columns>
                      <asp:BoundField DataField="id_recepcion" HeaderText="No. Envio">
                          <ItemStyle HorizontalAlign="center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="center" Wrap="False" />
                      </asp:BoundField>
                        <asp:BoundField DataField="error_des" HeaderText="Estatus" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" />
                      </asp:BoundField>
                      <asp:BoundField DataField="fecha_carga" HeaderText="Fecha de Envio" 
                          DataFormatString="{0:d}" HtmlEncode="False" >
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="registros_ok" HeaderText="Registro OK" >
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" />
                      </asp:BoundField>
                         <asp:BoundField DataField="registros_bad" HeaderText="Registro RE" >
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" />
                      </asp:BoundField>
                                                                 
                      <asp:TemplateField>
                          <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemTemplate>                            
                            <asp:LinkButton ID="lnkDescargar" Visible='<%# iif(container.dataitem("registros_bad") > 0,"True","False") %>' CommandName="Ver" CommandArgument='<%# container.dataitem("id_recepcion")  %>' runat="server">Ver Detalle</asp:LinkButton>             
                        </ItemTemplate>                       
                      </asp:TemplateField>  
                    
                  </Columns>
              </asp:GridView>
            <br />
            
            
            </asp:Panel>
    <asp:Panel ID="pnlNavegacion" runat="server" Visible="False">
            Detalle Archivo<asp:GridView ID="gvArchivos" runat="server" 
                AutoGenerateColumns="False" Width="600px" Wrap="False">
                <Columns>
                    <asp:BoundField DataField="id_pensionado" HeaderText="No Pensionado">
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="False" />
                    </asp:BoundField>
                     <asp:BoundField DataField="nombre" HeaderText="Nombre">
                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="id_error" HeaderText="Error">
                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:BoundField>                   
                    <asp:BoundField DataField="error_des" HeaderText="Error Desc">
                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>                  
                </Columns>
            </asp:GridView>
            <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
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
             
                </td>
            </tr>
            </table>
            </asp:Panel>
</asp:Content>

