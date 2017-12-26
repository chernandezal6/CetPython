<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="GrCerAportes.aspx.vb" Inherits="Oficina_Virtual_GrCerAportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">
        $(function () {
            $("#navMenu").load("MenuOFV.html");
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <div id="infoLibre" class="panel panel-primary Center" style="border-color: #EFEFEF;" runat="server">
        <div class="panel-heading" style="height: 32px;">
            <h4 id="Titulo">Solicitud de Certificación
            </h4>
        </div>
        <div class="panel-body">
            <table>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Nombre: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNombre" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Apellido: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblApellido" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">No. Certificación: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNoCertificacion" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Tipo de Certificación: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblTipoCertificacion" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;">Aporte Personal</asp:Label>
                    </td>
                </tr>                
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Cédula: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNoDocumento" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">NSS: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNSS" runat="server" Text="" Style="font: normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>                
            </table>
        </div>
    </div>
    <div id="dvError" class="panel panel-primary Center" style="border-color: #EFEFEF; display: none;" runat="server">
        <div class="panel-heading" style="height: auto; background-color: #fff">
            <h5 id="txtError" style="font: bold 14px arial; color: #FF2400;" runat="server"></h5>
        </div>
    </div>
    <hr />
    <div style="text-align: center">
        <asp:Button ID="btnRegresar" runat="server" CssClass="btn btn-primary" Text="Regresar" style="margin-right: 5px;"/>
        <asp:Button ID="btnConscertificacion" runat="server" CssClass="btn btn-primary" Text="Consultar" style="margin-left: 5px;"/>
    </div>
</asp:Content>

