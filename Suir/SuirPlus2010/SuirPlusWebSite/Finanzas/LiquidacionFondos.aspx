<%@ Page Title="Liquidación de Aportes" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="LiquidacionFondos.aspx.vb" Inherits="Finanzas_LiquidacionFondos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <div class="header">Reporte Liquidación de Aportes</div>
    <br />
   
     <fieldset id="fsInfoLiquidacion" style="width: 600px" visible="false" runat="server">
     <legend>Liquidación de Aportes</legend><br />
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
             TRN:
             </td>
             <td>
             <asp:Label ID="lblTRN" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Tipo:
             </td>
             <td>
             <asp:Label ID="lblTipo" runat="server" CssClass="labelData" ></asp:Label>
             </td>
         </tr>   
                  <tr>
             <td>
             Fecha Generación:
             </td>
             <td>
                 <asp:Label ID="lblFechaGeneracion" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Hora Generación:
             </td>
             <td>
             <asp:Label ID="lblHoraGeneracion" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Lote:
             </td>
             <td>
             <asp:Label ID="lblLote" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Concepto Pago:
             </td>
             <td>
             <asp:Label ID="lblConceptoPago" runat="server" CssClass="labelData" ></asp:Label>
             </td>
         </tr> 
                  <tr>
             <td>
             Código BIC Entidad Debitada:
             </td>
             <td>
                 <asp:Label ID="lblCodigoBicDeb" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Código BIC Entidad Acreditada:
             </td>
             <td>
             <asp:Label ID="lblCodigoBicAcr" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Fecha Operación Del Crédito:
             </td>
             <td>
             <asp:Label ID="lblFechaOperacion" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Registros(Control):
             </td>
             <td>
             <asp:Label ID="lblRegistros" runat="server" CssClass="labelData" ></asp:Label>
             </td>
         </tr> 
         
         <tr>
             <td>
             Total(Control):
             </td>
             <td>
             <asp:Label ID="lblTotal" runat="server" CssClass="labelData"></asp:Label>
             </td>
         </tr>
         <tr>
             <td>
             Moneda:
             </td>
             <td>
             <asp:Label ID="lblMoneda" runat="server" CssClass="labelData" ></asp:Label>
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
            <asp:GridView ID="gvLiquidacion" runat="server" AutoGenerateColumns="False" Width="600px" EnableViewState="False">
                  <Columns>
                  
                     <asp:BoundField DataField="NOMBREBENEFICIARIO" HeaderText="Nombre Beneficiario">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>                   
                  
                      <asp:BoundField DataField="IDBENEFICIARIO" HeaderText="Id Beneficiario">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>  

                     <asp:BoundField DataField="MONTO" HeaderText="Monto" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="right" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="right" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>
                      
                      <asp:BoundField DataField="CUENTAESTANDARIZADO" HeaderText="Cuenta Estandarizado" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>   
                      <asp:BoundField DataField="TIPOCUENTA" HeaderText="Tipo Cuenta" 
                          DataFormatString="{0:n}">
                          <ItemStyle HorizontalAlign="left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>                         
                    <asp:BoundField DataField="CONCEPTO" HeaderText="Concepto">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>     
                      
                    <asp:BoundField DataField="INFOADICIONAL1" HeaderText="Info Adicional 1">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>    
                      
                    <asp:BoundField DataField="INFOADICIONAL2" HeaderText="Info Adicional 2">
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="left" Wrap="false" VerticalAlign="Bottom" />
                      </asp:BoundField>                                                             
                    <asp:BoundField DataField="DIGITOSCONTROL" HeaderText="Digitos Control">
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

