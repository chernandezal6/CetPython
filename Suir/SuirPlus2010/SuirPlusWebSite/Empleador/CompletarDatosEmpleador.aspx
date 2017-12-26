<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlain.master" AutoEventWireup="false" CodeFile="CompletarDatosEmpleador.aspx.vb" Inherits="Empleador_CompletarDatosEmpleador" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <div id="head" class="header"><span>Favor de completar sus datos:</span></div>
    <div id="divSectorSalarial" runat="server">
        <fieldset style="width: 665px">
            <legend>Ingrese los datos requeridos</legend>
            <br />
            <table id="AsignarSectorSalarial" class="td-content" style="width: 660px">
                <tr><td></td></tr>
                <tr>
                    <td style="text-align: left; font-size: medium; font-weight: bold;">Sector Salarial:
                                <asp:DropDownList ID="ddlescalasalarial" runat="server">
                                </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td style="text-align: center;">
                        <asp:Button ID="btnAsignarEscala" runat="server" Text="Aceptar"
                            ToolTip="Aceptar datos requeridos" />
                    </td>
                </tr>
            </table>
        </fieldset>
    </div>
    <br />
    <div>
        <asp:Label ID="lblMensaje" CssClass="error" runat="server"></asp:Label>
    </div>
    <div id="divDetalleEmpresa" runat="server" visible="false">
        <fieldset style="width: 820px">
            <legend>Detalle Del Empleador</legend>
            <br />
            <table id="TblDetalleEmpleador" style="width: 800px">
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td colspan="2">RNC/Cédula:
                                            <asp:Label ID="lblRNC" runat="server" CssClass="labelData" />
                                </td>
                                <td>Registro Patronal</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblRegPatronal" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: left;">
                                    <div>
                                        Razón Social
                                    </div>
                                    <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: left; width:250px;">
                                    <div>
                                        Sector Económico
                                    </div>
                                    <asp:Label ID="lblSectorEconomico" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="4" style="text-align: left;">
                                    <div>
                                        Nombre Comercial
                                    </div>
                                    <asp:Label ID="lblNombreComercial" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">Tipo de Empresa
                                </td>
                                <td style="text-align: left;" nowrap="nowrap">
                                    <asp:Label ID="lblTipoEmpresa" runat="server" CssClass="labelData" ></asp:Label>
                                </td>
                                <td style="text-align: left;">Fax</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblFax" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">Segundo Teléfono
                                </td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblTelefono2" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left;">Primer Teléfono</td>
                                <td style="text-align: left; width: 100px;">
                                    <asp:Label ID="lblTelefono1" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">Email</td>
                                <td style="text-align: left; width: 100px;">
                                    <asp:Label ID="lblEmail" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left;">Calle</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblCalle" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2" style="text-align: left;"></td>
                                <td style="text-align: left;">&nbsp;</td>
                                <td style="text-align: left;">&nbsp;</td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table>
                            <tr>
                                <td style="text-align: left;">&nbsp; Número
                                </td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblNumero" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left;">Municipio </td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">&nbsp; Edificio</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblEdificio" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left;">Sector</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblSector" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">&nbsp; Piso
                                </td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblPiso" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left;">Provincia</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblProvincia" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">&nbsp; Apartamento</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblApartamento" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left;">&nbsp;</td>
                                <td style="text-align: left;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">&nbsp; Inicio de&nbsp;&nbsp; Operaciones</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblFechaInicioOperacion" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left">Fecha Registro</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblFechaRegistro" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="text-align: left;">&nbsp; Fecha&nbsp;&nbsp; Constitución</td>
                                <td style="text-align: left;">
                                    <asp:Label ID="lblFechaConstitucion" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                                <td style="text-align: left;">&nbsp;</td>
                                <td style="text-align: left;">&nbsp;</td>
                            </tr>
                            <tr>
                                <td style="text-align: left; height: 37px;">&nbsp; Administración Local</td>
                                <td style="text-align: left; height: 37px;">
                                    <asp:Label ID="lblAdministracionLocal" runat="server"
                                        CssClass="labelData"></asp:Label>
                                </td>
                                <td style="height: 37px; text-align: left">Estatus</td>
                                <td style="text-align: left; height: 37px;">
                                    <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
      
            <div class="subHeader"><span>&nbsp;Representantes:</span>
            <asp:DataList ID="dtRepresentante" runat="server" RepeatColumns="2" ShowFooter="False"
                ShowHeader="False" CellSpacing="5">
                <ItemTemplate>
                    <table class="tblContact" cellspacing="0" cellpadding="3" style="width: 300px;">
                        <tr>
                            <td class="tdContactHeader" colspan="3">
                                <asp:Label ID="lblRepresentante" runat="server" Text='<%# Eval("NOMBRE") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td style="width: 25%">Cédula/Pasaporte:
                            </td>
                            <td colspan="2">
                                <asp:Label ID="lblRedCedula" runat="server" Text='<%# formatCedula(Eval("NO_DOCUMENTO")) %>'>
                                </asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>Teléfono:
                            </td>
                            <td colspan="2">
                                <asp:Label ID="lblRepTelefono" runat="server" Text='<%# formatTelefono(Eval("TELEFONO_1")) %>'
                                    Width="150px"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>Email:
                            </td>
                            <td colspan="2">
                                <asp:Label ID="lblRepEmail" runat="server" Text='<%# Eval("EMAIL") %>' />
                            </td>
                        </tr>
                        <tr>
                            <td>Tipo:
                            </td>
                            <td>
                                <asp:Label ID="lblTipo" runat="server" Text='<%#IIF(Eval("Tipo_Representante")="A","Administrador","Normal") %>' />
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:DataList>
            </div>
        </fieldset>
    </div>



</asp:Content>



