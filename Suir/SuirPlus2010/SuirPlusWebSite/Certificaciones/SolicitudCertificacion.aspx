<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SolicitudCertificacion.aspx.vb" Inherits="Certificaciones_SolicitudCertificacion" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <style>
        .TituloDes
        {
            font-family: Verdana, Tahoma, Arial;
            font-size: 16px;
            font-weight: bold;
            color: #006699;
        }

        .Pad
        {
            padding: 10px;
        }

        .Des
        {
            font-family: Tahoma, Verdana, Arial;
            font-size: 13px;
        }
    </style>

    <asp:HiddenField ID="hdTipoCertificacion" runat="server" />
    <h2 class="header">Solicitud de Certificaciones
    </h2>

    <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
    <asp:Panel ID="pnlInfo" runat="server" Visible="false">
        <table class="td-content" style="width: 300px">
            <tr>
                <td>Introduzca Rnc:</td>
                <td>
                    <asp:TextBox ID="txtRnc" runat="server" Width="157px"></asp:TextBox></td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: right">
                    <asp:Button ID="btnRnc" runat="server" Text="Buscar" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" />
                </td>

            </tr>
        </table>

    </asp:Panel>


    <asp:Panel ID="pnlCertificaciones" runat="server" Visible="false">
        <table class="td-content" style="width: 750px">
            <tr>
                <td>
                    <asp:GridView ID="gvSolicitud" runat="server" AutoGenerateColumns="false" Style="width: 750px">
                        <Columns>
                            <asp:TemplateField>
                                <ItemTemplate>
                                    <asp:RadioButton ID="rdCertificacion" GroupName="Lista" runat="server" AutoPostBack="true" OnCheckedChanged="rdTipo_CheckedChanged" />
                                </ItemTemplate>
                                <ItemStyle HorizontalAlign="Center" />
                            </asp:TemplateField>
                            <asp:BoundField DataField="ID_TIPO_CERTIFICACION" HeaderText="ID" />
                            <asp:TemplateField HeaderText="Certificación" ItemStyle-CssClass="Pad">
                                <ItemTemplate>
                                    <asp:Label ID="lblTipoCertificacion" runat="server" Text='<%# Eval("TIPO_CERTIFICACION_DES")%>' CssClass="TituloDes"></asp:Label>
                                    <br />
                                    <asp:Label ID="lblDescripcion" runat="server" Text='<%# Eval("DESCRIPCION")%>' CssClass="Des"></asp:Label>
                                </ItemTemplate>

                            </asp:TemplateField>

                        </Columns>
                    </asp:GridView>
                </td>

            </tr>
            <tr>
                <td colspan="2" style="text-align: right">
                    <asp:Button ID="btnSiguiente" runat="server" Text="Siguiente" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" />

                </td>

            </tr>
        </table>
    </asp:Panel>
</asp:Content>

