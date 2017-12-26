<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="HistoricoSalariosAFP.aspx.vb" Inherits="Externos_HistoricoSalariosAFP" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">




    <div class="header">
        Consulta de Histórico de Salarios 
        <br />
        <br />
    </div>

    <div id="divDatos" runat="server">
        <table class="td-content" style="width: 550px">

            <tr id="trCedula" runat="server">
                <td>Cedula Empleado:</td>
                <td>
                    <asp:TextBox ID="txtCedula" runat="server" MaxLength="11"></asp:TextBox></td>
            </tr>
            <tr id="trDocumentos" runat="server">
                <td>Formulario de solicitud:</td>
                <td>
                    <asp:FileUpload ID="flCargarImagenCert" runat="server" />
                </td>
            </tr>
            <tr>
                <td colspan="2">
                    <div style="text-align: right">
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" Enabled="true" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" />

                    </div>
                     <td >
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" Enabled="true" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" />
                </td>

            </tr>

        </table>
    </div>
    <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>


    <br />
    <br />
    <br />


    <div id="divConsultasRealizadas" style="width: 500px;" visible="false" runat="server">
        <fieldset>
            <legend style="text-align: left">Resultado Consulta</legend>
            <br />
            <asp:Label ID="lblErrorConsultas" runat="server" CssClass="error" EnableViewState="False"
                Font-Size="10pt"></asp:Label>
            <asp:GridView ID="gvConsultasRealizadas" runat="server" AutoGenerateColumns="False" SortedAscendingCellStyle-Font-Size="Medium" CellPadding="6"
                Style="width: 500px;">
                <Columns>
                    <asp:BoundField DataField="ID" HeaderText="Código Consulta">
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Cédula">
                        <ItemTemplate>
                            <asp:Label ID="Label2" runat="server" Text='<%# formateaCedula(Eval("no_documento"))%>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="nombres" HeaderText="Nombre Completo">
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="aprobado" HeaderText="Estatus">
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="center" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="fecha_solicitud" HeaderText="Fecha Solicitud"  DataFormatString="{0:d}">
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="center" Wrap="False" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="">
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemTemplate>
                            <asp:LinkButton ID="lbResultadoConsulta" runat="server" CommandName="VerResultado" CommandArgument='<%# Eval("ID") & "|" & Eval("no_documento")%>'>Ver Resultado</asp:LinkButton>
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
            <table width="150%">
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
        </fieldset>
        <br />
        <br />
    </div>

    <div style="float: left; width: 400px;" id="divInfo" runat="server" visible="false">
                    <fieldset>
                        <legend style="text-align: left">Información general</legend>
                         <br />
                        <table width:"100%">
                            <tr>
                                <td>
                                    AFP:
                                </td>
                                <td>
                                    <asp:Label ID="lblAfp" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td nowrap="nowrap">
                                    Nombres Ciudadano:
                                </td>
                                <td>
                                    <asp:Label ID="lblNombres" runat="server" CssClass="labelData" Text=''></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Fecha Solicitud:
                                </td>
                                <td>
                                    <asp:Label ID="lblFechaSolicitud" runat="server" CssClass="labelData" Text=''></asp:Label>
                                </td>
                            </tr>
                           
                        </table>
                    </fieldset>
                    <br />
                    <br />
                    <br />
                </div>

    <br />
    <br />
    <br />
         <br />
    <div id="divHistoricoSalarios" style="width: 500px;" visible="false" runat="server">
        <fieldset>
            <legend style="text-align: left">Histórico de Salarios</legend>
            <br />
            <asp:Label ID="lblErrorHistoricos" runat="server" CssClass="error" EnableViewState="False"
                Font-Size="10pt"></asp:Label>
            <asp:GridView ID="gvHistoricoSalarios" runat="server" AutoGenerateColumns="False" SortedAscendingCellStyle-Font-Size="Medium" CellPadding="6"
                Style="width: 500px;">
                <Columns>
                     <asp:TemplateField HeaderText="Periodo Factura">
                        <ItemTemplate>
                            <asp:Label ID="lblPeriodoFactura" runat="server" Text='<%# formateaPeriodo(Eval("periodo_factura"))%>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Periodo Aplicación">
                        <ItemTemplate>
                            <asp:Label ID="lblPeriodoAplicación" runat="server" Text='<%# formateaPeriodo(Eval("periodo_aplicacion"))%>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                    <asp:TemplateField HeaderText="Salario">
                        <ItemTemplate>
                            <asp:Label ID="lblSalario" runat="server" Text='<%# formateaSalario(Eval("salario_ss"))%>'></asp:Label>
                        </ItemTemplate>
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:TemplateField>
                    <asp:BoundField DataField="fecha_pago" HeaderText="Fecha de pago"  DataFormatString="{0:d}">
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemStyle HorizontalAlign="center" Wrap="False" />
                    </asp:BoundField>
                   </Columns>
            </asp:GridView>
            <table width="150%">
                <tr>
                    <td>
                        <asp:LinkButton ID="btnLnkFirstPage2" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                            CommandName="First" OnCommand="NavigationLink_Click2"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage2" runat="server" CssClass="linkPaginacion"
                                    Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_Click2"></asp:LinkButton>&nbsp;
                                Página [<asp:Label ID="lblCurrentPage2" runat="server"></asp:Label>] de
                                <asp:Label ID="lblTotalPages2" runat="server"></asp:Label>&nbsp;
                                <asp:LinkButton ID="btnLnkNextPage2" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                    CommandName="Next" OnCommand="NavigationLink_Click2"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage2" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                    CommandName="Last" OnCommand="NavigationLink_Click2"></asp:LinkButton>&nbsp;
                                <asp:Label ID="lblPageSize2" runat="server" Visible="False"></asp:Label>
                        <asp:Label ID="lblPageNum2" runat="server" Visible="False"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <br />
                        Total de registros&nbsp;
                                <asp:Label ID="lblTotalRegistros2" CssClass="error" runat="server" />
                    </td>
                </tr>
            </table>
        </fieldset><br />
&nbsp;</div>
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
</asp:Content>

