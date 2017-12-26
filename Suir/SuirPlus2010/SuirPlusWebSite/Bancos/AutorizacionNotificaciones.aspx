<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="AutorizacionNotificaciones.aspx.vb" Inherits="Bancos_AutorizacionNotificaciones" title="Autorización de Referencias" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <asp:Label ID="lblTitulo" runat="server" CssClass="header" Text="Autorización de Referencias"></asp:Label><br />
    <br />
    <table id="Table1" border="0" cellpadding="1" cellspacing="1">
        <tr>
            <td>
                <asp:Label ID="lbltxtRNC" runat="server">RNC / Cédula:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtRNC" runat="server" MaxLength="11"></asp:TextBox></td>
            <td rowspan="3">
                <img id="imgLogo" runat="server" /></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblReferencia" runat="server">Número de Referencia:</asp:Label>
            </td>
            <td>
                <asp:TextBox ID="txtReferencia" runat="server" MaxLength="16"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center">
                <asp:Button
                    ID="btBuscar" runat="server" EnableViewState="False" Text="Buscar" Width="165px" /></td>
        </tr>
        <tr>
            <td colspan="3">
                <asp:Label ID="lblMensajeError" runat="server" CssClass="error" EnableViewState="False"
                    Font-Bold="True" Font-Size="Medium" Visible="False"></asp:Label>
            </td>
        </tr>
    </table>
    <br />
    <asp:Panel ID="pnlInfoEmp" runat="server" Visible=false>
    <table id="Table2" border="0" cellpadding="1" cellspacing="1" class="td-content">
        <tr>
            <td>
                <asp:Label ID="label8" runat="server" >Razon Social:</asp:Label>
            </td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True" ></asp:Label></td>
        </tr>
        <tr>
            <td>
                <asp:Label ID="lblTXTNombreComercial" runat="server" >Nombre Comercial:</asp:Label>
            </td>
            <td>
                <asp:Label ID="lblNombreComercial" runat="server" Font-Bold="True" ></asp:Label></td>
        </tr>
    </table>
    </asp:Panel>
    <br />
    <asp:Panel ID="pnlSDSS" runat="server" Visible="False">
        <asp:Label ID="lblTSS" runat="server" CssClass="subHeader" Text="Notificaciones de la Seguridad Social" Width="362px"></asp:Label>
    <asp:GridView ID="dgFacturas" runat="server" AutoGenerateColumns="False" EnableTheming="True" Width="421px" >
        <Columns>
            <asp:BoundField DataField="referencia" HeaderText="Nro. Referencia">
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="Nomina" HeaderText="Nomina" >
                <ItemStyle Wrap="False" />
            </asp:BoundField>
            <asp:BoundField DataField="Periodo" HeaderText="Periodo">
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="Total_General" DataFormatString="{0:c}" HeaderText="Total"
                HtmlEncode="False">
                <ItemStyle HorizontalAlign="Right" />
            </asp:BoundField>
            <asp:TemplateField>
                <ItemStyle HorizontalAlign="Center" />
                <ItemTemplate>
                    <asp:Button ID="btAutorizar" runat="server" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.referencia") %>'
                        CommandName="SelectCommand" Text="Autorizar Referencia" Visible='<%# EvaluarBoton(DataBinder.Eval(Container, "DataItem.Puede_Pagar")) %>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    </asp:Panel>
    <asp:Panel ID="pnlISR" runat="server" Visible="False" Width="408px" >
        <asp:Label ID="lblISR" runat="server" CssClass="subHeader" Text="Liquidaciones de la DGII - ISR" Width="364px"></asp:Label><br />
        <asp:GridView ID="gvISR" runat="server" AutoGenerateColumns="False" EnableTheming="True" Width="421px" >
            <Columns>
                <asp:BoundField DataField="referencia" HeaderText="Nro. Referencia">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="Nomina" HeaderText="Nomina" >
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Periodo" HeaderText="Periodo">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="Total_General" DataFormatString="{0:c}" HeaderText="Total"
                HtmlEncode="False">
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btAutorizar" runat="server" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.referencia") %>'
                        CommandName="SelectCommand" Text="Autorizar Referencia" Visible='<%# EvaluarBoton(DataBinder.Eval(Container, "DataItem.Puede_Pagar")) %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>
    <asp:Panel ID="pnlIR17" runat="server" Visible="False" Width="420px">
        <asp:Label ID="lblIR17" runat="server" CssClass="subHeader" Text="Liquidaciones de la DGII - IR17" Width="363px"></asp:Label><br />
        <asp:GridView ID="gvIR17" runat="server" AutoGenerateColumns="False" EnableTheming="True" Width="421px" >
            <Columns>
                <asp:BoundField DataField="referencia" HeaderText="Nro. Referencia">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="Nomina" HeaderText="Nomina" >
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Periodo" HeaderText="Periodo">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="Total_General" DataFormatString="{0:c}" HeaderText="Total"
                HtmlEncode="False">
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btAutorizar" runat="server" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.referencia") %>'
                        CommandName="SelectCommand" Text="Autorizar Referencia" Visible='<%# EvaluarBoton(DataBinder.Eval(Container, "DataItem.Puede_Pagar")) %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>
    <asp:Panel ID="pnlInfotep" runat="server" Visible="False" Width="376px">
        <asp:Label ID="lblINF" runat="server" CssClass="subHeader" Text="Liquidaciones del INFOTEP" Width="353px"></asp:Label><br />
        <asp:GridView ID="gvINFOTEP" runat="server" AutoGenerateColumns="False" EnableTheming="True" Width="421px" >
            <Columns>
                <asp:BoundField DataField="referencia" HeaderText="Nro. Referencia">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="Nomina" HeaderText="Nomina" >
                    <ItemStyle Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Periodo" HeaderText="Periodo">
                    <ItemStyle HorizontalAlign="Center" />
                </asp:BoundField>
                <asp:BoundField DataField="Total_General" DataFormatString="{0:c}" HeaderText="Total"
                HtmlEncode="False">
                    <ItemStyle HorizontalAlign="Right" />
                </asp:BoundField>
                <asp:TemplateField>
                    <ItemTemplate>
                        <asp:Button ID="btAutorizar" runat="server" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.referencia") %>'
                        CommandName="SelectCommand" Text="Autorizar Referencia" Visible='<%# EvaluarBoton(DataBinder.Eval(Container, "DataItem.Puede_Pagar")) %>' />
                    </ItemTemplate>
                    <ItemStyle HorizontalAlign="Center" />
                </asp:TemplateField>
            </Columns>
        </asp:GridView>
    </asp:Panel>   

</asp:Content>

