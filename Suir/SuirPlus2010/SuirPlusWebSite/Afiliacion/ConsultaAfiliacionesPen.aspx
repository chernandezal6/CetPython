<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaAfiliacionesPen.aspx.vb" Inherits="ConsultaAfiliacionesPen" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<div class="header" align="left">Consulta de Afiliaciones Pendientes<br />
&nbsp;<br />
        </div>
   <table class="td-content" style="width: 385px" cellpadding="1" cellspacing="0">
        <tr>
            <td align="right" style="width: 21%">
                ARS</td>
            <td>
                <asp:DropDownList ID="ddlARS" runat="server" CssClass="dropDowns">
                    <asp:ListItem Value="0">--Seleccione--</asp:ListItem>
                    <asp:ListItem Value="52">SENASA</asp:ListItem>
                    <asp:ListItem Value="42">SEMMA</asp:ListItem>
                    <asp:ListItem Value="2">Salud Segura</asp:ListItem>
                    <asp:ListItem Value="98">Secretaria de Hacienda</asp:ListItem>
                </asp:DropDownList>
            </td>
            <td>
            </td>
            <td align="left" colspan="1" nowrap="nowrap">
                &nbsp;<asp:Button ID="btnBuscar" runat="server" 
                    Text="Buscar" />
                &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" 
                    CausesValidation="False" />
            </td>
        </tr>
        <tr>
            <td colspan="4" style="height: 15px">
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            </td>
        </tr>
    </table> 
    <asp:Panel ID="pnlNavegacion" runat="server" Visible="False">
            <br />
            <br />
            <b>ARS:</b> 
        <asp:Label ID="lblARS" runat="server" CssClass="labelData"></asp:Label>
            <br />
            <asp:GridView ID="gvArchivos" runat="server" AutoGenerateColumns="False" 
                Width="600px" Wrap="False">
                  <Columns>
                      <asp:BoundField DataField="id_pensionado" HeaderText="No Pensionado">
                          <ItemStyle HorizontalAlign="center" />
                      </asp:BoundField>
                      <asp:BoundField DataField="NOMBRE" HeaderText="Pensionado">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" Wrap="False" />
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

