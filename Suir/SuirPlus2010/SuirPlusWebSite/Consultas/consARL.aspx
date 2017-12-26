<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consARL.aspx.vb" Inherits="Consultas_consARL" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

<span class="header">Consulta ARL</span>
           <br/>
            <br/>
             <br/>

                <fieldset style="width: 250px; height: 100px;" id="fldPin" runat ="server" >
                 <table id="TbPINInfo" style="width: 250px;" >
                    <tr>
                        <td  style="width: 100px;">
                            Nss:
                        </td>
                        <td>
                            <asp:TextBox ID="txtNss" runat="server" Width="145px" MaxLength="10"></asp:TextBox>
                        </td>
                        </tr>
                        <tr>
                        <td>
                            RNC o Cédula:
                        </td>
                        <td>
                            <asp:TextBox ID="txtRNC" runat="server" Width="143px" 
                                MaxLength="10"></asp:TextBox>
                        </td>
                        </tr>
                      
                    <tr>
                        <td align="center" colspan="2" style="height: 37px">
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
                    </fieldset>
                    <br />
                    <br />
                    <br />

                    <div id= "divEmpleado" style="width: 800px; height: 120px;" visible="false" runat ="server">
                <fieldset style="width: 800px; height: 70px;">
                <legend style="text-align:left">Detalle de Trabajador</legend>
               
                </br>
                <asp:GridView ID="gvDetalleEmpleado" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="800px">
                    <Columns>
                   
                                <asp:BoundField DataField="id_nss" HeaderText="NSS">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                           <asp:BoundField DataField="nombres" HeaderText="Nombres" >
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                          <%-- <asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC" >
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>--%>
                        <asp:TemplateField HeaderText="RNC">
                                    <ItemTemplate>
                                        <asp:Label ID="LblRnc" runat="server" Text='<%# formateaRNC_Cedula(eval("rnc_o_cedula")) %>'></asp:Label>
                                    </ItemTemplate>
                                    <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                                    <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                </asp:TemplateField>
                        <asp:BoundField DataField="razon_social" HeaderText="Razon Social" >
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="fecha_registro" HeaderText="Fecha Registro" 
                            DataFormatString="{0:d}" HtmlEncode="False" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="fecha_ingreso" HeaderText="Fecha Ingreso" 
                            DataFormatString="{0:d}" HtmlEncode="False" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="fecha_salida" HeaderText="Fecha Salida" 
                            DataFormatString="{0:d}" HtmlEncode="False" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="fecha_ult_reintegro" HeaderText="Fecha Reintegro" 
                            DataFormatString="{0:d}" HtmlEncode="False" >
                            <ItemStyle HorizontalAlign="center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        
                    </Columns>
                </asp:GridView>
                </fieldset>
                   
                        <br />
                        <br />
                   
                 </div>
                  <br />



</asp:Content>

