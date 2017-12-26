<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consAcuerdosVencidos.aspx.vb" Inherits="Legal_consAcuerdosVencidos" title="Consulta de Acuerdos de Pago Vencidos" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">


<script language="vb" runat="server">
    Private Sub Cargar_Seguridad(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Init
			
        Me.PermisoRequerido = 158
				
    End Sub
</script>

<div class="header" align="left">Consulta de Acuerdos de Pago Vencidos</div>
    <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Font-Size="11pt"
        Visible="False"></asp:Label><br />

<TABLE align="left" id="Table1">
		<TR>
			<TD>
			<asp:GridView id="gvAcuerdosVencidos" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="100%">
				<Columns>
					<asp:BoundField DataField="id_acuerdo" HeaderText="Acuerdo">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="cuota" HeaderText="Cuota">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>
					<asp:BoundField DataField="rnc_o_cedula" HeaderText="RNC">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>					
                    <asp:BoundField DataField="razon_social" HeaderText="Raz&#243;n Social">
                        <ItemStyle HorizontalAlign="Left" Wrap="False" />
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>
					<asp:TemplateField HeaderText="Tel&#233;fono1">
                        <ItemStyle HorizontalAlign="Center" Wrap="False"></ItemStyle>
                        <ItemTemplate>
                            <asp:Label id="lblTel1" runat="server" Text='<%# formateaTelefono(Eval("telefono_1")) %>' Visible="true" />
                        </ItemTemplate>
                    </asp:TemplateField> 
                    <asp:TemplateField HeaderText="Tel&#233;fono2">
                        <ItemStyle HorizontalAlign="Center" Wrap="False"></ItemStyle>
                        <ItemTemplate>
                            <asp:Label id="lblTel2" runat="server" Text='<%# formateaTelefono(Eval("telefono_2")) %>' Visible="true" />
                        </ItemTemplate>
                    </asp:TemplateField>
		           <asp:Templatefield>
				     <ItemTemplate>
                      <asp:LinkButton ID="lbtnVer" runat="server" CausesValidation="false" CommandName="Ver" CommandArgument='<%#Eval("ID_ACUERDO")%>'  Text="[Ver]"></asp:LinkButton>
                      <asp:Label id="lblcuota" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.cuota") %>' Visible="False"></asp:Label>
                      <asp:Label id="lbltipoAcuerdo" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.tipo") %>' Visible="False"></asp:Label>
                     </ItemTemplate>
					</asp:Templatefield>
					
					
				</Columns>
			</asp:GridView>
           
	       </TD>
		</TR>
	</TABLE> 


</asp:Content>

