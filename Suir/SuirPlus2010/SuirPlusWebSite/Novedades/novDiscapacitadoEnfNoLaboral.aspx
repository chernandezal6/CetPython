<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="novDiscapacitadoEnfNoLaboral.aspx.vb" Inherits="Novedades_novDiscapacitadoEnfNoLaboral" %>

<%@ Register Src="~/Controles/ucEnfermedadNoLaboral.ascx" TagPrefix="uc1" TagName="ucEnfermedadNoLaboral" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">


    <h2 class="header">Registro pago retroactivo a pensionados x discapacidad
    </h2>


    <div id="PantallaInteractiva" runat="server">
        <table class="td-content" cellspacing="2" cellpadding="2" style="width: 425px">

            <tr>
                <td style="text-align: right; width: 440px;">
                    <asp:Panel ID="pnlPendiente" runat="server" Visible="False">
                        <table class="td-note" id="Table5">
                            <tr>
                                <td class="subHeader">Tiene Novedades Pendientes</td>
                            </tr>
                        </table>
                    </asp:Panel>

                </td>
            </tr>
            <tr>
                <td style="width: 440px">
                    <table class="td-Content" width="425px">
                        <tr>
                            <td colspan="4">
                                <asp:Label ID="lblRepError" CssClass="error" runat="server"></asp:Label></td>
                        </tr>
                        <tr>
                            <td colspan="4" height="3"></td>
                        </tr>
                        <tr>
                            <td style="text-align: left" valign="bottom">Cédula:</td>
                            <td colspan="3" valign="bottom" style="width: 394px">
                                <asp:TextBox ID="txtRepDocumento" OnKeyUp="Sel()" onChange="Sel()" runat="server" Width="125px" MaxLength="25"></asp:TextBox>&nbsp;
			<asp:Button ID="btnRepBuscar" runat="server" Text="Buscar" CausesValidation="False"></asp:Button>
                                &nbsp;
                            </td>
                        </tr>
                    </table>
                    <table class="td-Content" width="425px">
                        <tr>
                            <td class="labelData" colspan="4">
                                <asp:Label ID="lblNombres" runat="server"></asp:Label>
                                <asp:Label ID="lblApellidos" runat="server"></asp:Label></td>
                        </tr>
                    </table>
                    <table class="td-content" cellspacing="2" cellpadding="2" style="width: 425px">
                        <tr>
                            <td>Nómina:</td>
                            <td>
                                <asp:DropDownList ID="ddlNominas" runat="server" CssClass="dropDowns" />
                                <%--<strong>Retroactivo por Enfermedad no Laboral</strong>--%></td>
                        </tr>
                        <tr>
                            <td>Periodo Desde:</td>
                            <td>
                                <asp:DropDownList ID="ddlPeriodoDesde" runat="server" Height="20px" Width="107px">
                                </asp:DropDownList>
                            </td>
                            <td>Periodo Hasta:</td>
                            <td>
                                <asp:DropDownList ID="ddlPeriodoHasta" runat="server" Height="20px" Width="107px">
                                </asp:DropDownList>
                            </td>
                        </tr>
                        <tr>
                            <td>Monto de Pensión:</td>
                            <td>
                                <asp:TextBox ID="txtSalario" runat="server" Height="18px"></asp:TextBox></td>
                        </tr>

                    </table>
                </td>
            </tr>
        </table>
        <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
        <asp:HiddenField ID="PersoNss" runat="server" />

        <table cellspacing="0" cellpadding="0" style="width: 440px" border="0">
            <tr>
                <td valign="top" align="right" colspan="2" style="height: 17px">
                    <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" OnClientClick="return Resultado();"></asp:Button>&nbsp;<asp:Button ID="btnRepCancelar" runat="server" CausesValidation="False" Text="Cancelar"></asp:Button>
                    &nbsp;
                </td>
            </tr>
        </table>
    </div>

    <table id="tbpendiente" runat="server">
        <tr>
            <td style="width: 320px">
                <asp:Label ID="lblPendientes" runat="server" CssClass="header">Ingresos Pendientes de Aplicar</asp:Label></td>
            <td align="left" style="width: 220px;">
                <asp:Button ID="btnAplicar" runat="server" Text="Aplicar Novedades" CausesValidation="False" Visible="false"></asp:Button></td>
        </tr>
        <tr>
            <td colspan="2" style="width: 820px">
                <br />
                        <asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>

                        <asp:GridView ID="gvNovedades" runat="server" CellPadding="4" Width="800PX" AutoGenerateColumns="False"
                            DataKeyNames="ID_MOVIMIENTO,ID_LINEA">
                            <Columns>
                                <asp:BoundField DataField="NO_DOCUMENTO" HeaderText="Documento" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                                <asp:BoundField DataField="NOMBRE" HeaderText="Nombre" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                                <asp:BoundField DataField="Nomina_des" HeaderText="Nómina" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                                <asp:TemplateField HeaderText="Monto de Pensión" ItemStyle-HorizontalAlign="Center">
                                    <ItemStyle HorizontalAlign="Right"></ItemStyle>
                                    <ItemTemplate>
                                        <%#FormatNumber(Eval("SALARIO_SS"))%>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                <asp:BoundField DataField="periodo_aplicacion" HeaderText="Periodo Desde" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                                <asp:BoundField DataField="sfs_secuencia" HeaderText="Periodo Hasta" ItemStyle-HorizontalAlign="Center"></asp:BoundField>
                                <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton CausesValidation="False" ID="iBtnBorrar" runat="server"
                                            ToolTip="Borrar" ImageUrl="../images/error.gif"
                                            CommandName="Borrar" BorderWidth="0px"></asp:ImageButton>&nbsp;
				<asp:Label ID="lblIdMov" runat="server" Text='<%# Eval("ID_MOVIMIENTO") %>'
                    Visible="False">
                </asp:Label>
                                        <asp:Label ID="lblIdLinia" runat="server" Text='<%# Eval("ID_LINEA") %>'
                                            Visible="False">
                                        </asp:Label>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>


            </td>
        </tr>
    </table>



</asp:Content>

