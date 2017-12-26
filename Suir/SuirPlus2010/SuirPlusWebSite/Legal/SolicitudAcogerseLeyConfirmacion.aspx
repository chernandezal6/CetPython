<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SolicitudAcogerseLeyConfirmacion.aspx.vb" Inherits="Legal_SolicitudAcogerseLeyConfirmacion" title="Confirmación" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">Solicitud Para Acogerse a la Ley No. 189-07 que facilita el pago a los empleadores
        <br />
        con deudas pendientes con el Sistema Dominicano de Seguridad Social.</div>
    <div class="subHeader">
        <br />
        <br />
        <table border="0" width="350" cellpadding="0" cellspacing="0">
            <tr>
                <td colspan="2" style="text-align: center" >
                    <asp:Label ID="Label6" runat="server" CssClass="subHeader" Font-Bold="True" Text="Confirmación de la Solicitud"></asp:Label></td>
            </tr>
            <tr>
                <td >
                </td>
                <td >
                </td>
            </tr>
            <tr>
                <td >
                    Solicitud #:</td>
                <td >
                    <asp:Label ID="lblNroSolicitud" runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td>
                    Status:</td>
                <td>
                    <asp:Label ID="Label1" runat="server" Text="Procesado Correctamente"></asp:Label></td>
            </tr>
            <tr>
                <td >
                    RNC:</td>
                <td>
                    <asp:Label ID="lblRNC" runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td >
                    Razon Social:</td>
                <td >
                    <asp:Label ID="lblRazonSocial" runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td >
                    Fecha:</td>
                <td >
                    <asp:Label ID="lblFecha" runat="server"></asp:Label></td>
            </tr>
            <tr>
                <td>
                </td>
                <td>
                </td>
            </tr>
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:Button ID="btProcesarOtra" runat="server" Text="Procesar Otra Solicitud" /></td>
            </tr>
        </table>
        <br />
    </div>
        
</asp:Content>

