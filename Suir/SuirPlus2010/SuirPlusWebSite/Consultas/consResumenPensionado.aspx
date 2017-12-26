<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consResumenPensionado.aspx.vb" Inherits="sys_consARS" title="Consulta de ARS" %>
<%@ Register src="../Controles/ucExportarExcel.ascx" tagname="ucExportarExcel" tagprefix="uc2" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script language="javascript" type="text/javascript">
        function checkNum(e) {
            var carCode = (window.event) ? window.event.keyCode : e.which;
            if (carCode != 8) {
                if ((carCode < 48) || (carCode > 57)) {
                    if (window.event) //IE       
                        window.event.returnValue = null;
                    else //Firefox       
                        e.preventDefault();
                }

            }
        }   
	</script>

    <img alt="Tesoreria de la Seguridad Social" src="../images/logoTSShorizontal.gif" />
    <div class="header">Consulta Resumen Dispersión de Pensionados</div>
    <div>
      
    <br />
    <fieldset style="height: 40px; width: 247px;";  >
     <table>
            <tr>
          
                <td nowrap="nowrap">
                    Período
                </td>
                <td colspan="1" nowrap="nowrap" style="width: 157px">
                    <asp:DropDownList ID="ddlPeriodos" runat="server" CssClass="dropDowns">

                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td align="center" colspan="4" nowrap="nowrap" style="height: 20px">
                     <asp:Button ID="btBuscarRef" runat="server" CssClass ="botones"  Enabled="True" EnableViewState="False"
                        Text="Buscar" />
                    &nbsp;
                    <asp:Button ID="btnLimpiar" runat="server"  CssClass="botones" Text="Limpiar" />
                </td>
            </tr>
        </table>
    </fieldset><br />

    <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false"></asp:Label>
        <br />
        <asp:Panel ID="pnlNucleo" runat="server" Visible="False">
           
            <asp:GridView ID="gvResumePensionados" runat="server" AutoGenerateColumns="False">
                        <Columns>

                            <asp:BoundField DataField="codigo_ars" HeaderText="codigo_ars" >
                                <ItemStyle Wrap="False" HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Descripcion" HeaderText="Descripcion" >
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                         <asp:BoundField DataField="Cantidad_Pensionados" HeaderText="Cantidad_Pensionados" 
                                HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Right" Wrap="False" />
                            </asp:BoundField>
                        
                            <asp:BoundField DataField="pago" HeaderText="pago" 
                                DataFormatString="{0:n}" HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                             
                        

                        </Columns>
                    </asp:GridView>
            <br />
            <uc2:ucExportarExcel ID="ucExportarExcel" runat="server" />

        </asp:Panel>
        <br />
        
    <br />
   </div>
</asp:Content>

