<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consLotes.aspx.vb" Inherits="Consultas_consLotes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
    <script language="javascript" type="text/javascript">

        function checkNum() {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57)) {
                event.cancelBubble = true
                event.returnValue = false;
            }

        }
    </script>
    <asp:Label ID="lblTitulo" runat="server" CssClass="header">Consulta Asignación y cambio NSS</asp:Label>
    <br />
    <br/>
    <div>
        <table>
            <tr>
                <td>
                    <div id="divInfoLotes" style="height: 100px;">
                        <fieldset style="width: 220px; height: 100px;" id="fldPin" runat="server">
                            <legend style="text-align: left">Criterio de búsqueda</legend>
                            <table id="TbLotesInfo">
                                <tr>
                                    <td>Nro. Lote:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtNumLote" runat="server" Width="120px" MaxLength="10" onkeypress="checkNum()"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td>Nro. Registro:
                                    </td>
                                    <td>
                                        <asp:TextBox ID="txtNumDetalle" runat="server" Width="120px" MaxLength="10" onkeypress="checkNum()"></asp:TextBox>
                                    </td>
                                </tr>
                                <tr>
                                    <td colspan="2" style="text-align: center">
                                        <asp:Button ID="btnBuscar" runat="server" Text="Buscar" CausesValidation="False" />
                                        <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" /></td>
                                </tr>
                            </table>
                        </fieldset>
                    </div>
                </td>
                <td id="tdArs" nowrap="nowrap" visible="false" style="vertical-align: middle; font-size: 11px" runat="server">ARS:
                    <asp:Label ID="LblARS" runat="server" CssClass="labelData" Font-Size="11px" Visible="False"></asp:Label>
                </td>
            </tr>
        </table>
       <br />
        <asp:Label ID="LblError" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label>
    </div>
    <br />
    <div id="divDetalleLotes" runat="server" visible=" false">
        <asp:GridView ID="gvInfoLotes" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="380px">
            <Columns>
                <asp:BoundField DataField="Asignacion" HeaderText="Tipo">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="lote" HeaderText="Nro. Lote">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="id_registro" HeaderText="Nro. Registro">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="idNSS" HeaderText="NSS">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="nombres" HeaderText="Nombres">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Apellidos" HeaderText="Apellidos">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="extranjero" HeaderText="Extranjero">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="status" HeaderText="Estatus">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="Desc_error" HeaderText="Descripción Motivo">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="left" Wrap="False" />
                </asp:BoundField>
                <asp:BoundField DataField="nss_duplicidad" HeaderText="NSS Duplicidad">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                </asp:BoundField>
                <%-- <asp:TemplateField HeaderText="Recibido En">
                    <ItemTemplate>
                        <asp:Label ID="LblFechaRegistro" runat="server" Text='<%# Eval("RecibidoEn")%>' ></asp:Label>
                    </ItemTemplate>
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                </asp:TemplateField>--%>
                <asp:BoundField DataField="RecibidoEn" HeaderText="Fecha Recibido"
                    DataFormatString="{0:d}" HtmlEncode="False">
                    <ItemStyle HorizontalAlign="center" Wrap="false" />
                    <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                </asp:BoundField>

                <%--  <asp:BoundField DataField="fecha_evaluacion" HeaderText="Fecha Evaluación"
                    DataFormatString="{0:d}" HtmlEncode="False">
                    <ItemStyle HorizontalAlign="center" Wrap="false" />
                    <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                </asp:BoundField>--%>
                <asp:BoundField DataField="fecha_repuesta" HeaderText="Fecha Respuesta"
                    DataFormatString="{0:d}" HtmlEncode="False">
                    <ItemStyle HorizontalAlign="center" Wrap="false" />
                    <HeaderStyle HorizontalAlign="Center" Wrap="false" />
                </asp:BoundField>
                <%--<asp:BoundField DataField="RecibidoEn" HeaderText="Recibido en">
                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                </asp:BoundField>--%>
                <asp:TemplateField HeaderText="Detalle">
                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                    <ItemTemplate>
                        <asp:LinkButton ID="btnLnkVerMas" runat="server" Visible="true" CommandName="VerMas" CommandArgument='<%# Eval("lote") & "|" & Eval("id_registro")%>'>Ver Mas</asp:LinkButton>
                    </ItemTemplate>
                </asp:TemplateField>
                <%--<asp:TemplateField>
                    <ItemStyle HorizontalAlign="Center" />
                    <ItemTemplate>
                        <asp:Label ID="lblActa" runat="server" Visible="false" Text='<%# eval("Id") %>'></asp:Label>
                        <asp:ImageButton ID="ibAsignarNss" runat="server" Visible="false" ImageUrl="~/images/kappfinder.gif" CommandName="A" CommandArgument='<%# Eval("id_solicitud")%>' />
                        <asp:ImageButton ID="ibEvaluarCiudadanos" runat="server" Visible="false" ImageUrl="~/images/kappfinder.gif" CommandName="E" CommandArgument='<%# Eval("IdRow")%>' />
                    </ItemTemplate>
                </asp:TemplateField>--%>
                <asp:TemplateField HeaderText="">
                    <ItemTemplate>
                        <asp:ImageButton ID="VerActa" runat="server" ToolTip="Ver Acta" ImageUrl="~/images/kappfinder.gif"
                            CommandName="VerActa" CommandArgument='<%# Eval("lote") & "|" & Eval("id_registro")%>' ImageAlign="right"></asp:ImageButton>
                    </ItemTemplate>
                </asp:TemplateField>
            </Columns>
        </asp:GridView>

        <table style="width:780px">
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

        </table>
    </div>
    <br />

    <div style="width: 500px;" id="divInfoLote" runat="server" visible="false">
        <fieldset id="fsDetalleRegistro" runat="server" style="height: auto">
            <legend>Detalle del Registro</legend>

            <table border="0" cellpadding="0" cellspacing="0">
                <tr>
                    <td>

                        <table>
                            <tr>
                                <td align="right" nowrap="nowrap">Nro. Lote:
                                </td>
                                <td  nowrap="nowrap">
                                    <asp:Label ID="lblNumLote" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">Nro. Registro:
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label ID="lblNumRegistro" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">ARS:</td>
                                <td>
                                    <asp:Label ID="LblNombreARS" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">Nro. Documento:
                                </td>
                                <td>
                                    <asp:Label ID="lblNroDoc" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>

                            <tr>
                                <td align="right">Nombres:
                                </td>
                                <td>
                                    <asp:Label ID="LblNombres" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Apellidos:
                                </td>
                                <td>
                                    <asp:Label ID="lblApellidos" runat="server" CssClass="labelData"></asp:Label>
                                </td>

                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">Estado Civil:
                                </td>
                                <td s nowrap="nowrap">
                                    <asp:Label ID="LblEstadoCivil" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">NSS:
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label ID="LblNSS" runat="server" CssClass="labelData"></asp:Label>
                                </td>

                            </tr>
                            <tr>
                                <td align="right">Fecha Nacimiento:
                                </td>
                                <td>
                                    <asp:Label ID="LblFechaNac" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Padre:
                                </td>
                                <td>
                                    <asp:Label ID="lblNombrePadre" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right">Madre:
                                </td>
                                <td>
                                    <asp:Label ID="lblNombreMadre" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">Estatus:
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label ID="LblEstatus" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                             <tr>
                                <td align="right" nowrap="nowrap">Descripción Motivo:
                                </td>
                                <td  nowrap="nowrap">
                                    <asp:Label ID="LblMotivoError" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                             <tr>
                                <td align="right" nowrap="nowrap">NSS Duplicidad:
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label ID="LblNSSDuplicidad" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">Extranjero:
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label ID="LblExtranjero" runat="server" CssClass="labelData"></asp:Label>
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
                                <td align="right" nowrap="nowrap" >Nombre Titular:
                                </td>
                                <td nowrap="nowrap" >
                                    <asp:Label ID="LblNombreTitular" runat="server" CssClass="labelData"></asp:Label>
                                </td>

                            </tr>
                            <tr>
                                <td align="right" nowrap="nowrap">Apellidos Titular:
                                </td>
                                <td nowrap="nowrap">
                                    <asp:Label ID="LblApellidosTitular" runat="server" CssClass="labelData"></asp:Label>
                                </td>
                            </tr>
                           

                            <tr>
                                <td  align="right" nowrap="nowrap">Nro. Documento Titular:
                                </td>
                                <td  nowrap="nowrap">
                                    <asp:Label ID="LblCodTitular" runat="server" CssClass="labelData"></asp:Label>
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
                    </td>

                </tr>
                <tr>
                    <td>
                        <table style="width:490px">
                            <tr>
                                <%--  <td align="center">Provincia:
                                </td>

                                <td align="center">Municipio:
                                </td>--%>

                                <td align="center">Oficialia:
                                </td>

                                <td align="center">Libro:
                                </td>

                                <td align="center">Folio:
                                </td>

                                <td align="center">Acta:
                                </td>

                                <td align="center">Año:
                                </td>

                            </tr>
                            <tr>
                                <%-- <td align="center">
                                    <asp:Label ID="lblProvincia" runat="server" CssClass="labelData" ></asp:Label>
                                </td>
                                <td align="center">
                                    <asp:Label ID="lblMunicipio" runat="server" CssClass="labelData"></asp:Label>
                                </td>--%>
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
                    </td>
                </tr>
            </table>

        </fieldset>
    </div>
</asp:Content>

