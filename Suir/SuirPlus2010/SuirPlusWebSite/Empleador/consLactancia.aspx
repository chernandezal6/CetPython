<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consLactancia.aspx.vb" Inherits="Empleador_consLactancia" title="Subsidio Lactancia" %>

<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <div class="header"><span style="font-size: 20px">Subsidio de Lactancia<br />
    <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
        </span><br /> </div>
       <asp:Panel ID="pnlLatancia" runat="server">
        <asp:Label ID="Label5" runat="server" CssClass="subHeader" Text="Datos Generales de Lactante:"></asp:Label></td> 
        <asp:GridView ID="gvLantancia" runat="server" AutoGenerateColumns="False">
            <Columns>
                <asp:BoundField DataField="NombreCompleto" HeaderText="Nombre" />
                <asp:BoundField DataField="SalarioCotizable" HeaderText="Salario Cotizable" 
                    DataFormatString="{0:c}" />
                <asp:TemplateField HeaderText="Periodo Inicio">
                    <ItemTemplate>
                        <asp:Label ID="Label1" runat="server" Text='<%# FormateaPeriodo(eval("PeriodoInicio")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:TemplateField HeaderText="Periodo Fin">
                <ItemTemplate>
                        <asp:Label ID="Label2" runat="server" Text='<%# FormateaPeriodo(eval("PeriodoFin")) %>'></asp:Label>
                    </ItemTemplate>
                </asp:TemplateField>
                <asp:BoundField DataField="MotivoBaja" HeaderText="Motivo Baja" />
                <asp:BoundField DataField="FechaBaja" HeaderText="Fecha Baja" 
                    DataFormatString="{0:d}" />
                <asp:BoundField DataField="CategoriaSalario" HeaderText="Categoria Salario" />
            </Columns>
        </asp:GridView>
          </asp:Panel>
          <asp:Label ID="lblMensaje" runat="server" CssClass="label-Resaltado" EnableViewState="False"></asp:Label>
</asp:Content>

