<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="FormularioServicios.aspx.vb" Inherits="FormularioServicios" %>

<%@ Register Src="../Controles/UCTelefono.ascx" TagName="UCTelefono" TagPrefix="uc1" %>
<%@ Register Src="../Controles/UCCiudadano.ascx" TagName="UCCiudadano" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">
    
        function modelesswin(url) {
            window.open(url, "", "width=800px,height=1300px").print();
        }

 
    </script>
    <span class="header">Formulario de Solicitud de Servicio<br />
    </span>

    &nbsp;<div id="divTipoServicio" runat="server" style="width:400px">
        <fieldset style="width: 400px">
            <legend>Seleccione el tipo de servicio.</legend>
            <table cellspacing="0" runat="server" id="tblTipo" cellpadding="0">
                <tr>
                    <td>
                        Tipo de Servicio:
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoServicio" runat="server" CssClass="dropDowns" AutoPostBack="True">
                        </asp:DropDownList>
                    </td>
                </tr>                
                <tr>
                    <td>
                        &nbsp;</td>
                    <td>
                        &nbsp;</td>
                </tr>                
            </table>
        </fieldset>
    </div>
       <br/>
    <asp:UpdatePanel ID="upInfoEmpleador" runat="server"  UpdateMode="Conditional">
        <ContentTemplate>
            <asp:Label ID="lblMensaje" runat="server"  CssClass="error"></asp:Label>
            <br />            
            <asp:Panel ID="pnlRequisitos" runat="server" Visible="False" Width="525px">
            <fieldset style="width: 525px">
                <legend>Clasificación Empresa</legend>
                    <table cellspacing="0" runat="server" id="Table2" cellpadding="0" 
                    width="500px">
                <tr>
                    <td width="20%">
                        Clasificación Empresa:</td>
                    <td>
                        <asp:DropDownList ID="ddlClaseEmpresa" runat="server" CssClass="dropDowns" AutoPostBack="True">
                        </asp:DropDownList>
                        <asp:RequiredFieldValidator ID="RequiredFieldValidator9" runat="server" CssClass="error"
                        Display="Dynamic" ErrorMessage="RequiredFieldValidator" ControlToValidate="ddlClaseEmpresa" InitialValue="0" SetFocusOnError="True" ToolTip="Favor específicar la clasificación de la empresa">Clasificación de empresa requerida.</asp:RequiredFieldValidator>

                    </td>
                </tr> 
                        <tr>
                            <td></td>
                            <td></td>
                        </tr>
                <tr id="trRequisitos" runat="server" visible="false">
                <td colspan="2">
                <asp:Label ID="lblTituloRequisitos" runat="server" 
                        Text="Debe presentar los siguientes documentos:" CssClass="labelData"></asp:Label>
                     <asp:CheckBoxList ID="cbRequisitos" runat="server" ToolTip="Seleccionar los documentos requeridos que el solicitante ha suplido">
                     </asp:CheckBoxList>
                     <asp:Label ID="lblMensajeDocumentos" runat="server" CssClass="error"></asp:Label>               
                    
                </td>
                </tr> 
                        <tr>
                            <td align="right" nowrap="nowrap">
                                &nbsp;</td>
                            <td>
                                &nbsp;</td>
                        </tr>
                        <tr>
                            <td align="right" nowrap="nowrap">
                                Sector Salarial:</td>
                            <td>
                                <asp:DropDownList ID="ddlSectorSalarial" runat="server" AutoPostBack="True" 
                                    CssClass="dropDowns">
                                </asp:DropDownList>
                                <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                    ControlToValidate="ddlSectorSalarial" CssClass="error" Display="Dynamic" 
                                    ErrorMessage="RequiredFieldValidator" InitialValue="0" SetFocusOnError="True" 
                                    ToolTip="Favor específicar el sector salarial de la empresa">Sector salarial requerido.</asp:RequiredFieldValidator>
                            </td>
                        </tr>
            </table>
                
            </fieldset>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlInfo" runat="server" Visible="false">
                <fieldset style="width: 525px">
                    <legend>Datos Empresa</legend>
                    <table cellspacing="0" cellpadding="0" width="500px">
                        <tr>
                            <td align="right" width="20%">
                                Rnc/Cédula:</td>
                            <td>
                                <asp:TextBox ID="txtRnc" runat="server" MaxLength="11" Width="88px"></asp:TextBox>
                                &nbsp;<asp:Button ID="btnConsRNC" runat="server" Text="Consultar">
                                </asp:Button>
                            </td>
                        </tr>
                        <tr id="trRazonSocial" runat="server" visible="false">
                            <td align="right" valign="top">
                                Razon Social:</td>
                            <td>
                                <asp:Label ID="lblRazonSocialActual" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                        <td></td>
                        <td>
                            <asp:Label ID="lblMensajeEmpresa" runat="server" CssClass="error"></asp:Label>

                        </td>
                        </tr>
                        <tr>
                            <td align="right" colspan="2">
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                                
                </fieldset>
                <br />
                            
                <fieldset style="width: 525px">
                    <legend>Datos Solicitante</legend>
                    <uc2:UCCiudadano ID="UCCiudadano1" runat="server" />
                </fieldset>
                <br />
                           
                <fieldset style="width: 525px">
                    <asp:Panel ID="pnlFirmas" runat="server">
                        <table cellspacing="0" cellpadding="0" width="520px">
                            <tr>
                                <td>
                                    <asp:Label ID="lblTituloMotivo" runat="server" CssClass="labelData">Explique brevemente el motivo de su solicitud</asp:Label>
                                    <br />
                                    <br />
                                    <hr ID="HR1" size="1" style="width: 100%">
                                    <asp:TextBox ID="txtMotivo" runat="server" Height="80px" TextMode="MultiLine" 
                                        Width="510px"></asp:TextBox>
                                    </hr>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <br />
                        <br />
                        <table cellspacing="0" cellpadding="0" width="520px">
                            <tr>
                                <td>
                                    <table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">
                                        <tr>
                                            <td align="center">
                                                <strong>
                                                    <asp:Label ID="lblSolicitante" runat="server" CssClass="labelData">Solicitante</asp:Label></strong>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="width: 9">
                                                <br />
                                                <asp:Label ID="lblFirma" runat="server">Firma:</asp:Label>
                                                &nbsp; _______________________________________
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="width: 9">
                                                <br />
                                                <asp:Label ID="lblCedula" runat="server">Cédula:</asp:Label>
                                                _______________________________________
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                                <td>
                                    <table cellspacing="0" cellpadding="0" width="250px" align="left" border="0">
                                        <tr>
                                            <td align="center">
                                                <strong>
                                                    <asp:Label ID="lblRepresentate" runat="server" CssClass="labelData">Representante</asp:Label>
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="width: 9">
                                                <br />
                                                <asp:Label ID="lblFirmaRep" runat="server">Firma:</asp:Label>
                                                &nbsp; _______________________________________
                                            </td>
                                        </tr>
                                        <tr>
                                            <td align="left" style="width: 9">
                                                <br />
                                                <asp:Label ID="lblCedulaRep" runat="server">Cédula:</asp:Label>
                                                _______________________________________
                                            </td>
                                        </tr>
                                    </table>
                                </td>
                            </tr>
                        </table>
                        <br />
                        <br />
                        <br />
                        <table cellspacing="0" cellpadding="0" width="520px">
                            <tr>
                                <td style="text-align: right">
                                    <asp:Button ID="btnGuardar" runat="server" Text="Guardar" />
                                    &nbsp;<asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </fieldset>
            </asp:Panel>
            <br />
            <asp:Panel ID="pnlFinal" runat="Server" Visible="False" Width="100%">
            <fieldset style="width: 525px">
               <legend>Confirmación</legend>
                <table id="Table4" cellspacing="0" cellpadding="0" width="520px" border="0">
                    <tr valign="top">
                        <td colspan="2" style="height: 12px" width="12%">
                            <div align="center">
                                <asp:Label ID="lblConfirmacion" runat="server" CssClass="subHeader" EnableViewState="False">La Solicitud fue creada satisfactoriamente</asp:Label>&nbsp;<br />
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td style="height: 12px">
                        </td>
                    </tr>
                    <tr valign="top">
                        <td>
                            <div align="right">
                                Número de Solicitud&nbsp;</div>
                        </td>
                        <td>
                            <asp:Label ID="lblNoSolicitud" runat="server" CssClass="labelData"></asp:Label>&nbsp;
                        </td>
                    </tr>
                    <tr valign="top">
                        <td>
                            <div align="right">
                                Tipo de Servicio&nbsp;</div>
                        </td>
                        <td>
                            <asp:Label CssClass="labelData" ID="lblTipoServicio" runat="server"></asp:Label>
                        </td>
                    </tr>
                    <tr>
                        <td>
                        </td>
                        <td>
                        </td>
                    </tr>
                </table>
                <table id="Table10" cellspacing="0" cellpadding="0" width="520px" border="0">                     
                    <tr>
                        <td width="100%">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td valign="bottom" align="center">
                            <input id="btnVerCert" onclick="javascript:modelesswin('VerFormServicio.aspx?NoSol=<%= NoSol %>')"
                                type="button" value="Ver Solicitud" class="Button">
                                <asp:Button ID="btnNuevaCert" runat="server" Text="Nueva Solicitud"></asp:Button>
                        </td>
                    </tr>
                </table>
            </fieldset>
            </asp:Panel>
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="btnGuardar" />
            <asp:PostBackTrigger ControlID="btnLimpiar" />
            
        </Triggers>
    </asp:UpdatePanel>
   
</asp:Content>
