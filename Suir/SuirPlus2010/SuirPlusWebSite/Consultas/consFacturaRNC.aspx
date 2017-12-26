<%@ Page AutoEventWireup="false" CodeFile="consFacturaRNC.aspx.vb" Inherits="Consultas_consFacturaRNC"
    Language="VB" MasterPageFile="~/SuirPlus.master" Title="Consulta de Notificaciones por RNC" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div class="header">
        Notificaciones por RNC</div>
    <br />
    <asp:UpdatePanel ID="up" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table cellpadding="1" cellspacing="0" class="td-content" style="width: 400px">
                <tr>
                    <td style="width: 25%; height: 5px">
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        RNC/Cédula:
                    </td>
                    <td>
                        <asp:TextBox ID="txtRnc" runat="server" EnableViewState="False" MaxLength="11" AutoPostBack="True"
                            OnTextChanged="txtRnc_TextChanged"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRnc"
                            CssClass="error" Display="Dynamic" ErrorMessage="*" SetFocusOnError="True" ToolTip="Debe especificar un RNC/Cédula">*</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" ControlToValidate="txtRNC"
                            Display="Dynamic" EnableViewState="False" ErrorMessage="RNC o Cédula invalido."
                            ValidationExpression="^(\d{9}|\d{11})$" CssClass="error" SetFocusOnError="True"></asp:RegularExpressionValidator>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Concepto:
                    </td>
                    <td>
                        <asp:DropDownList ID="drpConcepto" runat="server" CssClass="dropDowns" AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr id="trNomina" runat="server">
                    <td align="right">
                        Nómina:
                    </td>
                    <td>
                        <asp:DropDownList ID="drpNominas" runat="server" CssClass="dropDowns">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Estatus:
                    </td>
                    <td>
                        <asp:DropDownList ID="drpEstatus" runat="server" CssClass="dropDowns">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                    </td>
                    <td>
                        <div style="height: 3px;">
                        </div>
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
                        <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" Text="Limpiar" />
                    </td>
                </tr>
                <tr>
                    <td align="center" colspan="2" style="height: 5px">
                    </td>
                </tr>
            </table>

        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <asp:UpdatePanel ID="upEncabezado" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Panel ID="pnlResumen" runat="server" Visible="False">
                <table cellpadding="2" cellspacing="0" class="tableTotales" width="450">
                    <tr>
                        <td class="TDTotales" style="width: 28%">
                            Razón Social
                        </td>
                        <td class="TDTotales" colspan="5">
                            <asp:HyperLink ID="lnkRazonSocial" runat="server" CssClass="labelData"></asp:HyperLink>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Nombre Comercial
                        </td>
                        <td colspan="5">
                            <asp:HyperLink ID="lnkNombreComercial" runat="server" CssClass="labelData"></asp:HyperLink>
                        </td>
                    </tr>
                    <tr>
                        <td class="TDTotales">
                            Cantidad de Ref.
                        </td>
                        <td class="TDTotales" style="width: 20%">
                            <asp:Label ID="lblTotalRef" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                        <td class="TDTotales" style="width: 3%">
                            Estatus
                        </td>
                        <td class="TDTotales" style="width: 5%">
                            <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                        <td class="TDTotales" align="right">
                            Tipo Ref.
                        </td>
                        <td class="TDTotales">
                            <asp:Label ID="lblTipoRef" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Total Importe
                        </td>
                        <td align="right">
                            <asp:Label ID="lblImporte" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                        <td>
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDTotales">
                            Total Recargo
                        </td>
                        <td class="TDTotales" align="right">
                            <asp:Label ID="lblRecargo" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                        <td class="TDTotales">
                        </td>
                        <td align="right" class="TDTotales">
                        </td>
                        <td align="right" class="TDTotales">
                        </td>
                        <td align="right" class="TDTotales">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Total Intereses
                        </td>
                        <td align="right">
                            <asp:Label ID="lblIntereses" runat="server" CssClass="labelData"></asp:Label>
                        </td>
                        <td>
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                        <td align="right">
                        </td>
                    </tr>
                    <tr>
                        <td class="TDTotalGral">
                            Total Gral.
                        </td>
                        <td class="TDTotalGral" align="right" style="white-space: nowrap;">
                            <asp:Label ID="lblTotalGeneral" runat="server"></asp:Label>
                        </td>
                        <td class="TDTotalGral">
                        </td>
                        <td align="right" class="TDTotalGral">
                        </td>
                        <td align="right" class="TDTotalGral">
                        </td>
                        <td align="right" class="TDTotalGral">
                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="10pt"></asp:Label>
          </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <asp:UpdatePanel ID="upNotificaciones" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table cellpadding="0" cellspacing="0" style="width: 80%">
                <tr>
                    <td>
                        <ajaxToolkit:TabContainer ID="tcNp" runat="server" ActiveTabIndex="0" Width="100%"
                            Visible="false">
                            <ajaxToolkit:TabPanel ID="TabPanel1" TabIndex="0" runat="server" HeaderText="Todas Las NP">
                                <ContentTemplate>
                                    <table>
                                        <tr>
                                            <td>
                                                <asp:GridView ID="gvNotificaciones" runat="server" AutoGenerateColumns="False" CellPadding="2">
                                                    <Columns>
                                                        <asp:BoundField DataField="ID_Referencia" HeaderText="Referencia">
                                                            <ItemStyle Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="id_tipo_factura" HeaderText="Tipo Ref">
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Status" HeaderText="Estatus">
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Nomina_Des" HeaderText="N&#243;mina">
                                                            <ItemStyle Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="tipo_nomina" HeaderText="Tipo">
                                                            <ItemStyle Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Periodo_Factura" HeaderText="Per&#237;odo">
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="fecha_emision" DataFormatString="{0:d}" HeaderText="Emisi&#243;n"
                                                            HtmlEncode="False">
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="fecha_limite_acuerdo_pago" HeaderText="L&#237;mite Acuerdo"
                                                            DataFormatString="{0:d}" HtmlEncode="False">
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="fecha_pago" DataFormatString="{0:d}" HeaderText="Fecha Pago"
                                                            HtmlEncode="False">
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Total_Importe" DataFormatString="{0:n}" HeaderText="Importe"
                                                            HtmlEncode="False">
                                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Total_Recargos_Factura" DataFormatString="{0:n}" HeaderText="Recargo"
                                                            HtmlEncode="False">
                                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Total_Interes_Factura" DataFormatString="{0:n}" HeaderText="Intereses"
                                                            HtmlEncode="False">
                                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="total_general" DataFormatString="{0:n}" HeaderText="Total"
                                                            HtmlEncode="False">
                                                            <ItemStyle HorizontalAlign="Right" Wrap="False" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="Detalles" HeaderText="Resumen">
                                                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                        </asp:BoundField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                        <asp:Panel ID="pnlNavigation" runat="server" Visible="false">
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
                                                <td>
                                                    Total de notificaciones
                                                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                                                </td>
                                            </tr>
                                        </asp:Panel>
                                    </table>
                                </ContentTemplate>
                            </ajaxToolkit:TabPanel>
                        </ajaxToolkit:TabContainer>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
