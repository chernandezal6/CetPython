<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="ConsDispercionARS.aspx.vb" Inherits="Oficina_Virtual_ConsDispercionARS" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .ajax_custom_tab_body {
            font-family: verdana,tahoma,helvetica;
            font-size: 11pt;
            background-color: #ffffff;
        }
        .ajax_custom_tab_tab {
            font-family: verdana,tahoma,helvetica;
            font-size: 11px;
        }
    </style>
    <script type="text/javascript">
        $(function () {
            $("#navMenu").load("MenuOFV.html");
            setTimeout(function () {
                debugger;
                $("#ctl00_ContentPlaceHolder1_tc1_body").removeClass("ajax__tab_body");
                $("#ctl00_ContentPlaceHolder1_tc1_body").addClass("ajax_custom_tab_body");
                $("#ctl00_ContentPlaceHolder1_tc1").css('text-align', '-webkit-center');
                $("#ctl00_ContentPlaceHolder1_tc1_header").removeClass("ajax__tab_header");
                $("#ctl00_ContentPlaceHolder1_tc1_header").addClass("ajax_custom_tab_tab");
            }, 200);            
        });
    </script>
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <div id="infoLibre" class="panel panel-primary Center" style="border-color: #EFEFEF;" runat="server">
        <div class="panel-heading" style="height: 32px;">
            <h4>Disperción ARS
            </h4>
        </div>
        <div class="panel-body">
            <table>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Nombre del afiliado: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblNombreAfiliado" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
                <tr>
                <tr>
                    <td>
                        <h5 style="font: bold 14px Tahoma, Verdana, Arial;">Cotizaciones continuas SFS: </h5>
                    </td>
                    <td>
                        <asp:Label ID="lblConsecutivos" runat="server" Text="" CssClass="SRtxt"></asp:Label>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <%--<div id="divConsecutivas" class="labelData" style="width: 400px" runat="server"
        visible="False">
        Cantidad de Cotizaciones en el SFS continuas:&nbsp;
        <asp:Label ID="lblConsecutivos" runat="server"></asp:Label>
        <br />
        Nombre del afiliado:&nbsp;
        <asp:Label ID="lblNombreAfiliado" runat="server"></asp:Label>
    </div>--%>
    <hr />
    <asp:Panel ID="Panel1" runat="server">
        <ajaxToolkit:TabContainer ID="tc1" runat="server">
            <ajaxToolkit:TabPanel ID="tpbase" runat="server" HeaderText="Resultados">
                <ContentTemplate>
                    
                    <asp:Literal runat="server" ID="ojk" Text="0 Resultados"></asp:Literal>
                </ContentTemplate>
            </ajaxToolkit:TabPanel>
        </ajaxToolkit:TabContainer>
    </asp:Panel>
    <div id="dvError" class="panel panel-primary Center" style="border-color: #EFEFEF; display: none;" runat="server">
        <div class="panel-heading" style="height: auto; background-color: #fff">
            <h5 id="txtError" style="font: bold 14px arial; color: #FF2400;" runat="server"></h5>
        </div>
    </div>
    <hr />
    <div style="text-align: center">
        <asp:Button ID="btnRegresar" runat="server" CssClass="btn btn-primary" Text="Regresar" />
    </div>
</asp:Content>

