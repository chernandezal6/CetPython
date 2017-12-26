<%@ Page Language="VB" AutoEventWireup="false" CodeFile="PanelConsCiudadano.aspx.vb" Inherits="Oficina_Virtual_PanelConsCiudadano" %>

<!DOCTYPE html>
<head runat="server">
    <title></title>
</head>
<body>
    <div id="infoLibre" class="panel panel-primary Center" style="border-color: #EFEFEF;" runat="server">
        <div class="panel-heading" style="height: 32px;">
            <h4 id="Titulo">
                Empleadores Reportados
            </h4>
        </div>
        <div class="panel-body">
            <table>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Nombre: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNombre" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Apellido: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblApellido" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">NSS: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNSS" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Fecha de Nacimiento: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblFechaNac" runat="server" Text="" style="font:normal 12px Tahoma, Verdana, Arial; margin-left: 10px;"></asp:Label>
                    </td>
                </tr>
            </table>    
        </div>
    </div>
    <hr />
</body>
