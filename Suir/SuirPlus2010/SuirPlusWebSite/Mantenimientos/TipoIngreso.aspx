<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="TipoIngreso.aspx.vb" Inherits="Mantenimientos_TipoIngreso" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <asp:UpdatePanel ID="upTipoIngreso" runat="server">
    <ContentTemplate>

    <asp:label ID="lbl_error" runat="server" Visible="False" CssClass="error"></asp:label>
    <br />

    <fieldset style="width: 350px">
        <legend>Tipo Ingreso</legend>
        <table>
            <tr>
                <td>
                    <asp:label ID="lbldescripcion" runat="server">Tipo Ingreso</asp:label>
                </td>
                <td>
                    <asp:TextBox ID="txtdescripcion" runat="server" Width="250px"></asp:TextBox>
                </td>
            </tr>
            <tr id="trEstatus" runat="server" visible="false">
                <td>
                    <asp:label ID="lblEstatus" runat="server">Estatus</asp:label>
                </td>
                <td>
                    <asp:DropDownList ID="ddlEstatus" runat="server" CssClass="dropDowns">
                        <asp:ListItem Value="A">Activo</asp:ListItem>
                        <asp:ListItem Value="I">Inactivo</asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr>
                <td colspan="2" align="right">
                    <asp:Button ID="btnGrabar" runat="server" Text="Guardar"/>&nbsp;
                    <asp:Button ID="btnCancelar" runat="server" Text="Cancelar" />
                </td>
            </tr>
        </table>

    <br />

    </fieldset> 

        <table>
            <tr>

            <td>
            <asp:GridView id="gvTipoIngreso" runat="server" AutoGenerateColumns="False" OnRowCommand = "gvTipoIngreso_RowCommand">
				<Columns>
					<asp:BoundField DataField="COD_INGRESO" HeaderText="Tipo Ingreso">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>					
					<asp:BoundField DataField="DESCRIPCION" HeaderText="Descripción">
                        <ItemStyle HorizontalAlign="left" />
                    </asp:BoundField>  
                                      
					<asp:BoundField DataField="NOMBRE_ESTATUS" HeaderText="Estatus">
                        <ItemStyle HorizontalAlign="Center" />
                    </asp:BoundField> 
                    <asp:BoundField DataField="ULT_USUARIO_ACT" HeaderText="Modificado Por">
                        <ItemStyle HorizontalAlign="Left" />
					</asp:BoundField>   
                    <asp:BoundField DataField="ULT_FECHA_ACT" HeaderText="Modificado En" 
                        HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
					</asp:BoundField>                              
                     <asp:Templatefield>
				     <ItemTemplate ><asp:Label id="lblEstatus" runat="server" text='<%# eval("STATUS") %>' Visible="false"></asp:Label>
                     <asp:ImageButton id="ibEditar" runat="server" BorderWidth="0px" CausesValidation="False"
						ImageUrl="../images/editar.gif" ToolTip="Editar Tipo Ingreso"></asp:ImageButton>
                     </ItemTemplate>
					</asp:Templatefield> 
                                                        
		          </Columns> 
			</asp:GridView>             
            </td>
            </tr>
        </table>
 
    </ContentTemplate>
    </asp:UpdatePanel>
</asp:Content>

