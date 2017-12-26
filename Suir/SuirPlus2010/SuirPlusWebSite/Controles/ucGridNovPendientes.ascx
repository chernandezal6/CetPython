<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucGridNovPendientes.ascx.vb" Inherits="Novedades_ucGridNovPendientes" %>
<asp:Label ID="lblMensaje" runat="server" CssClass="error"></asp:Label>
<asp:GridView id="gvLactancia" runat="server" cellpadding="4" 
    AutoGenerateColumns="False" Width="999px">
	<Columns>
	    <asp:BoundField DataField="id_nss" HeaderText="NSS"></asp:BoundField>
		<asp:BoundField DataField="nombres" HeaderText="Nombre" />
		<asp:BoundField DataField="tipo_novedad_des" HeaderText="Tipo Novedad"></asp:BoundField>
		<asp:BoundField DataField="InfoNovedad" 
            HeaderText="Información de Novedad" />
		<asp:TemplateField>
			<ItemTemplate>
				<asp:ImageButton CausesValidation="False" id="iBtnBorrar" runat="server" ToolTip="Borrar" ImageUrl="../images/error.gif"
					CommandName="Borrar" BorderWidth="0px"></asp:ImageButton>&nbsp;
				<asp:Label id="lblIdMov" runat="server" Text='<%# Eval("ID_MOVIMIENTO") %>' Visible="False">
				</asp:Label>
				<asp:Label id="lblIdLinia" runat="server" Text='<%# Eval("ID_LINEA") %>' Visible="False">
				</asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
</asp:GridView>
<asp:GridView id="gvNovedades" runat="server" cellpadding="4" Width="1200px" AutoGenerateColumns="False" 
    DataKeyNames="ID_MOVIMIENTO,ID_LINEA">
	<Columns>
	    <asp:BoundField DataField="NO_DOCUMENTO" HeaderText="Documento"></asp:BoundField>
		<asp:BoundField DataField="NOMBRE" HeaderText="Nombre"></asp:BoundField>
		<asp:BoundField DataField="fecha_inicio" HeaderText="Fecha"></asp:BoundField>
		<asp:BoundField DataField="ID_NOMINA" HeaderText="N&#243;mina"></asp:BoundField>
		<asp:TemplateField HeaderText="Salario SS">
			<ItemStyle HorizontalAlign="Right"></ItemStyle>
			<ItemTemplate>
				<%#FormatNumber(Eval("SALARIO_SS"))%>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="A.V.O.">
			<ItemStyle HorizontalAlign="Right"></ItemStyle>
			<ItemTemplate>
				<%#FormatNumber(Eval("APORTE_VOLUNTARIO"))%>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="S.C. ISR">
			<ItemStyle HorizontalAlign="Right"></ItemStyle>
			<ItemTemplate>
				<%#FormatNumber(Eval("SALARIO_ISR"))%>
			</ItemTemplate>
		</asp:TemplateField>
		
		<asp:TemplateField HeaderText="S.INFOTEP">
			<ItemStyle HorizontalAlign="Right"></ItemStyle>
			<ItemTemplate>
				<%#FormatNumber(Eval("SALARIO_INFOTEP"))%>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="O. Rem.">
			<ItemStyle HorizontalAlign="Right"></ItemStyle>
			<ItemTemplate>
				<%#FormatNumber(Eval("OTROS_INGRESOS_ISR"))%>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField HeaderText="S. Favor">
			<ItemStyle HorizontalAlign="Right"></ItemStyle>
			<ItemTemplate>
				<%#FormatNumber(Eval("SALDO_FAVOR_ISR"))%>
			</ItemTemplate>
		</asp:TemplateField>
		<asp:TemplateField>
			<ItemTemplate>
				<asp:ImageButton CausesValidation="False" id="iBtnBorrar4" runat="server" 
                    ToolTip="Borrar" ImageUrl="../images/error.gif"
					CommandName="Borrar" BorderWidth="0px"></asp:ImageButton>&nbsp;
				<asp:Label id="lblIdMov" runat="server" Text='<%# Eval("ID_MOVIMIENTO") %>' 
                    Visible="False">
				</asp:Label>
				<asp:Label id="lblIdLinia" runat="server" Text='<%# Eval("ID_LINEA") %>' 
                    Visible="False">
				</asp:Label>
			</ItemTemplate>
		</asp:TemplateField>
	</Columns>
