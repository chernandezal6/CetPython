<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="segUsuarioCopiarPerfil.aspx.vb" Inherits="Seguridad_segCopiar" title="Copiar perfil usuario" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:UpdatePanel ID="upPadreUsuario" runat="server">
    <ContentTemplate>
    <div><asp:Label id="lblMensaje" runat="server"></asp:Label> </div>
    
<table>
    <tr>
        <td>
    <div style="FLOAT: left;MARGIN-RIGHT: 10px" id="dUsuarioPadre" runat="server">
        <fieldset>
            <legend>Introduzca el usuario que tiene los Permisos y Roles deseados</legend><br />
            <table>
                <tr>
                    <td colspan="2">
                        <label for="UsuarioPadre">Nombre de Usuario :</label> 
                        <asp:TextBox id="tbUsuarioPadre" runat="server"></asp:TextBox>&nbsp; 
                        <asp:Button accessKey="B" id="btnBuscarUsuario" runat="server" Text="Buscar"></asp:Button> <br /><br /> 
                    </td>               
                </tr>
                <tr>
                    <td valign="top">
                        <asp:GridView id="gvRoles" runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="Roles_Des" HeaderText="Role"  />
                            </Columns>
                        </asp:GridView> 
                    </td> 
                      
                    <td>
                        <asp:GridView id="gvPermisos" runat="server" AutoGenerateColumns="False">
                            <Columns>
                                <asp:BoundField DataField="permiso_des" HeaderText="Permiso"></asp:BoundField>
                                <asp:BoundField DataField="seccion_des" HeaderText="Secci&#243;n"></asp:BoundField>
                                <asp:BoundField DataField="direccion_electronica" HeaderText="URL"></asp:BoundField>
                            </Columns>
                        </asp:GridView> 
                    </td>               
                </tr>            
            </table>

        </fieldset> <br />
            
    </div>

    <div style="FLOAT: left; WIDTH: 300px" id="dUsuarioHijo" runat="server" visible="false">
        <fieldset>
            <legend>Asignar roles y permisos</legend><br />
            <table>
                <tr>
                    <td>
                        <span>Introduzca el usuario al cual se le quiere asignar los mismos Permisos y Roles que tiene </span>
                        <asp:Label id="lblNombreUsuerPadre" runat="server" ForeColor="DarkGreen"></asp:Label> <br /><br />
                        <label for="tbNombreUsuarioHijo">Nombre Usuario:</label> 
                        <asp:TextBox id="tbNombreUsuarioHijo" runat="server"></asp:TextBox> <br /><br />
                        <div style="TEXT-ALIGN: center">
                        <asp:Button id="btAsigPR" runat="server" Text="Asignar Roles y Permisos" OnClick="btAsigPR_Click"></asp:Button> 
                        </div>
                    </td>
               </tr>
            
            </table>
         </fieldset> 
    </div>
    
        </td>
   </tr>

</table>

    </ContentTemplate>
</asp:UpdatePanel>

<asp:UpdateProgress AssociatedUpdatePanelID="upPadreUsuario" ID="UpdateProgress1" runat="server">
    <ProgressTemplate>
        <div style="">
            <span>Cargando...</span>
        </div>
    </ProgressTemplate>
</asp:UpdateProgress>  
</asp:Content>

