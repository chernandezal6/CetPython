<%@ Page Title="Certificaciones Pendientes" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="verCertificacionAutorizar.aspx.vb" Inherits="Certificaciones_verCertificacionAutorizar" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

		<script language="vb" runat="server">
			Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
		        Me.PermisoRequerido = 156
				
			End Sub
		</script>
<div class="header" align="left"> Certificaciones Pendientes de Verificación</div>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Font-Size="9pt"
        Visible="False"></asp:Label><br /><br />

<table>
<tr>
<td>

    <asp:GridView id="gvCertificacionesAutorizar" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="100%">
				<Columns>
					<asp:BoundField DataField="id_certificacion" HeaderText="Certificación">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
                    <asp:BoundField DataField="Tipo" HeaderText="Tipo" />
                    
					<asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>					
                    <asp:BoundField DataField="razon_social" HeaderText="Raz&#243;n Social">
                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
					<asp:BoundField DataField="ID_NSS" HeaderText="NSS">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>					
                    <asp:BoundField DataField="NOMBRE" HeaderText="Nombre">
                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
                    
					<asp:BoundField DataField="Fecha" HeaderText="Registro" DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField>
                    
                    <asp:BoundField DataField="USUARIO" HeaderText="Creada Por">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
                    
		           <asp:Templatefield>
				     <ItemTemplate>
                      <asp:LinkButton ID="lbtnVer" runat="server" CausesValidation="false" CommandName="Ver" CommandArgument='<%#Eval("ID_CERTIFICACION") & "|" &eval("Tipo")%>'   Text="[Ver]"></asp:LinkButton>
                     </ItemTemplate>
					</asp:Templatefield>
				</Columns>
			</asp:GridView>
</td>
</tr>
</table>

</asp:Content>

