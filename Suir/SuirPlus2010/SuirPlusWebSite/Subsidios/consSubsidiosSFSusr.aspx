<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consSubsidiosSFSusr.aspx.vb" Inherits="Subsidios_consSubsidiosSFSusr" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">

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

        var newwindow;
        function poptastic(url) {
            newwindow = window.open(url, 'Imagen Subsidio SFS', 'height=400,width=600,left=400,top=200');
            if (window.focus) { newwindow.focus() }
        }

        function AbrirVentana(url) {
            window.location = url;
        }

    </script>
    <div class="header">
        Consulta Subsidios del SFS</div>
    <br />
    <asp:UpdatePanel ID="upSubsidiosSFS" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <fieldset style="width: 400px; height: 150px;">
                <table cellpadding="0" width="310">
                	<tr>
						    <td align="right" nowrap="nowrap">RNC o Cédula</td>
						    <td>
							    <asp:TextBox id="txtrncCedula" MaxLength="11" runat="server"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtrncCedula"
                                    ErrorMessage="El RNC es requerido" SetFocusOnError="True" 
                                    Display="Dynamic">El RNC es requerido</asp:RequiredFieldValidator>
                                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtrncCedula"
                                Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$"
                                SetFocusOnError="True" EnableViewState="False">RNC o cédula Inválida</asp:RegularExpressionValidator>    
                                    </td>
					    </tr>
                    <tr>
                        <td align="right" valign="top">
                            Cédula:
                        </td>
                        <td valign="top">
                            <asp:TextBox ID="txtCedula" runat="server" EnableViewState="False" MaxLength="11"></asp:TextBox>
                            <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtCedula"
                                Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$"
                                SetFocusOnError="True" EnableViewState="False">Cédula Inválida</asp:RegularExpressionValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Estatus:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlEstatusSubsidios" runat="server" CssClass="dropDowns">
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Tipo:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlTipoSubsidio" runat="server" CssClass="dropDowns">
                                <asp:ListItem Selected="True" Value=""><--Todos--></asp:ListItem>
                                <asp:ListItem Value="M">Maternidad</asp:ListItem>
                                <asp:ListItem Value="E">Enfermedad Común</asp:ListItem>
                                <asp:ListItem Value="L">Lactancia</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Fecha Inicial:
                        </td>
                        <td>
                            <asp:TextBox ID="txtFechaDesde" class="fecha" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="right">
                            Fecha Final:
                        </td>
                        <td>
                            <asp:TextBox ID="txtFechaHasta" class="fecha" runat="server"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <br />
                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="botones" />
                            &nbsp;
                            <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" Text="Limpiar"
                                CssClass="botones" />
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            &nbsp;
                        </td>
                    </tr>
                </table>
            </fieldset>
            <div>
                <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"
                    Visible="False"></asp:Label></div>
            <br />
            <asp:Panel runat="server" ID="pnlSubsidiosSFS" Visible="false">
                <table cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <asp:GridView ID="gvSubsidiosSFS" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                CellSpacing="3" Style="width: 600px;">
                                <Columns>
                                    <asp:BoundField DataField="IdRegistro" HeaderText="IdRegistro" Visible="false">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="nro_solicitud" HeaderText="Nro Solicitud">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Tipo" HeaderText="Tipo">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="Nombres" HeaderText="Nombre">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="descripcion" HeaderText="Estatus">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="fecha_registro" HeaderText="Registro" DataFormatString="{0:d}"
                                        HtmlEncode="False">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="fecha_respuesta" HeaderText="Respuesta" DataFormatString="{0:d}"
                                        HtmlEncode="False">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="error_desc" HeaderText="Descripción">
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lbDetalleSol" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("nro_solicitud") &"|"& Eval("id_tipo_subsidio")%>'>Ver Detalle</asp:LinkButton>
                                        </ItemTemplate>
                                    </asp:TemplateField>
                                    <asp:TemplateField>
                                        <ItemTemplate>
                                            <asp:Label ID="lblTieneImagen" runat="server" Text='<%# Eval("nombre_archivo") %>'
                                                Visible="False"></asp:Label>
                                            <a href="javascript:AbrirVentana('verImagenSubsidiosSFS.aspx?idSolicitud=<%#DataBinder.Eval(Container.DataItem,"nro_solicitud") %>');">
                                                Ver Imagen</a>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                    <tr>
                        <td>
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
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="gvSubsidiosSFS" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 23px; bottom: 2%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

