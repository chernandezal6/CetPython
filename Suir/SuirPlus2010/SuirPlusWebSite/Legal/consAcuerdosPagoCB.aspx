<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consAcuerdosPagoCB.aspx.vb" Inherits="Legal_consAcuerdosPagoCB" title="Consulta de Acuerdos de Pago - Cobros" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
		        Me.PermisoRequerido = 158
				
			End Sub
		</script>
<div class="header" align="left"> Acuerdos de Pago procesados</div>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Font-Size="11pt"
        Visible="False"></asp:Label><br />

<TABLE align="left" id="Table1" width="650">
		<TR>
			<TD>
			<asp:GridView id="gvAcuerdosPago" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="100%">
				<Columns>
					<asp:BoundField DataField="id_acuerdo" HeaderText="Nro">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
                    <asp:BoundField DataField="descripcion" HeaderText="Tipo Acuerdo" />
					
					<asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
										
                    <asp:BoundField DataField="razon_social" HeaderText="Raz&#243;n Social">
                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
					<asp:BoundField DataField="Fecha_Registro" HeaderText="Registro" DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>

		           <asp:Templatefield>
				     <ItemTemplate>
                      <asp:LinkButton ID="lbtnVer" runat="server" CausesValidation="false" CommandName="Ver" CommandArgument='<%#Eval("ID_ACUERDO") & "|" & Eval("Tipo") %>'  Text="[Ver]"></asp:LinkButton>
                     </ItemTemplate>
					</asp:Templatefield>
				</Columns>
			</asp:GridView>
           
	       </TD>
		</TR>
	</TABLE> 
</asp:Content>

