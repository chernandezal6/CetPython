<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consResumenDispersionARS.aspx.vb" Inherits="sys_consARS" title="Consulta de ARS" %>
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
    <div class="header">Consulta Resumen De Conciliación Dispersión ARS</div>
    <div>
      
    <br />
    <fieldset style="height: 100px; width: 350px;">
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
                <tr><td></td></tr>
                <tr>
                <td>
                    Tipo Dispersión
                </td>
                <td>
                    <asp:DropDownList ID="ddlTipo" runat="server" CssClass="dropDowns">
                        <asp:ListItem Value="0">Seleccionar</asp:ListItem>
                        <asp:ListItem Value="1">Dispersión ARS</asp:ListItem>
                        <asp:ListItem Value="2">Dispersión Fonamat</asp:ListItem>
                    </asp:DropDownList>
                </td>
                </tr>
                <tr><td></td></tr>
                 <tr>
                <td>
                    Ciclo Dispersión
                </td>
                  <td>
                    <asp:DropDownList ID="ddlresumen" runat="server" CssClass="dropDowns">
                        <asp:ListItem Value="0">Seleccionar</asp:ListItem>
                        <asp:ListItem Value="1"> 1ra Dispersion </asp:ListItem>
                        <asp:ListItem Value="2"> 2da Dispersion </asp:ListItem>
                        <asp:ListItem Value="3">Consolidado</asp:ListItem>
                    </asp:DropDownList>
                </td>
                  </tr>
                  <tr><td></td></tr>
             <tr>
                 <td align="center" colspan="4">
                    <asp:Button ID="btBuscarRef" runat="server" Enabled="True" EnableViewState="False"
                        Text="Buscar" />
                    &nbsp;
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" />
                </td>
            </tr>
        </table>
    </fieldset><br />

    <asp:Label ID="lbl_error" runat="server" CssClass="error" Visible="false"></asp:Label>
        <br />
        <asp:Panel ID="pnlNucleo" runat="server" Visible="False">
           
            <asp:GridView ID="gvResumeCartera" runat="server" AutoGenerateColumns="False">
                        <Columns>

                            <asp:BoundField DataField="ID" HeaderText="ID" >
                                <ItemStyle Wrap="False" HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ARS" HeaderText="ARS" >
                                <HeaderStyle HorizontalAlign="Center" />
                                <ItemStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                                <asp:BoundField DataField="titulares" HeaderText="Titulares" 
                                DataFormatString="{0:##,###}" >
                            <ItemStyle Wrap="False" HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="dependientes" HeaderText="Dependientes" 
                                DataFormatString="{0:##,###}" >
                            <ItemStyle Wrap="False" HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="adicionales" HeaderText="Adicionales" 
                                DataFormatString="{0:##,###}">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Right" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="monto_titulares" HeaderText="Monto Titulares" 
                                DataFormatString="{0:n}" HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                             
                             <asp:BoundField DataField="monto_dependientes" HeaderText="Monto Dependientes" 
                                DataFormatString="{0:n}" HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Right" Wrap="False" />
                            </asp:BoundField>
                             
                             <asp:BoundField DataField="monto_adicionales" HeaderText="Monto Adicionales" 
                                DataFormatString="{0:n}" HtmlEncode="False">
                                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                <ItemStyle HorizontalAlign="Right" />
                            </asp:BoundField>
                            <asp:BoundField DataField="pago" HeaderText="Pago" DataFormatString="{0:n}" 
                                HtmlEncode="False">
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