</asp:GridView>
<asp:GridView ID="gvEmpleado" runat="server" AutoGenerateColumns="False" CellPadding="4" Width="100%">
    <Columns>
        <asp:BoundField DataField="NOMBRE" HeaderText="Empleado" >
            <ItemStyle Wrap="False" />
        </asp:BoundField>
        <asp:BoundField DataField="NO_DOCUMENTODep" HeaderText="Documento" />
        <asp:BoundField DataField="NOMBREDEP" HeaderText="Dependiente" >
            <ItemStyle Wrap="False" />
        </asp:BoundField>
        <asp:BoundField DataField="NOMINA_DES" HeaderText="Nómina">
            <ItemStyle Wrap="False" />
        </asp:BoundField>
        <asp:TemplateField HeaderText="Periodo">
            <ItemTemplate>
                <%#formatPeriodo(Eval("PERIODO_APLICACION"))%>
            </ItemTemplate>
            <ItemStyle Wrap="False" />
        </asp:TemplateField>
        <asp:BoundField DataField="fecha_inicio" HeaderText="Registro" />
        <asp:TemplateField>
            <ItemTemplate>
                <asp:ImageButton ID="iBtnBorrar2" runat="server" BorderWidth="0px" CausesValidation="False"
                    CommandName="Borrar" ImageUrl="../images/error.gif" ToolTip="Borrar" />&nbsp;
                <asp:Label ID="lblIdMov" runat="server" Text='<%# Eval("ID_MOVIMIENTO") %>' Visible="False">
									</asp:Label>
                <asp:Label ID="lblIdLinia" runat="server" Text='<%# Eval("ID_LINEA") %>' Visible="False">
									</asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
<asp:GridView ID="gvDependiente" runat="server" AutoGenerateColumns="False" CellPadding="4"
    Width="630px">
    <Columns>
        <asp:BoundField DataField="TIPO_NOVEDAD_DES" HeaderText="Acci&#243;n" Visible="False">
            <ItemStyle HorizontalAlign="Center" />
        </asp:BoundField>
        <asp:BoundField DataField="NOMBREDEP" HeaderText="Dependiente" >
            <ItemStyle Wrap="False" />
        </asp:BoundField>
        <asp:BoundField DataField="NO_DOCUMENTODep" HeaderText="C&#233;dula">
            <ItemStyle HorizontalAlign="Center" />
        </asp:BoundField>
        <asp:BoundField DataField="NOMBRE" HeaderText="Empleado">
            <ItemStyle HorizontalAlign="Left" Wrap="False" />
        </asp:BoundField>
        <asp:BoundField DataField="ID_NOMINA" HeaderText="Id_Nomina" Visible="False">
            <ItemStyle HorizontalAlign="Center" />
        </asp:BoundField>
        <asp:BoundField DataField="NOMINA_DES" HeaderText="N&#243;mina">
            <ItemStyle HorizontalAlign="Left" Wrap="False" />
        </asp:BoundField>
        <asp:TemplateField HeaderText="Ver">
            <ItemStyle HorizontalAlign="Center" />
            <ItemTemplate>
                <asp:ImageButton ID="Imagebutton1" runat="server" BorderWidth="0px" CausesValidation="False"
                    CommandName="Borrar" ImageUrl="../images/error.gif" ToolTip="Borrar" />&nbsp;
                <asp:Label ID="lblIdMov" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ID_MOVIMIENTO") %>'
                    Visible="False">
						</asp:Label>
                <asp:Label ID="lblIdLinia" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.ID_LINEA") %>'
                    Visible="False">
						</asp:Label>
                <asp:Label ID="lblIdNssDependiente" runat="server" Text='<%# DataBinder.Eval(Container, "DataItem.id_nss_dependiente") %>'
                    Visible="False">
						</asp:Label>
            </ItemTemplate>
        </asp:TemplateField>
    </Columns>
</asp:GridView>
