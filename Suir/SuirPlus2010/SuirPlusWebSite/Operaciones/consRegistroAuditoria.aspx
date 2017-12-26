<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consRegistroAuditoria.aspx.vb" Inherits="Operaciones_consRegistroAuditoria" title="Registro de Auditoría" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    
    
    <script language="javascript" type="text/javascript">
	function checkNum()
	    {
            var carCode = event.keyCode;
            if ((carCode < 48) || (carCode > 57))
                {
                    event.cancelBubble = true	
                    event.returnValue = false;	
                 }
         }
    </script> 
    <fieldset style="width: 600px; margin-left: 60px">
                <legend class="header" style="font-size: 14px">Registro de Auditoría</legend>
        
    <table border="0" cellpadding="0" cellspacing="0" class="td-content" style="width: 250px">
    <tr>
            <td colspan="2">
                  <asp:Label ID="lblMsg" runat="server" CssClass="error" Visible="False"></asp:Label>  
            </td>
        </tr>
        <tr>
            <td style="width: 81px; height: 19px; text-align: right;">
                <br />
                RNC/Cédula:</td>
            <td style="height: 19px">
                <br />
                
                <asp:TextBox onKeyPress="checkNum()"  id="txtRNC" runat="server" MaxLength="11" Width="95px"></asp:TextBox>

                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ControlToValidate="txtRNC"
                    Display="Dynamic" ErrorMessage="Requerido"></asp:RequiredFieldValidator></td>
                    
        </tr>
        <tr>
            <td colspan="2" align="center">
                <br />
                <asp:Button ID="btnAceptar" runat="server" Text="Aceptar" />&nbsp;
                <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" /><br />
                <br />
            </td>
        </tr>
    </table>
    <br />
    <asp:Panel ID="pnlDetalle" runat="server" Visible="false">
    <table border="0" cellpadding="0" cellspacing="0" class="td-content" width="100%">
            <tr>
                <td>
                    <asp:GridView ID="gvDetalle" runat="server" AutoGenerateColumns="False" CellPadding="3">
                        <Columns>
                            <asp:BoundField DataField="DESCRIPCION" HeaderText="Tipo">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="FECHA_REGISTRO" HeaderText="Fecha/Hora">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="IP_PC" HeaderText="IP">
                                <HeaderStyle HorizontalAlign="Center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="NOMBRE_PC" HeaderText="Nombre PC">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:BoundField>
                            <asp:BoundField DataField="USUARIO_REP" HeaderText="Representante">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="USUARIO_CAE" HeaderText="Usuario">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle Wrap="False" />
                            </asp:BoundField>                            
                            
                        </Columns>
                    </asp:GridView>
                </td>
          </tr>           
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
            <td style="height: 12px">
                Total Registros:
                <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
            </td>
        </tr>
     </table>
    </asp:Panel>
    </fieldset>
</asp:Content>

