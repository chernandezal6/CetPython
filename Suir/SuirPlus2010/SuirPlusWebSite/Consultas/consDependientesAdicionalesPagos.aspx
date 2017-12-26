<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDependientesAdicionalesPagos.aspx.vb" Inherits="Consultas_consDependientesAdicionalesPagos" title="Dependientes Adicionales" %>

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
    
    <script language="javascript" type="text/javascript">
        function Sel()
        {
            if ((document.aspnetForm.ctl00$MainContent$txtDocumento.value.length) !== 11)
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[1].selected = true;
            }
            else
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[0].selected = true;
            }
        }
    </script>
    
	<span class="header">Consulta de Pagos y ARS de los Dependientes Adicionales</span>
	<br />
	<br />
	
	 
  
	<table id="Table2" cellspacing="0" cellpadding="0" width="50%" border="0">
	  <tr>
		<td align="center">
 
			<table class="tblWithImagen" id="table5" width="350px" style="BORDER-COLLAPSE: collapse" 
                cellspacing="1" cellpadding="0" align="left">
				<tr>
					<td style="width: 20%" rowspan="5"><img height="90" src="../images/upcatriesgo.jpg" width="167" alt="" /></td>
				</tr>
				<tr>
					<td align="right" style="width: 20%">&nbsp;<asp:dropdownlist id="drpTipoConsulta" runat="server" CssClass="dropDowns">
							<asp:ListItem Value="C" Selected="True">Cédula</asp:ListItem>
							<asp:ListItem Value="N">NSS</asp:ListItem>
						</asp:dropdownlist>
					</td>
					<td align="left"><asp:textbox id="txtDocumento" onKeyPress="checkNum()" runat="server" MaxLength="11" OnKeyUp="Sel()" OnChange="Sel()"></asp:textbox></td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<asp:button id="btnBuscar" runat="server" Text="Buscar" Enabled="True" EnableViewState="False"></asp:button>&nbsp;
						<asp:button id="btnLimpiar" runat="server" Text="Limpiar" 
                            CausesValidation="False"></asp:button></td>
				</tr>
				<tr>
					<td align="center" colspan="2">
						<asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                            ControlToValidate="txtDocumento" Display="Dynamic" 
                            ErrorMessage="El NSS/Cédula es requerido" style="text-align: left"></asp:RequiredFieldValidator>
                    </td>
				</tr>
			</table>
				
		</td>
	</tr>
	<tr>
		<td>
		    <asp:Label ID="lblError" runat="server" CssClass="error" EnableViewState="False"></asp:Label>
		</td>
	</tr>
	<tr>
       <td>
	  <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
      <ContentTemplate>       
          <div style="FLOAT: left; width: 300px;" id="divInfo" runat="server" visible="false">
        <fieldset> 
            <legend>Información Del Ciudadano</legend><br /> 
                       
             <table cellpadding="1" cellspacing="0">
                            
                            <tr>
                                <td style="width: 84px; height: 14px;">
                                    NSS</td>
                                <td style="height: 14px">
                                    <asp:Label ID="lblNss" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>                            
      
                            <tr>
                                <td style="width: 84px">
                                    Nombres</td>
                                <td>
                                    <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 84px">
                                    Apellidos</td>
                                <td>
                                    <asp:Label ID="lblApellidos" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            <tr>
                                <td style="width: 84px">
                                    Fecha Nacimiento</td>
                                <td>
                                    <asp:Label ID="lblFechaNac" runat="server" CssClass="labelData"></asp:Label></td>
                            </tr>
                            
                            
                        </table><br />
                  
        </fieldset>
     </div> 
     </ContentTemplate> 
     </asp:UpdatePanel>       
                           
       </td> 
    </tr> 
    
    <tr>
       <td>                                   
     <asp:UpdatePanel ID="UpDetNotificaciones" runat="server" UpdateMode="Conditional">
     <ContentTemplate>  
          <asp:Panel ID="pnlDetalleNotificacionPago" runat="server" Visible="False">
                 
               <table id="Table1" cellspacing="0" cellpadding="0" border="0" width="500px">
		        <tr>
			        <td>
			        <div style="FLOAT: left; width: 300px;" id="divDetalleNotificacionPago" 
                            runat="server">
                    <fieldset><legend>Detalle de Notificaciones de Pago</legend>
                        <br />
			            <asp:gridview id="gvDetalleNotificacionPago" runat="server" CssClass="list" AutoGenerateColumns="False">
					        <Columns>
						        <asp:BoundField DataField="id_nss" HeaderText="NSS" Visible="false">
							        <ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						        </asp:BoundField>
						        <asp:BoundField DataField="periodo_factura" HeaderText="Período">
							        <ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						        </asp:BoundField>
						        <asp:BoundField DataField="id_referencia" HeaderText="NroReferencia">
							        <ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						        </asp:BoundField>
						        <asp:BoundField DataField="status" HeaderText="Status">
							        <ItemStyle Wrap="False" HorizontalAlign="Left"></ItemStyle>
						        </asp:BoundField>
						        <asp:BoundField DataField="fecha_pago" HeaderText="Fecha Pago" 
                                    DataFormatString="{0:d}">
							        <ItemStyle Wrap="False" HorizontalAlign="Left"></ItemStyle>
						        </asp:BoundField>
        						
					        </Columns>
        				
				         </asp:gridview>
                   </fieldset>
                   </div>	
			        </td>
		        </tr>
		        <tr>
		            <td>
		              <asp:Panel ID="pnlNavegacion" runat="server" Height="50px">
                    <table cellpadding="0" cellspacing="0">
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
                        <td>Total de Registros:
                            <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                        </td>
                    </tr>
                
                    </table>
                    </asp:Panel>
		            </td>
		        </tr>
	        </table>
	        
          </asp:Panel>
    </ContentTemplate> 
    </asp:UpdatePanel>
       </td> 
    </tr>
    <tr>
       <td> 
    <asp:UpdatePanel ID="UpDetCarteraDisp" runat="server" UpdateMode="Conditional">
    <ContentTemplate>  
       <asp:Panel ID="pnlDetCarteraDispersion" runat="server" Visible="False">
         
          <table id="Table3" cellspacing="0" cellpadding="0" border="0" width="500px">
		
		<tr>
			<td>
			<div style="FLOAT: left; width: 350px;" id="DetCarteraDispersion" runat="server">
            <fieldset><legend>Detalle de Cartera y Dispersión</legend>
                <br />
			    <asp:gridview id="gvDetCarteraDispersion" runat="server" CssClass="list" AutoGenerateColumns="False">
					<Columns>
						<asp:BoundField DataField="nss_dependiente" HeaderText="NSS" Visible="false">
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Periodo" HeaderText="Período">
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Fecha_Registro" HeaderText="Fecha Registro" 
                            DataFormatString="{0:d}">
							<ItemStyle Wrap="False" HorizontalAlign="Center"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Dispersada" HeaderText="Dispersada">
							<ItemStyle Wrap="False" HorizontalAlign="Left"></ItemStyle>
						</asp:BoundField>
						<asp:BoundField DataField="Fecha_Dispersion" HeaderText="Fecha Dispersión" 
                            DataFormatString="{0:d}">
							<ItemStyle Wrap="False" HorizontalAlign="Left"></ItemStyle>
						</asp:BoundField>
						
					</Columns>
				</asp:gridview>
		   </fieldset>
           </div>
			</td>
		</tr>
		<tr>
		    <td>
		        <asp:Panel ID="pnlNavegacion2" runat="server" Height="50px">
            <table cellpadding="0" cellspacing="0">
            <tr>
                <td style="height: 24px">
                    <asp:LinkButton ID="btnLnkFirstPage2" runat="server" CommandName="First2" CssClass="linkPaginacion"
                        OnCommand="NavigationLink2_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkPreviousPage2" runat="server" CommandName="Prev2" CssClass="linkPaginacion"
                        OnCommand="NavigationLink2_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                    [<asp:Label ID="lblCurrentPage2" runat="server"></asp:Label>] de
                    <asp:Label ID="lblTotalPages2" runat="server"></asp:Label>&nbsp;
                    <asp:LinkButton ID="btnLnkNextPage2" runat="server" CommandName="Next2" CssClass="linkPaginacion"
                        OnCommand="NavigationLink2_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                    <asp:LinkButton ID="btnLnkLastPage2" runat="server" CommandName="Last2" CssClass="linkPaginacion"
                        OnCommand="NavigationLink2_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                    <asp:Label ID="lblPageSize2" runat="server" Visible="False"></asp:Label>
                    <asp:Label ID="lblPageNum2" runat="server" Visible="False"></asp:Label>
                </td>
            </tr>
            <tr>
                <td>Total de Registros:
                    <asp:Label ID="lblTotalRegistros2" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
            </table>
            </asp:Panel>
		    </td>
		</tr>
	</table>
                  
       </asp:Panel>
    </ContentTemplate> 
    </asp:UpdatePanel>
		    </td>
		</tr>
	</table>

    
     
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
</asp:UpdateProgress>  
	
    
</asp:Content>

