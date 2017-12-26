<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsAsignacionNssLote.aspx.vb" Inherits="Asignacion_NSS_ConsAsignacionNssLote" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="bigtitle">
        <span class="header">Consulta de solicitud de asignación NSS por lote y registro</span>        
    </div>     
    <br />
    <table class="td-content" style="width:270px" >
        <tr> 
            <td style="text-align:right">Lote:</td>          
            <td>
                <asp:TextBox ID="txtLote" runat="server"></asp:TextBox>                
                 <asp:RegularExpressionValidator ID="RegularExpressionValidator1" runat="server" ControlToValidate="txtLote"
                    ErrorMessage="Solo números" ForeColor="Red" ValidationExpression="^\d+$"> 
                </asp:RegularExpressionValidator>
            </td> 
        </tr>
        <tr>
            <td style="text-align:right">Registro: </td>
            <td>
                <asp:TextBox ID="txtRegistro" runat="server"></asp:TextBox>                
                <asp:RegularExpressionValidator ID="RegularExpressionValidator2" runat="server" ControlToValidate="txtRegistro"
                    ErrorMessage="Solo números" ForeColor="Red" ValidationExpression="^\d+$"> 
                </asp:RegularExpressionValidator>
            </td>     
        </tr> 
        <tr>
            <td colspan="2" style="width:80%; text-align:center">                 
                 <asp:Button ID="btBuscar" runat="server" Text="Buscar" />&nbsp;
                <asp:Button ID="btLimpiar" runat="server" Text="Limpiar" CausesValidation="false" />
                 <br />
                 <br />
            </td>
        </tr>      
    </table> 
    
    <br />
    <asp:label id="lblMensajeError" runat="server" Visible="False" CssClass="error" Font-Size="Small"></asp:label><br />
    <asp:GridView ID="gvSolicitudGeneral" runat="server" AutoGenerateColumns="False" Width="90%" >
                    <Columns>
                        <asp:BoundField HeaderText="Solicitud" DataField="Solicitud" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField> 
                         <asp:BoundField HeaderText="Tipo Solicitud" DataField="TipoSolicitud" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>                         
                        <asp:BoundField HeaderText="Fecha Solicitud" DataField="FechaSolicitud" HeaderStyle-HorizontalAlign="Center" dataformatstring="{0:dd/MM/yyyy}">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Lote" DataField="Lote" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Registro" DataField="Registro" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>    
                         <asp:BoundField HeaderText="Estatus" DataField="Estatus" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Motivo" DataField="MotivoRechazo" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Tipo Documento Solicita" DataField="TipoDoc" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>                         
                       <asp:BoundField HeaderText="Documento Solicita" DataField="Expediente" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>                                                                  
                        <asp:BoundField HeaderText="Nombres" DataField="Nombres" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Apellidos" DataField="Apellidos" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>                        
                        <asp:BoundField HeaderText="Sexo" DataField="Sexo" HeaderStyle-HorizontalAlign="Center" NullDisplayText=" ">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="Fecha Nacimiento" DataField="FechaNacimiento" HeaderStyle-HorizontalAlign="Center" dataformatstring="{0:dd/MM/yyyy}">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField HeaderText="NSS" DataField="Nss" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>    
                        <asp:BoundField HeaderText="No. Documento" DataField="NroDoc" HeaderStyle-HorizontalAlign="Center">
                            <HeaderStyle HorizontalAlign="Center" />
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Imagen" ItemStyle-HorizontalAlign="Center">
                                    <ItemTemplate>
                                        <asp:ImageButton ID="ibImagen" runat="server"  ImageUrl="~/images/pdf.png" CommandName="Ver" CommandArgument='<%# Eval("Solicitud")%>' />
                                     </ItemTemplate>
                        </asp:TemplateField>                       
                    </Columns>
          </asp:GridView> 
    <br />

    <asp:Panel ID="pnlNavegacion" runat="server" Height="50px" Visible="False" Width="125px">
            <table cellpadding="0" cellspacing="0" width="550px">
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
                <td><br />
                    Total de Registros:
                    <asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                </td>
            </tr>
            </table>
            </asp:Panel>
</asp:Content>

