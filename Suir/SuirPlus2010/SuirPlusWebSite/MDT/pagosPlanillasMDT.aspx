<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="pagosPlanillasMDT.aspx.vb" Inherits="MDT_pagosPlanillasMDT" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <% If 1 = 2 Then
    %>
    <script src="../Script/Util.js" type="text/javascript"></script>
    <script src="../Script/jquery-1.5.2-vsdoc.js" type="text/javascript"></script>
    <%
    End If
    %>
    <script type="text/javascript">
        $(function () {


        });

        function SobreEscribirMensaje() { Util.MostrarMensaje("OK", "Pago procesado correctamente.<br /> Estamos re-direccionándolo a la página de Notificaciones"); }

        function OcultarObjetos() {
            $("#TbPINPagos").hide();
            $("#planillaPagos").hide();
            $("#TrProcesarFactura").hide();
            $("#TrProcesar").hide();
            $("#TbPlanillasMDT").hide();

        } 

    </script>
    <style>
        .lbDinero
        {
            font-size: 10pt;
            font-weight: bold;
        }
        #wrap
        {
            width: 390px;
            position: absolute;
            left: 50%;
            top: 50%;
        }
        #DivMensaje
        {
            text-align: center;
        }
        
        .Horizontal
        {
            text-align: left;
            width: 50px;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:ScriptManager ID="ScriptManager1" runat="server">
    </asp:ScriptManager>
    <asp:UpdatePanel ID="upPagosPlanillas" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <span class="header">Pagos planillas del Ministerio de Trabajo</span>
            <br />
            <br />
            <div id="contenido" runat="server">
                <table id="TbPlanillasMDT" style="background-color: #F8FBFC; border: 1px solid #DBEAF3;">
                    <tr>
                        <td class="labelSubtitulo" style="text-align: left; font-size: 10pt; font-weight: bold;">
                            Planillas del Ministerio de Trabajo
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <span style="font-weight: bold; color: #006699;">Total planillas Seleccionadas:</span>&nbsp;
                            <asp:Label ID="lbTotalFacturas" runat="server" CssClass="lbDinero" />
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <asp:GridView ID="gvPlanillasMDT" runat="server" ShowFooter="True" AutoGenerateColumns="False"
                                Width="600px">
                                <Columns>
                                    <%--                        <asp:TemplateField HeaderText="Nro. Referencia" ItemStyle-HorizontalAlign="Center">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkFacturas" runat="server" Text='<%# Eval("id_referencia")%>'
                                    Checked="true" AutoPostBack="true" />
                            </ItemTemplate>
                        </asp:TemplateField>--%>
                                    <asp:BoundField DataField="id_referencia" HeaderText="Nro. Referencia">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="status" HeaderText="Status">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:TemplateField HeaderText="Per&#237;odo">
                                        <ItemTemplate>
                                            <asp:Label ID="Label6" runat="server" Text='<%# FormatearPeriodo(Eval("periodo_factura")) %>'></asp:Label>
                                        </ItemTemplate>
                                        <ItemStyle HorizontalAlign="Center" />
                                        <HeaderStyle HorizontalAlign="Center" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="FECHA_EMISION" HeaderText="Emisi&#243;n" DataFormatString="{0:d}"
                                        HtmlEncode="False">
                                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="total_general" HeaderText="Total" HtmlEncode="False" DataFormatString="{0:n}">
                                        <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                        <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                    </asp:BoundField>
                                </Columns>
                                <FooterStyle Font-Bold="True" />
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <br />
                <table id="TbPINPagos">
                    <tr>
                        <td>
                            Recibo:
                        </td>
                        <td>
                            <asp:TextBox ID="txtPIN" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Código Aprobación:
                        </td>
                        <td>
                            <asp:TextBox ID="txtAutorizarPIN" runat="server" Width="70px" MaxLength="10"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td>
                            Representación Local:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlRepresentacionLocal" runat="server" CssClass="dropDowns"
                                Width="250px">
                            </asp:DropDownList>
                        </td>
                        <td>
                            <asp:Button ID="btnAutorizarPIN" runat="server" CssClass="botones" Text="Validar PIN" />
                        </td>
                    </tr>
                </table>
                <br />
                <br />
                <table id="planillaPagos" style="background-color: #F8FBFC; border: 1px solid #DBEAF3;">
                    <tr>
                        <td class="labelSubtitulo" style="text-align: left; font-size: 10pt; font-weight: bold;">
                            Balance de Creditos(PIN)
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right">
                            <span style="font-weight: bold; color: #006699;">Total PIN Seleccionados:</span>&nbsp;
                            <asp:Label ID="lbTotalPIN" runat="server" CssClass="lbDinero"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: center">
                            <asp:GridView ID="gvPIN" AutoGenerateColumns="False" runat="server" Width="600px">
                                <Columns>
                                    <asp:TemplateField HeaderText="Nro.Recibo" ItemStyle-CssClass="Horizontal">
                                        <%--ItemStyle-HorizontalAlign="Justify" ItemStyle-Width="50px" >--%>
                                        <ItemTemplate>
                                            <asp:CheckBox ID="chkPIN" runat="server" Text='<%# Eval("NRO_RECIBO")%>' OnCheckedChanged="chkPIN_CheckedChanged"
                                                AutoPostBack="true" />
                                        </ItemTemplate>
                                        <ItemStyle CssClass="Horizontal" />
                                    </asp:TemplateField>
                                    <asp:BoundField DataField="ID_AJUSTE" HeaderText="AJUSTE"></asp:BoundField>
                                    <asp:BoundField DataField="CODIGO_APROBACION" HeaderText="Nro. Aprobación"></asp:BoundField>
                                    <asp:BoundField DataField="DESCRIPCION" HeaderText="Representación Local">
                                        <ItemStyle Width="200px" HorizontalAlign="Left"></ItemStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="MONTO" HeaderText="Monto" DataFormatString="{0:C}">
                                        <ItemStyle HorizontalAlign="Right" Width="100px"></ItemStyle>
                                        <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                    </asp:BoundField>
                                    <asp:BoundField DataField="BALANCE" HeaderText="Balance Actual" DataFormatString="{0:C}">
                                        <ItemStyle HorizontalAlign="Right" Width="100px"></ItemStyle>
                                        <FooterStyle HorizontalAlign="Right"></FooterStyle>
                                    </asp:BoundField>
                                </Columns>
                            </asp:GridView>
                        </td>
                    </tr>
                </table>
                <br />

                <table>
                    <tr>
                        <td>
                            Observación:
                        </td>
                        <td>
                            <asp:TextBox ID="txtObservacion" runat="server" Width="520px" Height="45px" TextMode="multiline"
                                MaxLength="500"></asp:TextBox>
                        </td>
                    </tr>
                </table>
                <div>
                    <table width="600px">
                        <tr id="TrProcesarFactura">
                            <td colspan="2" style="text-align: right;">
                                <asp:Button ID="btnProcesarFactura" Text="Procesar" CssClass="botones" runat="server" />
                            </td>
                        </tr>
                        <tr id="TrProcesar">
                            <td>
                                <br />
                                <asp:Label ID="lblMensajeError" Style="font-size: 15pt; font-weight: bold;" runat="server"
                                    CssClass="error"></asp:Label>
                                <input type="button" id="MensajeFinal" onclick="SobreEscribirMensaje();" style="visibility: hidden;" />
                            </td>
                        </tr>
                    </table>
                </div>
            </div>
            <div>
                <div id="DivMensaje">
                    <br />
                    <br />
                    <br />
                    <br />
                    <asp:Label ID="lbSuccess" runat="server" CssClass="labelData" Style="font-size: 12pt;"></asp:Label><br />
                    <asp:Button ID="btnProcesar" runat="server" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover"
                        Text="Volver" />
                </div>
            </div>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnAutorizarPIN" />
            <asp:PostBackTrigger ControlID="btnProcesarFactura" />
            <asp:PostBackTrigger ControlID="btnProcesar" />
        </Triggers>
    </asp:UpdatePanel>
    <asp:HiddenField ID="Planilla" runat="server" />
</asp:Content>
