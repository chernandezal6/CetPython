<%@ Page Title="Consulta de Archivos Nachas por Devolución de Aportes" Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="NachasReclamaciones.aspx.vb" Inherits="Finanzas_NachasReclamaciones" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    
    <div class="header">Consulta de Archivos Nachas por Devolución de Aportes</div>
    <br />
       
    <fieldset id="fsNachasPendientes" runat="server" visible="false" style="width:500px"> 
    <legend>Archivos Nacha Pendientes</legend>   
        <asp:GridView ID="gvNachasPendientes" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="NOMBRE_ARCHIVO_NACHA" HeaderText="Nombre Archivo">
                <ItemStyle HorizontalAlign="left" Wrap="False" />
                <FooterStyle Wrap="False" />
                <HeaderStyle HorizontalAlign="left" Wrap="False" />
            </asp:BoundField>
            
            <asp:BoundField DataField="MONTO_NACHA" HeaderText="Monto Total">
                <ItemStyle HorizontalAlign="right" Wrap="False" />
                <FooterStyle Wrap="False" />
                <HeaderStyle HorizontalAlign="right" Wrap="False" />
            </asp:BoundField>
            
            <asp:BoundField DataField="STATUS_DESC" HeaderText="Estatus">
                <ItemStyle HorizontalAlign="left" Wrap="False" />
                <FooterStyle Wrap="False" />
                <HeaderStyle HorizontalAlign="left" Wrap="False" />
            </asp:BoundField>

            <asp:BoundField DataField="FECHA_ENVIO_NACHA" DataFormatString="{0:d}" HeaderText="Fecha Envío" HtmlEncode="False">
                <ItemStyle HorizontalAlign="Center" />
                <FooterStyle Wrap="False" />
                <HeaderStyle HorizontalAlign="Center" Wrap="False" />
            </asp:BoundField> 
            <asp:TemplateField>
            <ItemTemplate> 
             <asp:Label ID="lblStatus" runat="server" Visible="false" text='<%# eval("status_archivo_nacha")%>'></asp:Label>           
                <asp:LinkButton ID="lbDetalle" runat="server" CommandName="DET" CommandArgument='<%# eval("NOMBRE_ARCHIVO_NACHA")& "|" & eval("MONTO_NACHA") & "|" & eval("STATUS_DESC")%>'>Ver Detalle</asp:LinkButton>
                <asp:LinkButton ID="lbAprobar" Visible="true" runat="server" CommandName="APR" CommandArgument='<%# eval("nombre_archivo_nacha")%>'> | Aprobar </asp:LinkButton>
                <asp:LinkButton ID="lbRechazar" Visible="true" runat="server" CommandName="REC" CommandArgument='<%# eval("nombre_archivo_nacha")%>'> | Rechazar </asp:LinkButton>
            
            </ItemTemplate>                       
            </asp:TemplateField>          
                    
        </Columns>
    </asp:GridView>
    </fieldset>
    <div>
        <asp:Label ID="lblMsg" CssClass="error" runat="server" Visible="false" Font-Size="Small" ></asp:Label>
    </div>
</asp:Content>

