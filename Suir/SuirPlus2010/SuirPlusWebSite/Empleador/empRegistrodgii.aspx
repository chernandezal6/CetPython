<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" EnableEventValidation="false" AutoEventWireup="false" CodeFile="empRegistrodgii.aspx.vb" Inherits="Empleador_empRegistrodgii" title="Registro Empleadores en DGII" %>

<%@ Register Src="../Controles/ucTelefono2.ascx" TagName="ucTelefono2" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="javascript" type="text/javascript">
	    $(function pageLoad(sender, args) {

	        // Datepicker
	        $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

	        $("#ctl00_MainContent_txtFechaConstitucion").datepicker($.datepicker.regional['es']);
	        $("#ctl00_MainContent_txtFechaAct").datepicker($.datepicker.regional['es']);

	    });
	  </script>
    <script runat="server" language="vb">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
				
				Me.PermisoRequerido = 54
				
			End Sub
    </script>
  
    
    <div class="header">Registro Empleadores en DGII</div>
    <br />
    <span class="error">*</span>&nbsp;<span>Información obligatoria</span>
    <asp:UpdatePanel ID="upError" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Label ID="lblFormError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdatePanel ID="upFormulario" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Panel id="pnlRegistro" runat="server">
                <table border="0" cellpadding="0" cellspacing="1" class="td-note" width="600">
                <tr>
                    <td colspan="2" class="listheadermultiline">Información General</td>
                </tr>
                <tr>
                    <td colspan="2">
                        <div style="height: 5px;">
                            &nbsp;</div>
                    </td>
                </tr>
                <tr>
                    <td style="width: 15%">RNC/Cédula</td>
                    <td>
                        <asp:TextBox ID="txtRncCedula" runat="server" MaxLength="11" ToolTip="RNC o Cédula del Empleador"></asp:TextBox>
                        <span class="error">*&nbsp;</span>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRncCedula"
                            CssClass="error" Display="Dynamic" SetFocusOnError="True">Introduzca RNC/Cédula</asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRncCedula"
                            CssClass="error" Display="Dynamic" SetFocusOnError="True" ValidationExpression="^(\d{9}|\d{11})$">RNC/Cédula Inválido</asp:RegularExpressionValidator></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Razón Social</td>
                    <td>
                        <asp:TextBox ID="txtRazonSocial" runat="server" MaxLength="150" Width="417px" ToolTip="Escriba Correctamente la Razón Social"></asp:TextBox>
                        <span class="error">*&nbsp;</span>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtRazonSocial"
                            CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True">Obligatorio</asp:RequiredFieldValidator></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Nombre Comercial</td>
                    <td>
                        <asp:TextBox ID="txtNombreComercial" runat="server" MaxLength="150" ToolTip="Escriba Correctamente el Nombre Comercial"
                            Width="417px"></asp:TextBox>
                        <span class="error">*&nbsp;</span>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtNombreComercial"
                            CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True">Obligatorio</asp:RequiredFieldValidator></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Tipo Empresa</td>
                    <td>
                        <asp:DropDownList ID="ddlTipoEmpresa" runat="server" CssClass="dropDowns">
                            <asp:ListItem Selected="True" Value="PR">Privada</asp:ListItem>
                            <asp:ListItem Value="PU">P&#250;blica</asp:ListItem>
                            <asp:ListItem Value="PC">P&#250;blica Centralizada</asp:ListItem>
                        </asp:DropDownList></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Teléfono</td>
                    <td>
                        <uc1:ucTelefono2 ID="Telefono" runat="server" ErrorMessage="Obligatorio" isValidEmpty="false" EnableViewState="true" />
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Email</td>
                    <td>
                        <asp:TextBox ID="txtEmail" runat="server" MaxLength="50" Width="242px"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtEmail"
                            CssClass="error" Display="Dynamic" SetFocusOnError="True" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Email Inválido</asp:RegularExpressionValidator></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Fecha Constitución</td>
                    <td>
                        <asp:TextBox ID="txtFechaConstitucion" runat="server" Width="70px" onkeypress="return false;"></asp:TextBox>
                
                        
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Inicio Actividades</td>
                    <td>
                        <asp:TextBox ID="txtFechaAct" runat="server" Width="70px" onkeypress="return false;"></asp:TextBox>
                                              
                    </td>
                </tr>               
            </table>
             <div style="height: 3px;">
            &nbsp;</div>
        <asp:UpdatePanel ID="upDireccion" runat="server" UpdateMode="Conditional">
            <ContentTemplate>
                <table id="TABLE1" border="0" cellpadding="0" cellspacing="0" class="td-note" width="600">
                    <tr>
                        <td class="listheadermultiline" colspan="4">
                            Dirección</td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <div style="height: 5px;">
                                &nbsp;</div>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 15%">
                            Calle</td>
                        <td>
                            <asp:TextBox ID="txtCalle" runat="server" Width="171px" MaxLength="150"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtCalle"
                                Display="Dynamic" SetFocusOnError="True" CssClass="error">*</asp:RequiredFieldValidator></td>
                        <td style="width: 10%">
                            Número</td>
                        <td>
                            <asp:TextBox ID="txtNumero" runat="server" Width="63px" MaxLength="10"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtNumero"
                                Display="Dynamic" SetFocusOnError="True" CssClass="error">*</asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td>
                            Edificio</td>
                        <td>
                            <asp:TextBox ID="txtEdificio" runat="server" Width="171px" MaxLength="25"></asp:TextBox></td>
                        <td>
                            Piso</td>
                        <td>
                            <asp:TextBox ID="txtPiso" runat="server" Width="61px" MaxLength="2"></asp:TextBox></td>
                    </tr>
                    <tr>
                        <td>
                            Apartamento</td>
                        <td>
                            <asp:TextBox ID="txtApartamento" runat="server" Width="171px" MaxLength="25"></asp:TextBox></td>
                        <td>
                            Sector</td>
                        <td>
                            <asp:TextBox ID="txtSector" runat="server" Width="133px" MaxLength="150"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtSector"
                                CssClass="error" Display="Dynamic" SetFocusOnError="True">*</asp:RequiredFieldValidator></td>
                    </tr>
                    <tr>
                        <td>
                            Provincia</td>
                        <td>
                            <asp:DropDownList ID="ddProvincia" runat="server" AutoPostBack="True" CssClass="dropDowns">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="ddProvincia"
                                CssClass="error" Display="Dynamic" InitialValue="-1" SetFocusOnError="True" ToolTip="Selecciones una Provincia">obligatorio</asp:RequiredFieldValidator></td>
                        <td>
                            Municipio</td>
                        <td>
                            <asp:DropDownList ID="ddMunicipio" runat="server" CssClass="dropDowns">
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddMunicipio"
                                CssClass="error" Display="Dynamic" InitialValue="-1" SetFocusOnError="True" ToolTip="Selecciones un Municipio">obligatorio</asp:RequiredFieldValidator></td>
                    </tr>                    
                </table>
                 <div style="height: 3px;">
            &nbsp;</div>
                <table  border="0" cellpadding="0" cellspacing="0" width="600">
                    <tr>
                        <td align="right">
                            <asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>&nbsp;
						<asp:button id="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False"></asp:button>&nbsp;
                        </td>
                    </tr>
                </table>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddProvincia" EventName="SelectedIndexChanged" />
            </Triggers>
        </asp:UpdatePanel>             
          </asp:Panel> 
          <asp:Panel ID="pnlConfirmacion" runat="server" Visible="false">
                 <table border="0" cellpadding="1" cellspacing="1" class="td-note" width="600">
                <tr>
                    <td colspan="2" class="listheadermultiline">
                        Confirmación</td>
                    <td class="listheadermultiline" colspan="1">
                    </td>
                    <td class="listheadermultiline" colspan="1">
                    </td>
                </tr>                    
                <tr>
                    <td colspan="4" align="center" class="label-Resaltado" style="height:5px;">
                        Favor confirmar los datos antes de proceder a Registrar el Empleador</td>
                </tr>
                <tr>
                    <td style="width: 15%">RNC/Cédula</td>
                    <td colspan="3">
                        <asp:Label ID="lblRNCCedula" runat="server" CssClass="subHeader"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Razón Social</td>
                    <td colspan="3">
                        <asp:Label ID="lblRS" runat="server" CssClass="subHeader"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Nombre Comercial</td>
                    <td colspan="3">
                        <asp:Label ID="lblNC" runat="server" CssClass="subHeader"></asp:Label></td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Tipo Empresa</td>
                    <td style="width: 25%">
                        <asp:Label ID="lblTipoEmp" runat="server" CssClass="labelData"></asp:Label></td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Teléfono</td>
                    <td>
                        <asp:Label ID="lblTelefono" runat="server" CssClass="labelData"></asp:Label></td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Email</td>
                    <td>
                        <asp:Label ID="lblEmail" runat="server" CssClass="labelData"></asp:Label></td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Fecha Constitución</td>
                    <td>
                        <asp:Label ID="lblFechaCont" runat="server" CssClass="labelData"></asp:Label></td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td style="width: 10%">
                        Inicio Actividades</td>
                    <td>
                        <asp:Label ID="lblFechaAct" runat="server" CssClass="labelData"></asp:Label></td>
                    <td>
                    </td>
                    <td>
                    </td>
                </tr>               
                     <tr>
                         <td style="width: 10%">
                             Calle</td>
                         <td>
                             <asp:Label ID="lblCalle" runat="server" CssClass="labelData"></asp:Label></td>
                         <td style="width: 8%">
                             Número</td>
                         <td>
                             <asp:Label ID="lblNumero" runat="server" CssClass="labelData"></asp:Label></td>
                     </tr>
                     <tr>
                         <td style="width: 10%">
                             Edificio</td>
                         <td>
                             <asp:Label ID="lblEdificio" runat="server" CssClass="labelData"></asp:Label></td>
                         <td>
                             Piso</td>
                         <td>
                             <asp:Label ID="lblPiso" runat="server" CssClass="labelData"></asp:Label></td>
                     </tr>
                     <tr>
                         <td style="width: 10%">
                             Apartamento</td>
                         <td>
                             <asp:Label ID="lblApartamento" runat="server" CssClass="labelData"></asp:Label></td>
                         <td>
                             Sector</td>
                         <td>
                             <asp:Label ID="lblSector" runat="server" CssClass="labelData"></asp:Label></td>
                     </tr>
                     <tr>
                         <td style="width: 10%">
                             Provincia</td>
                         <td>
                             <asp:Label ID="lblProvincia" runat="server" CssClass="labelData"></asp:Label></td>
                         <td>
                             Municipio</td>
                         <td>
                             <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label></td>
                     </tr>
                     <tr>
                         <td style="width: 10%">
                         </td>
                         <td>
                         </td>
                         <td>
                         </td>
                         <td>
                         </td>
                     </tr>
                     <tr>
                         <td style="width: 10%">
                         </td>
                         <td>
                         </td>
                         <td>
                         </td>
                         <td align="right">
                             <asp:Button ID="btnRegistrar" runat="server" OnClientClick='return("Está seguro que desea registrarlo");'
                                 Text="Registrar" OnClick="btnRegistrar_Click" />&nbsp;<asp:Button ID="btnActualizar" runat="server" Text="Modificar Datos" OnClick="btnActualizar_Click" /></td>
                     </tr>
            </table>         
          </asp:Panel>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

