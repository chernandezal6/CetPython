<%@ Page Title="Concentración de Aportes" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConcentracionFondos.aspx.vb" Inherits="Finanzas_ConcentracionFondos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">Reporte Concentración de Aportes</div>
    <br />
   
     <fieldset id="fsInfoConcentracion" style="width: 600px" visible="false" runat="server">
     <legend>Concentración de Aportes</legend><br />
      <table>
         <tr>
             <td>
             Nombre Archivo:
             </td>
             <td>
                 <asp:Label ID="lblArchivo" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Proceso:
             </td>
             <td>
             <asp:Label ID="lblProceso" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Sub_Proceso:
             </td>
             <td>
             <asp:Label ID="lblSubProceso" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         
         <tr>
             <td>
             Fecha Transacción:
             </td>
             <td>
                 <asp:Label ID="lblFechaTransaccion" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Entidad Receptora:
             </td>
             <td>
             <asp:Label ID="lblEntidadReceptora" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Nro. Lote:
             </td>
             <td>
             <asp:Label ID="lblLote" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Total Registros:
             </td>
             <td>
             <asp:Label ID="lblTotalRegistros" runat="server" CssClass="labelData" ></asp:Label>
             </td>
         </tr> 
                  <tr>
             <td>
             Total a Liquidar Sin Ajuste:
             </td>
             <td>
                 <asp:Label ID="lblTotalSinAjuste" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Monto Aclarado:
             </td>
             <td>
             <asp:Label ID="lblMontoAclarado" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Total Ajuste:
             </td>
             <td>
             <asp:Label ID="lblTotalAjuste" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Total a Liquidar:
             </td>
             <td>
             <asp:Label ID="lblTotalLiquidar" runat="server" CssClass="labelData" ></asp:Label>
             </td>
         </tr>       
     </table>    
     
     </fieldset>

            <table>
            <tr>
                <td>
            
            <div>
                <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
                <br />
            </div>            
            <asp:GridView ID="gvConcentracion" runat="server" AutoGenerateColumns="False" Width="600px" EnableViewState="False" Wrap="False">
                  <Columns>
                  
                      <asp:BoundField DataField="FECHA_SOLICITUD" HeaderText="Fecha Solicitud" 
                          DataFormatString="{0:d}" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="center" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField> 

                      <asp:BoundField DataField="TIPO_INSTRUCCION" HeaderText="Tipo Instrucción">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>  

                     <asp:BoundField DataField="MONTO_INSTRUCCION" HeaderText="Importe Instrucción" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="right" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="right" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>
                      
                      <asp:BoundField DataField="CUENTA_ORIGEN" HeaderText="Cuenta Origen" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>   
                      <asp:BoundField DataField="CUENTA_DESTINO" HeaderText="Cuenta Destino" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>                       
                     
                     <asp:BoundField DataField="ENTIDAD_ORIGEN" HeaderText="Entidad Origen">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField> 
                      
                    <asp:BoundField DataField="ENTIDAD_DESTINO" HeaderText="Entidad Destino">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>                       
                                                                                                                                                                            
                  </Columns>
              </asp:GridView>
            <br />
                </td>
            </tr>
            </table>
                    <img src="../images/detalle.gif" alt="" />
                    <asp:LinkButton ID="lnkEncabezado"  runat="server" 
                    Font-Size="Smaller">volver al encabezado</asp:LinkButton>
        
            <br />
</asp:Content>

