<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDependientesAdicionales.aspx.vb" Inherits="Consultas_ConsultaDependientesAdicionales" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
    
<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<span class="header">Consulta de Dependientes Adicionales</span>
<uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
                <br />
                <br />
                 <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"
                Font-Size="10pt" Visible="false "></asp:Label>
<table cellpadding="0" cellspacing="0" id="tblinicial" runat="server" >
 
        
    <tr>
        <td>
            
            <br />
            <br />
        </td>
    </tr>
    <tr>
            <td align="left">
                Nombres:
            
                <asp:TextBox ID="txtNombres" runat="server" Width="206px" MaxLength="50" EnableViewState="False"></asp:TextBox>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="Ciudadano" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
               
                <br />
                <br />
                <br />
                </td>
        </tr>
         <tr>
        <td>
            <asp:Label ID="LblErrorBuscar" runat="server" CssClass="error" EnableViewState="False"
                Font-Size="10pt"></asp:Label>
        </td>
    </tr>
    <tr>
        <td>
            <div style="float: left; width: auto;" id="divDependientes" runat="server" visible="false">
                <fieldset>
                    <legend style="text-align: left">Titulares y Dependientes</legend>
                    <br />
                    <asp:GridView ID="gvDependientes" runat="server" AutoGenerateColumns="False" CellPadding="3"
                        Style="width: 400px;">
                        <Columns>
                            <asp:BoundField DataField="nomina_des" HeaderText="Descripción Nómina">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="titular" HeaderText="Titular">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="dependiente" HeaderText="Dependiente">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="fecha_registro" HeaderText="Fecha Registro" HeaderStyle-Width="26%"
                                DataFormatString="{0:d}" HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="center" Wrap="False" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </fieldset>
                <table width="410px">
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
                        <td>
                            <uc2:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                            &nbsp; |&nbsp;
                        </td>
                    </tr>
                </table>
            </div>
        </td>
    </tr>
    </table>
</asp:Content>

