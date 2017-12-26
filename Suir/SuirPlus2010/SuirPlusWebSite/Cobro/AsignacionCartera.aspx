<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="AsignacionCartera.aspx.vb" Inherits="AsignacionCartera" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
     <div class="header">
         Asignación de Carteras
    </div>
    <table style="width: 50%">
        <tr>
            <td colspan="2">
                <asp:Label ID="lblMensaje" CssClass="error" runat="server"></asp:Label>
            </td>
        </tr>
        <tr>
            <td>
                <b>No. Cartera / Cantidad de Empleadores</b></td>
            <td>
                <asp:DropDownList ID="ddlCartera" runat="server" CssClass="dropDowns">
                </asp:DropDownList>
                <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" 
                    ControlToValidate="ddlCartera" ErrorMessage="Debe seleccionar una cartera!!" 
                    InitialValue="0"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                <b>Usuario:</b></td>
            <td>
                <asp:DropDownList ID="ddlUsuario" runat="server" CssClass="dropDowns">
                </asp:DropDownList>
&nbsp;<asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" 
                    ControlToValidate="ddlUsuario" ErrorMessage="Debe seleccionar un usuario!!" 
                    InitialValue="0"></asp:RequiredFieldValidator>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                <asp:Button ID="Button1" runat="server" Text="Cancelar" />
            &nbsp;<asp:Button ID="Button2" runat="server" Text="Asignar" />
            </td>
        </tr>
        <tr>
            <td colspan="2">
                <asp:GridView ID="gvCarteras" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="id_cartera" HeaderText="No. Cartera" />
                        <asp:BoundField DataField="Nombre" HeaderText="Usuario" />
                        <asp:BoundField DataField="status_cat" HeaderText="Estado" >
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Estado Asignacion">
                            <ItemTemplate>
                                <asp:Label ID="Label1" runat="server" CssClass='<%# iif(Container.Dataitem("status_asic") = "Deasignada","error","") %>' Text='<%# Bind("status_asic") %>'></asp:Label>
                            </ItemTemplate>                            
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:TemplateField>
                        <asp:BoundField DataField="fecha_asignacion" DataFormatString="{0:d}" 
                            HeaderText="Fecha Asignacion" HtmlEncode="False" >                           
                         <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                         <asp:TemplateField headertext="Remover">
					    <itemtemplate>
                         <asp:ImageButton CausesValidation="false" id="ImageButton9" runat="server" ImageUrl="../images/error.gif" BorderWidth="0px"
		                onclientclick="return confirm('Estas seguro de deasignar este usuario?')" ToolTip="Deasignar usuario" 
		                CommandName="Deasignar" commandargument='<%# Container.Dataitem("id_usuario") & "|" & Container.Dataitem("id_cartera")  %>'
		                visible='<%# iif(Container.Dataitem("status_asic") = "Deasignada","False","True") %>'></asp:ImageButton>
						 </itemtemplate>
						     <ItemStyle HorizontalAlign="Center" />
						</asp:TemplateField>
                    </Columns>
                </asp:GridView>
            </td>
        </tr>
        <tr>
            <td>
                &nbsp;</td>
            <td>
                &nbsp;</td>
        </tr>
    </table>
</asp:Content>

