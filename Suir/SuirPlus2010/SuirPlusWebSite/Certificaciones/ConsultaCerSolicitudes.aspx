
<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false" CodeFile="ConsultaCerSolicitudes.aspx.vb" Inherits="Certificaciones_ConsultaCerSolicitudes" %>


<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
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
</asp:Content>


<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">

    <asp:HiddenField ID="hdTipoCertificacion" runat="server" />
    <h2 class="header">Consulta Certificaciones Solicitadas
    </h2>
    <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
    <table class="td-content">


        <tr>
            <td nowrap="nowrap">Tipo Certificación:</td>
            <td>
                <asp:DropDownList ID="ddlTipoCertificacion" runat="server" CssClass="dropDowns"></asp:DropDownList></td>
        </tr>
        <tr>
            <td nowrap="nowrap">Nro. Certificación:</td>
            <td>
                <asp:TextBox ID="txtNroDocumento" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td nowrap="nowrap">Fecha Desde:</td>
            <td>
                <asp:TextBox ID="txtFechaDesde" runat="server" CssClass="Calendario"></asp:TextBox></td>
            <td nowrap="nowrap">Fecha Hasta:</td>
            <td>
                <asp:TextBox ID="txtFechaHasta" runat="server" CssClass="Calendario"></asp:TextBox></td>
        </tr>

    </table>
    <div style="width: 416px; text-align: right;">
        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" Font-Size="10pt" />
        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" Font-Size="10pt" />
    </div>

    <br >
    <br >
    <table class="td-content">
        <tr>
            <td>
                <asp:GridView ID="gvConsulta" runat="server" AutoGenerateColumns="False" Width="1100px">
                    <Columns>
                        <asp:BoundField DataField="no_certificacion" HeaderText="Nro. Certificación" ItemStyle-HorizontalAlign="Center" />
                        <asp:BoundField DataField="RAZON_SOCIAL" HeaderText="Razón Social" />
                        <asp:BoundField DataField="TIPO_CERTIFICACION_DES" HeaderText="Tipo certificación" />
                        <asp:BoundField DataField="Estatus" HeaderText="Estatus" />
                        <asp:BoundField DataField="comentario" HeaderText="Motivo de Rechazo" />
                        <asp:BoundField DataField="fecha_creacion" HeaderText="Creación" DataFormatString="{0:d}" />
                        <asp:BoundField DataField="Usuario_solicita" HeaderText="Usuario solicita" />

                        <asp:TemplateField HeaderText="Descargar" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:ImageButton ID="ibDescargar" runat="server" ImageUrl="~/images/pdf.png" CommandName='<%# Eval("Estatus")%>' CommandArgument='<%# Eval("id_certificacion")%>' />
                                <%--<asp:HyperLink ID="ibDescargar" runat="server"
ImageUrl="~/images/pdf.png" Target="_new" CommandName='<%# Eval("Estatus")%>' CommandArgument='<%# Eval("id_certificacion")%>'></asp:HyperLink>--%>
                            </ItemTemplate>
                        </asp:TemplateField>
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

</asp:Content>

