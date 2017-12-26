<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ConsAfiliacionAFP.aspx.vb" Inherits="Oficina_Virtual_ConsAfiliacionAFP" %>

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
            <h4>
                Afiliación AFP
            </h4>
        </div>
        <div class="panel-body">
            <table>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">NSS: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNSS" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Nombre: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNombre" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">AFP: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblAFP" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Estatus: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblStatus" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trAfiliado1" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Tipo Afiliación: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblTipoAfiliacion" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trAfiliado2" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Fecha Afiliación: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblFechaAfiliacion" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trSolicitud1" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Tipo Solicitud: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblTipoSolicitud" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr id="trSolicitud2" runat="server">
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Fecha Solicitud: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblFechaSolicitud" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
            </table>    
        </div>
    </div> <!--#CA3820-->
    <div id="dvError" class="panel panel-primary Center" style="border-color: #EFEFEF; display:none;" runat="server">
        <div class="panel-heading" style="height: auto; background-color:#fff">
            <h5 id="txtError" style="font: bold 14px arial; color: #FF2400;" runat="server">
               
            </h5>
        </div>
    </div>
    <hr />
    <div style="text-align: center">
        <asp:Button ID="btnRegresar" runat="server" CssClass="btn btn-primary" Text="Regresar" />
    </div>
</asp:Content>

