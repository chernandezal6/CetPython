<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsARSPagados.aspx.vb" Inherits="Consultas_ConsARSPagados" title="Consulta de Pagos Por No. de Referencia" %>

<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
	function checkNum()
	    {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
         }

	</script>
    <asp:Label ID="lblTitulo" runat="server" CssClass="header">Consulta de Pagos Por No. de Referencia</asp:Label>
    <br />
    <br />
    <table cellpadding="1" cellspacing="1" class="tblWithImagen" style="border-collapse: collapse">
        <tr>
            <td rowspan="4">
                <img alt="" src="../images/calcfactura.jpg" />
            </td>
            <td>
                <br />
                &nbsp;No. de Referencia&nbsp;</td>
            <td>
                <br />
                &nbsp;<asp:TextBox ID="txtReferencia" runat="server" MaxLength="16" 
                    onkeypress="checkNum()" ></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: right">
                &nbsp;</td>
        </tr>
        <tr>
            <td colspan="2" style="text-align: center">
                <asp:Button ID="btBuscar" runat="server" Text="Buscar" />
                &nbsp;&nbsp;
                <asp:Button ID="btLimpiar" runat="server" CausesValidation="False" EnableViewState="False"
                    Text="Limpiar" /></td>
        </tr>
        <tr>
            <td colspan="2" style="height: 18px; text-align: center">
                <asp:RequiredFieldValidator ID="RequiredFieldValidator" runat="server" ControlToValidate="txtReferencia"
                    Display="Dynamic" ErrorMessage="Nro. de Referencia es requerido." Font-Bold="True"></asp:RequiredFieldValidator><br />
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtReferencia"
                    Display="Dynamic" ErrorMessage="Referencia Inválida" Font-Bold="True" ValidationExpression="0*[1-9][0-9]*"></asp:RegularExpressionValidator>&nbsp;&nbsp;
            </td>
        </tr>
    </table>
   <br />
       <asp:UpdatePanel ID="UpRegistros" runat="server">
    <ContentTemplate>
    <asp:Label
                        ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
   <asp:Panel ID="PanelRegistros" runat="server" Visible="false">
    <table>
    <tr>
    <td>
    
     <asp:GridView ID="gvPagosARS" runat="server" AutoGenerateColumns="False" OnRowDataBound="gvPagosARS_RowDataBound" PageSize="15">
        <Columns>
            <asp:BoundField DataField="nss_titular" HeaderText="NSS Titular" />
            <asp:BoundField DataField="nombre_titular" HeaderText="Nombre Titular" />
            <asp:BoundField DataField="nss_dependiente" HeaderText="NSS Dependiente" />
            <asp:BoundField DataField="nombre_dependiente" 
                HeaderText="Nombre Dependiente" />
            <asp:BoundField DataField="parentesco_desc" HeaderText="Titular" />
            <asp:BoundField DataField="ars_des" HeaderText="ARS" />
        </Columns>
    </asp:GridView>
    </td>
    </tr>
     <tr>
        <td>
            <asp:linkbutton id="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
	            CommandName="First" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
            <asp:linkbutton id="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion" Text="< Anterior"
	            CommandName="Prev" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;
            Página
	            [<asp:label id="lblCurrentPage" runat="server"></asp:label>] de
            <asp:label id="lblTotalPages" runat="server"></asp:label>&nbsp;
            <asp:linkbutton id="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
	            CommandName="Next" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;|
            <asp:linkbutton id="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
	            CommandName="Last" OnCommand="NavigationLink_Click"></asp:linkbutton>&nbsp;                    
            <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
            <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
        </td>                 
    </tr>           
    <tr>
        <td>
            <br />
            Total de empleados&nbsp;
            <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server"/>
        </td>
    </tr>
    </table>
                <uc1:ucExportarExcel ID="UcExportarExcel1" runat="server" Visible="true" />
    </asp:Panel> 
    </ContentTemplate>
    <Triggers>
    <asp:AsyncPostBackTrigger ControlID="btBuscar" EventName="Click" />
<asp:PostBackTrigger ControlID="UcExportarExcel1"></asp:PostBackTrigger>
    </Triggers>
    <Triggers>
    <asp:PostBackTrigger ControlID="UcExportarExcel1"/>
    </Triggers>
    </asp:UpdatePanel>
    &nbsp;
     <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

