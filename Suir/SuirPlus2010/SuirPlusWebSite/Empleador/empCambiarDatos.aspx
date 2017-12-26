<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="empCambiarDatos.aspx.vb" Inherits="Empleador_empCambiarDatos" Title="Actualizacion de Empleador" %>

<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc2" %>
<%@ Register Src="../Controles/UCTelefono.ascx" TagName="UCTelefono" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">
        function checkNum() {
            var carCode = event.keyCode;

            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }
        }

        function checkNum_punto(e) {
            var carCode = (window.event) ? window.event.keyCode : e.which;
            if (carCode != 8) {
                if ((carCode < 48) || (carCode > 57)) {
                    if (carCode == 46)
                        return;
                    else if (window.event) //IE       
                        window.event.returnValue = null;
                    else //Firefox       
                        e.preventDefault();
                }
            }
        }
    </script>

    <div class="header">
        Actualización de Empleadores
    </div>
    <br />
    <asp:UpdatePanel ID="upBotones" runat="server">
        <ContentTemplate>
            <table class="td-content" style="width: 290px" cellpadding="1" cellspacing="0">
                <tr>
                    <td>
                    </td>
                    <td colspan="2">
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        R.N.C.&nbsp;
                    </td>
                    <td>
                        <asp:TextBox ID="txtRNC" onKeyPress="checkNum()" runat="server" EnableViewState="False"
                            MaxLength="11"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                            Display="Dynamic" ErrorMessage="RegularExpressionValidator" ValidationExpression="^(\d{9}|\d{11})$"
                            SetFocusOnError="True" EnableViewState="False">(*)</asp:RegularExpressionValidator>
                    </td>
                    <td>
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />&nbsp;
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
    <br />
    <asp:UpdatePanel ID="upGrbar" runat="server">
        <ContentTemplate>
    <asp:Label ID="lbl_mensaje" runat="server" CssClass="labelData" Visible="false">El registro ha sido actualizado satisfactoriamente.</asp:Label>
            <br />
    <fieldset style="width: 590px" ID="fs_datos" runat="server" visible="false">
        <legend>Actualizacion de Datos</legend>
        <asp:Label ID="lblFormError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
        <table style="width: 400px">
            <tr>
                <td colspan="3"></td>
            </tr>
            <tr>
                <td align="right" style="width: 20%">
                    Razón Social&nbsp;
                </td>
                <td style="width: 65%">
                    <asp:TextBox ID="txt_razon_social_save" runat="server" Width="237px" 
                        EnableViewState="False" Enabled="False"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="txt_razon_social_save" SetFocusOnError="True" ToolTip="La razon social es obligatoria">(*)
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%" nowrap="nowrap">
                    Nombre Comercial&nbsp;
                </td>
                <td style="width: 65%">
                    <asp:TextBox ID="txt_nombre_comercial_save" runat="server" Width="237px" EnableViewState="False"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="txt_nombre_comercial_save" SetFocusOnError="True" ToolTip="El nombre comercial es obligatorio">(*)
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%" nowrap="nowrap">
                    Sector Economico&nbsp;
                </td>
                <td style="width: 65%">
                    <asp:DropDownList ID="ddlSectorEconomico_save" runat="server" CssClass="dropDowns">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlSectorEconomico_save" InitialValue="-1" SetFocusOnError="True" ToolTip="El sector económico es obligatorio">(*)
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%" nowrap="nowrap">
                    Sector Salarial&nbsp;
                </td>
                <td style="width: 65%">
                    <asp:DropDownList ID="ddlSectorSalarial_save" runat="server" CssClass="dropDowns">
                    </asp:DropDownList>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlSectorSalarial_save" InitialValue="-1" SetFocusOnError="True" ToolTip="El sector salarial es obligatorio">(*)
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%" nowrap="nowrap">
                    Capital&nbsp;
                </td>
                <td style="width: 65%">
                    <asp:TextBox ID="txt_capital_contable_save" runat="server" onKeyPress="checkNum_punto(event)"></asp:TextBox>
                    <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" CssClass="error"
                    Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="txt_capital_contable_save" SetFocusOnError="True" ToolTip="El capital contable es obligatorio">(*)
                    </asp:RequiredFieldValidator>
                </td>
            </tr>
            <tr>
                <td align="right" style="width: 20%" nowrap="nowrap">
                    Tipo de Empresa&nbsp;
                </td>
                <td style="width: 65%">
                    <asp:DropDownList ID="ddlTipoEmpresa_save" runat="server" CssClass="dropDowns">
                        <asp:ListItem Selected="True" Value="PR">Privada</asp:ListItem>
                        <asp:ListItem Value="PU">P&#250;blica</asp:ListItem>
                        <asp:ListItem Value="PC">P&#250;blica Centralizada</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
         <%--   <tr>
                <td align="right" style="width: 20%" nowrap="nowrap">
                    Estatus Cobro&nbsp;
                </td>
                <td style="width: 65%">
                    <asp:DropDownList ID="ddlEstatusCobro_save" runat="server" CssClass="dropDowns">
                        <asp:ListItem Selected="True" Value="N">N/A</asp:ListItem>
                        <asp:ListItem Value="L">Legal</asp:ListItem>
                        <asp:ListItem Value="C">En Cobro</asp:ListItem>
                        <asp:ListItem Value="A">En Auditoria</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>--%>
            <tr>
                <td colspan="2"></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <asp:Button ID="btn_salvar" runat="server" Text="Grabar" onclientclick="return confirm('¿Estas seguro de actualizar estos datos?')" />&nbsp;
                    <asp:Button ID="btn_cancelar" runat="server" Text="Limpiar" CausesValidation="False" />
                </td>
            </tr>
        </table>
    </fieldset>
        </ContentTemplate>
    </asp:UpdatePanel>
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>
