<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaCuotasSubsidio.aspx.vb" Inherits="ConsultaCuotasSubsidio" %>

<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript">
        $(document).ready(function () {

            var desde = $("#<%=txtFechaDesde.ClientID %>").attr('id');

            var dates = $(".fecha").datepicker({
                dateFormat: 'd/mm/yy',
                defaultDate: "+1w",
                changeMonth: true,
                numberOfMonths: 3,
                onSelect: function (selectedDate) {
                    var option = this.id == desde ? "minDate" : "maxDate",
                                    instance = $(this).data("datepicker"),
                                    date = $.datepicker.parseDate(
                                        instance.settings.dateFormat ||
                                        $.datepicker._defaults.dateFormat,
                                        selectedDate, instance.settings);
                    dates.not(this).datepicker("option", option, date);
                }
            });
        });

    </script>


    <div class="header" align="left">
        Consulta de Subsidios<br />
    </div>
    <table class="td-content" style="width: 385px" cellpadding="1" cellspacing="0">

        <tr>
            <td align="right">Fecha Inicial:
            </td>
            <td>
                <asp:TextBox ID="txtFechaDesde" class="fecha" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="right">Fecha Final:
            </td>
            <td>
                <asp:TextBox ID="txtFechaHasta" class="fecha" runat="server"></asp:TextBox>
            </td>
        </tr>
        <tr>
            <td align="right">Tipo Empresa:
            </td>
            <td>
                <asp:DropDownList CssClass="dropDowns" runat="server" ID="ddlTipoEmpresa">
                    <asp:ListItem Value="" Text="Todas" />
                    <asp:ListItem Value="PU" Text="Publica no centralizada" />
                    <asp:ListItem Value="PC" Text="Publica centralizada" />
                </asp:DropDownList>
            </td>
        </tr>

        <tr>
            <td align="right" style="width: 21%">&nbsp;</td>
            <td>
                <asp:Button ID="btnBuscar" runat="server"
                    Text="Buscar" />
                &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar"
                    CausesValidation="False" />
            </td>
        </tr>
        <tr>
            <td colspan="2" style="height: 15px">
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
            </td>
        </tr>
    </table>
    <asp:Panel ID="pnlDatos" runat="server" Visible="False">
        <div class="subHeader">
            Detalle Cuotas<br />
            <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
        </div>
        <table cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <asp:GridView ID="gvCuotasSubsidios" runat="server" AutoGenerateColumns="False" Style="width: 90%;">
                        <Columns>
                            <asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC" />
                            <asp:BoundField DataField="razon_social" HeaderText="Institucion" />
                            <asp:BoundField DataField="Nombre" HeaderText="Empleado" />
                            <asp:BoundField DataField="no_documento" HeaderText="Cedula" />
                            <asp:BoundField DataField="tipo_subsidio" HeaderText="Tipo Subsidio" />
                            <asp:BoundField DataField="NRO_PAGO" HeaderText="Pago Nro.">
                                <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PERIODO" HeaderText="Período">
                                <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Tipo_Cuenta" HeaderText="Tipo Cuenta">
                                <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                <ItemStyle HorizontalAlign="center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="cuenta_banco" HeaderText="Cuenta Nro.">
                                <HeaderStyle HorizontalAlign="left" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="entidad_recaudadora_des" HeaderText="Entidad Bancaria">
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NRO_REFERENCIA" HeaderText="Referencia">
                                <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                <ItemStyle HorizontalAlign="center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="MONTO_SUBSIDIO" HeaderText="Monto" DataFormatString="{0:c}">
                                <HeaderStyle HorizontalAlign="center" Wrap="False" />
                                <ItemStyle HorizontalAlign="right" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="STATUS_PAGO" HeaderText="Descripción">
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FECHA_PAGO" HeaderText="Fecha Pago" DataFormatString="{0:d}"
                                HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </td>
            </tr>
            <tr>
                <td>
                    <asp:LinkButton ID="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                        CommandName="First" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                            <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion"
                                Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                            Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                            <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                            <asp:LinkButton ID="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                CommandName="Next" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                            <asp:LinkButton ID="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                CommandName="Last" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                            <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    <br />
                    Total de registros&nbsp;
                            <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server" />
                </td>
            </tr>
        </table>


    </asp:Panel>

</asp:Content>

