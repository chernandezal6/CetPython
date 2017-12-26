<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="insertupdateParametros.aspx.vb" Inherits="Mantenimientos_insertupdateParametros" title="Mantenimientos de parametros" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <script type="text/javascript">
     $(function () {
            // Datepicker
            //$.datepicker.setDefaults($.extend({ showMonthAfterYear: true }, $.datepicker.regional['ES']));
            $("#ctl00_MainContent_txtFechaIni").datepicker($.datepicker.regional['es']);
            $("#ctl00_MainContent_txtFechaFin").datepicker($.datepicker.regional['es']);
            $("#ctl00_MainContent_txtValorFecha").datepicker($.datepicker.regional['es']);
            //$(".Fecha").datepicker($.datepicker.regional['es']);

      });
    </script>   
    <style>
        .succes {
            color: #0F00F3;
            font-weight: bold;
            font-size: x-small;
            font-family: Verdana, Tahoma, Arial;
        }
        .CamposFecha {
            padding: 5px;
            text-align: center;
        }
        .CamposDinero {
            padding: 5px;
            text-align: right;
        }
    </style>     
    
	<script language="vb" runat="server">
		Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
			Me.PermisoRequerido = 124
			
	    End Sub
	   
	  
	</script>

<%--    <asp:updatepanel id="updTabla" runat="server" UpdateMode="Conditional">
        <contenttemplate>--%>
           <span class="header">Mantenimiento de parámetros</span><br /><br />
           <table class="td-content" id="table1" cellspacing="0" cellpadding="2" width="29%" border="0">
		        <tr>
			        <td align="right" style="width: 22%">Parametro</td>
			        <td colspan="2">
			            <asp:dropdownlist id="drpParametro" runat="server" cssclass="dropDowns" AutoPostBack="True"></asp:dropdownlist>
			        </td>
		        </tr>
		        <tr>
			        <td align="right" style="width: 22%">Descripción</td>
			        <td colspan="2"><asp:textbox id="txtDescripcion" runat="server" MaxLength="100" Width="98%"></asp:textbox></td>
		        </tr>
		        <tr>
			        <td align="right" style="width: 22%">Tipo Parámetro</td>
			        <td>
			            <asp:dropdownlist id="drpTipoParam" runat="server" cssclass="dropDowns">
					        <asp:ListItem Value="N" Selected="True">Numero</asp:ListItem>
					        <asp:ListItem Value="F">Fecha</asp:ListItem>
					        <asp:ListItem Value="T">Texto</asp:ListItem>
				        </asp:dropdownlist>
				    </td>
			        <td align="right">Tipo calculo&nbsp;
			            <asp:textbox id="txtTipoCalculo" runat="server" MaxLength="1"></asp:textbox>
			        </td>				    
		        </tr>
		        <tr>
			        <td colspan="3"></td>
		        </tr>
		        <tr>
			        <td colspan="3" align="right">
			            <asp:button id="btnGrabar" runat="server" Text="Grabar" CausesValidation="False" onclick="btnGrabar_Click"></asp:button>&nbsp;
				        <asp:button id="btnCancelar" runat="server" Text="Limpiar" CausesValidation="False" onclick="btnLimpiar_Click"></asp:button>
			        </td>
		        </tr>
	        </table>
        	
	        <asp:label id="lblError" runat="server" cssclass="error" font-size="Small"></asp:label><br>
	        <table class="td-content" id="table2" cellspacing="0" cellpadding="2" width="31%" border="0">
		        <tr>
			        <td align="right" style="width: 15%">Fecha inicio</td>
			        <td>
			            <asp:textbox id="txtFechaIni" runat="server" Width="88px" CssClass="Fecha"></asp:textbox>
                    </td>
			        <td align="right" style="width: 20%">Fecha fin</td>
			        <td>
			            <asp:textbox id="txtFechaFin" runat="server" Width="88px"></asp:textbox>&nbsp;
                      
                    </td>
		        </tr>
		        <tr>
			        <td align="right" style="width: 15%">Valor fecha</td>
			        <td>
			            <asp:textbox id="txtValorFecha" runat="server" MaxLength="10" Width="88px"></asp:textbox>&nbsp;
			            
                    </td>
			        <td align="right" style="width: 20%">Valor númerico</td>
			        <td><asp:textbox id="txtValorNum" runat="server" MaxLength="10" Width="88px"></asp:textbox></td>
		        </tr>
		        <tr>
			        <td align="right" style="width: 15%">Valor texto</td>
			        <td><asp:textbox id="txtValorTex" runat="server" MaxLength="50" Width="88px"></asp:textbox></td>
			        <td align="right" style="width: 20%">Autorizado</td>
			        <td><asp:dropdownlist id="drpAutorizado" runat="server" cssclass="dropDowns">
					        <asp:ListItem Value="S">Si</asp:ListItem>
					        <asp:ListItem Value="N">No</asp:ListItem>
				        </asp:dropdownlist>
				    </td>
		        </tr>
		        <tr>
			        <td align="right" colspan="4">
			            <asp:button id="btnGrabarDetalle" runat="server" Text="Grabar" Enabled="False"></asp:button>&nbsp;
			            <asp:button id="btnLimpiar" text="Limpiar" runat="server" onclick="btnLimpiar_Click" />&nbsp;
			        </td>
		        </tr>
	        </table>	    
	        <br />
	        <asp:gridview id="dgDetalleParametros" runat="server" CssClass="table table-bordered" Visible="False" AutoGenerateColumns="False" onrowcommand="dgDetalleParametros_RowCommand">
		        <Columns>
			        <asp:BoundField DataField="Fecha_ini" HeaderText="Fecha Inicio" dataformatstring="{0:d}">
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:BoundField DataField="Fecha_Fin" HeaderText="Fecha Fin" dataformatstring="{0:d}">
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:BoundField DataField="Valor_Fecha" HeaderText="Valor Fecha" dataformatstring="{0:d}">
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:BoundField DataField="Valor_Numerico" HeaderText="Valor Numerico">
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:BoundField DataField="Valor_Texto" HeaderText="Valor texto">
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:BoundField DataField="Autorizado" HeaderText="Autorizado">
				        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:BoundField DataField="Ult_Fecha_Act" HeaderText="Fecha Modificaci&#243;n">
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:BoundField DataField="Ult_Usuario_Act" HeaderText="Usuario Modificaci&#243;n">
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:BoundField>
			        <asp:TemplateField HeaderText="Editar">
				        <ItemTemplate>
					        <asp:ImageButton id="imgBtReseteo" runat="server" BorderWidth="0px" CausesValidation="False"
						        ImageUrl="../images/editar.gif" ToolTip="Editar detalle del parametro"></asp:ImageButton>
					        <asp:Label id="lblIDParametro" runat="server" Visible="False" Text='<%# DataBinder.Eval(Container, "DataItem.id_parametro") %>' />
					        <asp:Label ID="lblFechaInicio" Runat="server" Visible="False" Text='<%# DataBinder.Eval(Container, "DataItem.fecha_ini") %>' />
				        </ItemTemplate>
                        <ItemStyle CssClass="CamposFecha" />
			        </asp:TemplateField>
		        </Columns>
	        </asp:gridview>
<%--	    </contenttemplate>
	    <triggers>
	        <asp:asyncpostbacktrigger controlid="btnGrabarDetalle" eventname="Click" />
	    </triggers>
    </asp:updatepanel>--%>
	
</asp:Content>