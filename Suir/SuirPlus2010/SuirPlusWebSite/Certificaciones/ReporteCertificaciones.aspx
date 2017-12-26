<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ReporteCertificaciones.aspx.vb" Inherits="Certificaciones_ReporteCertificaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">


     <script type="text/javascript">
         $(function () {
             var curr_year = new Date().getFullYear();
             $(".Calendario").datepicker({
                 dateFormat: 'dd/mm/yy',
                 defaultDate: "+1w",
                 changeMonth: true,
                 changeYear: true,
                 yearRange: '1900:' + curr_year,
                 numberOfMonths: 1

             });
         });

    </script>

       <h2 class="header">Reporte de Certificaciones
    </h2>
    <br>
      <fieldset style="width: 350px">
        <table class="td-content">
            <tr>
                <td class="labelData" colspan="4" align="center">
                    <asp:Label ID="lblEncabezadoParam" runat="server" Text="Rango Fechas Válidas"></asp:Label>
                    <br />
                    <br />
                </td>
            </tr>
            <tr>
                <td valign="middle">
                    Desde:
                </td>
                <td valign="middle">
                    <asp:TextBox ID="txtFechaDesde" runat="server" Width="100px" CssClass="Calendario"></asp:TextBox>
                    &nbsp;
                </td>
                <td valign="middle">
                    Hasta:
                </td>
                <td valign="middle">
                    <asp:TextBox ID="txtFechaHasta" runat="server" Width="100px" CssClass="Calendario"></asp:TextBox>
                    &nbsp;
                </td>
            </tr>
            <tr>
                <td align="center" colspan="4" rowspan="1">
                    <br />
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" />
                    &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover"
                        CausesValidation="False" />
                </td>
            </tr>
            <%--<tr>
                    <td style="text-align: center;" colspan="2">
                        <asp:Label ID="LblError" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
                </tr>--%>
        </table>
    </fieldset>
    <br>
       <asp:Label ID="LblError" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>




  
    <br>
    <br>
   
    <div id="divCertificaciones" runat="server" visible=" false">
      <table class="td-content">
        <tr>
            <td>
                <asp:GridView ID="gvReporteCertificaciones" runat="server" AutoGenerateColumns="False" Width="550px">
                    <Columns>
                        <asp:BoundField DataField="solicita" HeaderText="Usuario solicita" ItemStyle-HorizontalAlign="left" />
                         <asp:BoundField DataField="aprobada" HeaderText="Aprobadas" HeaderStyle-HorizontalAlign ="Center" ItemStyle-HorizontalAlign="right" DataFormatString="{0:N0}"/>
                         <asp:BoundField DataField="pendiente" HeaderText="Pendientes" HeaderStyle-HorizontalAlign ="Center" ItemStyle-HorizontalAlign="right" DataFormatString="{0:N0}"/>
                         <asp:BoundField DataField="rechazada" HeaderText="Rechazadas" HeaderStyle-HorizontalAlign ="Center"  ItemStyle-HorizontalAlign="right" DataFormatString="{0:N0}"/>
                          <asp:BoundField DataField="Total_Certificaciones" HeaderText="Total"  HeaderStyle-HorizontalAlign ="Center" ItemStyle-HorizontalAlign="right" DataFormatString="{0:N0}"/>
                       
                       
                       </Columns>

                </asp:GridView>

            </td>

        </tr>
        <tr>

            <td>
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
            <td>Total de registros
                            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
            </td>
        </tr>
    </table>
        </div>
    <br>
    <br>
    <br>
     <br>
    <br>
    <br>
     <br>
    <br>
   
</asp:Content>

