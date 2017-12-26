<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ActualizacionMaestroCiu.aspx.vb" Inherits="Asignacion_NSS_ActualizacionMaestroCiu" %>


<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
<script type = "text/javascript">
function DisableButton() {
    document.getElementById("<%=btnActualizar.ClientID %>").disabled = true;
}
window.onbeforeunload = DisableButton;
</script>
    <div class="bigtitle">
        <span class="header">Actualización del maestro de ciudadanos</span>
    </div>  
    <br />
    <table class="td-content">
                
        <tr aling="top">
            <td style="text-align: right" colspan="2">Tipo Documento:</td>
            <td>
                <asp:DropDownList ID="ddlTipoDocumento" runat="server" CssClass="dropDowns" AutoPostBack="true" TabIndex="1">
                    <asp:ListItem Value="0">Seleccione</asp:ListItem>
                    <asp:ListItem Value="C">Cédula</asp:ListItem>
                    <asp:ListItem Value="U">NUI</asp:ListItem>
                </asp:DropDownList>
            </td>
        </tr>
        <tr>
            <td style="text-align: right;" colspan="2" >Número Documento:</td>
            <td>
                <asp:TextBox ID="txtNoDocumento" runat="server" TabIndex="2" MaxLength="11" Width="100px"></asp:TextBox></td>
        </tr>
        <tr>
            <td colspan="3" style="text-align: center">
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar"></asp:Button>&nbsp;
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar"></asp:Button>
            </td>
        </tr>
    </table>
    <br />
    <asp:Label ID="lblmensaje" runat="server" Visible="false" CssClass="label-Blue"></asp:Label>
    <asp:Label ID="lblError" runat="server" Visible="false" CssClass="error"></asp:Label>


    <fieldset id="fsCiudadano" style="width: 445px" runat="server" visible="false">
        <legend>Información del Ciudadano</legend>
          <div>
        <asp:Panel ID="pnlInfoTSS" runat="server" Visible="false">
        <table width="445" border="0">
            <tr>
                <td align="right" nowrap="nowrap" style="font-size-adjust">Número Documento:
                </td>
                <td>
                    <asp:Label ID="lblCedula" runat="server" CssClass="labelData"></asp:Label>
                </td>
                <td rowspan="3" align="right">
                    <img src="../images/logoTSShorizontalsmaller.gif" />
                </td>
            </tr>
            <tr>
                <td align="right" nowrap="nowrap">Nombres:
                </td>
                <td>
                    <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" nowrap="nowrap">Primer Apellido:
                </td>
                <td>
                    <asp:Label ID="lblPrimerApellido" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" nowrap="nowrap">Segundo Apellido
                </td>
                <td colspan="2">
                    <asp:Label ID="lblSegundoApellido" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td align="right" nowrap="nowrap" style="height: 18px">Fecha Nacimiento:</td>
                <td align="left" colspan="2" style="height: 18px">
                    <asp:Label ID="lblFechaNacimiento" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Sexo:
                    </td>
                    <td colspan="2" align="left">
                        <asp:Label ID="lblSexo" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Datos Acta:
                    </td>
                    <td colspan="2" nowrap="nowrap">Oficialia:<asp:Label ID="lblOficialia" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;Libro:<asp:Label ID="lblLibro" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;Tipo Libro:<asp:Label ID="lblTipoLibro" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;Folio:<asp:Label ID="lblFolio" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;Nro Acta:<asp:Label ID="lblNroActa" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;Año:<asp:Label ID="lblAno" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">&nbsp;
                    </td>
                    <td colspan="2">Municipio:<asp:Label ID="lblCodMunicipio" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;<asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Nacionalidad
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblCodNacion" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;<asp:Label ID="lblNacionalidad" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Estado Civil:
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblEstadoCivil" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Tipo Causa:
                    </td>
                    <td align="left" colspan="2">
                        <asp:Label ID="lblTipoCausa" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Causa Inhabilidad:
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblCodCausa" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;<asp:Label ID="lblCausaInhabilidad" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Estatus:
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
                        &nbsp;<asp:Label ID="lblEstatusDesc" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Padre:
                    </td>
                    <td align="left" colspan="2">
                        <asp:Label ID="lblPadreNombre" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td align="right" nowrap="nowrap">Madre:
                    </td>
                    <td colspan="2">
                        <asp:Label ID="lblMadreNombres" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
            <tr>
                <td colspan="3" style="text-align: center">
                    <br />
                    <asp:Button ID="btnActualizar" runat="server" Text="Actualizar"></asp:Button>
                </td>
            </tr>
        </table>
    </asp:Panel>
    </div>
    </fieldset> 
    
    <br />
    <asp:Panel ID="pnlSolicitarNss" runat="server" Visible="false">
        <fieldset style="width: 445px">
            <legend>Solicitar Asignación NSS </legend>
            <br />
            <div style="text-align: center; width: 420px">
                <asp:Label ID="lblMsg" runat="server" Visible="false" CssClass="error"></asp:Label>
                <br />
                <br />
                <asp:Button ID="btnSolicitar" runat="server" Text="Solicitar NSS"></asp:Button>
                <br />
            </div>
        </fieldset>
    </asp:Panel>
</asp:Content>

