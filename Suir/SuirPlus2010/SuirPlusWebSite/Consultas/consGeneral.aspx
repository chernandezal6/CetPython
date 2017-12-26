<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consGeneral.aspx.vb" Inherits="Consultas_consGeneral" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

    <span class="header">Consulta Ultimos Movimientos Empleador</span>
    <br />
    <br />
    <br />

    <fieldset style="width: 250px; height: 100px;" id="fldPin" runat="server">
        <legend>Busqueda</legend>
        <table id="TbPINInfo" style="width: 250px;">
            <tr>
                <td>RNC o Cédula:
                </td>
                <td>
                    <asp:TextBox ID="txtRNC" runat="server" Width="143px"
                        MaxLength="11"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td>Cédula Representante:&nbsp;
                </td>
                <td>
                    <asp:TextBox ID="txtCedula" runat="server" Width="143px"
                        MaxLength="11"></asp:TextBox>
                </td>
            </tr>

            <tr>
                <td align="center" colspan="2" style="height: 37px">
                    <br />
                    <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CssClass="botones" />
                    &nbsp;
                            
                           
                            <asp:Button ID="BtnLimpiar" runat="server" Text="Limpiar" CssClass="botones" />
                    &nbsp;
                            
                </td>

            </tr>
            <tr>
                <td style="text-align: center;" colspan="2">
                    <asp:Label ID="LblError" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
            </tr>
        </table>
    </fieldset>
    <br />
    <br />
    <br />

    <div id="divGrid" style="width: 80%" visible="false" runat="server">
        <asp:Label ID="lblEmpleador" runat="server"></asp:Label>
        <br />
        <fieldset style="width:80%">
            <legend style="text-align: left">Ultimos Archivos</legend>

            <br />
            <asp:GridView ID="gvArchivos" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="100%">
                <Columns>
                    <asp:BoundField DataField="id_recepcion" HeaderText="Nro Envio">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="tipo_movimiento_des" HeaderText="Tipo de Archivo">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="nombre_archivo" HeaderText="Nombre de Archivo">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="status" HeaderText="Estatus">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="REGISTROS_BAD" HeaderText="Rechazados">
                        <ItemStyle HorizontalAlign="Center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="representante" HeaderText="Representante">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="fecha_carga" HeaderText="Fecha Envio"
                        DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>


                </Columns>
            </asp:GridView>
        </fieldset>

        <br />
            <fieldset style="width: 80%">
            <legend style="text-align: left">Ultimas Novedades</legend>

            <br />
            <asp:GridView ID="gvNovedades" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="100%">
                <Columns>
                    <asp:BoundField DataField="id_movimiento" HeaderText="Nro Novedad">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="tipo_movimiento_des" HeaderText="Tipo Novedad">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="status" HeaderText="Estatus">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Representante" HeaderText="Representante">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="fecha_registro" HeaderText="Fecha Registro"
                        DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>


                </Columns>
            </asp:GridView>
        </fieldset>
        <br />
            <fieldset style="width: 80%">
            <legend style="text-align: left">Ultimos Subsidios</legend>

            <br />
            <asp:GridView ID="gvSubsidios" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="80%">
                <Columns>
                    <asp:BoundField DataField="nro_solicitud" HeaderText="Nro Subsidio">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Tipo" HeaderText="Tipo de Subsidio">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="desc_estatus" HeaderText="Estatus">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                  
                    <asp:BoundField DataField="fecha_registro" HeaderText="Fecha Registro"
                        DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>


                </Columns>
            </asp:GridView>
        </fieldset>
    </div>
    <br />



</asp:Content>

