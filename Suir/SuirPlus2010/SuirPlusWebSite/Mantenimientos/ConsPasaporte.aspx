<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false" CodeFile="ConsPasaporte.aspx.vb" Inherits="Mantenimientos_ConsPasaporte" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <% If 1 = 2 Then
    %>
    <link href="../App_Themes/SP/StyleSheet.css" rel="stylesheet" type="text/css" />
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>

   <script type="text/javascript">
        $(function () {

            //$(".date").datepicker({
            //    dateFormat: 'dd/mm/yy',
            //    defaultDate: "+1w",
            //    changeMonth: true,
            //    changeYear: true,
            //    numberOfMonths: 1
            //});


            $(".button").button();
        });

        //if ($(".date").val() == "") {
        //    Resultado += "* La fecha de nacimiento es requerida.</br>";
        //} else {
        //    if (!Util.ValidarFecha($(".date").val())) {
        //        Resultado += "* Debe ingresar una fecha de nacimiento válida.</br>";

        //    }
        //}
    </script>


    <script language="javascript" type="text/javascript">
        $(function pageLoad(sender, args) {

            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

            $("#ctl00_MainContent_txtFechaDesde").datepicker($.datepicker.regional['es']);
            $("#ctl00_MainContent_txtFechaHasta").datepicker($.datepicker.regional['es']);

        });
    </script>
    <div>
        <%--        <br />
        <h2 class="SubTitulo">Pasaportes Registrados
        </h2>--%>
        <div class="header" align="left">
            Pasaportes Registrados
        </div>
        <br />
        <table>
            <tr>
                <td>Pasaporte</td>
                <td>
                    <asp:TextBox ID="txtPasaporte" runat="server"></asp:TextBox></td>
                <td>Nombres</td>
                <td>
                    <asp:TextBox ID="txtNombres" runat="server"></asp:TextBox></td>
            </tr>
            <tr>
                <td>Primer Apellido:</td>
                <td>
                    <asp:TextBox ID="txtPrimerApellido" runat="server"></asp:TextBox>
                </td>
                <td>Segundo Apellido:</td>
                <td>
                    <asp:TextBox ID="txtsegundoApellido" runat="server"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>Fecha Desde:</td>
                <td>
                    <asp:TextBox ID="txtFechaDesde" runat="server" CssClass="date"></asp:TextBox></td>
                <td>Fecha Hasta:</td>
                <td>
                    <asp:TextBox ID="txtFechaHasta" runat="server" CssClass="date"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="4">
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="button" Style="font-size: 9pt;" />
                    &nbsp;&nbsp;
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CssClass="button" Style="font-size: 9pt;" />
                </td>
            </tr>
        </table>
        <br />
        <asp:GridView ID="gvListaPasaporte" runat="server" AutoGenerateColumns="false">
            <Columns>
                <asp:BoundField DataField="PASAPORTE" HeaderText="Numero Pasaporte" ItemStyle-HorizontalAlign="Justify" />
                <asp:BoundField DataField="NOMBRES" HeaderText="Nombres" ItemStyle-Width="100px" ItemStyle-HorizontalAlign="Justify" />
                <asp:BoundField DataField="PRIMER_APELLIDO" HeaderText="Primer Apellido" ItemStyle-HorizontalAlign="Justify" />
                <asp:BoundField DataField="SEGUNDO_APELLIDO" HeaderText="Segundo Apellido" ItemStyle-HorizontalAlign="Justify" />
                <asp:BoundField DataField="FECHA_NACIMIENTO" HeaderText="Fecha de Nacimiento" DataFormatString="{0:dd-MM-yyyy}" />
                <asp:BoundField DataField="SEXO_DES" HeaderText="Sexo" ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="STATUS" HeaderText="Estatus" ItemStyle-Width="90px" ItemStyle-HorizontalAlign="Center" />
                <asp:BoundField DataField="FECHA_REGISTRO" HeaderText="Fecha Registro" DataFormatString="{0:dd-MM-yyyy}" />
                <%--<asp:TemplateField>
                    <ItemTemplate>
                        <asp:ImageButton ID="btnImagenPasaporte" runat="server" Text='Eval("IMAGE_P")' />
                    </ItemTemplate>
                </asp:TemplateField>--%>
            </Columns>
        </asp:GridView>
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
                <td>
                    <br />
                    Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                    &nbsp;
             
                </td>
            </tr>
        </table>
    </div>
</asp:Content>

