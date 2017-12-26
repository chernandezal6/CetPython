<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="AsignacionNss.aspx.vb" Inherits="Mantenimientos_AsignacionNss" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <asp:Label ID="lblLetrero" runat="server" ForeColor="Blue" CssClass="labelData" Font-Bold="true" Text="Motivo Evaluación: "></asp:Label>
    <asp:Label ID="lblDescError" runat="server" ForeColor="Red" CssClass="labelData"></asp:Label><br />
    <br />

    <table border="0" cellpadding="0" cellspacing="0">
        <tr style="width: 500px">
            <td style="vertical-align: top">
                <fieldset id="fsAsignacionNSS" runat="server" style="height: auto">
                    <legend>Asignación NSS</legend>
                    <table>
                        <tr>
                            <td align="right">ARS:</td>
                            <td style="height: 16px; width: 147px;">
                                <asp:Label ID="lblARS" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Nro. Documento:
                            </td>
                            <td>
                                <asp:Label ID="lblDocumento" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Nombres:
                            </td>
                            <td>
                                <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Primer Apellido:
                            </td>
                            <td>
                                <asp:Label ID="lblPrimerApellido" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Segundo Apellido
                            </td>
                            <td>
                                <asp:Label ID="lblSegundoApellido" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Sexo:
                            </td>
                            <td>
                                <asp:Label ID="lblSexo" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Fecha Nacimeinto:
                            </td>
                            <td>
                                <asp:Label ID="lblFechaNac" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Padre:
                            </td>
                            <td>
                                <asp:Label ID="lblPadre" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Madre:
                            </td>
                            <td>
                                <asp:Label ID="lblMadre" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Nacionalidad:
                            </td>
                            <td>
                                <asp:Label ID="lblNacionalidad" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Provincia:
                            </td>
                            <td>
                                <asp:Label ID="lblProvincia" runat="server" CssClass="labelData"></asp:Label>
                                <asp:Label ID="lblProvinciaDes" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Municipio:</td>
                            <td>
                                <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                <asp:Label ID="lblMunicipioDes" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        </table>
  <table>
                        <tr>

                            <td width="60px" align="center">Oficialia</td>

                            <td width="60px" align="center">Libro</td>

                            <td width="60px" align="center">Folio</td>

                            <td width="60px" align="center">Acta</td>

                            <td width="60px" align="center">Año</td>

                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Label ID="lblOficialia" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblLibro" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblFolio" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblNroActa" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblAno" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                    </table>

                </fieldset>

                <fieldset id="fsNSSExtranjero" runat="server" style="height: auto">
                    <legend>Asignación NSS Extranjero</legend>
                    <table>
                        <tr>
                            <td align="right">ARS:</td>
                            <td style="height: 16px; width: 147px;">
                                <asp:Label ID="lblARSExt" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Nombres:
                            </td>
                            <td>
                                <asp:Label ID="lblNombresExt" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Primer Apellido:
                            </td>
                            <td>
                                <asp:Label ID="lblPrimerApellidoExt" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Segundo Apellido
                            </td>
                            <td>
                                <asp:Label ID="lblSegundoApellidoExt" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Sexo:
                            </td>
                            <td>
                                <asp:Label ID="lblSexoExt" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Fecha Nacimeinto:
                            </td>
                            <td>
                                <asp:Label ID="lblFechaNacExt" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Nacionalidad:
                            </td>
                            <td>
                                <asp:Label ID="lblNacionalidadExt" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" style="text-decoration: underline; font-weight: 700; font-style: italic">Datos del Titular
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Titular:
                            </td>
                            <td>
                                <asp:Label ID="lblNombresTitular" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Primer Apellido:
                            </td>
                            <td>
                                <asp:Label ID="lblPrimerApellidoTitular" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Segundo Apellido
                            </td>
                            <td>
                                <asp:Label ID="lblSegundoApellidoTitular" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Nro. Documento:
                            </td>
                            <td>
                                <asp:Label ID="lblDocumentoTitular" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td align="right">Nacionalidad:
                            </td>
                            <td>
                                <asp:Label ID="lblNacionalidadTitular" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                    </table>
                </fieldset>
                <br />
                <asp:UpdatePanel ID="upnlNSSDuplicado" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <fieldset id="fsNSSDuplicado" runat="server" style="height: auto">
                            <legend>Info NSS Duplicado</legend>
                            <table id="tblNSSDuplicados" runat="server">
                                <tr>
                                    <td align="right">NSS Duplicados:
                                    </td>
                                    <td nowrap="nowrap">
                                        <asp:DropDownList ID="ddlNSSDuplicados" runat="server" CssClass="dropDowns" AutoPostBack="True">
                                        </asp:DropDownList>&nbsp;
                                        <asp:LinkButton ID="lbHistóricoARS" runat="server">Ver Histórico</asp:LinkButton>
                                        <asp:LinkButton ID="lbVerActa" runat="server" Visible="false"> | Ver Acta</asp:LinkButton>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Nro. Documento:
                                    </td>
                                    <td style="height: 16px; width: 147px;">
                                        <asp:Label ID="lblDocumentoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Nombres:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblNombresNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Primer Apellido:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblPrimerApellidoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Segundo Apellido
                                    </td>
                                    <td>
                                        <asp:Label ID="lblSegundoApellidoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Sexo:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblSexoNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Fecha Nacimeinto:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblFechaNacNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Padre:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblPadreNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Madre:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblMadreNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Nacionalidad:
                                    </td>
                                    <td>
                                        <asp:Label ID="lblNacionalidadNSS" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Provincia:</td>
                                    <td>
                                        <asp:Label ID="lblProvinciaNSS" runat="server" CssClass="labelData"></asp:Label>
                                        <asp:Label ID="lblProvinciaNSSDes" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                                <tr>
                                    <td align="right">Municipio: </td>
                                    <td>
                                        <asp:Label ID="lblMunicipioNSS" runat="server" CssClass="labelData"></asp:Label>
                                        <asp:Label ID="lblMunicipioNSSDes" runat="server" CssClass="labelData"></asp:Label>
                                    </td>
                                </tr>
                            </table>
  <table>
                        <tr>

                            <td width="60px" align="center">Oficialia</td>

                            <td width="60px" align="center">Libro</td>

                            <td width="60px" align="center">Folio</td>

                            <td width="60px" align="center">Acta</td>

                            <td width="60px" align="center">Año</td>

                        </tr>
                        <tr>
                            <td align="center">
                                <asp:Label ID="lblOficialiaNSS" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblLibroNSS" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblFolioNSS" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblNroActaNSS" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                            <td align="center">
                                <asp:Label ID="lblAnoNSS" runat="server" CssClass="labelData"></asp:Label>
                            </td>
                        </tr>
                    </table>
                        </fieldset>
                    </ContentTemplate>
                </asp:UpdatePanel>
            </td>
            <td>
                <table>
                    <tr>
                        <td>
                            <asp:DetailsView ID="DetailsView1" runat="server" AutoGenerateRows="False">
                                <Fields>
                                    <asp:ImageField DataImageUrlField="id_solicitud" DataImageUrlFormatString="~/Mantenimientos/MostrarImagen.aspx?id={0}"
                                        NullDisplayText="No Tiene Imagen" ReadOnly="True" ShowHeader="False">
                                        <ControlStyle Height="487px" Width="670px" />
                                        <ItemStyle Height="487px" Width="670px" />
                                    </asp:ImageField>
                                </Fields>
                            </asp:DetailsView>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
    <asp:UpdatePanel ID="upnlbotones" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table>
                <tr>
                    <td>
                        <asp:Button ID="btnActualizar" runat="server" Text="Actualizar" align="right" style="font-size: medium" Visible="false"/>
                    </td>
                    <td>
                        <asp:Button ID="btnAsignacion" runat="server" Text="Asignar" align="right" style="font-size: medium"/>
                    </td>
                    <td>
                        <asp:Button ID="btnRechazar" runat="server" Text="Rechazar" align="right" style="font-size: medium"/>
                    </td>
                    <td>
                        <asp:Button ID="btnSalir" runat="server" Text="Cancelar" align="right" style="font-size: medium"/>
                    </td>
                    <td align="right" style="font-size: medium">Motivo Rechazo:
                    </td>
                    <td colspan="1" nowrap="nowrap">
                        <asp:DropDownList ID="ddlMotivo" runat="server" CssClass="dropDowns" AutoPostBack="True" align="right" style="font-size: medium">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td colspan="6">
                        <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false"></asp:Label>
                    </td>
                </tr>
            </table>
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>
