<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false" CodeFile="ConsultaDGT3.aspx.vb" Inherits="MDT_ConsultaDGT3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <style>
        .Titulo
        {
            font-size: 15pt;
            font-weight: bold;
            font-family: Tahoma, Verdana,Arial;
            color: #006699;
        }

        .auto-style1
        {
            font-size: small;
            font-weight: bold;
        }
        .auto-style2
        {
            font-size: small;
            width: 125px;
        }
        .auto-style3
        {
            width: 22px;
            height: 22px;
        }
        .auto-style4
        {
            width: 136px;
        }
        .auto-style5
        {
            color: #4282A6;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">
    <h2 class="Titulo">Consulta Reporte DGT3</h2>

    <table>
        <tr>
            <td class="auto-style1">Rnc de Empresa:</td>
            <td>
                <asp:TextBox ID="txtRNC" runat="server"></asp:TextBox></td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
                &nbsp;
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
                
            </td>

        </tr>

    </table>
    <br />
    <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>


        <asp:GridView ID="gvDatos" runat="server" AutoGenerateColumns="false" Style="font-size: medium">
            <Columns>
                <asp:BoundField HeaderText="Año" DataField="Lista" ItemStyle-Font-Size="20pt" ItemStyle-Width="200px" ItemStyle-HorizontalAlign="Center" ItemStyle-Font-Bold="true"/>
                <asp:BoundField HeaderText="Reportado" DataField="RNC" ItemStyle-Font-Size="18pt" />
                <asp:TemplateField HeaderText="Estatus" ItemStyle-Width="200px" ItemStyle-HorizontalAlign="Center" >
                    <ItemTemplate>
                        <asp:Image Height="70px" Width="90px" ID="imgSaved" runat="server" />
                    </ItemTemplate>
                </asp:TemplateField>

            </Columns>
        </asp:GridView>

  
    <br />
    <h3 class="auto-style5">Leyenda</h3>
    <table class="td-content">
        <tr>
            <td class="auto-style2"><strong>Reportado:</strong></td>
            <td class="auto-style4">
                <img alt="" class="auto-style3" src="../images/Aproval.png" /></td>

        </tr>
        <tr>
            <td class="auto-style2"><strong>No Reportado:</strong></td>
            <td class="auto-style4">
                <img alt="" class="auto-style3" src="../images/Cancelar.png" /></td>

        </tr>
    </table>

</asp:Content>

