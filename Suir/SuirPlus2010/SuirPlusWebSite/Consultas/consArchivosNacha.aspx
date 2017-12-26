<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consArchivosNacha.aspx.vb" Inherits="Consultas_consArchivosNacha" title="Archivos Nacha Recibidos " %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<script language="javascript" type="text/javascript">
   $(function() {

        // Datepicker
       $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['']));
       $(".fecha").datepicker($.datepicker.regional['es']); 

    });
</script>

    <div class = "header">Archivos Nacha Recibidos 
        <br />
        <br />
        <table cellpadding="1" cellspacing="0" class="td-content" style="width: 370px">
            <tr>
                <td align="right" style="width: 21%">
                    Fecha Inicial:
                </td>
                <td>
                    &nbsp;<asp:TextBox ID="txtDesde" runat="server" CssClass="Fecha" Width="69px"></asp:TextBox>
                   
                </td>
                <td align="right" style="width: 21%">
                    Fecha Final:</td>
                <td>
                    &nbsp;<asp:TextBox ID="txtHasta" runat="server" CssClass="Fecha"  Width="69px"></asp:TextBox>
                   
                </td>
            </tr>
            <tr>
                <td align="right" colspan="4" style="text-align: center">
                    <asp:Button ID="btnBuscar" runat="server" CausesValidation="False" Text="Buscar" />
                    <asp:Button ID="btnLimpiar" runat="server" Text="Limpiar" /></td>
            </tr>
        </table>
        <br />
        <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Size="9pt" Visible="False"></asp:Label></div>
  
                    
    <table>
    <tr>                
	    <td>
	        <table id="Table2" cellpadding="0" cellspacing="0" border="0">
        	
	            <tr>
	              <td valign="top">
	                <div id="divInfoMenor" runat="server" visible="true" style="width: 190px">
                    <fieldset>
                    <legend>Archivos Nacha Pendientes de Recoger </legend><br /> 
		                    <asp:GridView ID="gvArchivosPendientes" runat="server" 
                            AutoGenerateColumns="False" HorizontalAlign="Center">
                            <Columns>
                                <asp:BoundField DataField="NombreArchivo" HeaderText="Archivos Pendientes">
                                    <ItemStyle HorizontalAlign="Left" Wrap="False" />
                                </asp:BoundField>
                            </Columns>
                        </asp:GridView>
                            <br />
                            <div style="text-align:center">
                                <asp:Button ID="btnRecogerArchivos" runat="server" Text="Recoger Manualmente"/>
                            </div>                    
                    </fieldset>  
                    </div>   
		          </td>
		        </tr>
	        </table>
	    </td>
	    </tr>
	    <tr>	
            <td>
                <table id="Table1" cellpadding="0" cellspacing="0" border="0">
        		
		        <tr>
			        <td align="center" style="HEIGHT: 127px" valign="top">
        			
					        <asp:GridView id="gvNachas" runat="server" AutoGenerateColumns="False"
						        CssClass="list" CaptionAlign="Top" GridLines="None" BorderColor="White" CellSpacing="1" CellPadding="2">
						        <Columns>
							        <asp:BoundField DataField="NOMBRE_ARCHIVO" HeaderText="Nombre del Archivo">
                                        <HeaderStyle Wrap="False" />
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
							        <asp:BoundField DataField="HORA_RECOGIDO" HeaderText="Hora">
                                        <ItemStyle HorizontalAlign="Center" Wrap="False" />
                                    </asp:BoundField>
							        <asp:BoundField DataField="DESC_PROCESO" HeaderText="Proceso"></asp:BoundField>
							        <asp:BoundField DataField="DESC_SUBPROCESO" HeaderText="SubProceso">
                                        <ItemStyle HorizontalAlign="Left" />
                                    </asp:BoundField>
							        <asp:BoundField DataField="DESC_BANCO" HeaderText="Banco">
                                        <ItemStyle Wrap="False" />
                                    </asp:BoundField>
							        <asp:BoundField DataField="COD_ORIGEN" HeaderText="Cuenta Origen">
                                        <HeaderStyle Wrap="False" />
                                    </asp:BoundField>
							        <asp:BoundField DataField="COD_DESTINO" HeaderText="Cuenta Destino">
                                        <HeaderStyle Wrap="False" />
                                    </asp:BoundField>
							        <asp:BoundField DataField="ADD_" HeaderText="Recibido"></asp:BoundField>
							        <asp:BoundField DataField="FTP" HeaderText="Transmitido"></asp:BoundField>
							        <asp:BoundField DataField="LOAD" HeaderText="Cargado"></asp:BoundField>
							        <asp:BoundField DataField="MOVE" HeaderText="Movido"></asp:BoundField>
							        <asp:BoundField DataField="SEND" HeaderText="Enviado"></asp:BoundField>
        							
						        </Columns>
					        </asp:GridView>
        			
			        </td>

		        </tr>
	        </table>
	        </td>
	    </tr>
	</table>	
</asp:Content>

