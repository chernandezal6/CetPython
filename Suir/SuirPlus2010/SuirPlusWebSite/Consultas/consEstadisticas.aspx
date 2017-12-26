<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consEstadisticas.aspx.vb" Inherits="Consultas_consEstadisticas" %>

<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">


    <script language="javascript" type="text/javascript">
        function checkNum(e) {
            var carCode = (window.event) ? window.event.keyCode : e.which;
            if (carCode != 8) {
                if ((carCode < 48) || (carCode > 57)) {
                    if (window.event) //IE       
                        window.event.returnValue = null;
                    else //Firefox       
                        e.preventDefault();
                }

            }
        }
    </script>

    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <div class="header">Consulta de  Estadisticas de Trabajadores</div>
    <div>

        <br />
        <fieldset style="height: 82px; width: 350px;">
            <table>
                <tr>
                    <td align="right">Período
                    </td>
                    <td colspan="1" style="width: 138px">
                        <asp:DropDownList ID="ddlPeriodos" runat="server" CssClass="dropDowns">
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>
                <tr>
                    <td>Tipo Consulta
                    </td>
                    <td>
                        <asp:DropDownList ID="ddlTipoConsulta" runat="server" CssClass="dropDowns">
                            <asp:ListItem Value="0">Seleccionar</asp:ListItem>
                            <asp:ListItem Value="1">Tipo y Rango Salarial</asp:ListItem>
                            <asp:ListItem Value="2">Rango Salarial</asp:ListItem>
                            <asp:ListItem Value="3">Género</asp:ListItem>
                            <asp:ListItem Value="4">Rango de edad</asp:ListItem>
                            <asp:ListItem Value="5">Cantidad de trabajadores</asp:ListItem>
                            <asp:ListItem Value="6">Empresas con mas trabajadores</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td></td>
                </tr>


                <tr>
                    <td align="center" colspan="2">
                        <asp:Button ID="btBuscarRef" runat="server" Enabled="True" EnableViewState="False"
                            Text="Buscar" />
                        &nbsp;
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
                    </td>
                </tr>
            </table>
        </fieldset>
        <br />

        <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false"></asp:Label>
        <br />
        <asp:Panel ID="pnlEstadistica" runat="server" Visible="False">

            <asp:GridView ID="gvEstadiscasTrabajador" runat="server" Font-Size="Smaller" Width="450px" CellSpacing="3" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="tipo_empresa" HeaderText="Tipo Empresa">
                        <ItemStyle Wrap="False" HorizontalAlign="left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="rango" HeaderText="Rango Salarial">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="right" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="trabajadores" HeaderText="Núm Trabajadores" DataFormatString="{0:##,###}">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle Wrap="False" HorizontalAlign="Right" />
                    </asp:BoundField>

                </Columns>
            </asp:GridView>
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel" runat="server" />

        </asp:Panel>


        <asp:Panel ID="pnlEstadisticaRangoSalarial" runat="server" Visible="False">

            <asp:GridView ID="gvEstadisticasRangoSalarial" runat="server" Font-Size="Smaller" Width="370px" CellSpacing="3" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="rango" HeaderText="Rango Salarial">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="trabajadores" HeaderText="Núm Trabajadores" DataFormatString="{0:##,###}">
                        <HeaderStyle HorizontalAlign="right" />
                        <ItemStyle Wrap="False" HorizontalAlign="left" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel2" runat="server" />

        </asp:Panel>


        <asp:Panel ID="pnlTrabajadoresPorGenero" runat="server" Visible="False">

            <asp:GridView ID="gvTrabajadorPorGenero" runat="server" Font-Size="Smaller" Width="350px" CellSpacing="3" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="sexo" HeaderText="Sexo">
                        <ItemStyle Wrap="False" HorizontalAlign="left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="trabajadores" HeaderText="Núm Trabajadores" DataFormatString="{0:##,###}">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="right" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="salario_promedio" HeaderText="Salario Promedio" DataFormatString="{0:##,###}">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle Wrap="False" HorizontalAlign="right" />
                    </asp:BoundField>

                </Columns>
            </asp:GridView>
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel3" runat="server" />

        </asp:Panel>


        <asp:Panel ID="pnlTrabajadoresRangoEdad" runat="server" Visible="False">

            <asp:GridView ID="gvTrabajadorRangoEdad" runat="server" Font-Size="Smaller" Width="400px" CellSpacing="3" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="sexo" HeaderText="Sexo">
                        <ItemStyle Wrap="False" HorizontalAlign="left" />
                    </asp:BoundField>
                    <asp:BoundField DataField="rango_edad" HeaderText="Rango Edades">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="right" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="salario_promedio" HeaderText="Salario Promedio" DataFormatString="{0:##,###}">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle Wrap="False" HorizontalAlign="right" />
                    </asp:BoundField>

                </Columns>
            </asp:GridView>
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel4" runat="server" />

        </asp:Panel>

        <br />
        <asp:Panel ID="pnlEmpresasCantidadTrabajadores" runat="server" Visible="False">

            <asp:GridView ID="gvEmpresasCantTrabajadores" runat="server" Width="450px" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="desde" HeaderText="Rango Desde">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="right" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="TRABAJADORES" HeaderText="Núm Trabajadores">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="right" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="empleadores" HeaderText="Núm Empleadores">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="right" Wrap="False" />
                    </asp:BoundField>

                </Columns>
            </asp:GridView>
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel5" runat="server" />

        </asp:Panel>
        <br />



        <br />
        <asp:Panel ID="pnlEstadisticasTrabajadores" runat="server" Visible="False">

            <asp:GridView ID="gvEstadiscasTrabajadores" runat="server" Width="550px" AutoGenerateColumns="False">
                <Columns>
                    <asp:BoundField DataField="razon_social" HeaderText="Razón Social">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="left" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="trabs" HeaderText="Núm Trabajadores">
                        <HeaderStyle HorizontalAlign="Center" />
                        <ItemStyle HorizontalAlign="right" Wrap="False" />
                    </asp:BoundField>

                </Columns>
            </asp:GridView>
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel1" runat="server" />

        </asp:Panel>
        <br />
    </div>

</asp:Content>

