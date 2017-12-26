<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCNominas.ascx.vb" Inherits="Controles_UCNominas" %>
<%@ Register Src="ucNominaDetalle.ascx" TagName="ucNominaDetalle" TagPrefix="uc1" %>
<asp:Panel ID="pnlNominasEnc" runat="server">

<table id="Table1" cellspacing="0" cellpadding="0" style="width:100%;">		
	<tr id="trHeader" runat="server" visible="true">
		<td>
			<div class="header">Consulta de Nóminas Registradas</div>		
		</td>
	</tr>
	 <tr>
        <td>
            <div style="height:2px;"></div>
        </td>
    </tr>
	<tr>
		<td>
            <asp:GridView ID="gvNominas" runat="server" Width="580px" autogeneratecolumns="false">
                <Columns>
                    <asp:BoundField DataField="ID_Nomina" HeaderText="ID N&#243;mina" >
                        <ItemStyle HorizontalAlign="Center" width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="tipo_des" HeaderText="Tipo"></asp:BoundField>
                    <asp:BoundField DataField="Nomina_Des" HeaderText="Descripci&#243;n" />
                    <asp:BoundField DataField="Trabajadores" HeaderText="Empleados" >
                        <ItemStyle HorizontalAlign="Right" width="80px" />
                    </asp:BoundField>
                    <asp:BoundField DataField="Fecha_Registro" HeaderText="Fecha Creaci&#243;n" DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" width="100px" />
                    </asp:BoundField>
                    <asp:TemplateField HeaderText="Ver">
                        <ItemStyle HorizontalAlign="Center" width="70px" />
                        <ItemTemplate>
                            <asp:Label id="lblRegistroPatronal" Runat="server" Visible="False" Text='<%# Eval("ID_Registro_Patronal") %>' />                            
                            <asp:Label id="lblNomina" Runat="server" Visible="False" text='<%# Eval("id_nomina") %>' />
                            <img alt="Detalle Nomina" src="../images/detalle.gif">&nbsp;
                            <asp:HyperLink id="hlkDetalle" Runat="server">Detalle</asp:HyperLink>
                        </ItemTemplate>                        
                    </asp:TemplateField>                                           
                </Columns>                 
            </asp:GridView>
		</td>
	</tr>
	<tr>
		<td style="height:15px;"></td>
	</tr>
	<tr>
		<td>
		    <asp:label id="lblResultado" CssClass="error" EnableViewState="False" Visible="False" Runat="server"/>
		</td>
	</tr>
	</table>
</asp:Panel>

<asp:Panel ID="pnlDetalleNomina" runat="server">
<table cellspacing="0" cellpadding="0" style="width:100%;">
	<tr>
		<td>
            <uc1:ucNominaDetalle ID="ctrlDetalle" runat="server" visible="true"/>
        </td>
	</tr>
</table>
</asp:Panel>