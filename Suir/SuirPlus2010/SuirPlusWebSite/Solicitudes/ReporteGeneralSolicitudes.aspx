<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ReporteGeneralSolicitudes.aspx.vb" Inherits="Solicitudes_ReporteGeneralSolicitudes" %>

<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

 <script language="javascript" type="text/javascript">
     $(function pageLoad(sender, args) {

         EndRequestHandler();

         Sys.WebForms.PageRequestManager.getInstance().add_endRequest(EndRequestHandler);
     });

     function EndRequestHandler() {
         // Datepicker
         $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));

         $("#ctl00_MainContent_txtDesde").datepicker($.datepicker.regional['es']);
         $("#ctl00_MainContent_txtHasta").datepicker($.datepicker.regional['es']);
     }
    </script>
   
    <asp:UpdatePanel ID="upReporteSolicitudes" runat="server">
        <ContentTemplate>
           <!---->
        <!---->
            <!---->
            <table >
                <tr>
                    <td align="left">
                              <div  id="divRepSolicitudes" runat="server"  >
            <fieldset> 
                <legend>Reporte General de Solicitudes</legend><br /> 
                <table cellpadding="1" cellspacing="0" class="td-content" >
                    <tr>
                        <td style="width: 88px">
                            <br />
                        </td>
                        <td style="width: 200px">
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 88px;">Tipo de Servicio</td>
                        <td style="width: 200px;">
                            <asp:DropDownList ID="ddlTipoServicio" runat="server" AutoPostBack="True"  CssClass="dropDowns">
                                <asp:ListItem Value="0">--Todos--</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" nowrap="nowrap" style="width: 88px">
                            Usuario</td>
                        <td style="width: 200px">
                            <asp:DropDownList ID="ddlUsuario" runat="server" AutoPostBack="True"  CssClass="dropDowns">
                                <asp:ListItem Value="0">--Todos--</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 88px">
                            Status</td>
                        <td style="width: 200px">
                            <asp:DropDownList ID="ddlStatus" runat="server" AutoPostBack="True" CssClass="dropDowns">
                                <asp:ListItem Value="-1">--Todos--</asp:ListItem>
                                <asp:ListItem Value="0">Abierta</asp:ListItem>
                                <asp:ListItem Value="1">En Proceso</asp:ListItem>
                                <asp:ListItem Value="2">Incompleta</asp:ListItem>
                                <asp:ListItem Value="3">Completada</asp:ListItem>
                                <asp:ListItem Value="4">Entregada</asp:ListItem>
                            </asp:DropDownList>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 88px">
                            &nbsp;&nbsp; Fecha Inicial
                        </td>
                        <td style="width: 200px">
                            <asp:TextBox ID="txtDesde" runat="server" onkeypress="return false;"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                                ControlToValidate="txtDesde" ErrorMessage="La Fecha Inicial es requerida" 
                                Display="Dynamic"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 88px">
                            Fecha Final</td>
                        <td style="width: 200px">
                            <asp:TextBox ID="txtHasta" runat="server" onkeypress="return false;"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                                ControlToValidate="txtHasta" ErrorMessage="La Fecha Final es requerida"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                    <tr>
                        <td align="right" style="width: 88px">
                        </td>
                        <td style="width: 200px">
                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" />
                            <asp:Button ID="btnLimpiar" runat="server" CausesValidation="False" 
                                Text="Limpiar" />
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 88px">
                        </td>
                        <td style="width: 200px">
                            &nbsp;</td>
                    </tr>
                </table>
                <br />
                 
            </fieldset></div>
                    </td>
                </tr>
            </table>
          
            <!---->
        <!---->
        
        <!---->
            <!---->
            <div>
                <asp:Label ID="lblMensaje" runat="server" CssClass="error" 
                    EnableViewState="False"></asp:Label></div>
            <!---->
        <!---->
        <!---->
            <!---->
            
            <table>
            
                <tr>
                    <td>
                             <asp:Panel ID="pnlInfoEncabezado" runat="server" Visible="false" > 
           
                 <fieldset>
                 <legend>Solicitudes </legend>
                 <br />
                 <table>
                 <tr>
                    <td>
                        <asp:GridView ID="gvInfoEncabezado" runat="server" 
                         HorizontalAlign="Left" AutoGenerateColumns="False" Width="1200px">
                            <Columns>
                                <asp:BoundField DataField="id_solicitud" HeaderText="Solicitud" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="tipo_solicitud" HeaderText="Tipo Solicitud" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="descStatus" HeaderText="Status" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle Width="70px" Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="razon_social" HeaderText="Razon Social" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="nombrerep" HeaderText="Solicitante">
                                <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Usuario" HeaderText="Usuario" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="fecha_proceso" HeaderText="Fecha Inicio" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="fecha_cierre" HeaderText="Fecha Cierre" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:BoundField DataField="dias" HeaderText="Dias de Proceso" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="horas" HeaderText="Horas de Proceso" >
                                <HeaderStyle Wrap="False" />
                                <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Minutos" HeaderText="Minutos">
                                <ItemStyle HorizontalAlign="Center" />
                                </asp:BoundField>
                                <asp:BoundField DataField="Pausa" HeaderText="Tiempo Total en Pausa" >
                                <ItemStyle Width="200px" Wrap="false" />
                                <HeaderStyle Wrap="False" />
                                </asp:BoundField>
                                <asp:TemplateField>
                                <ItemStyle Width="60px" Wrap="False" />
                                    <ItemTemplate >
                                        <asp:LinkButton ID="lbDetalleSolicitud" runat="server" CommandName="VerDetalle" CommandArgument='<%# Eval("id_solicitud") %>'>[Histórico]</asp:LinkButton>
                                    </ItemTemplate>
                                </asp:TemplateField>
                                              
                            </Columns>
                         <FooterStyle Height="25px" HorizontalAlign="Center" VerticalAlign="Bottom" Wrap="False"  />
                 </asp:GridView>
                    </td>
                 </tr>
                 
                        <tr>
                            <td>
                                 <asp:Panel ID="pnlNavegacion2" runat="server" Height="70px" Visible="False" 
                                     width="550px">
                                     <table cellpadding="0" cellspacing="0" width="550px">
                                         <tr>
                                             <td colspan="2" style="height: 24px">
                                                 <asp:LinkButton ID="btnLnkFirstPage2" runat="server" CommandName="First" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" 
                                                     Text="&lt;&lt; Primera"></asp:LinkButton>
                                                 &nbsp;|
                                                 <asp:LinkButton ID="btnLnkPreviousPage2" runat="server" CommandName="Prev" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" Text="&lt; Anterior"></asp:LinkButton>
                                                 &nbsp; Página [<asp:Label ID="lblCurrentPage2" runat="server"></asp:Label>
                                                 ] de
                                                 <asp:Label ID="lblTotalPages2" runat="server"></asp:Label>
                                                 &nbsp;
                                                 <asp:LinkButton ID="btnLnkNextPage2" runat="server" CommandName="Next" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" Text="Próxima &gt;"></asp:LinkButton>
                                                 &nbsp;|
                                                 <asp:LinkButton ID="btnLnkLastPage2" runat="server" CommandName="Last" 
                                                     CssClass="linkPaginacion" OnCommand="NavigationLink_Click2" 
                                                     Text="Última &gt;&gt;"></asp:LinkButton>
                                                 &nbsp;
                                                 <asp:Label ID="lblPageSize2" runat="server" Visible="False"></asp:Label>
                                                 <asp:Label ID="lblPageNum2" runat="server" Visible="False"></asp:Label>
                                             </td>
                                         </tr>
                                         <tr>
                                             <td>
                                                 Total de Registros:
                                                 <asp:Label ID="lblTotalRegistros2" runat="server" CssClass="error"></asp:Label>
                                                 &nbsp;&nbsp;
                                                 <br />
                                                 <br />
                                                 <uc1:ucExportarExcel ID="ucExportarExcel1" runat="server" />
                                                 &nbsp;&nbsp;&nbsp;&nbsp;
                                                 <asp:LinkButton ID="lbVolverEncabezado" runat="server" Visible="False">volver al encabezado</asp:LinkButton>
                                                 <br />
                                             </td>
                                         </tr>
                                     </table>
                                 </asp:Panel>
                            </td>
                        </tr>
                 
                 </table>   
                 </fieldset>
                    <br />
                    <br />
                
             </asp:Panel>
                    </td>
                </tr>
            </table>

            <table>
                <tr>
                <td>
                  <asp:Panel ID="pnlUsuarios" runat="server" Visible="false">
                <fieldset>
                    <legend>Histórico de Tareas por Solicitud</legend>
                    <br />
                    <asp:Label ID="lblMensajeUsuarios" runat="server" CssClass="error" 
                        EnableViewState="False"></asp:Label>
                    <br />
                    <asp:GridView ID="gvUsuarios" runat="server" 
                        AutoGenerateColumns="False" Width="336px">
                        <Columns>
                            <asp:BoundField DataField="Usuario" HeaderText="Usuario" />
                            <asp:BoundField DataField="fecha_registro" HeaderText="Fecha" />
                        </Columns>
                    </asp:GridView>
                </fieldset>
                <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False">
                    <table cellpadding="0" cellspacing="0">
                        <tr>
                            <td style="height: 24px">
                                <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="&lt;&lt; Primera"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="&lt; Anterior"></asp:LinkButton>
                                &nbsp; Página [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>
                                ] de
                                <asp:Label ID="lblTotalPages" runat="server"></asp:Label>
                                &nbsp;
                                <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" Text="Próxima &gt;"></asp:LinkButton>
                                &nbsp;|
                                <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" 
                                    CssClass="linkPaginacion" OnCommand="NavigationLink_Click" 
                                    Text="Última &gt;&gt;"></asp:LinkButton>
                                &nbsp;
                                <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                                <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                            </td>
                        </tr>
                        <tr>
                            <td>
                                Total de Registros:
                                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                                &nbsp;</td>
                        </tr>
                    </table>
                </asp:Panel>
                <br />
                <br />
            </asp:Panel>
                </td>
                </tr>
            </table>
          
                
        <br />

            <!---->
        <!---->
  <!---->
        </ContentTemplate>
        <Triggers>
            <asp:PostBackTrigger ControlID="ucExportarExcel1" />
            
        </Triggers>
    </asp:UpdatePanel>
      <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>