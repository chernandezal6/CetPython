<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consPerCapitaExceso.aspx.vb" Inherits="Consultas_consPerCapitaExceso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script type="text/javascript">

        if (top != self) top.location.replace(location.href); 
    
    </script>
    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <div class="header">
        Devolución de pagos Per Cápita de adicionales</div>
    <br />
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

    </script>
    <table>
        <tr>
            <td>
                <table border="0" cellpadding="1" cellspacing="1" class="consultaTabla" style="font-size: 13pt; color: #006699; font-family: Verdana"
                    width="370">
                    <tr>
                        <td>
                            <table id="Table1" cellpadding="0" cellspacing="0" class="td-content">
                                <tr>
                                    <td style="width: 455px">&nbsp;
                                    </td>
                                </tr>
                                <tr>
                                    <td valign="top" style="text-align: center; width: 455px;">No de Cédula: (sin guiones)
                                    </td>
                                </tr>
                                <tr>
                                    <td style="height: 12px; text-align: center; width: 455px;" valign="top">
                                        <asp:TextBox onKeyPress="checkNum()" ID="txtnodocumento" runat="server" MaxLength="11"></asp:TextBox><asp:RegularExpressionValidator
                                            ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtnodocumento"
                                            Display="Dynamic" ErrorMessage="Debe ser numérico el valor" ValidationExpression="\d*"></asp:RegularExpressionValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="center" style="width: 455px">
                                        <br />
                                        <asp:Button ID="btBuscarRef" runat="server" Enabled="True" EnableViewState="False"
                                            Text="Buscar" />
                                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                    </td>
                                </tr>
                            </table>
                            <asp:Label ID="lblError" runat="server" CssClass="error" Font-Size="8pt" Visible="False"></asp:Label>
                        </td>
                    </tr>
                </table>
                <br />
                <asp:Panel ID="pnlInfo" runat="server" Visible="False" Width="543px">
                    <table border="0" cellpadding="0" cellspacing="0" id="TABLE2" runat="server" visible="true"
                        width="370">
                        <tr>
                            <td colspan="2" id="TD1" runat="server">
                                <asp:Label ID="Label8" runat="server" Text="Datos de la Persona" CssClass="subHeader"
                                    Font-Size="Small"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 106px">
                                <asp:Label ID="Label5" runat="server" Text="Nombre:" Font-Size="Small"></asp:Label>
                            </td>
                            <td style="width: 416px">
                                <asp:Label ID="lblNombre" runat="server" Font-Bold="True" Font-Size="Small" CssClass="subHeader"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 106px">
                                <asp:Label ID="Label6" runat="server" Text="Cédula:" Font-Size="Small"></asp:Label>
                            </td>
                            <td style="width: 416px">
                                <asp:Label ID="lblCedula" runat="server" Font-Bold="True" Font-Size="Small" CssClass="subHeader"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </asp:Panel>
                <br />
                <div style="width: 1082px;">
                    <asp:Panel ID="pnlPagos" runat="server" Visible="False" Width="1081px">
                        <asp:Label ID="Label1" runat="server" Font-Bold="True" Font-Size="Small" EnableViewState="False"
                            Height="20px" Width="256px" CssClass="subHeader">Detalle de los Pagos</asp:Label><br />
                        <asp:GridView ID="gvPagos" runat="server" HorizontalAlign="Left" Width="1082px" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="Razon_Social" HeaderText="Razón Social">
                                    <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia Pagada(1)">
                                    <HeaderStyle Wrap="False" />
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
                                        <asp:Label ID="Label3" runat="server" Text='<%# FormateaCedula(eval("Cedula_Titular")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="Nombre_Titular" HeaderText="Nombre Titular">
                                    <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Cédula Dependiente">
                                    <ItemTemplate>
                                        <asp:Label ID="Label4" runat="server" Text='<%# FormateaCedula(eval("Cedula_Dependiente")) %>'></asp:Label>
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
                    </asp:Panel>
                </div>
            </td>
        </tr>


        <tr>
            <td>
                <table id="Leyenda" class="td-content" runat="server" visible="false">
                    <tr>
                        <td colspan="2">Leyenda:
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2">(1) - Referencia donde se le esta devolviendo el monto pagado.
                        </td>
                    </tr>
                </table>

            </td>
        </tr>
    </table>

</asp:Content>
