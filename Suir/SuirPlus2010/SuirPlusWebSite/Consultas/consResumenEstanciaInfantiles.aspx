<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consResumenEstanciaInfantiles.aspx.vb" Inherits="sys_consARS" title="Consulta de ARS" %>
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
    <div class="header">Consulta Resumen Dispersión de Estancias Infantiles</div>
    <div>
      
    <br />
    <fieldset style="height: 40px; width: 247px;";  >
     <table>
           <tr>
                <td align="right">
                    Período
                </td>
                <td colspan="1" style="width: 158px">
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
           
            <asp:GridView ID="gvResumeEstanciasInf" runat="server" AutoGenerateColumns="False">
                        <Columns>

                            <asp:BoundField DataField="ID_ESTANCIA" HeaderText="Id Estancia" >
                                <ItemStyle Wrap="False" HorizontalAlign="center" />
                            </asp:BoundField>
                            <asp:BoundField DataField="Estancia_Infantil" HeaderText=" Estancia Infantil" >
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                            
                         <asp:BoundField DataField="titulares" HeaderText="Titulares" 
                                HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="center" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="dependientes" HeaderText="Dependientes" >
                                <ItemStyle Wrap="False" HorizontalAlign="center" />
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

