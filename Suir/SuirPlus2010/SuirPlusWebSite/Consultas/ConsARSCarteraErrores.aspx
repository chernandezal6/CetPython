<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsARSCarteraErrores.aspx.vb" Inherits="ConsARSCarteraErrores" title="Consulta de Errores de Dispersion" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:Label ID="lblTitulo" runat="server" CssClass="header">Consulta de Errores de Cartera</asp:Label><br />
                
    <table>
        <tr>
            <td colspan="9">
                <asp:UpdatePanel ID="UpdatePanel1" runat="server">
                    <ContentTemplate>
                    <asp:Label runat="server" ID="lblMensaje" Font-Bold="True" ForeColor="Red"></asp:Label>
                        <asp:Panel ID="PanelRegistrosDisp" runat="server">
                            <table>
                                <tr>
                                    <td>
                                        <asp:GridView ID="gvDipersionesErrores" runat="server" AutoGenerateColumns="False" PageSize="15" OnRowCommand="gvDipersionesErrores_RowCommand">
                                            <Columns>
                                                <asp:BoundField DataField="ID_CARGA" HeaderText="ID Carga" />
                                                <asp:BoundField DataField="FECHA" HeaderText="Fecha" />
                                                <asp:BoundField DataField="STATUS" HeaderText="Estado" />
                                                 <asp:TemplateField HeaderText="Resumen">               
                                                    <ItemTemplate>
                                                        <asp:LinkButton CommandArgument='<%# container.dataitem("ID_CARGA")%>' CommandName="VerDetalle" ID="lnkVer" runat="server" Text="[Ver]"/>
                                                    </ItemTemplate>
                                                    <ItemStyle HorizontalAlign="Center" />
                                                </asp:TemplateField>
                                            </Columns>
                                        </asp:GridView>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <asp:LinkButton ID="btnLnkFirstPageDisp" runat="server" CommandName="First" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="<< Primera"></asp:LinkButton>
                                        |
                                        <asp:LinkButton ID="btnLnkPreviousPageDisp" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                                        [<asp:Label ID="lblCurrentPageDisp" runat="server"></asp:Label>] de
                                        <asp:Label ID="lblTotalPagesDisp" runat="server"></asp:Label>&nbsp;
                                        <asp:LinkButton ID="btnLnkNextPageDisp" runat="server" CommandName="Next" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="Próxima >"></asp:LinkButton>
                                        |
                                        <asp:LinkButton ID="btnLnkLastPageDisp" runat="server" CommandName="Last" CssClass="linkPaginacion"
                                            OnCommand="NavigationLinkDisp_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                                        <asp:Label ID="lblPageSizeDisp" runat="server" Visible="False"></asp:Label>
                                        <asp:Label ID="lblPageNumDisp" runat="server" Visible="False"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <br />
                                        Total de Registros&nbsp;
                                        <asp:Label ID="lblTotalRegistrosDisp" CssClass="error" runat="server"/>
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
        </tr>
        <tr>
            <td colspan="9">
                &nbsp;<asp:UpdatePanel runat="server" ID="up1">
            <ContentTemplate>
            <asp:GridView ID="gvErroresCartera" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="id_error" HeaderText="ID Error">
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="error_des" HeaderText="Descripci&#243;n" />
            <asp:BoundField DataField="cantidad" HeaderText="Cantidad de Registros">
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Resumen">               
                <ItemTemplate>
                    <asp:LinkButton CommandArgument='<%# container.dataitem("id_error")%>' CommandName="VerDetalle" ID="lnkVer" runat="server" Text="[Ver]"/>
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
        </Columns>        
    </asp:GridView>  
    </ContentTemplate>
    </asp:UpdatePanel>          
            </td>
        </tr>
        <tr>
            <td colspan="9">
                 <asp:UpdatePanel ID="UpRegistros" runat="server">
    <ContentTemplate>
   <asp:Panel ID="PanelRegistros" runat="server" Visible="false">
    <table>
    <tr>
    <td>
    
     <asp:GridView ID="gvDetalleErrores" runat="server" AutoGenerateColumns="False" PageSize="15">
        <Columns>
            <asp:BoundField DataField="CODIGO_ARS" HeaderText="ARS" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="PERIODO_FACTURA" HeaderText="Periodo" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="NSS_TITULAR" HeaderText="NSS Titular" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="TIPO_AFILIADO" HeaderText="Tipo Afiliado" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="CEDULA_TITULAR" HeaderText="Cedula Titular" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="NSS_TITULAR" HeaderText="NSS Titular" />
            <asp:BoundField DataField="CEDULA_DEPENDIENTE" HeaderText="Cedula Dependiente" />
            <asp:BoundField DataField="NSS_DEPENDIENTE" HeaderText="NSS_Dependiente" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="ESTATUS_AFILIADO" HeaderText="Estado Afiliado" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="CODIGO_PARENTESCO" HeaderText="Codigo Parentesco" >
                <ItemStyle HorizontalAlign="Center" />
            </asp:BoundField>
            <asp:BoundField DataField="DISCAPACITADO" HeaderText="Discapacitado" />
            <asp:BoundField DataField="ESTUDIANTE" HeaderText="Estudiante" />
            <asp:BoundField DataField="ID_ERROR" HeaderText="ID Error" />
            <asp:BoundField DataField="FECHA_REGISTRO" DataFormatString="{0:d}" HeaderText="Fecha Registro"
                HtmlEncode="False" />
        </Columns>
    </asp:GridView>
    </td>
    </tr>
     <tr>
        <td>
            <asp:linkbutton id="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
	            CommandName="First" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
            <asp:linkbutton id="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion" Text="< Anterior"
	            CommandName="Prev" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;
            Página
	            [<asp:label id="lblCurrentPage" runat="server"></asp:label>] de
            <asp:label id="lblTotalPages" runat="server"></asp:label>&nbsp;
            <asp:linkbutton id="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
	            CommandName="Next" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
            <asp:linkbutton id="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
	            CommandName="Last" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;                    
            <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
        </td>                 
    </tr>           
    <tr>
        <td>
            <br />
            Total de Registros&nbsp;
            <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server"/>
        </td>
    </tr>
    </table></asp:Panel> 
    </ContentTemplate>
    
    </asp:UpdatePanel>
     <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
            </td>
        </tr>
    </table>
</asp:Content>

