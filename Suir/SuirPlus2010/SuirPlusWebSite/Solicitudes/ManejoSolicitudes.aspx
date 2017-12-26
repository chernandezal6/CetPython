<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ManejoSolicitudes.aspx.vb" Inherits="Solicitudes_ManejoSolicitudes" Title="Manejo de Solicitudes - TSS" %>

<%@ Register TagPrefix="uc1" TagName="ucSolicitud" Src="../Controles/ucSolicitud.ascx" %>
<%@ Register Src="../Controles/ucTelefono2.ascx" TagName="ucTelefono2" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="udpConsulta" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Panel ID="pnlBusqueda" runat="server">

                <div align="left" class="header">Manejo de Solicitudes</div>
                <br />
                <table>
                    <tr>
                        <td>

                            <table align="left" id="Table2">

                                <tr>
                                    <td align="left" nowrap="noWrap" width="50%">Nro. Solicitud:</td>
                                    <td align="left" style="width: 50%">Estatus:</td>
                                </tr>
                                <tr>
                                    <td align="left" width="50%">
                                        <asp:TextBox ID="txtIDSolicitud" runat="server" MaxLength="11" Width="100px"></asp:TextBox></td>
                                    <td align="left" style="width: 50%">
                                        <asp:DropDownList ID="ddlEstatus" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList></td>
                                </tr>
                                <tr>
                                    <td align="left" width="50%">Provincia:</td>
                                    <td align="left" style="width: 50%">Tipo de Solicitud:</td>
                                </tr>
                                <tr>
                                    <td align="left" width="50%">
                                        <asp:DropDownList ID="ddlProvincia" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList></td>
                                    <td align="left" style="width: 50%">

                                        <asp:DropDownList ID="ddlTipo" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList>

                                    </td>
                                </tr>
                                <tr>
                                    <td align="left">Cant. Registros:</td>
                                    <td align="left" style="width: 50%"></td>
                                </tr>
                                <tr>
                                    <td align="left">
                                        <asp:DropDownList ID="ddlCantRegistros" runat="server" CssClass="dropDowns">
                                            <asp:ListItem Selected="True">25</asp:ListItem>
                                            <asp:ListItem>50</asp:ListItem>
                                            <asp:ListItem>100</asp:ListItem>
                                            <asp:ListItem>150</asp:ListItem>
                                        </asp:DropDownList></td>
                                    <td align="left" style="width: 50%">
                                        <asp:Button ID="btnConsultar" runat="server" Text="Mostrar Registros"></asp:Button></td>
                                </tr>
                                <tr>
                                    <td align="center" colspan="2" rowspan="3">
                                        <asp:Label CssClass="error" ID="lblMensaje" runat="server" EnableViewState="False"></asp:Label></td>
                                </tr>
                            </table>


                        </td>
                    </tr>
                </table>
            </asp:Panel>
            <table>
                <tr>
                    <td style="width: 590px">

                        <asp:GridView ID="gvSolicitudes" runat="server" CssClass="list" AutoGenerateColumns="False" CellPadding="3">
                            <Columns>
                                <asp:BoundField DataField="ID_SOLICITUD" HeaderText="Solicitud">
                                    <ItemStyle HorizontalAlign="Center"></ItemStyle>
                                </asp:BoundField>
                                <asp:BoundField DataField="tipo_solicitud" HeaderText="Tipo Solicitud">
                                    <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Descripcion_Via" HeaderText="V&#237;a"></asp:BoundField>
                                <asp:BoundField DataField="Provincia" HeaderText="Provincia">
                                    <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Comentarios" HeaderText="Comentarios">
                                    <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField Visible="False" DataField="descripcion_oficina" HeaderText="Oficina Entrega"></asp:BoundField>
                                <asp:BoundField DataField="Fecha_Registro" HeaderText="Fecha Registro" DataFormatString="{0:d}" HtmlEncode="False">
                                    <HeaderStyle Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbtnVer" runat="server" CausesValidation="false" CommandName="Ver" CommandArgument='<%#Eval("ID_SOLICITUD")%>' Text="[Ver]"></asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                        <td>
                </tr>
            </table>
          
        </ContentTemplate>
        <Triggers>
            <asp:AsyncPostBackTrigger ControlID="btnConsultar" EventName="Click" />
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

