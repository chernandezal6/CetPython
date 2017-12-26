<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consFacturaDetalle.aspx.vb" Inherits="Consultas_consFacturaDetalle" title="Detalle de Notificaciones" %>

<%@ Register Src="../Controles/UCDetalleDependientesReferencia.ascx" TagName="UCDetalleDependientesReferencia" TagPrefix="uc5" %>
<%@ Register Src="../Controles/ucLiquidacionInfotepDet.ascx" TagName="ucLiquidacionInfotepDet" TagPrefix="uc4" %>
<%@ Register Src="../Controles/ucNotificacionTSSDetalleAuditoria.ascx" TagName="ucNotificacionTSSDetalleAuditoria" TagPrefix="uc3" %>
<%@ Register Src="../Controles/ucNotificacionTSSDetalle.ascx" TagName="ucNotificacionTSSDetalle" TagPrefix="uc2" %>
<%@ Register Src="../Controles/ucLiquidacionISRDetalle.ascx" TagName="ucLiquidacionISRDetalle" TagPrefix="uc1" %>

<%@ Register src="../Controles/ucDetalleAjuste.ascx" tagname="ucDetalleAjuste" tagprefix="uc6" %>

<%@ Register src="../Controles/ucPlanillasMDTdetalle.ascx" tagname="ucPlanillasMDTdetalle" tagprefix="uc7" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="vb" runat="server">
		Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
	        Me.PermisoRequerido = 97
		End Sub
	</script>

    <uc1:ucLiquidacionISRDetalle ID="ucLiqISRDetalle" runat="server" Visible="false" />
    <uc2:ucNotificacionTSSDetalle ID="ucNotTssDetalle" runat="server" Visible="false" />
    <uc3:ucNotificacionTSSDetalleAuditoria ID="ucNotTssDetalleAuditoria" runat="server" Visible="false" />
    <uc4:ucLiquidacionInfotepDet ID="ucLiqInfotepDetalle" runat="server" Visible="false" />
    <uc5:UCDetalleDependientesReferencia ID="ucDetDepReferencia" runat="server" Visible="false" /> 
    <uc6:ucDetalleAjuste ID="ucDetalleAjuste1" runat="server" Visible="false"  />
    <uc7:ucPlanillasMDTdetalle ID="ucPlanillasMDTdetalle" runat="server" Visible="false" />

</asp:Content>