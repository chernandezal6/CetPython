<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="Carteras.aspx.vb" Inherits="Carteras" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
     <div class="header">
         Carteras Asignadas
    </div>
    <table style="width: 50%">
        <tr>
            <td colspan="2">
                <asp:GridView ID="gvCarteras" runat="server" AutoGenerateColumns="False">
                    <Columns>
                        <asp:BoundField DataField="ID_Cartera" HeaderText="No. Cartera" />
                        <asp:BoundField DataField="fecha_generacion" DataFormatString="{0:d}" 
                            HeaderText="Fecha Generacion" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="status_cat" HeaderText="Estado" />
                         <asp:TemplateField headertext="Acciones">
					    <itemtemplate>
                            <asp:LinkButton ID="LinkButton1" runat="server" CommandName="Trabajar" commandargument='<%# Container.Dataitem("id_cartera")  %>'>Realizar Gestion</asp:LinkButton>                            
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

