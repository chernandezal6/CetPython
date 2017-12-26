<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="EntidadesRecaudadoras.aspx.vb" Inherits="Bancos_EntidadesRecaudadoras" title="Entidades recaudadoras" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
    <%--<asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <Triggers>
    <asp:AsyncPostBackTrigger ControlID="ddlEntidades" EventName="SelectedIndexChanged" />
    </Triggers>
    </asp:UpdatePanel>--%>
<fieldset style="margin-left: 150px; width: 70%">
<legend>Selección de entidades..</legend>
<br />  
<br />
<span class="span">Entidades Recaudadoras:</span>
    <asp:DropDownList ID="ddlEntidades" AutoPostBack="true" Height="22px" style="font-size: 10px; font-family: Arial helvevica; margin-left: 6px" Width="270px" runat="server">
    </asp:DropDownList>
<br />
<br />
<%--<span class="span">Tipos de impuestos:</span>
    <asp:DropDownList ID="ddlTipoImpuesto" Height="22px" style="font-size: 10px; font-family: Arial helvevica; margin-left: 32px" Width="200px" runat="server">
    </asp:DropDownList>--%>
</fieldset>
<fieldset style="margin-left: 150px; width: 70%">
<legend>Seleccionar tipos de impuestos</legend>
<br />
    <asp:GridView ID="gvBancos" runat="server" AutoGenerateColumns="False">
        <Columns>
            <asp:BoundField DataField="id_entidad_recaudadora" HeaderText="ID" ReadOnly="True">
                <ItemStyle Width="10px" />
            </asp:BoundField>
            <asp:BoundField DataField="entidad_recaudadora_des" HeaderText="Entidad Recaudadora" ReadOnly="True">
                <ItemStyle Width="250px" />
            </asp:BoundField>
            <asp:TemplateField HeaderText="Recaudador TSS">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckTSS" runat="server" Checked='<%# Bind("bancosrecaudadorestss") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckTSS" runat="server" Checked='<%# Bind("bancosrecaudadorestss") %>'
                        Enabled="false" />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Recaudador Infotep">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckInfotec" runat="server" Checked='<%# Bind("bancosrecaudadoresinf") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckInfotec" runat="server" Checked='<%# Bind("bancosrecaudadoresinf") %>'
                        Enabled="false" />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:TemplateField HeaderText="Recaudador DGII">
                <EditItemTemplate>
                    <asp:CheckBox ID="CheckDGII" runat="server" Checked='<%# Bind("bancosrecaudadoresdgii") %>' />
                </EditItemTemplate>
                <ItemTemplate>
                    <asp:CheckBox ID="CheckDGII" runat="server" Checked='<%# Bind("bancosrecaudadoresdgii") %>'
                        Enabled="false" />
                </ItemTemplate>
                <ItemStyle HorizontalAlign="Center" />
            </asp:TemplateField>
            <asp:CommandField CancelText="Cancelar" EditText="Seleccionar impuestos" ShowEditButton="True"
                UpdateText="Actualizar" ButtonType="Button" />
            
        </Columns>
    </asp:GridView>
    <br />
</fieldset>
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Buscando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

