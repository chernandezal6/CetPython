<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="EvaVisualMaster.aspx.vb" Inherits="Evaluacion_Visual_EvaVisualMaster" %>

<asp:Content ID="body" ContentPlaceHolderID="MainContent" runat="Server">

    <div class="bigtitle">
        <span class="header">Evaluación visual</span>
    </div>
    <br />

    <table class="td-content">
        <tr>
            <td align="left" colspan="3" style="font-size: small">&nbsp;Número Solicitud:</td>
            <td>
                <asp:TextBox ID="txtSolicitud" MaxLength="10" runat="server" Style="width: 100px" placeholder="Buscar Solicitud"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" ControlToValidate="txtSolicitud" runat="server" ErrorMessage="Solo números" ValidationExpression="\d+"></asp:RegularExpressionValidator>
            </td>
        </tr>
        <tr>
            <td align="left" colspan="3" style="font-size: small">&nbsp;Tipo Solicitud:</td>
            <td colspan="4">
                <asp:DropDownList ID="ddlTipoSol" runat="server" CssClass="dropDowns" AutoPostBack="true"></asp:DropDownList>

            </td>
        </tr>
        <tr>
            <td></td>
        </tr>
        <tr>
            <td colspan="4" style="text-align: center">
                <asp:Button ID="btBuscar" runat="server" Text="Buscar" />
                &nbsp;<asp:Button ID="btLimpiar" runat="server" Text="Limpiar" CausesValidation="false" />
            </td>
        </tr>

        <tr>
            <td></td>
        </tr>
    </table>
    <br />
    <asp:Label ID="lblerror" runat="server" CssClass="error" Font-Size="10pt" Visible="false"></asp:Label>


    <asp:GridView ID="gvEvaluaciones" runat="server" AutoGenerateColumns="False" Visible="False" Width="80%">
        <Columns>
            <asp:BoundField HeaderText="Solicitud" DataField="Solicitud" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Registro" DataField="Registro" HeaderStyle-HorizontalAlign="Center" Visible="false">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>                       
            <asp:BoundField HeaderText="Fecha Solicitud" DataField="FechaSolicitud" HeaderStyle-HorizontalAlign="Center" DataFormatString="{0:dd/MM/yyyy}">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Tipo Solicitud" DataField="TipoSolicitud" HeaderStyle-HorizontalAlign="center">
                <HeaderStyle HorizontalAlign="center" />
                <ItemStyle HorizontalAlign="center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Tipo Documento" DataField="TipoDoc" HeaderStyle-HorizontalAlign="Center">
                <HeaderStyle HorizontalAlign="Center" />
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Documento Solicita" DataField="NO_DOCUMENTO_SOL" HeaderStyle-HorizontalAlign="center">
                <HeaderStyle HorizontalAlign="center" />
                <ItemStyle HorizontalAlign="center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="center">
                <HeaderStyle HorizontalAlign="center" />
                <ItemStyle HorizontalAlign="center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Nacionalidad" DataField="NACIONALIDAD_DES" HeaderStyle-HorizontalAlign="center">
                <HeaderStyle HorizontalAlign="center" />
                <ItemStyle HorizontalAlign="center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Motivo" DataField="MotivoRechazo" HeaderStyle-HorizontalAlign="center">
                <HeaderStyle HorizontalAlign="center" />
                <ItemStyle HorizontalAlign="center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="Parentesco" DataField="Parentesco_desc" HeaderStyle-HorizontalAlign="center">
                <HeaderStyle HorizontalAlign="center" />
                <ItemStyle HorizontalAlign="center" />
            </asp:BoundField>
            <asp:BoundField HeaderText="NSS Titular" DataField="id_nss_titular" HeaderStyle-HorizontalAlign="center">
                <HeaderStyle HorizontalAlign="center" />
                <ItemStyle HorizontalAlign="center" />
            </asp:BoundField>  
            <asp:TemplateField>
                <ItemTemplate>
                    <asp:ImageButton ID="Evaluar" runat="server" Visible="true" ImageUrl="~/images/kappfinder.gif" CommandName="E" CommandArgument='<%# Eval("Registro") & "," & Eval("TipoSolicitud")%>' />
                </ItemTemplate>
            </asp:TemplateField>
        </Columns>
    </asp:GridView>
    <br />

    <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
        <table cellpadding="0" cellspacing="0" width="550px">
            <tr>
                <td style="height: 24px">
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
                    <br />
                    Total de Registros:
                        <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
        </table>
    </asp:Panel>

</asp:Content>
