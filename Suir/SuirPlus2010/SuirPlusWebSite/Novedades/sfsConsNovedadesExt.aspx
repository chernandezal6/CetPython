<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsConsNovedadesExt.aspx.vb" Inherits="Novedades_sfsConsNovedadesExt" title="Consulta Subsidios Extraordinarios" %>
<%@ Register src="../Controles/ucInfoEmpleado.ascx" tagname="ucInfoEmpleado" tagprefix="uc1" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc2" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
    $(function () {

        // Datepicker
        $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));
        $(".fecha").datepicker($.datepicker.regional['es']); 

    });
    </script>
    
    <div class="header">
        Consulta de Subsidios Extraordinarios<br />
    </div>
    <asp:UpdatePanel ID="udpBuscar" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
        
            <table cellpadding="1" cellspacing="0" class="td-content" style="width: 400px">
                <tr>
                    <td style="width: 25%; height:5px;">
                    </td>
                    <td>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Fecha desde:</td>
                    <td>
                        <asp:TextBox ID="txtDesde"  runat="server" CssClass="fecha" onkeypress="return false"
                            MaxLength="25" EnableViewState="False" />
                       
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Fecha hasta:</td>
                    <td>
                        <asp:TextBox ID="txtHasta" runat="server" CssClass="fecha" EnableViewState="False" onkeypress="return false"
                            MaxLength="25" />
                       
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Tipo subsidio:</td>
                    <td>
                        <asp:DropDownList ID="ddlTipoSubsidio" runat="server" CssClass="dropDowns">
                            <asp:ListItem Value="M">Maternidad</asp:ListItem>
                            <asp:ListItem Value="L">Lactancia</asp:ListItem>
                            <asp:ListItem>Todas</asp:ListItem>
                        </asp:DropDownList>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                        Registro Patronal:</td>
                    <td>
                        <asp:TextBox ID="txtRegistroPatronal" runat="server" EnableViewState="False" 
                            ></asp:TextBox>
                    </td>
                </tr>
                <tr>
                    <td align="right">
                    </td>
                    <td>
                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" />
                    </td>
                </tr>
                <tr>
                    <td style="height: 5px;" align="center" colspan="2">
                    </td>
                </tr>
            </table>
            <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
            <asp:Label ID="lblMsg2" runat="server" CssClass="label-Blue" 
                EnableViewState="False" Visible="False">Baja procesada exitosamente</asp:Label>
            <br />
            <div id="divConsulta" runat="server" visible="False">
                
            <br />
            <asp:GridView ID="gvSubsidios" runat="server" AutoGenerateColumns="False" 
                Width="943px" Wrap="False">
                <Columns>
                    <asp:BoundField DataField="Nro_Solicitud" HeaderText="Nro Solicitud" >
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="id_nss" HeaderText="NSS">
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="NOMBRES" HeaderText="Nombre" />
                    <asp:BoundField DataField="id_registro_patronal" 
                        HeaderText="Registro Patronal" >
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:BoundField DataField="fecha_registro" DataFormatString="{0:d}" 
                        HeaderText="Fecha Solicitud" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
                        <FooterStyle Wrap="False" />
                        <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Tipo_Subsidios" HeaderText="Tipo Subsidio" >
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:LinkButton ID="detalle" runat="server" CommandName="Detalle" 
                                CommandArgument='<%# container.dataitem("id_nss")& "|" & container.dataitem("Tipo_Subsidios")& "|" & container.dataitem("id_registro_patronal") %>'>[Ver Detalle]</asp:LinkButton>
                        </ItemTemplate>
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:TemplateField>
                    <asp:TemplateField>
                        <ItemTemplate>
                            <asp:ImageButton ID="iBtnBorrar" runat="server" BorderWidth="0px" 
                                CausesValidation="False" CommandName="Borrar" ImageUrl="../images/error.gif" 
                                ToolTip="Borrar" CommandArgument='<%# container.dataitem("id_nss")& "|" & container.dataitem("Tipo_Subsidios") &"|"& container.dataitem("id_registro_patronal") &"|"& container.dataitem("nro_solicitud")%>'/>
                            &nbsp;
                        </ItemTemplate>
                    </asp:TemplateField>
                </Columns>
            </asp:GridView>
                <br />
                <asp:Panel ID="pnlNavegacion" runat="server" Height="50px"  Width="66px">
            <table cellpadding="0" cellspacing="0" width="550px">
            <tr>
                <td style="height: 24px">
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
            </asp:Panel>
           </div>
            <br />
        </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

