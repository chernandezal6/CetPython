<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/SuirPlus.master" CodeFile="ConsultaDetalleTrabajador.aspx.vb" Inherits="Consultas_ConsultaDetalleTrabajador" %>



<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">
   
    <span class="header">Consulta Detalle Trabajador DGT3/DGT4</span>
    <br />
    <br />
    <fieldset style="width: 280px; height: 70px;" id="fldTrabajador" runat="server">
        <table id="TbPINInfo" style="width: 280px;">
            <tr>
                <td>Nro. Documento:
                </td>
                <td>
                    <asp:TextBox ID="txtCedula" runat="server" Width="143px"
                        MaxLength="25" ></asp:TextBox>
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

    <div id="divInfoTrabajador" style="width: 350px; height: 120px;" visible="false" runat="server">
        <fieldset style="width: 350px; height: 80px;">
          
            <table cellpadding="3" cellspacing="0" id="tblInfoTrabajador" width="350px" runat="server" visible="false">
             
                 <tr>
                    <td align="right" style="text-align: center" colspan="2">
                        <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Datos Generales del Trabajador"></asp:Label>
                    </td>
                   
                </tr>
                  <tr>
                   <td>
                       </td>
                   </tr>
                
                  
                <tr>
                    <td align="right">
                        <asp:Label ID="lbltxtNSS" runat="server" Text="NSS:" Visible="true"></asp:Label></td>
                    <td>
                        <asp:Label ID="lblNSS" runat="server" Font-Bold="True"></asp:Label></td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Label ID="LbltxtCedula" runat="server" Text="Cédula:" Visible="true"></asp:Label></td>
                    <td>
                        <asp:Label ID="LblCedula" runat="server" Font-Bold="True"></asp:Label></td>
                </tr>
                <tr>
                    <td align="right">
                        <asp:Label ID="LbltxtNombres" runat="server" Text="Nombres:" Visible="true"></asp:Label></td>
                    <td>
                        <asp:Label ID="LblNombres" runat="server" Font-Bold="True"></asp:Label></td>
                </tr>
            </table>
        </fieldset>
    </div>
    <br />
    <asp:UpdatePanel ID="UpdatePanelInfoTrabajador" runat="server" Visible ="false" UpdateMode="Always">
        <ContentTemplate>
            <ajaxToolkit:TabContainer ID="tbContainer" runat="server" ActiveTabIndex="4" AutoPostBack="True">
                <ajaxToolkit:TabPanel ID="MovimientosDGT3" runat="server" HeaderText="Novedades DGT3">
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <br />
                                    <asp:GridView ID="gvMovDGT3" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="960px">
                                        <Columns>
                                            <asp:TemplateField HeaderText="RNC">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="tipo_novedad" HeaderText="Tipo novedad">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="nro_localidad" HeaderText="Nro. Localidad" HtmlEncode="False">
                                                <ItemStyle HorizontalAlign="right" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="localidad" HeaderText="Localidad">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="ocupacion" HeaderText="Ocupacion">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="turno" HeaderText="Turno">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:LinkButton ID="btnlnkFirstPageMovDGT3" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                        CommandName="First" OnCommand="NavigationLink_ClickMovDGT3"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnlnkPreviousPageMovDGT3" runat="server" CssClass="linkPaginacion"
                                        Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_ClickMovDGT3"></asp:LinkButton>&nbsp; Página [<asp:Label ID="LblCurrentPageMovDGT3" runat="server"></asp:Label>] de
                                    <asp:Label ID="lblTotalPagesMovDGT3" runat="server"></asp:Label>&nbsp;
                                    <asp:LinkButton ID="btnLnkNextPageMovDGT3" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                        CommandName="Next" OnCommand="NavigationLink_ClickMovDGT3"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkLastPageMovDGT3" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                        CommandName="Last" OnCommand="NavigationLink_ClickMovDGT3"></asp:LinkButton>&nbsp;
                                    <asp:Label ID="lblPageSizeMovDGT3" runat="server"  Visible="False"></asp:Label><asp:Label ID="lblPageNumMovDGT3" runat="server" Visible="False"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                    Total de registros&nbsp;
                                    <asp:Label ID="lblTotalRegistrosMovDGT3" CssClass="error" runat="server" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblMensaje" runat="server" CssClass="error" EnableViewState="False"></asp:Label>&nbsp; </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="LblErrorMovDGT3" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
                            </tr>
                        </table>
                    </ContentTemplate>
                    <HeaderTemplate>Novedades DGT3</HeaderTemplate>
                </ajaxToolkit:TabPanel>

                <ajaxToolkit:TabPanel ID="MovimientosDGT4" runat="server" HeaderText="Novedades DGT4">
                    <HeaderTemplate>Novedades DGT4</HeaderTemplate>
                    <ContentTemplate>
                        <table>



                            <tr>
                                <td>
                                    <br />
                                    <asp:GridView ID="gvMovDGT4" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="960px">
                                        <Columns>
                                            <asp:TemplateField HeaderText="RNC">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="tipo_novedad" HeaderText="Tipo novedad">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="nro_localidad" HeaderText="Nro. Localidad" HtmlEncode="False">
                                                <ItemStyle HorizontalAlign="right" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="localidad" HeaderText="Localidad">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="ocupacion" HeaderText="Ocupacion">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="turno" HeaderText="Turno">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:LinkButton ID="btnlnkFirstPageMovDGT4" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                        CommandName="First" OnCommand="NavigationLink_ClickMovDGT4"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnlnkPreviousPageMovDGT4" runat="server" CssClass="linkPaginacion"
                                        Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_ClickMovDGT4"></asp:LinkButton>&nbsp; Página [<asp:Label ID="lblCurrentPageMovDGT4" runat="server"></asp:Label>] de
                                    <asp:Label ID="lblTotalPagesMovDGT4" runat="server"></asp:Label>&nbsp;
                                    <asp:LinkButton ID="btnLnkNextPageMovDGT4" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                        CommandName="Next" OnCommand="NavigationLink_ClickMovDGT4"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkLastPageMovDGT4" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                        CommandName="Last" OnCommand="NavigationLink_ClickMovDGT4"></asp:LinkButton>&nbsp;
                                    <asp:Label ID="lblPageSizeMovDGT4" runat="server" Visible="False"></asp:Label><asp:Label ID="lblPageNumMovDGT4" runat="server" Visible="False"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                    Total de registros&nbsp;
                                    <asp:Label ID="lblTotalRegistrosMovDGT4" CssClass="error" runat="server" /></td>
                                <tr>
                                    <td>
                                        <asp:Label ID="LblErrorMovDGT4" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
                                </tr>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>

                <ajaxToolkit:TabPanel ID="PlanillaDGT3" runat="server" HeaderText="Planillas DGT3">
                    <HeaderTemplate>Planilla DGT3</HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <br />
                                    <asp:GridView ID="gvPlanillaDGT3" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="960px">
                                        <Columns>
                                            <asp:TemplateField HeaderText="RNC">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Periodo">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblperiodoDGT3" runat="server" Text='<%# formateaPeriodo(Eval("periodo_planilla"))%>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Nro Referencia">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblReferencia" runat="server" Text='<%# formateaReferencia(Eval("id_referencia_planilla"))%>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="fecha_emision" HeaderText="Fecha emision"
                                                DataFormatString="{0:d}" HtmlEncode="False">
                                                <ItemStyle HorizontalAlign="center" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="status_planilla" HeaderText="Estatus">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:LinkButton ID="btnLnkFirstPageDGT3" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                        CommandName="First" OnCommand="NavigationLink_ClickDGT3"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkPreviousPageDGT3" runat="server" CssClass="linkPaginacion"
                                        Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_ClickDGT3"></asp:LinkButton>&nbsp; Página [<asp:Label ID="lblCurrentPageDGT3" runat="server"></asp:Label>] de
                                    <asp:Label ID="lblTotalPagesDGT3" runat="server"></asp:Label>&nbsp;
                                    <asp:LinkButton ID="btnLnkNextPageDGT3" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                        CommandName="Next" OnCommand="NavigationLink_ClickDGT3"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkLastPageDGT3" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                        CommandName="Last" OnCommand="NavigationLink_ClickDGT3"></asp:LinkButton>&nbsp;
                                    <asp:Label ID="lblPageSizeDGT3" runat="server" Visible="False"></asp:Label><asp:Label ID="lblPageNumDGT3" runat="server" Visible="False"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                    Total de registros&nbsp;
                                    <asp:Label ID="lblTotalRegistrosDGT3" CssClass="error" runat="server" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="LblErrorDGT3" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>

                <ajaxToolkit:TabPanel Visible="true" ID="PlanillaDGT4" runat="server" HeaderText="Planillas DGT4">
                    <HeaderTemplate>Planilla DGT4</HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <br />
                                    <asp:GridView ID="gvPlanillaDGT4" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="800px">
                                        <Columns>
                                            <asp:TemplateField HeaderText="RNC">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="Periodo planilla">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblperiodoDGT4" runat="server" Text='<%# formateaPeriodo(Eval("periodo_planilla"))%>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:TemplateField HeaderText="Nro Referencia">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblReferencia" runat="server" Text='<%# FormateaReferencia(eval("id_referencia_planilla")) %>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="fecha_emision" HeaderText="Fecha emision"
                                                DataFormatString="{0:d}" HtmlEncode="False">
                                                <ItemStyle HorizontalAlign="center" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:BoundField DataField="status_planilla" HeaderText="Estatus">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:LinkButton ID="btnLnkFirstPageDGT4" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                        CommandName="First" OnCommand="NavigationLink_ClickDGT4"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkPreviousPageDGT4" runat="server" CssClass="linkPaginacion"
                                        Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_ClickDGT4"></asp:LinkButton>&nbsp; Página [<asp:Label ID="lblCurrentPageDGT4" runat="server"></asp:Label>] de
                                    <asp:Label ID="lblTotalPagesDGT4" runat="server"></asp:Label>&nbsp;
                                    <asp:LinkButton ID="btnLnkNextPageDGT4" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                        CommandName="Next" OnCommand="NavigationLink_ClickDGT4"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkLastPageDGT4" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                        CommandName="Last" OnCommand="NavigationLink_ClickDGT4"></asp:LinkButton>&nbsp;
                                    <asp:Label ID="lblPageSizeDGT4" runat="server" Visible="False"></asp:Label><asp:Label ID="lblPageNumDGT4" runat="server" Visible="False"></asp:Label></td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                    Total de registros&nbsp;
                                    <asp:Label ID="lblTotalRegistrosDGT4" CssClass="error" runat="server" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblErrorDGT4" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label></td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>

                <ajaxToolkit:TabPanel Visible="true" ID="HistoricoErrores" runat="server" HeaderText="Historial de errores">
                    <HeaderTemplate>Historial de errores</HeaderTemplate>
                    <ContentTemplate>
                        <table>
                            <tr>
                                <td>
                                    <br />
                                    <asp:GridView ID="gvHistorial" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="1160px">
                                        <Columns>
                                                <asp:TemplateField HeaderText="Periodo">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblperiodoDGT4" runat="server" Text='<%# formateaPeriodo(Eval("periodo_aplicacion"))%>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                              <asp:BoundField DataField="error_des" HeaderText="Error">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                              <asp:BoundField DataField="planilla" HeaderText="Planilla">
                                                <ItemStyle HorizontalAlign="Center" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                             <asp:BoundField DataField="id_recepcion" HeaderText="Nro. Recepción">
                                                <ItemStyle HorizontalAlign="Center" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                             <asp:BoundField DataField="nombre_archivo" HeaderText="Archivo">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                             <asp:BoundField DataField="fecha_carga" HeaderText="Fecha carga"
                                                DataFormatString="{0:d}" HtmlEncode="False">
                                                <ItemStyle HorizontalAlign="center" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                            <asp:TemplateField HeaderText="RNC">
                                                <ItemTemplate>
                                                    <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(Eval("id_rnc_cedula"))%>'></asp:Label></ItemTemplate>
                                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                                <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                            </asp:TemplateField>
                                            <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                                                <ItemStyle HorizontalAlign="Left" />
                                                <HeaderStyle HorizontalAlign="Center" />
                                            </asp:BoundField>
                                        </Columns>
                                    </asp:GridView>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:LinkButton ID="btnLnkFirstPageHis" runat="server" CssClass="linkPaginacion" Text="<< Primera"
                                        CommandName="First" OnCommand="NavigationLink_ClickHis"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkPreviousPageHis" runat="server" CssClass="linkPaginacion"
                                        Text="< Anterior" CommandName="Prev" OnCommand="NavigationLink_ClickHis"></asp:LinkButton>&nbsp; Página [<asp:Label ID="lblCurrentPageHis" runat="server"></asp:Label>] de
                                    <asp:Label ID="lblTotalPagesHis" runat="server"></asp:Label>&nbsp;
                                    <asp:LinkButton ID="btnLnkNextPageHis" runat="server" CssClass="linkPaginacion" Text="Próxima >"
                                        CommandName="Next" OnCommand="NavigationLink_ClickHis"></asp:LinkButton>&nbsp;|
                                    <asp:LinkButton ID="btnLnkLastPageHis" runat="server" CssClass="linkPaginacion" Text="Última >>"
                                        CommandName="Last" OnCommand="NavigationLink_ClickHis"></asp:LinkButton>&nbsp;
                                    <asp:Label ID="lblPageSizeHis" runat="server" Visible="False"></asp:Label><asp:Label ID="lblPagenumHis" runat="server" Visible="False"></asp:Label>

                               </td>
                            </tr>
                            <tr>
                                <td>
                                    <br />
                                    Total de registros&nbsp;
                                    <asp:Label ID="lblTotalRegistrosHis" CssClass="error" runat="server" /></td>
                            </tr>
                            <tr>
                                <td>
                                    <asp:Label ID="lblErrorHis" runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label>

                                </td>
                            </tr>
                        </table>
                    </ContentTemplate>
                </ajaxToolkit:TabPanel>
            </ajaxToolkit:TabContainer>
        </ContentTemplate>
          
     
               
    </asp:UpdatePanel>


    <%-- Movimientos y planillas--%>

    <%--    <tr>
                <td>
        <fieldset style="width: 400px; height: auto;">
            <legend style="text-align: left">Movimiento DGT3</legend>
            <br />
                <asp:GridView ID="gvMovDGT3" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="400px">
                    <Columns>

                          <asp:TemplateField HeaderText="RNC">
                            <ItemTemplate>
                                <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="id_localidad" HeaderText="Nro. Localidad"
                            DataFormatString="{0:d}" HtmlEncode="False">
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="localidad" HeaderText="Localidad">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="tipo_planilla" HeaderText="Planilla">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                       
                    </Columns>
                </asp:GridView>
        </fieldset>
                    </td>
                <td>
                    </td>
                <td>
                    </td>
                <td>
                    <fieldset style="width: 400px; height: auto;">
            <legend style="text-align: left">Planilla DGT3</legend>
            <br />
                <asp:GridView ID="GridView1" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="400px">
                    <Columns>

                          <asp:TemplateField HeaderText="RNC">
                            <ItemTemplate>
                                <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="id_localidad" HeaderText="Nro. Localidad"
                            DataFormatString="{0:d}" HtmlEncode="False">
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="localidad" HeaderText="Localidad">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="tipo_planilla" HeaderText="Planilla">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                       
                    </Columns>
                </asp:GridView>
        </fieldset>
                    </td>
                </tr>
           <tr>
               <td>
              <fieldset style="width: 400px; height: auto;">
            <legend style="text-align: left">Movimiento DGT4</legend>
            <br />
                <asp:GridView ID="gvMovDGT4" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="400px">
                    <Columns>

                          <asp:TemplateField HeaderText="RNC">
                            <ItemTemplate>
                                <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="id_localidad" HeaderText="Nro. Localidad"
                            DataFormatString="{0:d}" HtmlEncode="False">
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="localidad" HeaderText="Localidad">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="tipo_planilla" HeaderText="Planilla">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                       
                    </Columns>
                </asp:GridView>
        </fieldset>
                   </td>
               <td>
                    </td>
               <td>
                    </td>
                  <td>
        <fieldset style="width: 400px; height: auto;">
            <legend style="text-align: left">Planilla DGT4</legend>
            <br />
                <asp:GridView ID="GridView3" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="400px">
                    <Columns>

                          <asp:TemplateField HeaderText="RNC">
                            <ItemTemplate>
                                <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="id_localidad" HeaderText="Nro. Localidad"
                            DataFormatString="{0:d}" HtmlEncode="False">
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="localidad" HeaderText="Localidad">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="tipo_planilla" HeaderText="Planilla">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                       
                    </Columns>
                </asp:GridView>
        </fieldset>
                    </td>
                   </tr>--%>

    <%--  </table>--%>
    <%--         <table width="920px">
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

        </table>--%>

    <%-- Historial de errores--%>
    <%-- <fieldset style="width: 860px; height: auto;">
            <legend style="text-align: left">historial de errores</legend>
            <br />
                <asp:GridView ID="GridView2" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="860px">
                    <Columns>

                          <asp:TemplateField HeaderText="RNC">
                            <ItemTemplate>
                                <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label>
                            </ItemTemplate>
                            <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                            <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="razon_social" HeaderText="Razon Social">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="id_localidad" HeaderText="Periodo aplicación">
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="tipo_planilla" HeaderText="Planilla">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="tipo_novedad" HeaderText="Error">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="ocupacion" HeaderText="Nro.Recepcion">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:BoundField DataField="turno" HeaderText="Nombre archivo">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="id_localidad" HeaderText="Fecha carga"
                            DataFormatString="{0:d}" HtmlEncode="False">
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                    </Columns>
                </asp:GridView>
        </fieldset>--%>

    <%--</div>--%>

    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />
    <br />

</asp:Content>

