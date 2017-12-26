<%@ Page AutoEventWireup="false" CodeFile="censoEmpleador.aspx.vb" Inherits="Censo_censoEmpleador"
    Language="VB" MasterPageFile="~/SuirPlus.master" Title="Actualización Perfíl de la Empresa" %>
<%@ Register TagPrefix="tss" TagName="Telefono" Src="~/Controles/ucTelefono2.ascx" %>
<script runat="server" language="vb">
    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init

        RolesOpcionales = New String() {41, 31, 48, 232}

    End Sub
</script>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <style>
        .td-content {
            width: 550px !important;
        }
    </style>

    <div class="header">
        Actualización Perfíl de la Empresa
    </div>    
     <br />
    <span style="color: Red;">*&nbsp;Información Obligatoria</span>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label>       
    <table id="tblCenso" runat="server" cellpadding="1" cellspacing="0" class="td-content">        
        <tr>
            <td class="listheadermultiline" colspan="4">
                Información General</td>
        </tr>
        <tr>
            <td colspan="4" style="height:3px;"></td>
        </tr>
        <tr>
            <td align="right" style="width:15%;">
                RNC / Cédula</td>
            <td colspan="3">
                <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                Razón Social</td>
            <td colspan="3">
                <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                Nombre Comercial</td>
            <td colspan="3">
                <asp:TextBox ID="txtNombreComercial" runat="server" Enabled="false" Width="344px"></asp:TextBox><span
                    style="color: Red;">*</span>
                <asp:RequiredFieldValidator ID="reqTxtNombreComercial" runat="server" ControlToValidate="txtNombreComercial"
                    Display="Dynamic" ErrorMessage="Nombre comercial es requerido." SetFocusOnError="True">*</asp:RequiredFieldValidator><br/>
                <span style="color: Red;">actual:&nbsp;</span><asp:Label ID="lblNombreComercial" runat="server"
                    CssClass="labelSmall">- -</asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Sector Económico</td>
            <td colspan="3">
                <asp:DropDownList ID="ddlSectorEconomico" Enabled="false" runat="server" CssClass="dropDowns">
                </asp:DropDownList><span style="color: Red;">*</span>
                <asp:RequiredFieldValidator ID="reqDdlSectorEconomico" runat="server" ControlToValidate="ddlSectorEconomico"
                    ErrorMessage="Sector económico requerido." InitialValue="-1" SetFocusOnError="True">*</asp:RequiredFieldValidator><br/>
                <span style="color: Red;">actual:&nbsp;</span><asp:Label ID="lblSectorEconomico" runat="server"
                    CssClass="labelSmall">- -</asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right" style="white-space:nowrap;">
                Motivo no impresion</td>
            <td colspan="3">
                <asp:DropDownList ID="ddlMotivoNoImpresion" runat="server" CssClass="dropDowns">
                </asp:DropDownList><span style="color: Red;">*</span></td>
        </tr>
       </table>
       <div style="height:5px;">
           &nbsp;</div>
        
        <asp:UpdatePanel runat="server" ID="upProvincia" UpdateMode="Conditional">
            <ContentTemplate>
                    <table cellpadding="0" cellspacing="0" class="td-content">
           <tr>
               <td colspan="4" style="height:3px;">
               </td>
           </tr>
        <tr>
            <td class="listheadermultiline" colspan="4">
                Dirección</td>
        </tr>       
        <tr>
            <td align="right" style="width: 15%">
                Calle</td>
            <td style="width:20%;">
                <asp:TextBox ID="txtCalle" runat="server" Width="216px"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblCalle" runat="server" CssClass="labelSmall">- -</asp:Label>
            </td>
            <td align="right" style="width: 5%;">
                Número</td>
            <td>
                <asp:TextBox ID="txtNumero" runat="server" Width="64px"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblNumero" runat="server" CssClass="labelSmall">- -</asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Edificio</td>
            <td>
                <asp:TextBox ID="txtEdificio" runat="server" Width="216px"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblEdificio" runat="server"
                    CssClass="labelSmall">- -</asp:Label>
            </td>
            <td align="right">
                Piso</td>
            <td>
                <asp:TextBox ID="txtPiso" runat="server" Width="64px"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblPiso" runat="server" CssClass="labelSmall">- -</asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Apartamento</td>
            <td>
                <asp:TextBox ID="txtApto" runat="server"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblApartamento" runat="server"
                    CssClass="labelSmall">- -</asp:Label>
            </td>
            <td align="right">
                Sector</td>
            <td>
                <asp:TextBox ID="txtSector" runat="server" Width="176px"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblSector" runat="server" CssClass="labelSmall">- -</asp:Label>
            </td>
        </tr>                                                                     
        <tr>
            <td align="right" style="width: 18%;">
                Provincia&nbsp;
            </td>
            <td colspan="3">
                <asp:DropDownList ID="ddProvincia" runat="server" AutoPostBack="True" CssClass="dropDowns">
                </asp:DropDownList>&nbsp;*
                <asp:CompareValidator ID="Comparevalidator3" runat="server" ControlToValidate="ddProvincia"
                    ErrorMessage="Debe seleccionar la Provincia." Operator="NotEqual" ValueToCompare="-1" Display="Dynamic"> Debe seleccionar la Provincia.</asp:CompareValidator>
                <br />
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblProvincia" runat="server"
                    CssClass="labelSmall">- -</asp:Label>
             </td>
        </tr>
        <tr>
            <td align="right">
                Municipio&nbsp;
            </td>
            <td colspan="3">
                <asp:DropDownList ID="ddMunicipio" runat="server" CssClass="dropDowns">
                </asp:DropDownList>&nbsp;*
                <asp:CompareValidator ID="Comparevalidator4" runat="server" ControlToValidate="ddMunicipio"
                    ErrorMessage="Debe seleccionar el Municipio." Operator="NotEqual" ValueToCompare="-1" Display="Dynamic"> Debe seleccionar el Municipio.</asp:CompareValidator>
                <br />
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblMunicipio" runat="server"
                    CssClass="labelSmall">- -</asp:Label>
            </td>
        </tr>
     </table>
            </ContentTemplate>
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="ddMunicipio" EventName="SelectedIndexChanged" />
            </Triggers>
        </asp:UpdatePanel>
           
       
    <div style="height: 5px;">
        &nbsp;</div>      
        <table id="Table1" runat="server" cellpadding="0" cellspacing="0" class="td-content"
            >
            <tr>
                <td colspan="4" style="height:3px;">
                </td>
            </tr>     
        <tr>
            <td class="listheadermultiline" colspan="4">
                E-mail y Teléfonos</td>
        </tr>
            <tr>
                <td colspan="4" style="height:3px;">
                </td>
            </tr>
        <tr>
            <td align="right">
                E-mail</td>
            <td colspan="3">
                <asp:TextBox ID="txtEmail" runat="server"></asp:TextBox>
                <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtEmail"
                    Display="Dynamic" ErrorMessage="Email Inválido" SetFocusOnError="True" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"></asp:RegularExpressionValidator><br/>
                <span style="color: Red;">actual:</span>&nbsp;
                <asp:Label ID="lblEmail" runat="server"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                Teléfono #1</td>
            <td>
                <tss:Telefono ID="ucTelefono1" runat="server" />                
                <br/>
                <span style="color: Red;">actual: </span>&nbsp;<asp:Label ID="lblTelefono1" runat="server">- -</asp:Label>
            </td>
            <td align="right">
                Ext.</td>
            <td>
                <asp:TextBox ID="txtExt1" runat="server" Width="40px"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblExt1" runat="server">- -</asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Teléfono #2</td>
            <td>
                <tss:Telefono ID="ucTelefono2" runat="server" />
                <br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblTelefono2" runat="server">- -</asp:Label>
            </td>
            <td align="right">
                Ext.</td>
            <td>
                <asp:TextBox ID="txtExt2" runat="server" Width="40px"></asp:TextBox><br/>
                <span style="color: Red;">actual:</span>&nbsp;<asp:Label ID="lblExt2" runat="server">- -</asp:Label>
            </td>
        </tr>
        <tr>
            <td align="right">
                Fax</td>
            <td colspan="3">
                <tss:Telefono ID="ucFax" runat="server" />
                <br/>
                <span style="color: Red;">actual:&nbsp;</span>
                <asp:Label ID="lblFax" runat="server"></asp:Label></td>
        </tr>
       </table>
    <div style="height: 5px;">
        &nbsp;</div>
       <table cellpadding="0" cellspacing="0" class="td-content" style="visibility:hidden;">
        <tr>
            <td class="listheadermultiline" colspan="4">
                Representantes</td>
        </tr>
           <tr>
               <td colspan="4" style="height:3px;">
               </td>
           </tr>     
        <tr>
            <td align="right" colspan="4">
                <asp:Repeater ID="repRepresentante" runat="server">
                    <ItemTemplate>
                        <table cellpadding="0" cellspacing="4" class="td-note" width="100%">
                            <tr>
                                <td style="width:15%;">
                                    Representante</td>
                                <td colspan="3">
                                    <asp:Label ID="lblRepDocumento" runat="server" Text='<%# Container.DataItem("no_documento")%>'
                                        Visible="False"></asp:Label>
                                    <asp:Label ID="lblRepresentante" runat="server" CssClass="LabelDataGreen">
												<%# Container.DataItem("NOMBRE")%>
                                    </asp:Label>&nbsp;</td>
                            </tr>
                            <tr>
                                <td align="right" style="width:10%;">
                                    Teléfono #1</td>
                                <td style="width: 10%;">
                                    <tss:Telefono ID="ucRepTel1" runat="server" phoneNumber='<%# Container.DataItem("TELEFONO")%>' />                                   
                                    <br/>
                                    <span style="color: Red;">actual:</span>&nbsp;
                                    <asp:Label ID="lblRepTelefono1" runat="server" EnableViewState="False"></asp:Label>
                                </td>
                                <td align="right">
                                    Ext.</td>
                                <td>
                                    <asp:TextBox ID="txtRepExt1" runat="server" Text='<%# Container.DataItem("EXTENSION1")%>'
                                        Width="40px">
                                    </asp:TextBox>
                                    <br/>
                                    <span style="color: Red;">actual:</span>&nbsp;
                                    <asp:Label ID="lblRepExt1" runat="server" EnableViewState="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    Teléfono #2</td>
                                <td>
                                    <tss:Telefono ID="ucRepTel2" runat="server" phoneNumber='<%# Container.DataItem("TELEFONO2")%>' />                                   
                                    <br/>
                                    <span style="color: Red;">actual:</span>&nbsp;
                                    <asp:Label ID="lblRepTelefono2" runat="server" EnableViewState="False"></asp:Label>
                                </td>
                                <td align="right" style="width:16%;">
                                    Ext.</td>
                                <td style="width:52%;">
                                    <asp:TextBox ID="txtRepExt2" runat="server" Text='<%# Container.DataItem("EXTENSION2")%>'
                                        Width="40px">
                                    </asp:TextBox>
                                    <br/>
                                    <span style="color: Red;">actual:</span>&nbsp;
                                    <asp:Label ID="lblRepExt2" runat="server" EnableViewState="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">
                                    Email</td>
                                <td colspan="3">
                                    <asp:TextBox ID="txtRepEmail" runat="server" Text='<%# Container.DataItem("EMAIL")%>'
                                        Width="216px">
                                    </asp:TextBox><asp:RegularExpressionValidator ID="regEmailRep" runat="server" ControlToValidate="txtRepEmail"
                                        Display="Dynamic" ErrorMessage="Email Inválido" SetFocusOnError="true" ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*">
                                    </asp:RegularExpressionValidator><br/>
                                    <span style="color: Red;">actual:</span>&nbsp;
                                    <asp:Label ID="lblRepEmail" runat="server" EnableViewState="False"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4">
                                    &nbsp;</td>
                            </tr>
                        </table>
                    </ItemTemplate>
                    <SeparatorTemplate>
                        <br/>
                    </SeparatorTemplate>
                </asp:Repeater>
               
        </tr>
    </table>
    <table cellpadding="0" cellspacing="0" class="td-content">
        <tr>
            <td align="right">
                 <br/>
                <asp:ValidationSummary ID="ValidationSummary1" runat="server" ShowMessageBox="True" />
                <asp:Button ID="btnActualizar" runat="server" Text="Actualizar" /></td>
            </td>
        </tr>
    </table>

</asp:Content>

