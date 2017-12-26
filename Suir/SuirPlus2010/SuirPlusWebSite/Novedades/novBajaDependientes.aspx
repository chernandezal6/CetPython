<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="novBajaDependientes.aspx.vb" Inherits="Novedades_novBajaDependientes" title="Novedades - Baja Dependientes Adicionales" %>

<%@ Register Src="../Controles/ucGridNovPendientes.ascx" TagName="ucGridNovPendientes"
    TagPrefix="uc3" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>

<%@ Register TagPrefix="uc2" TagName="UCCiudadano" Src="../Controles/UCCiudadano.ascx" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="vb" runat="server">
        Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
            Me.PermisoRequerido = 155
				
        End Sub
    </script>
    <uc1:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
        <ContentTemplate>
            <table id="TablePrincipal" cellspacing="1" cellpadding="1" width="630" border="0">
                <tbody>
                    <tr>
                        <td>
                            <table id="TableTitulo" width="630">
                                <tbody>
                                    <tr>
                                        <td style="height: 24px" valign="bottom">
                                            <asp:Label ID="lblTitulo1" runat="server" EnableViewState="False" Visible="true"
                                                CssClass="header"> Bajas de Dependientes Adicionales</asp:Label>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label><br />
                            <br />
                            <table id="TableInfoGeneral" class="td-content" cellspacing="0" cellpadding="0" width="630"
                                border="0">
                                <tbody>
                                    <tr>
                                        <td class="error" align="left" colspan="4" height="7">
                                        </td>
                                    </tr>
                                    <asp:Panel ID="pnlNuevaInfoGeneral" runat="server">
                                    </asp:Panel>
                                    <asp:Panel ID="pnlInfoGeneral" runat="server">
                                    </asp:Panel>
                                    <tr>
                                        <td align="right" width="13%">
                                            Nómina
                                        </td>
                                        <td colspan="3">
                                            <asp:DropDownList ID="ddNomina" runat="server" CssClass="dropDowns" AutoPostBack="True">
                                            </asp:DropDownList>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                            Cédula
                                        </td>
                                        <td class="subHeader" colspan="3">
                                            <asp:TextBox ID="txtCedula" runat="server" MaxLength="11"></asp:TextBox>&nbsp;<asp:Button
                                                ID="btnBuscar" runat="server" Text="Buscar"></asp:Button><asp:Image ID="imgRepBusca"
                                                    runat="server" Visible="False"></asp:Image>&nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator1"
                                                        runat="server" ErrorMessage="RequiredFieldValidator" Display="Dynamic" ControlToValidate="txtCedula">Cédula requerida.</asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr id="TRNss" runat="server">
                                        <td align="right">
                                            <asp:Label ID="lblIdNss" runat="server">NSS</asp:Label>&nbsp;
                                        </td>
                                        <td class="subHeader" colspan="3">
                                            <asp:Label ID="lblNSS" runat="server"></asp:Label>&nbsp;
                                        </td>
                                    </tr>
                                    <tr id="TRNombres" runat="server">
                                        <td align="right">
                                            <asp:Label ID="lblNombres" runat="server">Nombres</asp:Label>&nbsp;
                                        </td>
                                        <td class="subHeader" colspan="3">
                                            <asp:Label ID="lblEmpleadoNombres" runat="server"></asp:Label>&nbsp;
                                        </td>
                                    </tr>
                                    <tr id="TRApellidos" runat="server">
                                        <td align="right">
                                            <asp:Label ID="lblApellidos" runat="server">Apellidos</asp:Label>
                                        </td>
                                        <td class="subHeader" colspan="3">
                                            <asp:Label ID="lblEmpleadoApellidos" runat="server"></asp:Label>&nbsp;&nbsp;<asp:Button
                                                ID="btnCancelaBusqueda" runat="server" Visible="False" Text="Cancelar"></asp:Button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="right">
                                        </td>
                                        <td class="error" colspan="3">
                                            <asp:Label ID="lblMsg2" runat="server" CssClass="error"></asp:Label>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <asp:Panel ID="pnlActDatosForm" Visible="False" runat="server">
                                <br />
                                <table id="Table3" cellspacing="1" cellpadding="1" width="630" border="0">
                                    <tbody>
                                        <tr>
                                            <td class="header" colspan="4">
                                                Listado de Dependientes Adicionales
                                            </td>
                                        </tr>
                                        <tr>
                                            <td style="width: 322px" colspan="4">
                                                <asp:GridView ID="gvDependientes" runat="server" AutoGenerateColumns="False" CellPadding="4"
                                                    Width="630px">
                                                    <Columns>
                                                        <asp:BoundField DataField="ID_NSS_DEPENDIENTE" HeaderText="NSS">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="DOCUMENTODEP" HeaderText="C&#233;dula">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="NOMBREDEP" HeaderText="Dependiente">
                                                            <ItemStyle HorizontalAlign="Left" />
                                                        </asp:BoundField>
                                                        <asp:BoundField DataField="FECHA_REGISTRO" HeaderText="Fecha Registro" DataFormatString="{0:d}"
                                                            HtmlEncode="False" Visible="False">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                        </asp:BoundField>
                                                        <asp:TemplateField HeaderText="Borrar">
                                                            <ItemStyle HorizontalAlign="Center" />
                                                            <ItemTemplate>
                                                                <asp:ImageButton CausesValidation="False" ID="iBtnBorrar" runat="server" ToolTip="Borrar"
                                                                    ImageUrl="../images/error.gif" CommandName="Borrar" BorderWidth="0px"></asp:ImageButton>&nbsp;
                                                                <asp:Label ID="lblIdNssDep" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ID_NSS_DEPENDIENTE") %>'
                                                                    Visible="False">
                                                                </asp:Label>
                                                                <asp:Label ID="lblfechaRegDep" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.FECHA_REGISTRO") %>'
                                                                    Visible="False">
                                                                </asp:Label>
                                                            </ItemTemplate>
                                                        </asp:TemplateField>
                                                    </Columns>
                                                </asp:GridView>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </asp:Panel>
                            <asp:Panel ID="pnlPendiente" Visible="False" runat="server">
                                <br />
                                <table id="Table6" cellspacing="1" cellpadding="1" width="100%" border="0">
                                    <tbody>
                                        <tr>
                                            <td>
                                                <asp:Label ID="Label1" runat="server" EnableViewState="False" CssClass="header">Bajas Pendientes de Aplicar</asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td>
                                                &nbsp;<uc3:ucGridNovPendientes ID="UcGridNovPendientes1" runat="server" __designer:wfdid="w4">
                                                </uc3:ucGridNovPendientes>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="right">
                                                <asp:Button ID="btnAplicar" runat="server" Visible="True" Text="Aplicar Novedades"
                                                    CausesValidation="False"></asp:Button>
                                                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False">
                                                </asp:Button>&nbsp;
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </asp:Panel>
                        </td>
                    </tr>
                </tbody>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
</asp:Content>

