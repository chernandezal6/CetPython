<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusLite.master" AutoEventWireup="false"
    CodeFile="Dash.aspx.vb" Inherits="Dash" %>

<asp:Content ID="Content1" ContentPlaceHolderID="Cabezal" runat="Server">
    <style>
        .ecTitulo
        {
            font-size: small;
            color: #66B027;
            font-weight: bold;
            border-bottom: 1px solid #EAEAEA;
        }
        .ecMonto
        {
            font-size:12px;
            text-align:right;
            color:darkred;
            vertical-align:middle;
            font-weight:bold;
        }
        .ecMontoLabel
        {
            font-size:11px;
            text-align:right;
            vertical-align:middle;
            font-weight:bold;
        }
        .ecTabla
        {
            width: 100%;
        }

        .ecBox
        {
            width: 800px;
            margin: 0 auto;
            border: 1px solid #EAEAEA;
        }

            .ecBox table
            {
                width: 100%;
            }

        .ecBoxTitle
        {
            background-color: #F0F0F0;
            padding: 5px;
            font-weight: bold;
        }

        .ecBoxContent
        {
            padding: 10px;
        }
        .ecIcon
        {
            width:20px;
            text-align:center;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="Server">

    <div class="ecBox">
        <div class="ecBoxContent" style="padding-bottom: 0px;">
            <table>
                <tr>
                    <td class="ecTitulo" colspan="2">Estado de Cuenta</td>
                </tr>
                <tr>
                    <td style="vertical-align: top; width:60%;">
                        <table class="ecTabla">
                            <tr>
                                <td >&nbsp;</td>
                            </tr>
                            <tr>
                                <td><span style="font-size:small; font-weight:bold;">Nombre de la Empresa va aqui</span> (401157098)</td>
                            </tr>
                            <tr>
                                <td><span style="font-weight:bold;color:gray">Jose Hernandez Rep</span> (ced)</td>
                            </tr>
                        </table>
                    </td>
                    <td style="vertical-align: top; width:40%;">
                        <table class="ecTabla">
                            <tr>
                                <td class="ecTitulo" colspan="2">Balances Pendientes</td>
                            </tr>
                            <tr>
                                <td class="ecMontoLabel">TSS</td>
                                <td class="ecMonto">RD$4,054,215.01 <img src="images/bill_16.png" /></td>
                            </tr>
                            <tr>
                                <td class="ecMontoLabel">DGII</td>
                                <td class="ecMonto">RD$14,054,215.01 <img src="images/bill_16.png" /></td>
                            </tr>
                            <tr>
                                <td class="ecMontoLabel">MDT</td>
                                <td class="ecMonto">RD$4,215.01 <img src="images/bill_16.png" /></td>
                            </tr>
                            <tr>
                                <td class="ecMontoLabel">INFOTEP</td>
                                <td class="ecMonto">RD$0.00 <img src="images/bill_16.png" /></td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
        </div>
    </div>
    <div class="ecBox">
        <div class="ecBoxContent" style="padding-bottom: 0px;">
            <table class="ecTabla">
                <tr><td class="ecTitulo" colspan="2">Datos incompletos en su registro</td></tr>
                <tr>
                    <td class="ecIcon">
                         <img src="images/warning_16.png" /></td>
                    <td>Completar dirección</td>
                </tr>
                <tr>
                    <td class="ecIcon"> <img src="images/warning_16.png" /></td>
                    <td>Completar telefono de la empresa</td>
                </tr>
                <tr>
                    <td class="ecIcon"> <img src="images/warning_16.png" /></td>
                    <td>Llenar el valor de las instalaciones de sus localidades (mdt)</td>
                </tr>
                <tr>
                    <td class="ecIcon"> <img src="images/warning_16.png" /></td>
                    <td>Declarar MDT ZXY</td>
                </tr>
            </table>
        </div>
    </div>
    <div class="ecBox">
        <div class="ecBoxContent" style="padding-bottom: 0px;">
            <table class="ecTabla">
                <tr><td class="ecTitulo" colspan="2">Solicitud de servicios</td></tr>
                <tr>
                    <td class="ecIcon"> <img src="images/document_16.png" /></td>
                    <td>Solicitar certificación 123</td>
                </tr>
                <tr>
                    <td class="ecIcon"> <img src="images/document_16.png" /></td>
                    <td>Registrar Pasaporte</td>
                </tr>
                <tr>
                    <td class="ecIcon"> <img src="images/document_16.png" /></td>
                    <td>Solicitar certificación 123</td>
                </tr>
                <tr>
                    <td class="ecIcon"> <img src="images/document_16.png" /></td>
                    <td>Solicitar certificación 123</td>
                </tr>
            </table>
        </div>
    </div>


</asp:Content>
