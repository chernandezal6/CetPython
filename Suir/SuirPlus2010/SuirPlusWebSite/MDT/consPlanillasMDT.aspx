<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consPlanillasMDT.aspx.vb" Inherits="MDT_consPlanillasMDT" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<%@ Register Src="../Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <uc1:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <span class="header">Consulta Formularios MDT</span>
    <br />
    <br />
    <table cellpadding="0" cellspacing="0">
        <%-- <tr>
					<td style="width: 20" rowspan="1">
                    <img src="../images/LogoMDT.jpg" width="167" alt="" id="imgMDT" runat="server" />
                    </td>
				</tr>--%>
        <tr>
            <td>
                <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"
                    Font-Size="10pt"></asp:Label>
                <br />
            </td>
        </tr>
        <tr>
            <%--<td style="width: 5" rowspan="1">
                    <img src="../images/LogoMDT.jpg" width="167" alt="" />
                  </td>  --%>
            <td>
                <div style="float: left; width: auto;" id="divNovedades" runat="server" visible="false">
                    <fieldset>
                        <legend style="text-align: left">Listado de Formularios por periodo</legend>
                        <br />
                        <asp:GridView ID="gvPlanillasMDT" runat="server" AutoGenerateColumns="False" CellPadding="3"
                            Style="width: 400px;">
                            <Columns>
                                <asp:BoundField DataField="id_planilla" HeaderText="Tipo Formulario ">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                                <%-- <asp:BoundField DataField="periodo_factura" HeaderText="Periodo" 
                                DataFormatString="{0:d}" HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                            </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="Periodo">
                                    <ItemTemplate>
                                        <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("periodo_factura")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="total_novedades" HeaderText="Novedades" HeaderStyle-Width="26%">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:BoundField>
                                <%--<asp:BoundField DataField="ult_fecha_act" HeaderText="Fecha Novedad" 
                                HeaderStyle-Width="26%" DataFormatString="{0:d}" HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="center" Wrap="False" />
                            </asp:BoundField>--%>
                                <asp:TemplateField HeaderText="">
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemTemplate>
                                        <asp:LinkButton ID="lbDetallePlanilla" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("id_planilla") &"|"& Eval("periodo_factura") %>'>Ver Detalle</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </fieldset>
                </div>
            </td>
        </tr>
        <%-- 'Ponemos dos filas para hacer espacio entre los grids'--%>
        <tr>
            <td>
            </td>
        </tr>
        <tr>
            <td>
                <div style="float: left; width: 234px;" id="divInfoPlanilla" runat="server" visible="false">
                    <fieldset>
                        <legend style="text-align: left">Información general</legend>
                         <br />
                        <table>
                            <tr>
                                <td style="width: 54px; height: 14px;">
                                    Formulario:
                                </td>
                                <td style="height: 14px">
                                    <asp:Label ID="lblPlanilla" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td style="width: 74px">
                                    Período:
                                </td>
                                <td>
                                    <asp:Label ID="lblPeriodo" runat="server" CssClass="labelData" Text='<%# FormateaPeriodo(eval("periodo_factura"))%>'></asp:Label>
                                </td>
                            </tr>
                            <%--<tr>
                             <td style="width: 74px">
                                 Fecha:
                             </td>
                             <td>
                                 <asp:Label ID="LblFecha" runat="server" CssClass="labelData" Text='<%# eval("ult_fecha_act") %>'></asp:Label>
                             </td>
                         </tr>--%>
                        </table>
                    </fieldset>
                </div>
            </td>
        </tr>
        <tr>
            <td>
                 
                <br />
                <br />
                <div style="float: left; width: auto;" id="divDetNov" runat="server" visible="false">
                    <fieldset>
                        <legend style="text-align: left">Detalle</legend>
                        <br />
                        <asp:GridView ID="gvDetPlanillaMDT" runat="server" AutoGenerateColumns="False" CellPadding="2"
                            Style="width: 600px;" CellSpacing = "2">
                            <Columns>
                                <asp:BoundField DataField="novedad" HeaderText="Novedad">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="fecha_novedad" HeaderText="Fecha ingreso">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                                </asp:BoundField>
                                 <asp:BoundField DataField="fecha_salida" HeaderText="Fecha Salida">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Nro Ref.">
                                    <ItemTemplate>
                                        <asp:Label ID="LblReferencia" runat="server" Text='<%# FormateaReferencia(eval("id_referencia_planilla")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:TemplateField HeaderText="Nss">
                                    <ItemTemplate>
                                        <asp:Label ID="Lblnss" runat="server" Text='<%# (eval("nss")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="nombres" HeaderText="Trabajador">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="true" />
                                    <ItemStyle HorizontalAlign="left" Wrap="false" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Nacionalidad" HeaderText="Nacionalidad" >
                                    <HeaderStyle HorizontalAlign="Center" Wrap="true" />
                                    <ItemStyle HorizontalAlign="left" Wrap="true" />
                                </asp:BoundField>
                                <asp:TemplateField HeaderText="Salario">
                                    <ItemTemplate>
                                        <asp:Label ID="LblSalario" runat="server" Text='<%# FormateaSalario(eval("salario_mdt")) %>'  DataFormatString="{0:C}"></asp:Label>
                                    </ItemTemplate>
                                     <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                                </asp:TemplateField>
                                <asp:BoundField DataField="vacaciones" HeaderText="Vacaciones" DataFormatString="{0:d}"
                                    HtmlEncode="False">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="nombre_localidad" HeaderText="Establecimiento">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="descripcion_turno" HeaderText="Turno">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="descripcion_ocupacion" HeaderText="Ocupacion Real">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Segundo_puesto" HeaderText="Ocupacion (Descripción)">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="observacion" HeaderText="Observación">
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                                </asp:BoundField>
                             <asp:TemplateField>
                                    <ItemTemplate>
                                        <asp:ImageButton ID="BtnBorrar" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
                                            CommandName="Borrar" CommandArgument='<%# Eval("status_cartera")&"|"& Eval("id_referencia_planilla")&"|"& Eval("nss")&"|"& Eval("salario_mdt")%>'>
                                        </asp:ImageButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                            </Columns>
                        </asp:GridView>
                    </fieldset>
                    <table width="350px">
                        <tr>
                            <td>
                                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                    CommandName="First" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CssClass="linkPaginacion"
                                    Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                                Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                                <asp:LinkButton ID="btnLnkNextPage" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                    CommandName="Next" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                    CommandName="Last" OnCommand="NavigationLink_Click"></asp:LinkButton>&nbsp;
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <br />
                                Total de registros&nbsp;
                                <asp:Label ID="lblTotalRegistros" CssClass="error" runat="server" />
                            </td>
                        </tr>
                        <tr>
                            <td>
                                <uc2:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                                &nbsp; |&nbsp;
                                <asp:LinkButton ID="LnkBtvolver" runat="server" CssClass="linkPaginacion" Text="Volver encabezado >> "
                                    Visible="false"> </asp:LinkButton>&nbsp;
                            </td>
                        </tr>
                    </table>
                </div>
            </td>
        </tr>
        <tr>
            <td>
            </td>
        </tr>
    </table>
</asp:Content>
