<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consArchivosProcesados.aspx.vb" Inherits="Bancos_consArchivosProcesados" Title="Consulta Archivos Procesados" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
            Me.PermisoRequerido = 62
        End Sub
    </script>

    <script language="javascript" type="text/javascript">

        function checkNum(e) {
            var carCode = (window.event) ? window.event.keyCode : e.which;
            if (carCode != 8) {
                if ((carCode < 48) || (carCode > 57)) {
                    if (window.event) //IE       
                        window.event.returnValue = null;
                    else //Firefox       
                        e.preventDefault();
                }

            }
        }

        function checkDate(e) {
            var carCode = (window.event) ? window.event.keyCode : e.which;
            if (carCode != 8) {
                if ((carCode < 47) || (carCode > 57)) {
                    if (window.event) //IE       
                        window.event.returnValue = null;
                    else //Firefox       
                        e.preventDefault();
                }

            }
        }
        $(function () {

            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

            $("#ctl00_MainContent_txtDesde").datepicker($.datepicker.regional['es']);
            $("#ctl00_MainContent_txtHasta").datepicker($.datepicker.regional['es']);

        });
    </script>


    <table width="500px" cellspacing="0" cellpadding="0" border="0">
        <tr>
            <td>
                <div style="float: left; width: 300px; margin-right: 10px" id="divParamArchivos" runat="server">
                    <fieldset id="fsParamArchivos" style="width: auto">
                        <br />
                        <legend>Consulta de Archivos Procesados</legend>
                        <table cellspacing="0" cellpadding="0" border="0">

                            <tr>
                                <td align="right">
                                    <asp:Label ID="lblNoEnvio" runat="server" Text="Número Envio:"></asp:Label>
                                </td>
                                <td>&nbsp;
                    <asp:TextBox ID="txtNoEnvio" runat="server" MaxLength="16" onKeyPress="checkNum(event)"
                        EnableViewState="False" Width="65px"></asp:TextBox>
                                </td>
                            </tr>

                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <asp:Label ID="lblFechaIni" runat="server" Text="Fecha Inicial:"></asp:Label>
                                </td>
                                <td>&nbsp;
                        <asp:TextBox ID="txtDesde" runat="server" MaxLength="10" onKeyPress="checkDate(event)"></asp:TextBox>

                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;</td>
                                <td>&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="right">
                                    <asp:Label ID="lblFechaFin" runat="server" Text="Fecha Final:"></asp:Label>
                                </td>
                                <td>&nbsp;
                        <asp:TextBox ID="txtHasta" runat="server" MaxLength="10" onKeyPress="checkDate(event)"></asp:TextBox>

                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: center;" colspan="2">&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: center;" colspan="2">
                                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar"
                                        ValidationGroup="Ciudadano" />
                                    &nbsp;
                        <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False"
                            Text="Limpiar" />
                                </td>
                            </tr>
                        </table>
                    </fieldset>
                </div>
            </td>
        </tr>
    </table>
    <br />

    <table>
        <tr>
            <td>
                <div style="float: left; margin-right: 10px" id="divArchivos" visible="false" runat="server">
                    <fieldset id="fsArchivos" style="width: auto">
                        <br />
                        <legend>Listado Archivos Procesados</legend>
                        <asp:GridView ID="gvArchivos" runat="server" AutoGenerateColumns="False" CellPadding="3">
                            <Columns>
                                <asp:BoundField DataField="id_recepcion" HeaderText="No. Lote">
                                    <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="fecha_carga" HeaderText="Fecha Env&#237;o"
                                    DataFormatString="{0:d}">
                                    <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="entidad_recaudadora_des"
                                    HeaderText="Entidad Recaudadora">
                                    <HeaderStyle Wrap="False" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="status" HeaderText="Status" />
                                <asp:TemplateField HeaderText="Detalle">
                                    <HeaderStyle Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDetalleRechazo" runat="server" CommandArgument='<%#Eval("id_recepcion")%>' CommandName="status">[Ver]</asp:LinkButton>
                                        <%-- <asp:HyperLink ID="hlStatusRechazado" runat="server"><%#Eval("id_recepcion")%>Status3</asp:HyperLink>
                                <asp:Label ID="lblStatus" runat="server" Text="Status"></asp:Label>--%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="registros_ok" HeaderText="Registro Ok">
                                    <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="registros_bad" HeaderText="Registro AC/RC">
                                    <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="id_tipo_movimiento" HeaderText="Tipo Archivo">
                                    <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Archivo Respuesta">
                                    <HeaderStyle Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="hlRespuesta" runat="server" NavigateUrl=' <%# "~/bancos/DescargaArchivosProcesados.aspx?ref=" & Eval("id_recepcion") & "|" & "R"%>'><%#Eval("nombre_archivo_respuesta")%></asp:HyperLink>

                                    </ItemTemplate>
                                </asp:TemplateField>

                                <asp:TemplateField HeaderText="Archivo Nacha">
                                    <HeaderStyle Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" />
                                    <ItemTemplate>
                                        <asp:HyperLink ID="hlNacha" runat="server" NavigateUrl=' <%# "~/bancos/DescargaArchivosProcesados.aspx?ref=" & Eval("id_recepcion") & "|" & "N"%>'><%#Eval("nombre_archivo_nacha")%></asp:HyperLink>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <RowStyle HorizontalAlign="Center" />
                        </asp:GridView>
                        <asp:Panel ID="pnlNavigation" runat="server" Visible="False">
                            <table style="width: 100%">
                                <tr>
                                    <td>
                                        <asp:LinkButton ID="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                            CommandName="First" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion" Text="< Anterior"
                                    CommandName="Prev" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                                Página
	                                [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
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
                                    <td>Total de archivos&nbsp;
                                <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server" />
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </fieldset>
                </div>
            </td>
        </tr>
    </table>

    <div>
        <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label>
    </div>
    <br />
    <asp:Panel ID="pnlResultado" runat="server" Visible="False">
        <fieldset id="fsErroresArchivos" style="width: 500px">
            <legend>Errores Encontrados</legend>

            <table>
                <tr>
                    <td>Id Envío:</td>
                    <td>
                        <asp:Label ID="lblIdRecepcion" runat="server" CssClass="subHeader" EnableViewState="False"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width:20%">Motivo Rechazo:</td>
                    <td>
                        <asp:Label ID="lblRazonRechazo" runat="server" CssClass="subHeader" EnableViewState="False"></asp:Label></td>
                </tr>
            </table>
            <br />

            <asp:GridView ID="dgError" runat="server" AutoGenerateColumns="False"  CellPadding="3">
                <Columns>
                    <asp:BoundField DataField="error_des" HeaderText="Errores:" />
                </Columns>
            </asp:GridView>
        </fieldset>


    </asp:Panel>
</asp:Content>

