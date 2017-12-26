<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consCiudadano.aspx.vb" Inherits="Consultas_consCiudadano" title="Consulta de Ciudadanos" %>
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
    <div class="header">
        Consulta de Ciudadanos<br /> 
        <br />
            </div>
        
    <asp:UpdatePanel ID="udpBuscar" runat="server" UpdateMode="Conditional">
        <ContentTemplate>
            <table cellpadding="1" cellspacing="0" class="td-content" style="width: 400px">
        <tr>
            <td style="width: 25%; height:5px;"></td>
            <td></td>
        </tr>

        <tr>
            <td align="right">
                NSS:</td>
            <td>
                <asp:TextBox ID="txtNSS" onKeyPress="checkNum()" runat="server" MaxLength="9" EnableViewState="False"></asp:TextBox>
                </td>
        </tr>
        
            <tr>
            <td align="right">Nro. Documento:</td>
            <td><asp:TextBox ID="txtDocumento"  onKeyPress="checkNum()" runat="server" MaxLength="25" EnableViewState="False" /></td>                          
        </tr>    
        
        
        <tr>
            <td align="right">
                Nombres:</td>
            <td>
                <asp:TextBox ID="txtNombres" runat="server" Width="206px" MaxLength="50" EnableViewState="False"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right">Primer Apellido:</td>
            <td>
                <asp:TextBox ID="txtPrimerApellido" runat="server" MaxLength="15" EnableViewState="False"></asp:TextBox></td>            
        </tr>
        <tr>
            <td align="right">
                Segundo Apellido:</td>
            <td>
                <asp:TextBox ID="txtSegundoApellido" runat="server" MaxLength="15" EnableViewState="False"></asp:TextBox></td>
        </tr>
        <tr>
            <td align="right">
            </td>
            <td>
                <asp:Button ID="btnBuscar" runat="server" Text="Buscar" ValidationGroup="Ciudadano" />
                <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" CausesValidation="False" /></td>
        </tr>
        <tr>
            <td style="height: 5px;" align="center" colspan="2"></td>
        </tr>
    </table>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" EnableViewState="False"></asp:Label><br />
            <br />
              <asp:GridView ID="gvCiuidadanos" runat="server" AutoGenerateColumns="False" 
                Width="600px" EnableViewState="False" Wrap="False" CellPadding="4" 
                CellSpacing="4">
                  <Columns>
                      <asp:BoundField DataField="id_nss" HeaderText="NSS">
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="tipo_documento" HeaderText="Tipo Doc.">
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="no_documento" HeaderText="Documento" ItemStyle-Wrap="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" />
                      </asp:BoundField>
                      <asp:BoundField DataField="nombres" HeaderText="Nombres" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>
                      <asp:BoundField DataField="apellidos" HeaderText="Apellidos" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>
                      <asp:BoundField DataField="fecha_nacimiento" DataFormatString="{0:d}" 
                          HeaderText="Fecha Nacimiento" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                                                             
                       
                      <asp:TemplateField HeaderText="Info Menor">
                          <FooterStyle Wrap="False" />
                          <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                        <ItemTemplate>                        
                        <asp:HyperLink runat="server" NavigateUrl=' <%# "~/consultas/consmenores.aspx?NSS=" & eval("id_nss")& "&NoDoc=" & eval("no_documento") %>'>[Ver Más]</asp:HyperLink>
                        </ItemTemplate>
                      </asp:TemplateField>  
                      
                      <asp:BoundField DataField="esmadre" HeaderText="Es Madre" Visible="False">
                      <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" />
                      </asp:BoundField> 
                      
                    <asp:TemplateField HeaderText="Info Maternidad">
                        <FooterStyle Wrap="False" />
                        <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>      
                        <asp:Label id="lblEsMadre" runat="server" Text='<%# Eval("esmadre") %>' Visible="False"></asp:Label>                                          
                        <asp:HyperLink ID="HyperLink1" runat="server" NavigateUrl=' <%# "~/consultas/consmaternidad.aspx?NSS=" & eval("id_nss")& "&NoDoc=" & eval("no_documento") %>'>[Ver Más]</asp:HyperLink>
                        </ItemTemplate>
                      </asp:TemplateField>                       
                      
                        <asp:TemplateField HeaderText="Acta Nacimiento">
                        <FooterStyle Wrap="False" />
                        <HeaderStyle Wrap="False" />
                        <ItemStyle HorizontalAlign="Center" />
                        <ItemTemplate>      
                            <asp:HyperLink ID="hplinkImagen" runat="server" Target="_blank" NavigateUrl='<%# "VerActaNacimiento.aspx?idNss=" & container.dataitem("id_nss") %>'> [Ver Acta]</asp:HyperLink>
                        
                        </ItemTemplate>
                      </asp:TemplateField>
                        <asp:BoundField DataField="Tipo_Causa" HeaderText="Motivo" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>  
                      <asp:BoundField DataField="Id_Causa_Inhabilidad" HeaderText="Causa" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>
                    
                      
                  </Columns>
              </asp:GridView>
                                    <!--
                      
                      -->    
            <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
            <table cellpadding="0" cellspacing="0" width="550px">
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
                <td><br />
                    Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
            </table>
            </asp:Panel>
            <br />
        
        </ContentTemplate>
    </asp:UpdatePanel>
    &nbsp; &nbsp;&nbsp;

        
  <asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>  

</asp:Content>

