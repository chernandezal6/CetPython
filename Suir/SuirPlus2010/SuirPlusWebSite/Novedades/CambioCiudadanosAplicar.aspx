<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CambioCiudadanosAplicar.aspx.vb" Inherits="Novedades_CambioCiudadanosAplicar" title="Aplicar Cambios Pendientes"%>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

<div style="width: 600px">
<asp:Label ID="lblPendientes" runat="server" CssClass="header">Cambios Pendientes de Aplicar</asp:Label>
<br /><br />
                        <asp:Button ID="btnAplicarCambio" runat="server" CausesValidation="False" 
                            Text="Aplicar Cambios" />

    <br /><br />
        <asp:label id="lblMsg" CssClass="error" runat="server"></asp:label>
</div>
    <asp:GridView ID="gvCiudadanosPE" runat="server" AutoGenerateColumns="False" Width="600px" EnableViewState="True" >

                  <Columns>
                      <asp:BoundField DataField="id_secuencia" HeaderText="Id">
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>                  
                      <asp:BoundField DataField="id_nss" HeaderText="NSS">
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                       <asp:BoundField DataField="No_documento" HeaderText="NroDocumento">
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="tipo_documento" HeaderText="Tipo Doc.">
                          <ItemStyle HorizontalAlign="Center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField>
                      <asp:BoundField DataField="nombres" HeaderText="Nombres" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>
                      <asp:BoundField DataField="primer_apellido" HeaderText="Primer Apellido" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>
                      <asp:BoundField DataField="Segundo_Apellido" HeaderText="Segundo Apellido" >
                          <ItemStyle HorizontalAlign="Left" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>
                      <asp:BoundField DataField="fecha_nacimiento" DataFormatString="{0:d}" 
                          HeaderText="Fecha Nacimiento" HtmlEncode="False">
                          <ItemStyle HorizontalAlign="Center" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Center" Wrap="False" />
                      </asp:BoundField> 
                      
                      <asp:BoundField DataField="sexo" HeaderText="Sexo" >
                          <ItemStyle HorizontalAlign="center" Wrap="False" />
                          <FooterStyle Wrap="False" />
                          <HeaderStyle HorizontalAlign="Left" />
                      </asp:BoundField>   
                                   
                  </Columns>    
    
    </asp:GridView>


</asp:Content>