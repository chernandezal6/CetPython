<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consFacturasMDT.aspx.vb" Inherits="Empleador_consFacturasMDT" %>

<%@ Register Src="../Controles/ucPlanillasMDTdetalle.ascx" TagName="ucPlanillasMDTdetalle"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucPlanillasMDTencabezado.ascx" TagName="ucPlanillasMDTencabezado"
    TagPrefix="uc2" %>
<%@ Register Src="../Controles/UCEncabezadoMDT.ascx" TagName="UCEncabezadoMDT" TagPrefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <link href="../css/jquery-ui-1.8.11.custom.css" rel="stylesheet" type="text/css" />
    <script src="../Script/jquery-1.5.2.min.js" type="text/javascript"></script>
    <script src="../Script/jquery-ui-1.8.11.custom.min.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(function () {
            $("#<%=btnPagar.ClientID %>").button();

        });
    </script>
    <uc3:UCEncabezadoMDT ID="UCEncabezadoMDT1" runat="server" />
    <asp:Label ID="lblError" runat="server" CssClass="error"></asp:Label>
    <uc2:ucPlanillasMDTencabezado ID="ucPlanillasMDTencabezado1" runat="server" />
    <uc1:ucPlanillasMDTdetalle ID="ucPlanillasMDTdetalle1" runat="server" Visible="false" />
    <div style="width: 550px; text-align: right;">
        
        
        <br />
        <asp:Button ID="btnPagar" runat="server" Text="Pagar formulario" Font-Size="13px"
            Font-Bold="true" />
    </div>
</asp:Content>
