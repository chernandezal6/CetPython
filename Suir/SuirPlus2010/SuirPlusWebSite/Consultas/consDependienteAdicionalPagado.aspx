<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false"
    CodeFile="consDependienteAdicionalPagado.aspx.vb" Inherits="Consultas_consDependienteAdicionalPagado"
    Title="Consulta de Notificaciones de Dependientes Adicionales" %>

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
    <script language="javascript" type="text/javascript">
        function Sel() {
            if ((document.aspnetForm.ctl00$MainContent$txtDocumento.value.length) !== 11) {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[1].selected = true;
            }
            else {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[0].selected = true;
            }
        }
    </script>
    <span class="header">Consulta de las Notificaciones de Pago de los Dependientes Adicionales</span>
    <br />
    <br />
    <table width="700px">
        <tr>
            <td >
            <br />
                <table class="tblWithImagen" id="table5" width="400px" style="border-collapse: inherit"
                    cellspacing="1" cellpadding="0" align="left">
                    <tr>
                    
                        <td style="width: 25%" rowspan="5">
                            
                            &nbsp;<img height="90" src="../images/upcatriesgo.jpg" width="167" alt="" />
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;" nowrap="nowrap">
                            <br />
                            Cédula Titular:
                        </td>
                        <td align="left" style="width: 100%">
                            <br />
                            <asp:TextBox ID="txtDocumento" onKeyPress="checkNum()" runat="server" MaxLength="11"
                                OnKeyUp="Sel()" OnChange="Sel()" Width="88"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td style="text-align: right;" nowrap="nowrap" rowspan="1">
                            <br />
                            &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                            Cédula Dependiente:
                        </td>
                        <td align="left" style="width: 100%">
                            <br />
                            <asp:TextBox ID="TxtDependiente" onKeyPress="checkNum()" runat="server" MaxLength="11"
                                OnKeyUp="Sel()" OnChange="Sel()" Width="88"></asp:TextBox>
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <br />
                            <asp:Button ID="btnBuscar" runat="server" Text="Buscar" Enabled="True" EnableViewState="False">
                            </asp:Button>&nbsp;
                            <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False">
                            </asp:Button>
                            <br />
                              <br />
                        </td>
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
                            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtDocumento"
                                Display="Dynamic" ErrorMessage="Cédula/as Requerida/as " Style="text-align: left"></asp:RequiredFieldValidator>
                        </td>
                    </tr>
                </table>
            </td>
            </tr>
            <tr>
            <td>
                <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>            
                <br />
            </td>
            </tr>
          <%--  Si la informacion del titular y el dependiente se va a presentar en labels, entonces aqui ponemos los labels que se necesitaran.--%>
          <tr>
       <td>
	  <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
      <ContentTemplate>       
          <div style="FLOAT: left; width: 400px;" id="divInfo" runat="server" visible="false" >
        <fieldset> 
            <legend style="text-align: left">Información Del Titular y el Dependiente</legend>
                       
             <table cellpadding="1" cellspacing="0">
                            
                            <tr>
                                <td style="width: 100px; height: 18px; ">
                                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Nombre Titular:</td>
                                <td style="height: 18px">
                                    <asp:Label ID="lblNombreTitular" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>                            
      
                            <tr>
                                <td style="width: 100px">
                                   Nombre Dependiente:</td>
                                <td>
                                    <asp:Label ID="lblNombreDependiente" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
            
                        </table>
                  
        </fieldset>
     </div> 
     </ContentTemplate> 
     </asp:UpdatePanel>      
     </td> 
    </tr> 
      
            <tr>
                <td>
               <br />
               
                    <asp:Panel ID="pnlDetalleNotificacionPago" runat="server" Visible="False" Width="600px">
                        <table id="Table1" cellspacing="0" cellpadding="0" border="0" width="100%">
                            <tr>
                                <td>
                                    <div id="divDetalleNotificacionPago" runat="server">
                                        <fieldset>
                                            <legend style="text-align: left">Detalle de Notificaciones de Pago</legend>
                                            <asp:GridView ID="gvDetalleNotificacionPago" runat="server" AutoGenerateColumns="false" Width="100%"
                                                Visible="true">
                                                <Columns>
                                                    <asp:BoundField DataField="periodo_factura" HeaderText="Período">
                                                        <ItemStyle Wrap="false" HorizontalAlign="center" VerticalAlign="Middle"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="NumeroReferencia" HeaderText="NroReferencia">
                                                        <ItemStyle Wrap="False" HorizontalAlign="center"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC">
                                                        <ItemStyle Wrap="False" HorizontalAlign="center"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="razon_social" HeaderText="Razón Social">
                                                        <ItemStyle Wrap="False" HorizontalAlign="center"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="montoPagado" HeaderText="Percapita Pagado">
                                                        <ItemStyle Wrap="False" HorizontalAlign="right"></ItemStyle>
                                                    </asp:BoundField>
                                                    <asp:BoundField DataField="fecha_pago" HeaderText="Fecha Pago" DataFormatString="{0:d}">
                                                        <ItemStyle Wrap="False" HorizontalAlign="center"></ItemStyle>
                                                    </asp:BoundField>
                                                </Columns>
                                            </asp:GridView>
                                        </fieldset>
                                    </div>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                    <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="false">
                        <table cellpadding="0" cellspacing="0">
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
                                <td>
                                    Total de Registros:
                                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                                </td>
                            </tr>
                        </table>
                    </asp:Panel>
                </td>
        </tr>
    </table>
</asp:Content>
