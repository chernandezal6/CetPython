<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="DetNachaReclamaciones.aspx.vb" Inherits="Finanzas_DetNachaReclamaciones" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">Consulta Detalle Archivos Nacha por Devolución de Aportes</div>
    <br />
    <br />
   
     <fieldset style="width: 350px">
     <legend>Detalle Archivo Nacha</legend>
      <table>
         <tr>
             <td>
             Nombre Nacha:
             </td>
             <td>
                 <asp:Label ID="lblNacha" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Monto:
             </td>
             <td>
             <asp:Label ID="lblMontoNacha" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Estatus
             </td>
             <td>
             <asp:Label ID="lblEstatus" runat="server" CssClass="labelData" ></asp:Label>
             </td>
         </tr>         
     </table>    
     
     </fieldset>

            <div>
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
                <br />
            </div>      
     
            <asp:GridView ID="gvDetNacha" runat="server" AutoGenerateColumns="False" Width="600px" EnableViewState="False" Wrap="False">
                  <Columns>
                      <asp:BoundField DataField="NO_RECLAMACION" HeaderText="Nro. Reclamación">
                          <ItemStyle HorizontalAlign="center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                      </asp:BoundField>
                      <asp:BoundField DataField="RNC" HeaderText="RNC">
                          <ItemStyle HorizontalAlign="center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                      </asp:BoundField>   
                      <asp:BoundField DataField="RAZON_SOCIAL" HeaderText="Razón Social">
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="True" VerticalAlign="Bottom" />
                      </asp:BoundField>                        
                     <asp:BoundField DataField="MONTO_DEVOLUCION" HeaderText="Monto Devolución" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="right" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="right" Wrap="True" VerticalAlign="Bottom" />
                      </asp:BoundField>
                      <asp:BoundField DataField="MONTO_RENTABILIDAD" HeaderText="Monto Rentabilidad" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="right" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="right" Wrap="True" VerticalAlign="Bottom" />
                      </asp:BoundField>                         
                      <asp:BoundField DataField="MONTO_RECLAMACION" HeaderText="Monto Reclamación" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="right" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="right" Wrap="True" VerticalAlign="Bottom" />
                      </asp:BoundField>  
                                                                                                                                                       
                  </Columns>
              </asp:GridView>
            <asp:Panel ID="pnlNavegacion" runat="server" Visible="False">
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
                    <br />
                    <br />
                    <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                    
                    
                </td>
            </tr>
            </table>
            </asp:Panel><br />
                    <img src="../images/detalle.gif" alt="" />
                    <asp:LinkButton ID="lnkEncabezado"  runat="server" 
                    Font-Size="Smaller">volver al encabezado</asp:LinkButton>
</asp:Content>

