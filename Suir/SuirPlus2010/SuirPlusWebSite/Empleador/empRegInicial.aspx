<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="empRegInicial.aspx.vb" Inherits="Empleador_empRegInicial" Title="Registro Inicial" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucTelefono2.ascx" TagName="ucTelefono2" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <asp:UpdatePanel ID="upRegInicial" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <script runat="server" language="vb">
                Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
    			
                    Me.PermisoRequerido = 2
    			
                End Sub
            </script>
            <div class="header">
                Registro Inicial de Empleadores</div>
            <br />
            <table>
                <tr>
                    <td>
                        &nbsp;
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Panel ID="pnlFormulario" runat="server">
                            <span class="error">*</span>&nbsp;<span>Información obligatoria</span>
                            <asp:Label ID="lblFormError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                            <table border="0" cellpadding="0" cellspacing="0" width="600" class="td-note">
                                <tr>
                                    <td class="listheadermultiline">
                                        Información General
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        <div style="height: 5px;">
                                            &nbsp;</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Tipo Empresa<br />
                                        <asp:DropDownList ID="ddlTipoEmpresa" runat="server" CssClass="dropDowns" AutoPostBack="True">
                                            <asp:ListItem Selected="True" Value="PR">Privada</asp:ListItem>
                                            <asp:ListItem Value="PU">P&#250;blica</asp:ListItem>
                                            <asp:ListItem Value="PC">P&#250;blica Centralizada</asp:ListItem>
                                            <%--<asp:ListItem Value="PE">Persona</asp:ListItem>--%>
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        RNC/Cédula<br />
                                        <asp:TextBox ID="txtRNCCedula" runat="server" MaxLength="11"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="regExpRncCedula" runat="server" Display="Dynamic"
                                            SetFocusOnError="True" CssClass="error" ControlToValidate="txtRNCCedula" ValidationGroup="RNC"
                                            ValidationExpression="^(\d{9}|\d{11})$">RNC/Cédula Inválida</asp:RegularExpressionValidator>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtRNCCedula"
                                            CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True"
                                            ValidationGroup="RNC">*</asp:RequiredFieldValidator>
                                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar Empleador" ValidationGroup="RNC" />&nbsp;<asp:Image
                                            ID="imgBusqueda" runat="server" Visible="False" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Razón Social<br />
                                        <asp:TextBox ID="txtRazonSocial" runat="server" ReadOnly="True" Width="449px"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Nombre Comercial<br />
                                        <asp:TextBox ID="txtNombreComercial" runat="server" Width="449px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="error"
                                            Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="txtNombreComercial"
                                            ToolTip="Favor completar el nombre comercial">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Sector Salarial<br />
                                        <asp:DropDownList ID="ddlSectorSalarial" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rqvSectorSalarial" runat="server" CssClass="error"
                                            Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlSectorSalarial"
                                            InitialValue="-1" SetFocusOnError="True" ToolTip="Favor específicar el sector salarial">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Sector Económico<br />
                                        <asp:DropDownList ID="ddlSectorEconomico" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rqvSectorEconomico" runat="server" CssClass="error"
                                            Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlSectorEconomico"
                                            InitialValue="-1" SetFocusOnError="True" ToolTip="Favor específicar el sector económico">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Actividad<br />
                                        <asp:DropDownList ID="ddlActividad" runat="Server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="rqvActividad" runat="server" CssClass="error" Display="Dynamic"
                                            ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlActividad" SetFocusOnError="True"
                                            ToolTip="Favor específicar la actividad económica">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Es Zona Franca<br />
                                        <asp:CheckBox ID="ChkEsZonaFranca" runat="server" AutoPostBack="True" OnCheckedChanged="ChkEsZonaFranca_CheckedChanged" />
                                    </td>
                                </tr>
                                <tr id="TrTipo" runat="server">
                                    <td>
                                        Tipo<br />
                                        <asp:DropDownList ID="ddlTipoZonaFranca" runat="Server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                                <tr id="TrParque" runat="server">
                                    <td>
                                        Parque<br />
                                        <asp:DropDownList ID="ddlParque" runat="Server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                    </td>
                                </tr>
                            </table>
                            <div style="height: 3px;">
                                &nbsp;</div>
                            <table border="0" cellpadding="0" cellspacing="0" class="td-note" width="600">
                                <tr>
                                    <td class="listheadermultiline" colspan="2">
                                        Representante Principal
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%">
                                        Representante
                                    </td>
                                    <td>
                                        <uc1:UCCiudadano ID="ucRepresentante" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%">
                                        Teléfono 1
                                    </td>
                                    <td>
                                        <uc2:ucTelefono2 ID="RepTelefono1" runat="server" isValidEmpty="false" />
                                        &nbsp; Ext.
                                        <asp:TextBox ID="txtRepExt1" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%">
                                        Teléfono 2
                                    </td>
                                    <td>
                                        <uc2:ucTelefono2 ID="RepTelefono2" runat="server" />
                                        &nbsp; Ext.
                                        <asp:TextBox ID="txtRepExt2" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%">
                                        Email
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtRepEmail" runat="server" ToolTip="Ej: alguien@mail.com" Width="206px"
                                            MaxLength="50"></asp:TextBox>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRepEmail"
                                            CssClass="error" Display="Dynamic" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">Email inválido</asp:RegularExpressionValidator>&nbsp;<asp:CheckBox
                                                ID="chkboxNotificacionMail" runat="server" Text="Notificación vía e-mail" Checked="True" />
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 15%">
                                        Confirmar Email
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtConfirmarEmail" runat="server" Width="206px"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator12" runat="server" ControlToValidate="txtConfirmarEmail"
                                            ErrorMessage="La confirmación del Email es requerida" Display="Dynamic">*</asp:RequiredFieldValidator>
                                        <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtConfirmarEmail"
                                            ErrorMessage="Correo electrónico erróneo." SetFocusOnError="True" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                                            Display="Dynamic">*</asp:RegularExpressionValidator>
                                        <asp:CompareValidator ID="CompareValidator1" runat="server" ControlToCompare="txtRepEmail"
                                            ControlToValidate="txtConfirmarEmail" Display="Dynamic" ErrorMessage="El email actual debe ser igual al email de confirmación">*</asp:CompareValidator>
                                    </td>
                                </tr>
                            </table>
                            <div style="height: 3px;">
                                &nbsp;</div>
                            <table id="TABLE1" border="0" cellpadding="0" cellspacing="0" class="td-note" width="600">
                                <tr>
                                    <td class="listheadermultiline" colspan="4">
                                        Dirección
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="4">
                                        <div style="height: 5px;">
                                            &nbsp;</div>
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 10%">
                                        Calle
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtCalle" runat="server" Width="171px" MaxLength="150"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ControlToValidate="txtCalle"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="error">*</asp:RequiredFieldValidator>
                                    </td>
                                    <td style="width: 10%">
                                        Número
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtNumero" runat="server" Width="63px" MaxLength="10"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ControlToValidate="txtNumero"
                                            Display="Dynamic" SetFocusOnError="True" CssClass="error">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Edificio
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtEdificio" runat="server" Width="171px" MaxLength="25"></asp:TextBox>
                                    </td>
                                    <td>
                                        Piso
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtPiso" runat="server" Width="61px" MaxLength="2"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Apartamento
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtApartamento" runat="server" Width="171px" MaxLength="25"></asp:TextBox>
                                    </td>
                                    <td>
                                        Sector
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtSector" runat="server" Width="133px" MaxLength="150"></asp:TextBox>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ControlToValidate="txtSector"
                                            CssClass="error" Display="Dynamic" SetFocusOnError="True">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Provincia
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddProvincia" runat="server" AutoPostBack="True" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ControlToValidate="ddProvincia"
                                            CssClass="error" Display="Dynamic" InitialValue="-1" SetFocusOnError="True" ToolTip="Selecciones una Provincia">*</asp:RequiredFieldValidator>
                                    </td>
                                    <td>
                                        Municipio
                                    </td>
                                    <td>
                                        <asp:DropDownList ID="ddMunicipio" runat="server" CssClass="dropDowns">
                                        </asp:DropDownList>
                                        <asp:RequiredFieldValidator ID="RequiredFieldValidator8" runat="server" ControlToValidate="ddMunicipio"
                                            CssClass="error" Display="Dynamic" InitialValue="-1" SetFocusOnError="True" ToolTip="Selecciones un Municipio">*</asp:RequiredFieldValidator>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Teléfono 1
                                    </td>
                                    <td colspan="3">
                                        <uc2:ucTelefono2 ID="Telefono1" runat="server" ErrorMessage="*" isValidEmpty="false" />
                                        &nbsp;&nbsp; Ext.
                                        <asp:TextBox ID="txtExt1" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Teléfono 2
                                    </td>
                                    <td colspan="3">
                                        <uc2:ucTelefono2 ID="Telefono2" runat="server" />
                                        &nbsp;&nbsp; Ext.
                                        <asp:TextBox ID="txtExt2" runat="server" Width="43px" MaxLength="4"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Fax
                                    </td>
                                    <td>
                                        <uc2:ucTelefono2 ID="Fax" runat="server" isValidEmpty="true" />
                                    </td>
                                    <td>
                                        Email
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtEmail" runat="server" ToolTip="Ej: alguien@mail.com" Width="171px"
                                            MaxLength="50"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                    <td>
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                            <div style="height: 5px;">
                                &nbsp;</div>
                            <table border="0" cellpadding="0" cellspacing="0" class="td-note" width="600">
                                <tr>
                                    <td style="width: 55px">
                                        Documentos
                                    </td>
                                    <td>
                                        <asp:FileUpload ID="flCargarDocumentosEmpresa" runat="server" />
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right" colspan="4">
                                        <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" />
                                        &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
                                        <br />
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                        </asp:Panel>
                        <asp:Panel ID="pnlResultado" runat="server" Visible="false">
                            <table border="0" cellpadding="0" cellspacing="2" class="td-content" width="600">
                                <tr>
                                    <td align="left" class="subHeader" colspan="2">
                                        Empleador Registrado
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="height: 5px;">
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" valign="top">
                                        <span class="error">El empledor fue registrado satisfactoriamente.</span>
                                    </td>
                                </tr>
                                <tr>
                                    <td class="error" colspan="2" style="height: 5px;">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="subHeader" colspan="2">
                                        Información del Empleador
                                    </td>
                                </tr>
                                <tr>
                                    <td class="error" colspan="2" style="height: 5px;">
                                    </td>
                                </tr>
                                <tr>
                                    <td style="width: 16%">
                                        RNC o Cédula
                                    </td>
                                    <td align="left" valign="top">
                                        <asp:Label ID="lblFRncCedula" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Razón Social
                                    </td>
                                    <td>
                                        <asp:Label ID="lblFinRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td nowrap="nowrap">
                                        Nombre Comercial
                                    </td>
                                    <td>
                                        <asp:Label ID="lblFinNombreComercial" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="height: 5px;">
                                    </td>
                                </tr>
                                <tr>
                                    <td class="subHeader" colspan="2">
                                        Información del Representante
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="height: 5px;">
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Documento
                                    </td>
                                    <td>
                                        <asp:Label ID="lblFinCedula" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        NSS
                                    </td>
                                    <td>
                                        <asp:Label ID="lblFinNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        Nombre
                                    </td>
                                    <td>
                                        <asp:Label ID="lblFinNombre" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                        CLASS
                                    </td>
                                    <td>
                                        <asp:Label ID="lblFinCLASS" runat="server" CssClass="labelData">El class se le envio al la dirección de correo registrado.</asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="height: 3px;">
                                        &nbsp;
                                    </td>
                                </tr>
                            </table>
                            <div style="width: 415px">
                                <div class="subHeader">
                                    <br />
                                    Completar Solicitud<br />
                                </div>
                                <table width="415px">
                                    <tr>
                                        <td nowrap="nowrap">
                                            &nbsp;
                                        </td>
                                        <td>
                                            &nbsp;
                                        </td>
                                    </tr>
                                    <tr>
                                        <td nowrap="nowrap" valign="top">
                                            Nro. Solicitud
                                        </td>
                                        <td valign="top">
                                            <asp:Label ID="lblNroSolicitud" runat="server" CssClass="labelData"></asp:Label>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            Comentario
                                        </td>
                                        <td>
                                            <asp:TextBox ID="txtComentarioSolicitud" runat="server" Height="50px" TextMode="MultiLine"
                                                Width="340px"></asp:TextBox>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                        <td>
                                            <asp:RequiredFieldValidator ID="RequiredFieldValidator10" runat="server" ControlToValidate="txtComentarioSolicitud"
                                                Display="Dynamic" ErrorMessage="El comentario es requerido." ValidationGroup="vgCierreSolicitud"></asp:RequiredFieldValidator>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td colspan="2" align="right">
                                            <asp:Button ID="btnCerrarSolRegistroEmpresa" runat="server" Text="Cerrar Solicitud"
                                                ValidationGroup="vgCierreSolicitud" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" colspan="2">
                                            <asp:Label ID="lblMensajeSol" runat="server" CssClass="error"></asp:Label>
                                        </td>
                                    </tr>
                                </table>
                            </div>
                            <br />
                            <br />
                            <br />
                            <div style="width: 415px">
                                <asp:Button ID="btnFinal" runat="server" Text="Registrar otro empleador" />&nbsp;
                                <asp:Button ID="btnImpersonar" runat="server" Text="Ingresar Como Representante" />
                            </div>
                        </asp:Panel>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnFinal" />
            <asp:PostBackTrigger ControlID="btnImpersonar" />
            <asp:PostBackTrigger ControlID="btnCerrarSolRegistroEmpresa" />
            <asp:PostBackTrigger ControlID="btnAceptar" />
            <asp:PostBackTrigger ControlID="btnLimpiar" />
        </Triggers>
    </asp:UpdatePanel>
</asp:Content>
