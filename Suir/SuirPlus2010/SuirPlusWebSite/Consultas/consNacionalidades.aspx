<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="consNacionalidades.aspx.vb" Inherits="Consultas_consNacionalidades" %>

<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <span class="header">Listado de Nacionalidades</span>
    <br />
    <br />
    <div id="divNacionalidades" runat="server" visible="false">
        <fieldset style="width: 300px">
            <asp:GridView ID="gvNacionalidades" runat="server" AutoGenerateColumns="False" Width="300px"
                EnableViewState="False" Wrap="False" CellPadding="2" CellSpacing="2">
                <Columns>
                    <asp:BoundField DataField="id_nacionalidad" HeaderText="Id">
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="nacionalidad_des" HeaderText="Nacionalidad">
                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="left" Wrap="False" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
            <br />
            <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
        </fieldset>
    </div>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label><br />
</asp:Content>
