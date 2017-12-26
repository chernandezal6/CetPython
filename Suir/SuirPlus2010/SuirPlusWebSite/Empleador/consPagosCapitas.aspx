<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consPagosCapitas.aspx.vb" Inherits="Empleador_consPagosCapitas" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc3" %>
<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="upReporteSolicitudes" runat="server">
        <ContentTemplate>
            <div>
                <span style="font-size: 20px">
                    <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
                    <div class="header">
                        <br />
                        Devolución de pagos Per Cápita de adicionales</div>
                </span>
       
                <br />
                <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label></div>
            <table>
                <tr>
                    <td>
                        <table class="td-content">
                            <tr>
                                <td colspan="4">
                                Filtrar Devoluciones
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Filtro:
                                </td>
                                <td>
                                    <asp:DropDownList ID="ddlFiltro" runat="server" CssClass="dropDowns">
                                    </asp:DropDownList>
                                </td>
                                <td>
                                <asp:TextBox ID="txtFiltro" runat="server"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:Button ID="btnFiltrar" runat="server" Text="Buscar" />
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Panel ID="pnlInfoEncabezado" runat="server" Visible="false">
                            <fieldset>
                                <legend>Pagos&nbsp; Per Cápita </legend>
                                <br />
                                <table>
                                    <tr>
                                        <td>
                                            <asp:GridView ID="gvPagosExceso" runat="server" HorizontalAlign="Left" AutoGenerateColumns="False"
                                                Width="962px" ShowFooter="True">
                                                <Columns>
                                                    <asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia Credito(1)">
                                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="ID_REFERENCIA_EXCESO" HeaderText="Referencia pagada Per Cápita(2)">
                                                        <ItemStyle HorizontalAlign="Center" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Período">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("Periodo")) %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="Estatus" HeaderText="Status">
                                                        <HeaderStyle Wrap="False" />
                                                        <ItemStyle Width="70px" HorizontalAlign="Center" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Fecha_Pago" HeaderText="Fecha Pago">
                                                        <HeaderStyle Wrap="False" />
                                                        <ItemStyle Wrap="False" HorizontalAlign="Center" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Cédula Titular">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# FormateaCedula(eval("Cedula_Titular")) %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="Nombre_Titular" HeaderText="Nombre Titular">
                                                        <ItemStyle Wrap="False" />
                                                    </asp:BoundField>
                                                    <asp:TemplateField HeaderText="Cédula Dependiente">
                                                        <ItemTemplate>
                                                            <asp:Label ID="Label2" runat="server" Text='<%# FormateaCedula(eval("Cedula_Dependiente")) %>'></asp:Label>
                                                        </ItemTemplate>
                                                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                                    </asp:TemplateField>
                                                    <asp:BoundField DataField="Nombre_Dependiente" HeaderText="Nombre Dependiente">
                                                        <ItemStyle Wrap="False" />
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="Monto" HeaderText="Monto" DataFormatString="{0:c}">
                                                        <HeaderStyle Wrap="False" />
                                                        <ItemStyle Wrap="False" />
                                                    </asp:BoundField>
                                                </Columns>
                                                <FooterStyle Height="25px" HorizontalAlign="Center" VerticalAlign="Bottom" Wrap="False" />
                                            </asp:GridView>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table class="td-content">
                                                <tr>
                                                    <td colspan="2">
                                                        Leyenda:
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        (1) - Referencia donde se le esta devolviendo el monto pagado.
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td colspan="2">
                                                        (2) - Referencia donde fue cobrado el per cápita adicional.
                                                    </td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                </table>
                            </fieldset>
                            <br />
                            <br />
                        </asp:Panel>
                    </td>
                </tr>
            </table>
            <br />
        </ContentTemplate>
             <Triggers>
            <asp:PostBackTrigger ControlID="ucExportarExcel1" />
        </Triggers>

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
