<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConfirmarDatos.aspx.vb" Inherits="Certificaciones_ConfirmarDatos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <style>
        .pnlMsg
        {
            text-align: center;
        }
    </style>
    <script type="text/javascript">
        $(function () {

            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

            $("#ctl00_MainContent_txtFechaDesde").datepicker($.datepicker.regional['es']);

            $("#ctl00_MainContent_txtFechaHasta").datepicker($.datepicker.regional['es']);

        });

    </script>



    <asp:HiddenField ID="hdTipoCertificacion" runat="server" />
    <asp:HiddenField ID="hdRNC" runat="server" />
    <h2 class="header">Confirmar Datos de Certificación
    </h2>
    <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
    <table class="td-content" style="width: 550px">

        <tr id="trRNC" runat="server">
            <td>RNC:</td>
            <td>
                <asp:Label ID="lblRNC" runat="server" Visible="true"></asp:Label>
                <asp:TextBox ID="txtRnc" runat="server" Visible="False" AutoPostBack="true"></asp:TextBox>
            </td>
        </tr>
        <tr id="trRazonSocial" runat="server">
            <td>Razon Social:</td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server"></asp:Label></td>
        </tr>
        <tr id="trCedula" runat="server">
            <td>Cedula Empleado:</td>
            <td>
                <asp:TextBox ID="txtCedula" runat="server" MaxLength="11"></asp:TextBox></td>
        </tr>
        <tr id="trFechaDesde" runat="server" visible="false">
            <td>Fecha Desde:</td>
            <td>
                <asp:TextBox id="txtFechaDesde" runat="server" Width="80px"></asp:TextBox></td>
        </tr>
        <tr id="trFechaHasta" runat="server" visible="false">
            <td>Fecha Hasta:</td>
            <td>
               <asp:TextBox id="txtFechaHasta" runat="server" Width="80px"></asp:TextBox></td>
        </tr>
        <tr id="trDocumentos" runat="server">
            <td>Documentos:</td>
            <td>
                <asp:FileUpload ID="flCargarImagenCert" runat="server" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <div style="text-align: right">
                    <asp:Button ID="btnSolicitar" runat="server" Text="Solicitar" Enabled="False" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover" />

                </div>

            </td>
        </tr>
    </table>
    <br />
    <asp:Panel ID="pnlMensaje" runat="server" class="pnlMsg" Visible="false">
        <p id="ParrafoMSG" class="pnlMsg">
            <br />
            <asp:Label ID="lblGenerado" runat="server" CssClass="labelData" Style="font-size: 15pt;" Visible="false"></asp:Label>
            <br />
            <asp:Button ID="btnProcesar" runat="server" CssClass="btnButton ui-button ui-widget ui-state-default ui-corner-all ui-state-hover"
                Text="Ok" Visible="false" />
        </p>

    </asp:Panel>
</asp:Content>

