<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="SolicitudAcogerseLey.aspx.vb" Inherits="Legal_SolicitudAcogerseLey" title="Solicitud para Acogerse a la Ley de Facilidades de Pago" %>

<%@ register src="../Controles/UCCiudadano.ascx" tagname="UCCiudadano" tagprefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="javascript" type="text/javascript">
	function checkNum()
	    {
	    
	        try
            {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
            }
            catch(err)
            {

            }

         }
    </script>
    
    <asp:updatepanel id="updMain" runat="server" updatemode="Conditional">
        <contenttemplate>
            <div class="header">Solicitud Para Acogerse a la Ley No. 189-07 que facilita el pago a los empleadores
                <br />
                con deudas pendientes con el Sistema Dominicano de Seguridad Social.</div>
            <div class="subHeader">
                &nbsp;</div>
            <br />
            <table class="tblWithImagen" cellspacing="1" cellpadding="1" border="0">
                <tr>
                    <td rowspan="3" >
                        <img src="../images/upcatriesgo.jpg" alt="" />
                    </td>
                    <td align="right">
                        &nbsp;<asp:Label ID="lbltxtRNC" runat="server" Font-Bold="True" Text="RNC o Cédula:"></asp:Label>
                    </td>
                    <td style="width: 131px">
                        &nbsp;<asp:TextBox ID="txtRNC" onKeyPress="checkNum()" runat="server" MaxLength="11"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtRNC"
                            Display="Dynamic" ErrorMessage="RNC o Cédula Inválido" SetFocusOnError="True"
                            ValidationExpression="^(\d{9}|\d{11})$" validationgroup="0"></asp:RegularExpressionValidator>&nbsp;
                    </td>
                </tr>
                <tr>
                    <td colspan="2" valign="middle" align="center">
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" causesvalidation="False" Enabled="False" />&nbsp;
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" causesvalidation="False" />&nbsp;
                    </td>
                </tr>
            </table>
            <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label><br />
            <asp:Label ID="lbltxtInfoAcuerdoPago" runat="server" CssClass="subHeader" Text="Favor completar la siguiente información para continuar con el proceso:"
                Visible="False"></asp:Label>
            <br />
            <br />
            <table cellpadding="1" cellspacing="1" id="tblInfoSolicitud" runat="server" visible="false" class="tblWithImagen" width="437px">
                <tr class="listheadermultiline">
                    <td align="right" style="text-align: left" colspan="3" >
                        <asp:Label ID="Label3" runat="server" Text="Datos Generales del Empleador"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 99px">
                        <asp:Label ID="lbltxtRazonSocial" runat="server" Text="Razón Social:"></asp:Label>
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 99px">
                            <asp:Label ID="lbltxtNombreComercial" runat="server" Text="Nombre Comercial:"></asp:Label>
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblNombreComercial" runat="server" Font-Bold="True"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" style="width: 99px">
                        <asp:Label ID="lbltxtTelefono" runat="server" Text="Teléfono:"></asp:Label>
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblTelefono" runat="server" Font-Bold="True"></asp:Label>
                    </td>            
                </tr>
                <tr>
                    <td colspan="3">
                        <fieldset>
                            <legend>
                                <asp:label id="lblgrid" runat="server" Text="Total Deudas del Empleador"></asp:label>
                            </legend>
                            <div style="height:4px"></div>
                            <asp:gridview id="gvDeuda" runat="server" autogeneratecolumns="false">
                                <columns>
                                    <asp:boundfield
                                     datafield="total_referencias" headertext="Referencias" dataformatstring="{0:N0}" htmlencode="false" itemstyle-width="85px" itemstyle-horizontalalign="Right">
                                     <headerstyle horizontalalign="right" />
                                    </asp:boundfield>
                                    <asp:boundfield
                                     datafield="total_interes" headertext="interés" dataformatstring="{0:c}" htmlencode="false" itemstyle-width="85px" itemstyle-horizontalalign="Right">
                                     <headerstyle horizontalalign="right" />
                                    </asp:boundfield>
                                    <asp:boundfield
                                     datafield="total_recargos" headertext="Recargo" dataformatstring="{0:c}" htmlencode="false" itemstyle-width="85px" itemstyle-horizontalalign="Right">
                                     <headerstyle horizontalalign="right" />
                                    </asp:boundfield>
                                    <asp:boundfield
                                     datafield="total_importes" headertext="Importe" dataformatstring="{0:c}" htmlencode="false" itemstyle-width="85px" itemstyle-horizontalalign="Right">
                                     <headerstyle horizontalalign="right" />
                                    </asp:boundfield>
                                    <asp:boundfield
                                     datafield="total_general" headertext="Total General" dataformatstring="{0:c}" htmlencode="false" itemstyle-width="85px" itemstyle-horizontalalign="Right">
                                     <headerstyle horizontalalign="right" />
                                    </asp:boundfield>
                                </columns>
                            </asp:gridview>
                        </fieldset>                        
                    </td>
                </tr>
                <tr>
                    <td colspan="3" style="height:8px"></td>
                </tr>
                <tr class="listheadermultiline">
                    <td align="right" style="text-align: left" colspan="3">
                        <asp:Label ID="Label4" runat="server" Text="Datos Complementarios de la Solicitud"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td colspan="3">
                        <uc1:ucciudadano id="UCCiudadano" runat="server" />                    
                    </td>
                </tr>
                <tr>
                    <td style="height: 6px" colspan="3"></td>
                </tr>
                <tr>
                    <td align="right" style="text-align: center;" colspan="3">
                        <asp:button id="btnGrabar" text="Procesar Solicitud" runat="server" UseSubmitBehavior="False" Enabled="False" />&nbsp;
                        <asp:button id="btnCancelar" text="Cancelar" runat="server" causesvalidation="False" />&nbsp;               &nbsp;&nbsp;
                        <br />
                        <asp:Label ID="Label1" runat="server" CssClass="error" Text="Favor NO presionar el boton de procesar mas de una vez."></asp:Label></td>
                </tr>                
            </table>
        </contenttemplate>
        <triggers>
            <asp:asyncpostbacktrigger controlid="btnBuscar" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnLimpiar" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnGrabar" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnCancelar" eventname="Click" />
        </triggers>
    </asp:updatepanel>
    
    <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator" style="left: 21px; bottom: 2%">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
    <br />
</asp:Content>

