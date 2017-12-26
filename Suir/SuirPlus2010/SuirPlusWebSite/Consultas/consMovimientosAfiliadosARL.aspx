<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consMovimientosAfiliadosARL.aspx.vb" Inherits="Consultas_consMovimientosAfiliadosARL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <span class="header">Consulta de Movimientos de Afiliados ARL </span>
    <br />
    <br />
    <br />
    <fieldset style="width: 250px; height: 100px;" id="fldPin" runat="server">
        <table id="TbPINInfo" style="width: 250px;">
            <tr>
                <td style="width: 100px;">
                    Nss:
                </td>
                <td>
                    <asp:TextBox ID="txtNss" runat="server" Width="145px" MaxLength="10"></asp:TextBox>
                </td>
            </tr>
            <tr>
                <td>
                    RNC o Cédula:
                </td>
                <td>
                    <asp:TextBox ID="txtRNC" runat="server" Width="143px" MaxLength="10"></asp:TextBox>
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
                    <asp:Label ID="LblError" runat="server" CssClass="error" EnableViewState="False"
                        Visible="False"></asp:Label>
                </td>
            </tr>
        </table>
    </fieldset>
    <br />
    <br />
    <br />

    <div  id= "divInfoempleado" style="width: 250px; height: 100px;" visible="false" runat ="server">
                 <fieldset style="width: 250px; height: 90px;">
                 <legend style="text-align: left">Datos Afiliado</legend>
                 <br/>
                    <table cellpadding="3" cellspacing="0" id="tblInfoPin"  runat="server" >
       <%-- <tr>
            <td align="right" style="text-align: center" colspan="2" >
                <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Datos Empleado:"></asp:Label>
               </td>
        </tr>--%>
        
        <tr>
            <td align="left">
                    <asp:Label ID="lbltxtcedula" runat="server" Text="Cédula:" Visible="true"></asp:Label></td>
            <td align="left">
                <asp:Label ID="lblcedula" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="left">
                    <asp:Label ID="lbltxtNombres" runat="server" Text="Nombres:" Visible="true"></asp:Label></td>
            <td align="left">
                <asp:Label ID="lblnombres" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        
         
          </table>
          </fieldset>
          </div>

          <br />
    <br />


    <div id="divAfiliado" style="width: 500px;" visible="false" runat="server">
        <fieldset style="width: 500px; ">
            <legend style="text-align: left">Detalle de Movimiento</legend></br>
            <asp:GridView ID="gvDetalleAfiliado" runat="server" AutoGenerateColumns="False" CellPadding="3"
                Width="500px">
                <Columns>
                    <%--<asp:BoundField DataField="id_nss" HeaderText="NSS">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="no_documento" HeaderText="Cédula">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>--%>
                    <%--<asp:BoundField DataField="nombres" HeaderText="Nombres">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>--%>
                    <asp:BoundField DataField="id_movimiento" HeaderText="Nro Movimiento">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Tipo_Movimiento" HeaderText="Tipo">
                        <ItemStyle HorizontalAlign="Left" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <%-- <asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC" >
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>--%>
                    <asp:BoundField DataField="fecha_registro" HeaderText="Fecha Registro" DataFormatString="{0:d}"
                        HtmlEncode="False">
                        <ItemStyle HorizontalAlign="center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="fecha_envio" HeaderText="Fecha Envio" DataFormatString="{0:d}"
                        HtmlEncode="False">
                        <ItemStyle HorizontalAlign="center" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                </Columns>
            </asp:GridView>
        </fieldset>
    <table cellpadding="0" cellspacing="0" width="500px">
            <tr>
                <td>
                    <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                    [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                    <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                        OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                    <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td><br />
                    Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
            </table>
             </div>
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
</asp:Content>
