<%@ Page Title="Detalle Devolución Aportes" Language="VB" MasterPageFile="~/SuirPlus.master"
    AutoEventWireup="false" CodeFile="DetDevolucionAportes.aspx.vb" Inherits="Finanzas_DetDevolucionAportes" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" runat="Server">

        <script  type="text/javascript">

            function imprimirDevolucion() {
 		        var nroReclamacion = $('#ctl00_MainContent_lblreclamacion').html();       
 		        var url = 'ImprimirDetalleDevolucion.aspx?rec=' + nroReclamacion;
 		        //window.showModalDialog(url, "", "help:0;status:0;toolbar:0;scrollbars:0;dialogwidth:800px:dialogHeight:1300px")
 		        newwindow = window.open(url, '', 'height=1300px,width=800px');
 		        newwindow.print();
 		    }  
        </script>  
   
    <div class="header">
        Detalle Devolución de Aportes</div>
    <br />
    <fieldset style="width: 400px">
        <legend>Informacion Devolución Aportes</legend>
        <br />
        <table>
            <tr>
                <td>
                    Nro. Reclamación:
                </td>
                <td>
                    <asp:Label ID="lblreclamacion" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    RNC:
                </td>
                <td>
                    <asp:Label ID="lblRnc" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Razón Social:
                </td>
                <td>
                    <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>
                    Estatus Devolución:
                </td>
                <td>
                    <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
                </td>
            </tr>
            <div id="divInfoCheque" runat="server" visible="false">
                <tr>
                    <td>
                        Nro. Cheque:
                    </td>
                    <td>
                        <asp:Label ID="lblNroCheque" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Nro. Documento:
                    </td>
                    <td>
                        <asp:Label ID="lblNroDocumento" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Nombre Completo:
                    </td>
                    <td>
                        <asp:Label ID="lblNombreCompleto" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                <tr>
                    <td>
                        Entregado Por:
                    </td>
                    <td>
                        <asp:Label ID="lblEntregadoPor" runat="server" CssClass="labelData"></asp:Label>
                    </td>
                </tr>
                
            </div>
                <tr>
                    <td></td>
                    <td></td>
                </tr>
                <tr>
                    <td></td>
                    <td></td>
                </tr>
                
            <tr>
                <td colspan="2" style="text-align: center">
                    <asp:LinkButton ID="lbtnEntregarFondos" runat="server" Visible="false" Font-Size="Smaller"><img src="../images/detalle.gif" alt="" />&nbsp;Entregar Fondos&nbsp;|&nbsp;</asp:LinkButton>                                    
                     <asp:LinkButton ID="lbtnImprimir" runat="server" Visible="false" Font-Size="Smaller" OnClientClick="imprimirDevolucion();"><img src="../images/printv.gif" alt="" />&nbsp;Imprimir&nbsp;|&nbsp;</asp:LinkButton>                                      
                    <asp:LinkButton ID="lbtnEncabezado" runat="server" Font-Size="Smaller"><img src="../images/retornar.gif" alt="" />&nbsp;volver al encabezado</asp:LinkButton>
                    <br />
                </td>
            </tr>
        </table>
    </fieldset>
    <div>
        <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
        <br />
    </div>

    <div>
        <div class="header">
            Aprobados</div>
        <div>
            <asp:Label ID="lblErrMsgA" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
        </div>
        <asp:GridView ID="gvDetDevolucionesA" runat="server" AutoGenerateColumns="False"
            Width="600px" EnableViewState="False" Wrap="False" ShowFooter="True">
            <Columns>
                <asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="Trabajador" HeaderText="Trabajador">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="TIPO_RECLAMACION" HeaderText="Reclamación">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="MOTIVO_DEVOLUCION" HeaderText="Motivo Devolución">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="SALARIO" HeaderText="Salario" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="APORTE_VOLUNTARIO" HeaderText="Aporte Voluntario" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="MONTO_DEVOLUCION" HeaderText="Monto Solicitado" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="Total_Devolver" HeaderText="Total a Devolver" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
            </Columns>
            <FooterStyle Font-Bold="True" />
        </asp:GridView>
    </div>
    <br />
    <div>
        <div class="header">
            Rechazados</div>
        <div>
            <asp:Label ID="lblErrMsgR" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
        </div>
        <asp:GridView ID="gvDetDevolucionesR" runat="server" AutoGenerateColumns="False"
            Width="600px" EnableViewState="False" Wrap="False" ShowFooter="True">
            <Columns>
                <asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="Trabajador" HeaderText="Trabajador">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>

                <asp:Templatefield HeaderText="Motivo Rechazo" ItemStyle-Wrap="False">
				     <ItemTemplate>
                      <asp:Label ID="lblMotivoRechazo" runat="server" Text = '<%# eval("Motivo_Rechazo")%>' ></asp:Label>                       
                     </ItemTemplate>
					</asp:Templatefield> 

                <asp:BoundField DataField="TIPO_RECLAMACION" HeaderText="Reclamación">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="MOTIVO_DEVOLUCION" HeaderText="Motivo Devolución">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="SALARIO" HeaderText="Salario" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="APORTE_VOLUNTARIO" HeaderText="Aporte Voluntario" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                                <asp:BoundField DataField="MONTO_DEVOLUCION" HeaderText="Monto Solicitado" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
            </Columns>
            <FooterStyle Font-Bold="True" />
        </asp:GridView>
    </div>
    <br />
    <div>
        <div class="header">
            Generados</div>
        <div>
            <asp:Label ID="lblErrMsgG" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
        </div>
        <asp:GridView ID="gvDetDevolucionesG" runat="server" AutoGenerateColumns="False"
            Width="600px" EnableViewState="False" Wrap="False" ShowFooter="True">
            <Columns>
                <asp:BoundField DataField="ID_REFERENCIA" HeaderText="Referencia">
                    <ItemStyle HorizontalAlign="center" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="Trabajador" HeaderText="Trabajador">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="TIPO_RECLAMACION" HeaderText="Reclamación">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="MOTIVO_DEVOLUCION" HeaderText="Motivo Devolución">
                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="SALARIO" HeaderText="Salario" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="MONTO_DEVOLUCION" HeaderText="Monto Devolución" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
                <asp:BoundField DataField="APORTE_VOLUNTARIO" HeaderText="Aporte Voluntario" DataFormatString="{0:n}">
                    <ItemStyle HorizontalAlign="right" Wrap="False" />
                    <FooterStyle Wrap="False" />
                    <HeaderStyle HorizontalAlign="center" Wrap="True" VerticalAlign="Bottom" />
                </asp:BoundField>
            </Columns>
            <FooterStyle Font-Bold="True" />
        </asp:GridView>
    </div>

</asp:Content>
