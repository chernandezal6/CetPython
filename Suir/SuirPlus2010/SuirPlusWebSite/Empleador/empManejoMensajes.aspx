<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="empManejoMensajes.aspx.vb" Inherits="Empleador_empManejoMensajes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <br />
    <br />

    <asp:Label ID="lblError" runat="server" CssClass="error" Font-Size="12pt"></asp:Label>
    <br />
    <br />
    <asp:UpdatePanel ID="UpdatePanel1" style="width: inherit; height: 100%;" runat="server">
        <ContentTemplate>
            <ajaxToolkit:TabContainer ID="tbContainer" runat="server" ActiveTabIndex="0" AutoPostBack="True">
                <ajaxToolkit:TabPanel ID="leidos" runat="server" HeaderText="LeidosyPendientes">
                    <HeaderTemplate>
                        Leídos & Pendientes
                    </HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <table >
                            <tr>
                                <td>
                        <asp:GridView ID="gvMensajesLeidosyPendientes" runat="server" AutoGenerateColumns="False" CellSpacing="2" CellPadding="5"
                            Style="width: inherit;">
                            <Columns>
                                <asp:TemplateField HeaderText="Asunto">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LnkBtvolver" runat="server" ForeColor="Black" CommandName="LeerMensaje" CommandArgument='<%# Eval("id_mensaje")&"|"& Eval("id_registro_patronal")%>' Font-Size="Small" Text='<%# Eval("asunto")%>'
                                            Visible="true"> </asp:LinkButton>
                                        <%--  <asp:Label ID="lblasunto" runat="server" Text='<%# Eval("asunto")%>'></asp:Label>--%>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Estatus">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEstatus" runat="server"  Text='<%# Eval("status")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha_registro" HeaderText="Fecha">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="leido_por" HeaderText="Leído por">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="fecha_leido" HeaderText="Fecha Leido">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="btnLeer" Enabled="true" runat="server" ToolTip="Leer" ImageUrl="../images/buscar.gif"
                                            CommandName="Leer" ImageAlign="Baseline" CommandArgument='<%# Eval("id_mensaje")&"|"& Eval("id_registro_patronal")%>'></asp:ImageButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle Font-Size="Small" />
                            <RowStyle Font-Size="Small" />
                        </asp:GridView>
                                    </td>
                                </tr>
                            </table>
                        <div id="divPagMsjsPendientes" style="width: 600px;" visible="False" runat="server">
                           <table style="width:inherit">
                            <tr>
                                <td>
                                    <asp:LinkButton ID="btnLnkFirstPage1" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                        CommandName="First" OnCommand="NavigationLink_Click1"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage1" runat="server" CssClass="linkPaginacion"
                                    Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_Click1"></asp:LinkButton>&nbsp;
                                Página [<asp:Label ID="lblCurrentPage1" runat="server"></asp:Label>] de
                                <asp:Label ID="lblTotalPages1" runat="server"></asp:Label>&nbsp;
                                <asp:LinkButton ID="btnLnkNextPage1" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                    CommandName="Next" OnCommand="NavigationLink_Click1"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage1" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                    CommandName="Last" OnCommand="NavigationLink_Click1"></asp:LinkButton>&nbsp;
                                <asp:Label ID="lblPageSize1" runat="server" Visible="False"></asp:Label>
                                    <asp:Label ID="lblPageNum1" runat="server" Visible="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                              
                                <td>
                                    <br />
                                    Total de registros&nbsp;
                                <asp:Label ID="lblTotalRegistros1" CssClass="error" runat="server" />
                                </td>
                            </tr>
                        </table>
                            </div>
                          <asp:Label ID="lblErrorMsjsPendientes" runat="server" CssClass="error" Font-Size="12pt"></asp:Label>
  
                        <br />
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
                <ajaxToolkit:TabPanel ID="archivados" runat="server" HeaderText="Archivados">
                    <HeaderTemplate>
                        Archivados
                    </HeaderTemplate>
                    <ContentTemplate>
                        <br />
                        <asp:GridView ID="gvMensajesArchivados" runat="server" AutoGenerateColumns="False" CellSpacing="2" CellPadding="5"
                            Style="width: 600px;">
                            <Columns>
                                <asp:TemplateField HeaderText="Asunto">
                                    <ItemTemplate>
                                        <asp:LinkButton ID="LnkBtvolver" runat="server" ForeColor="Black" CommandName="LeerMensaje" CommandArgument='<%# Eval("id_mensaje")&"|"& Eval("id_registro_patronal")%>' Font-Size="Small" Text='<%# Eval("asunto")%>'
                                            Visible="true"> </asp:LinkButton>
                                        <%--  <asp:Label ID="lblasunto" runat="server" Text='<%# Eval("asunto")%>'></asp:Label>--%>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Estatus">
                                    <ItemTemplate>
                                        <asp:Label ID="lblEstatus" runat="server" Text='<%# Eval("status")%>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="fecha_registro" HeaderText="Fecha">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="btnLeer" Enabled="true" runat="server" ToolTip="Leer" ImageUrl="../images/buscar.gif"
                                            CommandName="Leer" ImageAlign="Baseline" CommandArgument='<%# Eval("id_mensaje")&"|"& Eval("id_registro_patronal")%>'></asp:ImageButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                            <HeaderStyle Font-Size="Small" />
                            <RowStyle Font-Size="Small" />
                        </asp:GridView>

                        <div id="divPagMsjsArchivados" visible="False" style="width:600px;" runat="server">
                        <table style="width:inherit;">
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
                            <tr>
                               <%-- <td>
                                    <asp:LinkButton ID="LnkBtvolver" runat="server" CssClass="linkPaginacion" Text="Volver encabezado >> "
                                        Visible="False"></asp:LinkButton>&nbsp;
                                </td>--%>
                            </tr>
                                
                        </table>
                            </div>
                         <asp:Label ID="lblErrorMsjsArchivados" runat="server" CssClass="error" Font-Size="12pt"></asp:Label>
  
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
            </ajaxToolkit:TabContainer>
        </ContentTemplate>
    </asp:UpdatePanel>


    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />


</asp:Content>

