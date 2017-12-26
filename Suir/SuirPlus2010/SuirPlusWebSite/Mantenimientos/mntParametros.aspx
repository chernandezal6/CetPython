<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="mntParametros.aspx.vb" Inherits="Mantenimientos_mntParametros" title="Untitled Page" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
	<script language="vb" runat="server">
	    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
	        Me.PermisoRequerido = 70
			
	    End Sub
	</script>
	
    <asp:updatepanel id="updPanel" runat="server" updatemode="Conditional">
        <contenttemplate>
            <asp:Label id="lblTitulo" runat="server" CssClass="header">Tabla de Parámetros</asp:Label>
            <br />
            <br/ />
	        <asp:gridview id="dgParametros" CssClass="list" runat="server" AutoGenerateColumns="False">
		        <Columns>
			        <asp:BoundField DataField="Parametro_des" HeaderText="Descripción"></asp:BoundField>
			        <asp:BoundField DataField="Tipo_Parametro" HeaderText="Tipo Parametro"></asp:BoundField>
			        <asp:BoundField DataField="tipo_calculo" HeaderText="Tipo Calculo"></asp:BoundField>
			        <asp:BoundField DataField="Ult_Fecha_Act" HeaderText="Fecha Modificación"></asp:BoundField>
			        <asp:BoundField DataField="Ult_Usuario_Act" HeaderText="Usuario Modificó"></asp:BoundField>
			        <asp:TemplateField>
				        <ItemTemplate>
					        <asp:ImageButton id="imgBtReseteo" runat="server" BorderWidth="0px" CommandName="Detalle" ImageUrl="../images/retornar.gif"
						        ToolTip="Detalle de Parametro"></asp:ImageButton>
					        <asp:Label id="lblID" runat="server" Visible="False" Text='<%# DataBinder.Eval(Container, "DataItem.id_parametro") %>'>
					        </asp:Label>
				        </ItemTemplate>
			        </asp:TemplateField>
		        </Columns>
	        </asp:gridview>
	        <br />
	        <br />
	        <asp:Panel id="pnlAbajo" runat="server" Visible="False">
		        <asp:label id="lblSubTitulo" runat="server" CssClass="subHeader">Detalle de Parámetros</asp:label>
		        <br />
		        <asp:gridview id="dgDetalleParametros" runat="server" CssClass="list" AutoGenerateColumns="False" Visible="True">
			        <Columns>
				        <asp:BoundField DataField="Fecha_ini" HeaderText="Fecha Inicio"></asp:BoundField>
				        <asp:BoundField DataField="Fecha_Fin" HeaderText="Fecha Fin"></asp:BoundField>
				        <asp:BoundField DataField="Valor_Fecha" HeaderText="Valor Fecha"></asp:BoundField>
				        <asp:BoundField DataField="Valor_Numerico" HeaderText="Valor Numerico"></asp:BoundField>
				        <asp:BoundField DataField="Valor_Texto" HeaderText="Valor texto"></asp:BoundField>
				        <asp:BoundField DataField="Autorizado" HeaderText="Autorizado">
					        <ItemStyle HorizontalAlign="Center"></ItemStyle>
				        </asp:BoundField>
				        <asp:BoundField DataField="Ult_Fecha_Act" HeaderText="Fecha Modificaci&#243;n"></asp:BoundField>
				        <asp:BoundField DataField="Ult_Usuario_Act" HeaderText="Usuario Modificaci&#243;n"></asp:BoundField>
			        </Columns>
		        </asp:gridview>
	        </asp:Panel>    	
	    </contenttemplate>
    </asp:updatepanel>

</asp:Content>