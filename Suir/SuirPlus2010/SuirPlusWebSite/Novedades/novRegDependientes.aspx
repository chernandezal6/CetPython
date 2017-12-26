<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="novRegDependientes.aspx.vb" Inherits="Novedades_novRegDependientes" title="Novedades - Registro Dependientes Adicionales" %>

<%@ Register Src="../Controles/ucGridNovPendientes.ascx" TagName="ucGridNovPendientes"
    TagPrefix="uc2" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
            Me.PermisoRequerido = 154    		
	    End Sub
    </script>
     <uc1:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
	<table id="table4" width="620">
	<tr>
		<td valign="bottom" style="width: 319px"><asp:label id="lblTitulo1" runat="server" CssClass="header">Registro Dependientes Adicionales</asp:label></td>
		<td align="right"><asp:panel id="pnlPendiente" Runat="server" Visible="False" 
                Height="16px" Width="136px">
				<table class="td-note" id="table5">
					<tr>
						<td class="labelDatared">Tiene Novedades Pendientes</td>
					</tr>
				</table>
			</asp:panel>
		</td>
	</tr>
	</table>   
	<br/>
	<table class="td-content" id="table1" cellspacing="2" cellpadding="1" 
        border="0">
		<tr>
			<td align="right" width="13%">
                <br />
                                Nómina</td>
			<td style="width: 518px">
                <br />
                <asp:dropdownlist id="ddNomina" runat="server" CssClass="dropDowns"></asp:dropdownlist></td>
		</tr>
		<tr>
			<td align="right" nowrap="nowrap">Cédula Trabajador</td>
			<td class="subHeader" style="width: 518px"><asp:textbox id="txtCedula" runat="server" MaxLength="11"></asp:textbox>&nbsp;<asp:image id="imgRepBusca" runat="server" Visible="False"></asp:image>&nbsp;<asp:button id="btnBuscar" runat="server" Text="Buscar"></asp:button>&nbsp;&nbsp;<asp:button id="btnCancelaBusqueda" tabIndex="1" runat="server" visible="False" Text="Cancelar"
					CausesValidation="False"></asp:button>
                <br />
                <asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ErrorMessage="RequiredFieldValidator"
					Display="Dynamic" ControlToValidate="txtCedula" style="font-size: 10px">Cédula requerida.</asp:requiredfieldvalidator></td>
		</tr>
		<tr id="TRNombres" runat="server" visible="False">
			<td align="right"><asp:label id="Label1" runat="server">Nombres</asp:label>&nbsp;</td>
			<td class="subHeader" style="width: 518px"><asp:label id="lblEmpleadoNombres" runat="server"></asp:label><asp:label id="lblNSS" runat="server" Visible="False"></asp:label></td>
		</tr>
		<tr id="TRApellidos" runat="server" visible="False">
			<td align="right"><asp:label id="Label2" runat="server">Apellidos</asp:label></td>
			<td class="subHeader" style="width: 518px"><asp:label id="lblEmpleadoApellidos" runat="server"></asp:label></td>
		</tr>
		</table>
	<asp:label id="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:label>
	<br/>
	<asp:panel id="pnlActDatosForm" Runat="server" Visible="False" Width="409px" 
        CssClass="td-content">
		<table id="table3" cellspacing="2" cellpadding="1" 
            border="0">
			<tr>
				<td colspan="2"><span class="subheader">Registre Dependiente&nbsp;&nbsp;</span><span class="error">aplicable 
                    al período:</span>
					<asp:label id="lblPeriodo" runat="server" ForeColor="Red" Font-Bold="True"></asp:label></td>
			</tr>
			<tr>
				<td class=" subheader" style="HEIGHT: 10px" colspan="2">
                    <asp:Label ID="lblMsg2" runat="server" CssClass="error" EnableViewState="False" 
                        Visible="False"></asp:Label>
                </td>
			</tr>
			<tr>
				<td valign="top" align="right" style="width: 20%">
					<asp:dropdownlist id="ddlTipoDoc" runat="server" CssClass="dropDowns">
						<asp:ListItem Value="C" Selected="True">C&#233;dula</asp:ListItem>
						<asp:ListItem Value="N">NSS</asp:ListItem>
					</asp:dropdownlist></td>
				<td valign="top" align="left" style="width: 331px">
					<asp:textbox id="txtDoumento" runat="server" MaxLength="11"></asp:textbox>
					&nbsp;<asp:Button ID="btnValidar" runat="server" Text="Buscar" />
                    &nbsp;<asp:RequiredFieldValidator id="RequiredFieldValidator2" runat="server" ControlToValidate="txtDoumento" Display="Dynamic"
						ErrorMessage="RequiredFieldValidator">El documento es requerido.</asp:RequiredFieldValidator>
					</td>
			</tr>
			</table>
	   		
	     <div id="divAgregarDep" visible="True" runat="server">
			<table>
			<tr>
			    <td align="right" valign="top" style="width: 20%">Dependiente</td>
			    <td class="subHeader" style="width: 327px"><asp:label id="lblNombreDep" runat="server"></asp:label></td>
		    </tr>
			<tr>
				<td align="right" valign="top" style="width: 20%"></td>
			    <td align="left" valign="top" style="width: 328px">
                    <asp:Button ID="btnAgregar" runat="server" Text="Agregar" />
                    &nbsp;
                    <asp:Button ID="btnCancelar" runat="server" CausesValidation="False" 
                        Text="Cancelar" />
                </td>
			</tr>
		</table>
		</div>
	</asp:panel><br/>
	<asp:panel id="pnlNovedadesDet" Runat="server" Visible="False">
		<table id="table6" width="620">
			<tr>
				<td>
					<asp:label id="lblPendientes" runat="server" CssClass="header" EnableViewState="False">Novedades Pendiente</asp:label></td>
				<td align="right">
					<asp:button id="btnAplicar" runat="server" Text="Aplicar Novedades" 
                        CausesValidation="False"></asp:button></td>
			</tr>
			<tr>
				<td colspan="2">
                    &nbsp;<uc2:ucGridNovPendientes id="UcGridNovPendientes1" runat="server">
                    </uc2:ucGridNovPendientes></td>
			</tr>
		</table>		
	</asp:panel>
</asp:Content>