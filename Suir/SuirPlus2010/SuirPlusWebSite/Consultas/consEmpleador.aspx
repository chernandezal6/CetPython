<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consEmpleador.aspx.vb" Inherits="Consultas_consEmpleador" Title="Consulta de Empleador" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc2" %>
<%@ Register Src="../Controles/UCTelefono.ascx" TagName="UCTelefono" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
        <style type="text/css">
.manito {
  cursor:pointer;
 }
</style>
    
    
    <script language="javascript" type="text/javascript">

        function modelesswin(url) {
            //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px");
            newwindow = window.open(url, '', 'height=1300px,width=800px');
            newwindow.print();
        }

       
        var newwindow;
        function poptastic(url) {
            newwindow = window.open(url,'_blank', 'Editar_Documentos', 'height=300,width=500,left=400,top=200');
            if (window.focus) { newwindow.focus() }
        }
        function checkNum() {
            var carCode = event.keyCode;

            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

        function pageLoad(sender, args) {

            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));
            $(".fecha").datepicker($.datepicker.regional['es']);


            $(".dialog").dialog({
                bgiframe: true,
                autoOpen: false,
                height: 300,
                width: 350,
                modal: true
            });

            $('.resetClass').click(function () {
                $('.dialog').dialog('open');
                $('.dialog').parent().appendTo($("form"));

            })

        }


    </script>
    <script runat="server" language="vb">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init

            Me.PermisoRequerido = 11312312312312

        End Sub
    </script>
    <div class="header">
        Consulta de Empleadores
    </div>
    <br />
    <asp:UpdatePanel ID="upBotones" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <ajaxToolkit:MaskedEditExtender ID="MaskPhone" runat="server" ErrorTooltipEnabled="True"
                Mask="999-999-9999" MaskType="Number" TargetControlID="txtTelefono">
            </ajaxToolkit:MaskedEditExtender>
            <table class="td-content" style="width: 350px" cellpadding="1" cellspacing="0">
                <tr>
                    <td style="width: 24%"></td>
                    <td style="width: 65%"></td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%">RNC&nbsp;
                    </td>
                    <td style="width: 65%">
                        <asp:TextBox ID="txtRNC" onKeyPress="checkNum()" runat="server" EnableViewState="False"
                            MaxLength="11"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                            Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$"
                            SetFocusOnError="True" EnableViewState="False">RNC o Cédula Inválido</asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%" nowrap="nowrap">Registro Patronal&nbsp;
                    </td>
                    <td style="width: 65%">
                        <asp:TextBox ID="txtRegPatronal" onKeyPress="checkNum()" runat="server" MaxLength="9"
                            EnableViewState="False"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtRegPatronal"
                            Display="Dynamic" ErrorMessage="Reg. Patronal Inválido" SetFocusOnError="True"
                            ValidationExpression="^\d+$" EnableViewState="False"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%">Razón Social&nbsp;
                    </td>
                    <td style="width: 65%">
                        <asp:TextBox ID="txtRazonSocial" runat="server" Width="237px" EnableViewState="False"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%" nowrap="nowrap">Nombre Comercial&nbsp;
                    </td>
                    <td style="width: 65%">
                        <asp:TextBox ID="txtNombreComercial" runat="server" Width="237px" EnableViewState="False"></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%">Teléfono&nbsp;
                    </td>
                    <td style="width: 65%">
                        <asp:TextBox ID="txtTelefono" runat="server" MaxLength="10" EnableViewState="False"></asp:TextBox>
                        <ajaxToolkit:MaskedEditValidator ID="ValidatePhone" runat="server" ControlExtender="MaskPhone"
                            ControlToValidate="txtTelefono" Display="Dynamic" InvalidValueMessage="Teléfono inválido"
                            TooltipMessage="Ej: 555-555-5555"></ajaxToolkit:MaskedEditValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 20%"></td>
                    <td style="width: 65%">
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 20%"></td>
                    <td style="width: 65%">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                    </td>
                </tr>
            </table>
            <ajaxToolkit:AutoCompleteExtender ID="acNombreComercial" runat="server" CompletionListCssClass="autocomplete_completionListElement"
                CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem" CompletionListItemCssClass="autocomplete_listItem"
                ServiceMethod="getNCList" ServicePath="~/Services/AutoComplete.asmx" TargetControlID="txtNombreComercial"
                MinimumPrefixLength="2">
            </ajaxToolkit:AutoCompleteExtender>
            <ajaxToolkit:AutoCompleteExtender ID="acRazonSocial" runat="server" CompletionListCssClass="autocomplete_completionListElement"
                CompletionListHighlightedItemCssClass="autocomplete_highlightedListItem" CompletionListItemCssClass="autocomplete_listItem"
                MinimumPrefixLength="2" ServiceMethod="getRSList" ServicePath="~/Services/AutoComplete.asmx"
                TargetControlID="txtRazonSocial">
            </ajaxToolkit:AutoCompleteExtender>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <asp:UpdatePanel ID="upEmpleadores" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Panel ID="pnlGridEmpleadores" runat="server" Visible="false" Width="100%">
                <table id="Table1" cellpadding="0" cellspacing="0" style="width: 80%">
                    <tr>
                        <td style="height: 103px">
                            <asp:GridView ID="gvEmpleadores" runat="server" AutoGenerateColumns="False" Width="680px">
                                <Columns>
                                    <asp:BoundField DataField="RNC_O_CEDULA" HeaderText="RNC">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ID_REGISTRO_PATRONAL" HeaderText="Reg. Patronal">
                                        <ItemStyle HorizontalAlign="Left" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="RAZON_SOCIAL" HeaderText="Raz&#243;n Social">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="NOMBRE_COMERCIAL" HeaderText="Nombre Comercial">
                                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="TELEFONO_1" HeaderText="Tel&#233;fono">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="TELEFONO_2" HeaderText="Tel&#233;fono 2">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:TemplateField>
                                        <ItemStyle HorizontalAlign="Center" />
                                        <ItemTemplate>
                                            <asp:LinkButton ID="lnkVer" runat="server" CommandArgument='<%# Eval("ID_REGISTRO_PATRONAL") & "|" & Eval("RNC_O_CEDULA") %>'
                                                CommandName="Ver" Text="[Ver]">
                                            </asp:LinkButton>
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
            </asp:Panel>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="upTabs" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <ajaxToolkit:TabContainer ID="Tabs" runat="server" ActiveTabIndex="8" Width="900px"
                AutoPostBack="True">
                <ajaxToolkit:TabPanel ID="tabGenerales" runat="server" HeaderText="Generales">
                    <HeaderTemplate>
                        Generales
                    </HeaderTemplate>
                    <ContentTemplate>
                        <table style="width: 100%;">
                            <tr>
                                <td align="center" colspan="4">
                                    <asp:Label ID="lblObservacion" runat="server" CssClass="label-Resaltado" Visible="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 19%;">RNC/Cédula
                                </td>
                                <td style="width: 35%">
                                    <asp:Label ID="lblRNC" runat="server" CssClass="labelData" />
                                </td>
                                <td style="width: 20%">Registro Patronal
                                </td>
                                <td>
                                    <asp:Label ID="lblRegPatronal" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div>
                                        Razón Social
                                    </div>
                                    <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div>
                                        Nombre Comercial
                                    </div>
                                    <asp:Label ID="lblNombreComercial" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    <div>
                                        Sector Económico
                                    </div>
                                    <asp:Label ID="lblSectorEconomico" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Capital
                                </td>
                                <td>
                                    <asp:Label ID="lblCapital" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>&nbsp;&nbsp;
                                </td>
                                <td>&nbsp;&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>Tipo de Empresa
                                </td>
                                <td>
                                    <asp:Label ID="lblTipoEmpresa" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Estatus
                                </td>
                                <td>
                                    <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Primer Teléfono
                                </td>
                                <td>
                                    <asp:Label ID="lblTelefono1" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Categoria de Riesgo
                                </td>
                                <td>
                                    <asp:Label ID="lblCategoriaRiesgo" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Segundo Teléfono
                                </td>
                                <td>
                                    <asp:Label ID="lblTelefono2" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Fecha Registro
                                </td>
                                <td>
                                    <asp:Label ID="lblFechaRegistro" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Fax
                                </td>
                                <td>
                                    <asp:Label ID="lblFax" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Fecha Constitución
                                </td>
                                <td>
                                    <asp:Label ID="lblFechaConstitucion" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Email
                                </td>
                                <td>
                                    <asp:Label ID="lblEmail" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Inicio de Operaciones
                                </td>
                                <td>
                                    <asp:Label ID="lblFechaInicioOperacion" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Calle
                                </td>
                                <td>
                                    <asp:Label ID="lblCalle" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Administración Local
                                </td>
                                <td>
                                    <asp:Label ID="lblAdministracionLocal" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Número
                                </td>
                                <td>
                                    <asp:Label ID="lblNumero" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Oficio Número
                                </td>
                                <td>
                                    <asp:Label ID="lblOficioNro" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Edificio
                                </td>
                                <td>
                                    <asp:Label ID="lblEdificio" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>¿Tiene Acuerdo de Pago?
                                </td>
                                <td>
                                    <asp:Label ID="lblTieneAcuerdo" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Apartamento
                                </td>
                                <td>
                                    <asp:Label ID="lblApartamento" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>¿Encuesta Completada?
                                </td>
                                <td>
                                    <asp:Label ID="lblEncuestaCompletada" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Piso
                                </td>
                                <td>
                                    <asp:Label ID="lblPiso" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>¿Permitir Pago?
                                </td>
                                <td>
                                    <asp:Label ID="lblPermitirPago" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Sector
                                </td>
                                <td>
                                    <asp:Label ID="lblSector" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>¿Movimientos Pendientes?
                                </td>
                                <td>
                                    <asp:Label ID="lblMovimientos" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Municipio
                                </td>
                                <td>
                                    <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>¿Paga INFOTEP?
                                </td>
                                <td>
                                    <asp:Label ID="lblPagaInfotep" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Provincia
                                </td>
                                <td>
                                    <asp:Label ID="lblProvincia" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>¿Pago Retroactivo a pensionados por discapacidad? </td>
                                <td>
                                    <asp:Label ID="lblPagoRectroActivo" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>Sector Salarial
                                </td>
                                <td>
                                    <asp:Label ID="lblSectorSalarial" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td>Salario Mínimo Vigente
                                </td>
                                <td>
                                    <asp:Label ID="lblSalarioMinimoVigente" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td></td>
                                <td></td>
                                <td></td>
                                <td></td>
                            </tr>
                            <tr>
                                <td align="right" colspan="4">&nbsp;<asp:HyperLink ID="hlnkVerNotificaciones" runat="server">Ver Notificaciones</asp:HyperLink>|
                                    <asp:HyperLink ID="hlnkVerLiquidaciones" runat="server">Ver Liquidaciones ISR</asp:HyperLink>|
                                    <asp:HyperLink ID="hlnkVerLiquidacionesInfotep" runat="server">Ver Liquidaciones 
                                    INFOTEP</asp:HyperLink>|
                                    <asp:HyperLink ID="hlnkVerSolicitudes" runat="server">Ver Solicitudes</asp:HyperLink>|
                                    <asp:HyperLink ID="hlnkActPerfil" runat="server">Actualizar Perfíl</asp:HyperLink>|
                                    <asp:HyperLink ID="hlnkRegistroAuditoria" runat="server">Registro Auditoría</asp:HyperLink>
                                </td>
                            </tr>
                            </caption>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabRepresentante" runat="server" HeaderText="Representante">
                    <HeaderTemplate>
                        Representantes
                    </HeaderTemplate>
                    <ContentTemplate>
                        <asp:UpdatePanel ID="upRepresentantes" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:LinkButton ID="lnkNuevoRep" runat="server" Text="[Crear Representante]" OnClick="lnkNuevoRep_Click"></asp:LinkButton>
                                <asp:DataList ID="dtRepresentante" runat="server" RepeatColumns="2" ShowFooter="False" ShowHeader="False"
                                    CellSpacing="5">
                                    <ItemTemplate>
                                        <table class="tblContact" cellspacing="0" cellpadding="3" style="width: 300px;">
                                            <tr>
                                                <td class="tdContactHeader" colspan="4">
                                                    <asp:Label ID="lblRepresentante" runat="server" Text='<%# Eval("NOMBRE") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td style="width: 25%">Cédula/Pasaporte:
                                                </td>
                                                <td colspan="2">
                                                    <asp:Label ID="lblRedCedula" runat="server" Text='<%# formatCedula(Eval("NO_DOCUMENTO")) %>'> </asp:Label>
                                                </td>
                                                <td align="right">
                                                    <asp:Label ID="lblStatus" runat="server" Visible="false" Text='<%# Eval("STATUS") %>' />
                                                    <asp:LinkButton ID="lbtnHabilitar" runat="server" CommandName="Deshabilitar" CommandArgument='<%# Eval("ID_NSS") & "|" & Eval("ID_REGISTRO_PATRONAL")%>' Visible="false" ToolTip="Deshabilitar Representante">
                                                    <img src='../images/ok.gif' alt=''/>
                                                    </asp:LinkButton>
                                                    <asp:LinkButton ID="lbtnDeshabilitar" runat="server" CommandName="Habilitar" CommandArgument='<%# Eval("ID_NSS") & "|" & Eval("ID_REGISTRO_PATRONAL")%>' Visible="false" ToolTip="Habilitar Representante">
                                                    <img src='../images/bullet_error.png' alt=''/>
                                                    </asp:LinkButton>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Teléfono:
                                                </td>
                                                <td colspan="3">
                                                    <asp:Label ID="lblRepTelefono" runat="server" Text='<%# formatTelefono(Eval("TELEFONO_1")) %>'
                                                        Width="150px"></asp:Label>
                                                </td>

                                            </tr>
                                            <tr>
                                                <td>Email:
                                                </td>
                                                <td colspan="3">
                                                    <asp:Label ID="lblRepEmail" runat="server" Text='<%# Eval("EMAIL") %>' />
                                                </td>
                                            </tr>
                                            <tr>
                                                <td>Tipo:
                                                </td>
                                                <td>
                                                    <asp:Label ID="lblTipo" runat="server" Text='<%#IIF(Eval("Tipo_Representante")="A","Administrador","Normal") %>' />
                                                </td>
                                                <td align="right" colspan="2">
                                                    <asp:LinkButton ID="btnResetearClave" CssClass="resetClass" runat="server" CommandArgument='<%# Eval("NO_DOCUMENTO")%>'
                                                        CommandName="Resetear">[Resetear Class]
                                                    </asp:LinkButton>

                                                </td>
                                            </tr>
                                        </table>
                                    </ItemTemplate>
                                </asp:DataList><asp:Label ID="lblNuevoClass" runat="server" CssClass="label-Resaltado"
                                    EnableViewState="False"></asp:Label><asp:Panel ID="pnlNuevoRep" runat="server" Visible="false">
                                        <table class="td-content" cellspacing="0" cellpadding="0" width="520" border="0">
                                            <tr>
                                                <td class="error" align="left" colspan="4" style="height: 7px"></td>
                                            </tr>
                                            <tr>
                                                <td class="subHeader" align="left" colspan="4">Información General
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="error" align="left" colspan="4" style="height: 7px">
                                                    <asp:Label ID="lblRepMsg" runat="server" EnableViewState="False" CssClass="error"></asp:Label>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="left" colspan="4">
                                                    <asp:Panel ID="pnlNuevaInfoGeneral" runat="server">
                                                        <uc2:UCCiudadano ID="ucRepresentante" runat="server" />
                                                    </asp:Panel>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height="10"></td>
                                            </tr>
                                            <tr>
                                                <td class="subHeader" align="left" colspan="4" style="height: 12px">Datos del Representante
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height="10"></td>
                                            </tr>
                                            <tr>
                                                <td align="center" colspan="4"></td>
                                            </tr>
                                            <tr>
                                                <td align="right">Tipo de Representante&#160;
                                                </td>
                                                <td colspan="3">
                                                    <asp:DropDownList ID="ddTipo" runat="server" CssClass="dropDowns" Enabled="false">
                                                        <asp:ListItem Value="A">Administrador</asp:ListItem>
                                                    </asp:DropDownList>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">Teléfono&#160; #1&#160;
                                                </td>
                                                <td colspan="3">
                                                    <uc1:UCTelefono ID="ucRepTelefono1" runat="server" />
                                                    <asp:Label ID="Label2" runat="server" CssClass="error">*</asp:Label>ext.
                                                    <asp:TextBox ID="txtRepExt1" runat="server" MaxLength="4" Width="48px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">Teléfono&#160; #2&#160;
                                                </td>
                                                <td colspan="3">
                                                    <uc1:UCTelefono ID="ucRepTelefono2" runat="server" />
                                                    ext.
                                                    <asp:TextBox ID="txtRepExt2" runat="server" MaxLength="4" Width="48px"></asp:TextBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right">Email&#160;
                                                </td>
                                                <td class="error" colspan="3">
                                                    <asp:TextBox ID="txtRepEmail" runat="server" MaxLength="50" Width="240px"></asp:TextBox><asp:RegularExpressionValidator
                                                        ID="RegularExpressionValidator5" runat="server" CssClass="error" ControlToValidate="txtRepEmail"
                                                        ErrorMessage="Formato Invalido" ValidationExpression="\w+([-+.]\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td align="right"></td>
                                                <td colspan="3">
                                                    <asp:CheckBox ID="chkboxNotificacionMail" runat="server" Text="  Deseo recibir notificación via e-mail"
                                                        Checked="True"></asp:CheckBox>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td class="subHeader" align="left" colspan="4" style="height: 14px">Nóminas Asignadas
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height="10"></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height="10">
                                                    <asp:GridView ID="dgNominas" runat="server" AutoGenerateColumns="false">
                                                        <Columns>
                                                            <asp:TemplateField>
                                                                <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                                <ItemTemplate>
                                                                    <asp:CheckBox ID="chbSelecciona" runat="server" BorderWidth="0px"></asp:CheckBox><asp:Label
                                                                        ID="lblID" runat="server" Visible="False" Text='<%# DataBinder.Eval(Container, "DataItem.id_nomina") %>'> </asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                            <asp:BoundField DataField="nomina_des" HeaderText="Descripci&#243;n"></asp:BoundField>
                                                            <asp:TemplateField HeaderText="Tipo">
                                                                <ItemTemplate>
                                                                    <asp:Label runat="server" Text='<%# getTipoNom(DataBinder.Eval(Container, "DataItem.tipo_nomina")) %>'
                                                                        ID="Label1"> </asp:Label>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4" height="10"></td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">
                                                    <hr size="1">
                                                </td>
                                            </tr>
                                            <tr>
                                                <td colspan="4">
                                                    <table width="100%">
                                                        <tr>
                                                            <td valign="top" align="left" width="80%">
                                                                <font color="red">*</font>Información obligatoria.
                                                            </td>
                                                            <td align="right">
                                                                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" OnClick="btnAceptar_Click"></asp:Button>&#160;&#160;<asp:Button ID="btnCancelar" runat="server" Text="Cancelar"
                                                                    CausesValidation="False" OnClick="btnCancelar_Click"></asp:Button>&#160; &#160;<br>
                                                            </td>
                                                        </tr>
                                                    </table>
                                                </td>
                                            </tr>
                                        </table>
                                    </asp:Panel>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabNominas" runat="server" HeaderText="Nomina">
                    <HeaderTemplate>
                        Nóminas
                    </HeaderTemplate>
                    <ContentTemplate>
                        <asp:UpdatePanel ID="upNominas" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <asp:GridView ID="gvNominas" CellSpacing="0" CellPadding="2" runat="server" AutoGenerateColumns="False"
                                    Width="100%">
                                    <Columns>
                                        <asp:BoundField DataField="ID_NOMINA" HeaderText="ID">
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="NOMINA_DES" HeaderText="N&#243;mina">
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="tipo_nomina" HeaderText="Tipo">
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:BoundField DataField="status_nomina" HeaderText="Estatus">
                                            <HeaderStyle HorizontalAlign="Left" />
                                            <ItemStyle HorizontalAlign="Left" />
                                        </asp:BoundField>
                                        <asp:TemplateField>
                                            <ItemStyle HorizontalAlign="Center" />
                                            <HeaderTemplate>
                                                Empleados
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <table style="border: 0px; width: 10%;" cellpadding="0" cellspacing="0">
                                                    <tr>
                                                        <td align="center">
                                                            <span></span>&nbsp;
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="Label3" runat="server" Text='<%# Eval("Trabajadores") %>'></asp:Label>
                                                            <asp:HyperLink ID="lnkVerDetalleNomina" runat="server" NavigateUrl='<%# "consNominaDetalle.aspx?regPat=" & RegistroPatronal & "&idNom=" & Eval("ID_NOMINA")  %>'
                                                                Text="[Ver]" />
                                                        </td>
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                        <asp:TemplateField>
                                            <ItemStyle HorizontalAlign="Center" />
                                            <HeaderTemplate>
                                                Dependientes
                                            </HeaderTemplate>
                                            <ItemTemplate>
                                                <table cellpadding="0" cellspacing="0" style="border: 0px; width: 10%;">
                                                    <tr>
                                                        <td align="center">
                                                            <span></span>&nbsp;
                                                        </td>
                                                        <td>
                                                            <asp:Label ID="Label4" runat="server" Text='<%# Eval("Dependientes") %>'></asp:Label>
                                                            <asp:HyperLink ID="lnkVerDependientes" runat="server" NavigateUrl='<%# "consDependientesAdicionales.aspx?reg=" & RegistroPatronal & "&nom=" & Eval("ID_NOMINA")  %>'
                                                                Text="[Ver]" />

                                                        </td>
                                                    </tr>
                                                </table>
                                            </ItemTemplate>
                                        </asp:TemplateField>
                                    </Columns>
                                </asp:GridView>
                            </ContentTemplate>
                        </asp:UpdatePanel>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabCRMRegistros" runat="server" HeaderText="CRM">
                    <HeaderTemplate>
                        CRM Registro
                    </HeaderTemplate>
                    <ContentTemplate>
                        <fieldset>
                            <legend>Registre Nuevo CRM</legend>
                            <table style="width: 100%;">
                                <tr>
                                    <td align="right" style="width: 15%;">Tipo de Caso:
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddlTipoCaso" runat="server" CssClass="dropDowns" AutoPostBack="True">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="ddlTipoCaso"
                                            CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" InitialValue="-1"
                                            ValidationGroup="CRMRegistro">Debe seleccionar el tipo de caso.</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr id="trTipoSolicitudes" runat="server" visible="False">
                                    <td align="right" style="width: 15%;" runat="server">Tipo Solicitud:
                                    </td>
                                    <td runat="server">
                                        <asp:DropDownList ID="ddlTipoSolicitud" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="ddlTipoSolicitud"
                                            CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" InitialValue="-1"
                                            ValidationGroup="CRMRegistro">Debe seleccionar el tipo de Solicitud.</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Asunto:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtAsunto" runat="server" MaxLength="150" Width="242px" EnableViewState="False"></asp:TextBox><asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtAsunto" CssClass="error"
                                            Display="Dynamic" ValidationGroup="CRMRegistro">El asunto es requerido.</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Contacto:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtContacto" runat="server" MaxLength="150" Width="241px" EnableViewState="False"></asp:TextBox><asp:RequiredFieldValidator
                                            ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtContacto" CssClass="error"
                                            Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True"
                                            ValidationGroup="CRMRegistro">El contacto es requerido.</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Descripción:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtDescripcion" runat="server" CssClass="input" EnableViewState="False"
                                            Height="58px" MaxLength="150" TextMode="MultiLine" Width="311px"></asp:TextBox><asp:RequiredFieldValidator
                                                ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtDescripcion"
                                                CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" ValidationGroup="CRMRegistro"
                                                SetFocusOnError="True">La descripción es requerida.</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Fecha Notificación:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtFechaNotificacion" runat="server"></asp:TextBox><ajaxToolkit:MaskedEditValidator
                                            ID="MaskedEditValidator1" runat="server" ControlExtender="MaskedEditExtender1"
                                            ControlToValidate="txtFechaNotificacion" CssClass="error" Display="Dynamic" ErrorMessage="MaskedEditValidator1"
                                            TooltipMessage="Ej: 01/12/2007">Fecha Inválida</ajaxToolkit:MaskedEditValidator><asp:CheckBox
                                                ID="chkNotificame" runat="server" EnableViewState="False" Text="Notifícame" /><ajaxToolkit:MaskedEditExtender
                                                    ID="MaskedEditExtender1" runat="server" CultureAMPMPlaceholder="a.m.;p.m." CultureCurrencySymbolPlaceholder="RD$"
                                                    CultureDateFormat="DMY" CultureDatePlaceholder="/" CultureDecimalPlaceholder="."
                                                    CultureName="es-DO" CultureThousandsPlaceholder="," CultureTimePlaceholder=""
                                                    Enabled="True" Mask="99/99/9999" MaskType="Date" TargetControlID="txtFechaNotificacion">
                                                </ajaxToolkit:MaskedEditExtender>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtFechaNotificacion"
                                            CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" InitialValue="-1"
                                            ValidationGroup="CRMRegistro">Debes digitar la fecha de notifiación.</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Email Adicional 1:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtMailAdic1" runat="server" MaxLength="150" Width="242px" EnableViewState="False"></asp:TextBox><asp:RegularExpressionValidator
                                            ID="RegularExpressionValidator3" runat="server" ControlToValidate="txtMailAdic1"
                                            CssClass="error" Display="Dynamic" SetFocusOnError="True" ToolTip="Ejemplo: usuarios@domain.com">Email Inválido</asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Email Adicional 2:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtMailAdic2" runat="server" EnableViewState="False" MaxLength="150"
                                            Width="242px"></asp:TextBox><asp:RegularExpressionValidator ID="RegularExpressionValidator4"
                                                runat="server" ControlToValidate="txtMailAdic2" CssClass="error" Display="Dynamic"
                                                SetFocusOnError="True" ToolTip="Ejemplo: usuarios@domain.com" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Email Inválido</asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right"></td>
                                    <td align="center">
                                        <asp:Button ID="btnRegistrar" runat="server" OnClick="btnRegistrar_Click" Text="Registrar"
                                            ValidationGroup="CRMRegistro" /><asp:Button ID="btnLimpiarCRMregistros" runat="server"
                                                Text="Limpiar" CausesValidation="False" />
                                    </td>
                                </tr>
                            </table>
                        </fieldset>
                        <asp:Label ID="lblMensajeCRM" runat="server" CssClass="error" EnableViewState="False"></asp:Label><br />
                        <table style="width: 100%" class="tblWithImagen" cellpadding="0" cellspacing="0">
                            <tr>
                                <td class="listheadermultiline" style="width: 100%">&nbsp;Último Registro
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DataList ID="dlUltimosRegistros" runat="server" RepeatDirection="Horizontal"
                                        Width="100%" EnableViewState="False">
                                        <ItemTemplate>
                                            <tr class="listItem">
                                                <td class="listItem" style="width: 25%">
                                                    <%#Eval("nombre") %>
                                                    <br>
                                                    <em>
                                                        <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                        <%#Eval("asunto")%>
                                                    </b>
                                                    <br>
                                                    Tipo de Registro:
                                                    <%#Eval("tipo_registro_des")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des") %>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr class="listAltItem">
                                                <td class="listItem" style="width: 25%">
                                                    <%#Eval("nombre") %>
                                                    <br>
                                                    <em>
                                                        <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                        <%#Eval("asunto")%>
                                                    </b>
                                                    <br>
                                                    Tipo de Registro:
                                                    <%#Eval("tipo_registro_des")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des") %>
                                                </td>
                                            </tr>
                                        </AlternatingItemTemplate>
                                    </asp:DataList>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabCRMReportes" runat="server" HeaderText="CRMReportes">
                    <HeaderTemplate>
                        CRM Reportes
                    </HeaderTemplate>
                    <ContentTemplate>
                        <table style="width: 350px;">
                            <tr>
                                <td style="width: 20%" align="right">Tipo de Caso:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlTipoCasosRep" runat="server" CssClass="dropDowns">
                                    </asp:DropDownList>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Desde:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtDesde" runat="server" CssClass="Fecha" ValidationGroup="Reportes"></asp:TextBox><asp:ImageButton
                                        ID="btnDesde" runat="server" ImageAlign="AbsMiddle" ImageUrl="../images/calendar.png" /><ajaxToolkit:MaskedEditValidator
                                            ID="MaskValFechaDesde" runat="server" ControlExtender="MaskedEditExtender2" ControlToValidate="txtDesde"
                                            CssClass="error" Display="Dynamic" EmptyValueMessage="requerido." ErrorMessage="MaskedEditValidator1"
                                            InvalidValueMessage="Fecha Inválida" IsValidEmpty="False" TooltipMessage="Ej: 01/12/2007"
                                            ValidationGroup="Reportes"></ajaxToolkit:MaskedEditValidator><ajaxToolkit:MaskedEditExtender
                                                ID="MaskedEditExtender2" runat="server" Mask="99/99/9999" MaskType="Date" TargetControlID="txtDesde"
                                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="RD$" CultureDateFormat="DMY"
                                                CultureDatePlaceholder="/" CultureDecimalPlaceholder="" CultureName="es-DO" CultureThousandsPlaceholder=","
                                                CultureTimePlaceholder="" Enabled="True">
                                            </ajaxToolkit:MaskedEditExtender>
                                    <ajaxToolkit:CalendarExtender ID="calDesde" runat="server" Format="dd/MM/yyyy" PopupButtonID="btnDesde"
                                        TargetControlID="txtDesde" Enabled="True">
                                    </ajaxToolkit:CalendarExtender>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Hasta:
                                </td>
                                <td>
                                    <asp:TextBox ID="txtHasta" runat="server" ValidationGroup="Reportes"></asp:TextBox><asp:ImageButton
                                        ID="btnHasta" runat="server" ImageAlign="AbsMiddle" ImageUrl="../images/calendar.png" /><ajaxToolkit:MaskedEditValidator
                                            ID="MaskValFechaHasta" runat="server" ControlExtender="MaskedEditExtender3" ControlToValidate="txtHasta"
                                            CssClass="error" Display="Dynamic" EmptyValueMessage="requerido." ErrorMessage="MaskedEditValidator1"
                                            InvalidValueMessage="Fecha Inválida" IsValidEmpty="False" TooltipMessage="Ej: 01/12/2007"
                                            ValidationGroup="Reportes"></ajaxToolkit:MaskedEditValidator><ajaxToolkit:MaskedEditExtender
                                                ID="MaskedEditExtender3" runat="server" Mask="99/99/9999" MaskType="Date" TargetControlID="txtHasta"
                                                CultureAMPMPlaceholder="" CultureCurrencySymbolPlaceholder="RD$" CultureDateFormat="DMY"
                                                CultureDatePlaceholder="/" CultureDecimalPlaceholder="" CultureName="es-DO" CultureThousandsPlaceholder=","
                                                CultureTimePlaceholder="" Enabled="True">
                                            </ajaxToolkit:MaskedEditExtender>
                                    <ajaxToolkit:CalendarExtender ID="calHasta" runat="server" Format="dd/MM/yyyy" PopupButtonID="btnHasta"
                                        TargetControlID="txtHasta" Enabled="True">
                                    </ajaxToolkit:CalendarExtender>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" align="center">
                                    <asp:Button ID="btnConsultar" runat="server" OnClick="btnConsultar_Click" Text="Consultar"
                                        ValidationGroup="Reportes" />
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="height: 5px;">
                                    </div>
                                </td>
                            </tr>
                        </table>
                        <table cellpadding="0" cellspacing="0" class="tblWithImagen" style="width: 100%">
                            <tr>
                                <td class="listheadermultiline">Resultados
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DataList ID="dlReporte" runat="server" RepeatDirection="Horizontal" Width="100%">
                                        <ItemTemplate>
                                            <tr class="listItem">
                                                <td class="listItem" style="width: 25%;">
                                                    <%#Eval("nombre")%>
                                                    <br>
                                                    <em>
                                                        <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                        <%#Eval("asunto")%>
                                                    </b>
                                                    <br>
                                                    Tipo de Registro:
                                                    <%#Eval("TIPO_REGISTRO_DES")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des")%>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr class="listAltItem">
                                                <td class="listItem" style="width: 25%;">
                                                    <%#Eval("nombre")%>
                                                    <br>
                                                    <em>
                                                        <%#Eval("fecha_registro")%>
                                                    </em>
                                                </td>
                                                <td class="listItem" colspan="3">
                                                    <b>
                                                        <%#Eval("asunto")%>
                                                    </b>
                                                    <br>
                                                    Tipo de Registro:
                                                    <%#Eval("TIPO_REGISTRO_DES")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("registro_des")%>
                                                </td>
                                            </tr>
                                        </AlternatingItemTemplate>
                                    </asp:DataList>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabCRMUltimaAcciones" runat="server" HeaderText="CRMUltimaAccion">
                    <HeaderTemplate>
                        Ultimas Acciones
                    </HeaderTemplate>
                    <ContentTemplate>
                        <table style="width: 100%">
                            <tr>
                                <td class="listheadermultiline">Oficios Aplicados
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DataList ID="dlOficios" runat="server" RepeatDirection="Horizontal" Width="100%">
                                        <ItemTemplate>
                                            <tr class="listItem">
                                                <td class="listItem" style="width: 25%">
                                                    <%#Eval("NOMBRE_COMPLETO_S")%>
                                                    <br>
                                                    <em>
                                                        <%#Eval("FECHA_PROCESA")%>
                                                    </em>
                                                </td>
                                                <td class="listItem">Nro. &nbsp;<b><%#Eval("ID_OFICIO")%></b><br>
                                                    <%#Eval("accion_des")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("TEXTO_MOTIVO")%>
                                                </td>
                                                <td class="listItem" style="width: 5%;">
                                                    <a target="_blank" href="../oficios/oficioDoc.aspx?codOficio=<%# Eval("ID_OFICIO") %>">[ver]</a>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr class="listAltItem">
                                                <td class="listItem" style="width: 25%">
                                                    <%#Eval("NOMBRE_COMPLETO_S")%>
                                                    <br>
                                                    <em>
                                                        <%#Eval("FECHA_PROCESA")%>
                                                    </em>
                                                </td>
                                                <td class="listItem">Nro. &nbsp;<b><%#Eval("ID_OFICIO")%></b><br>
                                                    <%#Eval("accion_des")%>
                                                    <br>
                                                    <br>
                                                    <%#Eval("TEXTO_MOTIVO")%>
                                                </td>
                                                <td class="listItem" style="width: 5%;">
                                                    <a href="../oficios/oficioDoc.aspx?codOficio=<%# Eval("ID_OFICIO") %>" target="_blank">[ver]</a>
                                                </td>
                                            </tr>
                                        </AlternatingItemTemplate>
                                    </asp:DataList>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <div style="height: 5px;">
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <td class="listheadermultiline">Certificaciones Solicitadas
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:DataList ID="dlCertificaciones" runat="server" RepeatDirection="Horizontal"
                                        Width="100%">
                                        <ItemTemplate>
                                            <tr class="listItem">
                                                <td class="listItem" style="width: 25%">
                                                    <%#Eval("NOMBRE")%>
                                                    <br>
                                                    <em>
                                                        <%#Eval("FECHA_CREACION")%>
                                                    </em>
                                                </td>
                                                <td class="listItem">Nro.&nbsp;<b><%#Eval("ID_CERTIFICACION")%></b><br>
                                                    Tipo:&nbsp;<%#Eval("tipo_certificacion_des")%></td>

                                                <td class="listItem" style="width: 5%">
                                                    <a href="../certificaciones/vercertificacion.aspx?codCert=<%# Eval("ID_CERTIFICACION") %>"
                                                        target="_blank">[ver]</a>
                                                </td>
                                            </tr>
                                        </ItemTemplate>
                                        <AlternatingItemTemplate>
                                            <tr class="listAltItem">
                                                <td class="listItem" style="width: 25%">
                                                    <%#Eval("NOMBRE")%>
                                                    <br>
                                                    <em>
                                                        <%#Eval("FECHA_CREACION")%>
                                                    </em>
                                                </td>
                                                <td class="listItem">Nro.&nbsp;<b><%#Eval("ID_CERTIFICACION")%></b><br>
                                                    Tipo:&nbsp;<%#Eval("tipo_certificacion_des")%></td>

                                                <td class="listItem" style="width: 5%">
                                                    <a target="_blank" href="../certificaciones/vercertificacion.aspx?codCert=<%# Eval("ID_CERTIFICACION") %>">[ver]</a>
                                                </td>
                                            </tr>
                                        </AlternatingItemTemplate>
                                    </asp:DataList>
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel runat="server" ID="tabLegal" HeaderText="Legal">
                    <HeaderTemplate>
                        Legal
                    </HeaderTemplate>
                    <ContentTemplate>
                        <asp:UpdatePanel ID="upMarcarRect" runat="server" UpdateMode="Conditional">
                            <ContentTemplate>
                                <table style="width: 100%;">
                                    <tr>
                                        <td align="center">
                                            <asp:Label ID="lblAcuerdosMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            <asp:LinkButton ID="lnkBtnMarcarEmp" Visible="False" CausesValidation="false" runat="server"
                                                OnClick="lnkBtnMarcarEmp_Click">[Permitir envio de Novedades Retroactivas]</asp:LinkButton>
                                        </td>
                                    </tr>
                                </table>
                            </ContentTemplate>
                            <Triggers>
                                <asp:AsyncPostBackTrigger ControlID="lnkBtnMarcarEmp" EventName="Click" />
                            </Triggers>
                        </asp:UpdatePanel>
                        <fieldset>
                            <legend>Acuerdos Realizados</legend>
                            <div style="height: 2px;">
                            </div>
                            <asp:GridView ID="gvAcuerdos" runat="server" AutoGenerateColumns="False" Width="550px">
                                <Columns>
                                    <asp:BoundField DataField="ID_ACUERDO" HeaderText="ID">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="ACUERDO" HeaderText="Acuerdo">
                                        <ItemStyle HorizontalAlign="Left" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="STATUS" HeaderText="Estatus" />
                                    <asp:BoundField DataField="CUOTAS" HeaderText="Cuotas">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PERIODO_INI" HeaderText="Inicio">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="PERIODO_FIN" HeaderText="Fin">
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                </Columns>
                                <RowStyle HorizontalAlign="Center" />
                                <HeaderStyle HorizontalAlign="Center" />
                            </asp:GridView>
                            <asp:Label ID="lblAcuerdosRealizado" runat="server" EnableViewState="False" CssClass="subHeader" />
                        </fieldset>
                        <br />
                        <fieldset>
                            <legend>Notificaciones Emitidas</legend>
                            <div style="height: 2px;">
                            </div>
                            <asp:GridView ID="gvNotificaciones" runat="server" AutoGenerateColumns="False" Width="550px">
                                <Columns>
                                    <asp:BoundField DataField="ID_NOTIFICACION" HeaderText="ID">
                                        <ItemStyle HorizontalAlign="Left" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="TIPO" HeaderText="Tipo">
                                        <ItemStyle HorizontalAlign="Left" />
                                        <HeaderStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
                                    <asp:BoundField DataField="FECHA" HeaderText="Fecha" HtmlEncode="False" DataFormatString="{0:d}">
                                        <ItemStyle HorizontalAlign="Center" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Imagen">
                                        <ItemTemplate>
                                            <a target="_blank" href=' <%# "../Legal/verImagenNotificacion.aspx?idNotificacion=" & eval("ID_NOTIFICACION") %>'>[Ver] </a>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                </Columns>
                            </asp:GridView>
                            <asp:Label ID="lblNotificacionesEmitidas" runat="server" EnableViewState="False"
                                CssClass="subHeader" />
                        </fieldset>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabSFS" runat="server" HeaderText="Subsidios">
                    <HeaderTemplate>
                        Subsidios
                    </HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <b>Información Cuenta Bancaria</b>
                                </td>
                                <td>&nbsp;&nbsp;
                                </td>
                            </tr>
                            <tr>
                                <td>Numero de Cuenta Bancaria
                                </td>
                                <td>
                                    <asp:Label ID="lblNumeroCuenta" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Tipo de Cuenta
                                </td>
                                <td>
                                    <asp:Label ID="lblTipoCuenta" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>Nombre del Banco
                                </td>
                                <td>
                                    <asp:Label ID="lblEntidadRecaudadora" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>&nbsp;&nbsp;
                                </td>
                                <td>&nbsp;&nbsp;
                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabDocumentos" Visible="true" runat="server" HeaderText="Documentos">
                    <ContentTemplate>
                        <br />
                        <fieldset>
                            <legend>Documentos </legend>
                            <br />
                            <table border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td>
                                        <br />
                                        <asp:HyperLink ID="hplinkDoc" runat="server" Target="_blank" ToolTip="Ver documentos suministrados" CssClass="manito"> 
                                            <img alt="Documento" src="../images/VerDocumentos.jpg" /></asp:HyperLink>
                                    </td>
                                    <td>
                                        <br />
                                        <asp:HyperLink ID="lnkAnexar" runat="server" Target="_blank" ToolTip="Anexar documentos" CssClass="manito"> 
                                            <img alt="Documento" src="../images/AnexarDocumento.jpg" /></asp:HyperLink>
                                    </td>
                                    <td>
                                        <br />
                                        <asp:HyperLink ID="lnkSubir" runat="server" ToolTip="Subir documento nuevo, o  reemplazar existentes" CssClass="manito">
                                            <img alt="Documento" src="../images/SubirDocumento.jpg" /></asp:HyperLink>
                                    </td>
                                </tr>
                            </table>
                            <br />
                        </fieldset>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="tabInformes" runat="server" HeaderText="InformeAuditoria">
                    <HeaderTemplate>
                        Informes Auditoria
                    </HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <fieldset>
                            <legend>Informes Auditoria </legend>
                            <br />
                            <table border="0" cellpadding="0" cellspacing="0" width="100%">
                                <tr>
                                    <td style="text-align: right">Cargar Informe:&nbsp;</td>
                                    <td>
                                        <asp:FileUpload CssClass="input" ID="flInforme" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="text-align: right">Descripcion:&nbsp;</td>
                                    <td>
                                        <asp:TextBox CssClass="input" ID="txtDescripcionInforme" TextMode="MultiLine" Width="400px" Height="100px" runat="server"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: center">
                                        <asp:Button ID="btnLimpiarInforme" runat="server" Text="Limpiar" />&nbsp;  
                                        <asp:Button ID="btnCargarInforme" runat="server" Text="Cargar" OnClientClick="this.disabled=true;" UseSubmitBehavior="false" />
                                    </td>

                                </tr>
                                <tr>
                                    <td colspan="2">
                                        <asp:Label ID="lblMensajeInforme" runat="server" CssClass="error" EnableViewState="False"></asp:Label><br />
                                        <table style="width: 680px" class="tblWithImagen" cellpadding="0" cellspacing="0">
                                            <tr>
                                                <td>
                                                    <asp:GridView ID="gvListadoInformes" runat="server" AutoGenerateColumns="False" Width="680px">
                                                        <Columns>
                                                            <asp:BoundField DataField="Descripcion" HeaderText="Descripcion">
                                                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                                <HeaderStyle HorizontalAlign="Left" />
                                                            </asp:BoundField>
                                                            <asp:BoundField DataField="ULT_FECHA_ACT" HeaderText="Fecha">
                                                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                                                <HeaderStyle HorizontalAlign="Left" />
                                                            </asp:BoundField>
                                                            <asp:TemplateField>
                                                                <ItemStyle HorizontalAlign="Center" />
                                                                <ItemTemplate>

                                                                    <asp:HyperLink NavigateUrl='<%# "VerArchivoInforme.aspx?IdInforme=" & Eval("ID_INFORME")%>' ID="lnkVer" runat="server"
                                                                        Target="_blank" Text="[Ver]">
                                                                    </asp:HyperLink>
                                                                </ItemTemplate>
                                                            </asp:TemplateField>
                                                        </Columns>
                                                    </asp:GridView>
                                                </td>
                                            </tr>
                                        </table>
                                    </td>

                                </tr>
                            </table>
                            <br />
                        </fieldset>
                    </ContentTemplate>

                </ajaxToolkit:TabPanel>

            </ajaxToolkit:TabContainer>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="Tabs$tabInformes$btnCargarInforme" />

        </Triggers>
    </asp:UpdatePanel>
    <div id="dialog" class="dialog" title="Resetear CLASS">
        <asp:UpdatePanel runat="server" ID="updaDiv" ChildrenAsTriggers="true" UpdateMode="Conditional">
            <ContentTemplate>
                <fieldset runat="server" id="fsDatos" style="width: 300px">
                    <p style="text-align: justify; width: 275px">
                        Por razones de seguridad favor introducir la fecha de nacimiento del representante
                        para validar la información:
                    </p>
                    <br />
                    <br />
                    <asp:Label runat="server" ID="lblMensajeReset" ForeColor="Red"></asp:Label>
                    <br />
                    <label for="name">
                        Fecha de Nacimiento</label>
                    <asp:TextBox runat="server" ID="txtFechaNac"></asp:TextBox>
                    <ajaxToolkit:MaskedEditExtender ID="MaskedEditExtender4" runat="server" Mask="99/99/9999"
                        MaskType="Date" TargetControlID="txtFechaNac" CultureDateFormat="DMY" CultureDatePlaceholder="/"
                        CultureName="es-DO" Enabled="True">
                    </ajaxToolkit:MaskedEditExtender>
                    <asp:Button runat="server" ID="btnResetClass" Text="Resetear" />
                </fieldset>
                <fieldset runat="server" id="fsComplete" visible="false" style="width: 300px">
                    <p style="text-align: justify; width: 275px">
                        <asp:Label runat="server" ID="lblMeCorrecto"></asp:Label>
                    </p>
                    <br />
                    <br />
                    <asp:Button runat="server" ID="btnCerrar" Text="Cerrar" />
                </fieldset>
            </ContentTemplate>
        </asp:UpdatePanel>
    </div>
    <br />
    <br />
    <br />
    &nbsp;&nbsp;&nbsp;
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
