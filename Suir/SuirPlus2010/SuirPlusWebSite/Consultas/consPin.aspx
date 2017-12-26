<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consPin.aspx.vb" Inherits="Consultas_consPin" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
 <span class="header">Consulta de Pin</span>
           <br/>
            <br/>
             <br/>

      <%--<asp:Label ID="Lblmsjerror"runat="server" CssClass="error" EnableViewState="False" Visible="False"></asp:Label>
     --%> <asp:Label ID="Lblmsjerror" runat="server" CssClass="error" 
        EnableViewState="False" Visible="False" ></asp:Label>
      
      
        <%--  <div style="float: left; width: auto;" id="div1" runat="server" visible="true">
        --%>        
       <br/>
            
                &nbsp;       
      
                <fieldset style="width: 220px; height: 100px;" id="fldPin" runat ="server" >
                 <table id="TbPINInfo"  >
                    <tr>
                        <td>
                            Recibo:
                        </td>
                        <td>
                            <asp:TextBox ID="txtNroRecibo" runat="server" Width="90px" MaxLength="10"></asp:TextBox>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            Código Aprobación:
                        </td>
                        <td>
                            <asp:TextBox ID="txtCodigoAprobacion" runat="server" Width="90px" MaxLength="10"></asp:TextBox>
                        </td>
                        </tr>
                       <tr>

                        <td>
                            Representación Local:
                        </td>
                        <td>
                            <asp:DropDownList ID="ddlRepresentacionLocal" runat="server" CssClass="dropDowns" Width="90px">
                            </asp:DropDownList>
                        </td>
                        
                    </tr>
                    <tr>
                        <td align="center" colspan="2">
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
                    </fieldset><br />
<%--  </div>--%>

                  </br>
                 
                
                <div  id= "divInfoPin" style="width: 350px; height: 120px;" visible="false" runat ="server">
                 <fieldset style="width: 350px; height: 120px;">
                 <br/>
                    <table cellpadding="3" cellspacing="0" id="tblInfoPin" width="350px" runat="server" visible="false">
        <tr>
            <td align="right" style="text-align: center" colspan="2" >
                <asp:Label ID="Label3" runat="server" CssClass="subHeader" Text="Datos Generales:"></asp:Label>
               </td>
        </tr>
         <tr>
            <td align="right">
                    <asp:Label ID="LbltxtMonto" runat="server" Text="Monto:" Visible="true"></asp:Label></td>
            <td>
                <asp:Label ID="LblMonto" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
         <tr>
            <td align="right">
                    <asp:Label ID="LbltxtBalance" runat="server" Text="Balance:" Visible="true"></asp:Label></td>
            <td>
                <asp:Label ID="LblBalance" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                    <asp:Label ID="lbltxtRazonSocial" runat="server" Text="Razón Social:" Visible="true"></asp:Label></td>
            <td>
                <asp:Label ID="lblRazonSocial" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                    <asp:Label ID="lbltxtStatus" runat="server" Text="Estatus Pin:" Visible="true"></asp:Label></td>
            <td>
                <asp:Label ID="lblStatusPin" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                    <asp:Label ID="lbltxtFecha" runat="server" Text="Fecha Venta:" Visible="true"></asp:Label></td>
            <td>
                <asp:Label ID="lblFecha" runat="server" Font-Bold="True"></asp:Label></td>
        </tr>
         <tr>
         <td></td>
         </tr>
          <tr>
         <td></td>
         </tr>
          </table>
          </fieldset>
          </div>
      
        </br>
         </br>
          </br>
                <div id= "divHistorialPin" style="width: 350px; height: 120px;" visible="false" runat ="server">
                <fieldset style="width: 350px; height: 100px;">
                <legend style="text-align:left">Historial</legend>
               
                </br>
                <asp:GridView ID="gvHistorial" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="350px">
                    <Columns>
                       
                      <asp:TemplateField HeaderText="Nro Referencia">
                                    <ItemTemplate>
                                        <asp:Label ID="LblReferencia" runat="server" Text='<%# FormateaReferencia(eval("id_referencia")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                                
                        <asp:BoundField DataField="fecha_aplicacion" HeaderText="Fecha Aplicacion" 
                            DataFormatString="{0:d}" HtmlEncode="False" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                          <asp:BoundField DataField="monto_ajuste" HeaderText="Monto" >
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                       <asp:TemplateField HeaderText="Periodo">
                                    <ItemTemplate>
                                        <asp:Label ID="LblReferencia" runat="server" Text='<%# FormateaPeriodo(eval("periodo_aplicacion")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                      
                    </Columns>
                </asp:GridView>
                </fieldset>
                   
                 </div>
                  <br />
                    <br />
                    <br />
                    <br />
</asp:Content>

