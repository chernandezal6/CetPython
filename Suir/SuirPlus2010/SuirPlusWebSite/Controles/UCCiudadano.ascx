<%@ Control Language="VB" AutoEventWireup="false" CodeFile="UCCiudadano.ascx.vb" Inherits="Controles_UCCiudadano" %>
<%@ Register TagPrefix="uc1" TagName="UC_DatePicker" Src="UC_DatePicker.ascx" %>

<asp:UpdatePanel ID="updGeneral" runat="server" UpdateMode="Conditional">
    <ContentTemplate>
<script language="javascript" type="text/javascript">
     function Sel()
     {
                 try
                    {
                            if ((document.aspnetForm.ctl00$MainContent$ucCiudadano$txtRepDocumento.value.length) !== 11)
                            {
                                document.aspnetForm.ctl00$MainContent$ucCiudadano$ddRepTipoDoc.options[1].selected = true;
                            }
                            else
                            {
                                document.aspnetForm.ctl00$MainContent$ucCiudadano$ddRepTipoDoc.options[0].selected = true;
                            }
                    }
                    catch(err)
                    {
                    //Handle errors here
                    }
         
     

      }
</script>
<table class="td-Content" width="425">
	<TR>
		<TD colSpan="4"><asp:label id="lblRepError" CssClass="error" runat="server"></asp:label></TD>
	</TR>
	<tr>
		<td colSpan="4" height="3"></td>
	</tr>
	<TR>
		<TD style="text-align: left" valign="bottom"><asp:dropdownlist id="ddRepTipoDoc" runat="server" CssClass="dropDowns">
				<asp:ListItem Value="C" Selected="True">C&#233;dula</asp:ListItem>
				<asp:ListItem Value="P">Pasaporte</asp:ListItem>
			</asp:dropdownlist></TD>
		<TD colSpan="3" valign="bottom" style="width: 394px"><asp:textbox id="txtRepDocumento" OnKeyUp="Sel()" onChange="Sel()"  runat="server" Width="125px" MaxLength="25"></asp:textbox>&nbsp;
			<asp:button id="btnRepBuscar" runat="server" Text="Buscar" CausesValidation="False"></asp:button>
			<asp:button id="btnRepCancelar" runat="server" CausesValidation="False" Text="Cancelar"></asp:button>
			&nbsp;
			<asp:image id="imgRepBusca" runat="server"></asp:image></TD>
	</TR>
	</table>
	<asp:panel id="pnlInfoPersona" Runat="server">
<table class="td-Content" width="425">
		<TR>
			<TD class="labelData" colspan="4" >
				<asp:label id="lblNombres" runat="server"></asp:label>
				<asp:label id="lblApellidos" runat="server"></asp:label></TD>
		</TR>
		<asp:Panel id="pnlNSS" Runat="server">
			<TR>
				<TD >NSS&nbsp;
				</TD>
				<TD class="labelData" colSpan="3">
					<asp:label id="lblNss" runat="server"></asp:label></TD>
			</TR>
		</asp:Panel>
		<TR>
			<TD  align="right"></TD>
			<TD class="labelData" colSpan="3">
				</TD>
		</TR>
		</table>
	</asp:panel>
	<asp:panel id="pnlNuevaPersona" Runat="server">
	<table class="td-Content" width="425">
		<TR>
			<TD class="subheader" colSpan="4"><b>Ingrese datos del ciudadano extranjero.</b>
			</TD>
		</TR>
		<TR>
			<TD >Nombres&nbsp;
			</TD>
			<TD class="labelData" colSpan="3">
				<asp:TextBox id="txtNombres" runat="server" MaxLength="50" Width="320px"></asp:TextBox>&nbsp;<FONT color="red">*</FONT></TD>
		</TR>
		<TR>
			<TD >Primer apellido</TD>
			<TD class="labelData" style="HEIGHT: 19px" colSpan="3">
				<asp:TextBox id="txtApellidoPat" runat="server" MaxLength="40" Width="320px"></asp:TextBox>&nbsp;<FONT color="red">*</FONT></TD>
		</TR>
		<TR>
			<TD >Segundo apellido</TD>
			<TD class="labelData" style="HEIGHT: 19px" colSpan="3">
				<asp:TextBox id="txtApellidoMat" runat="server" MaxLength="40" Width="320px"></asp:TextBox></TD>
		</TR>
		</table>
		
		<asp:Panel id="Panel2" Runat="server">
			<table class="td-Content" width="425">
			<TR>
				<TD >Sexo</TD>
				<TD class="labelData" colSpan="3">
					<asp:dropdownlist id="ddSexo" runat="server" CssClass="dropDowns">
						<asp:ListItem></asp:ListItem>
						<asp:ListItem Value="F">F</asp:ListItem>
						<asp:ListItem Value="M">M</asp:ListItem>
					</asp:dropdownlist>&nbsp;<FONT color="red">*</FONT></TD>
			</TR>
			<TR>
				<TD >Fecha Nacimiento&nbsp;
				</TD>
				<TD class="labelData" colSpan="3">
					<TABLE border="0">
						<TR>
							<TD>
								<uc1:UC_DatePicker id="ucFechaNac" runat="server"></uc1:UC_DatePicker></TD>
						</TR>
					</TABLE>
				</TD>
			</TR>
			</table>
		</asp:Panel>
			<table class="td-Content" width="425">
		<TR>
			<TD colSpan="4" height="10"></TD>
		</TR>
		<TR>
			<TD  align="right"></TD>
			<TD class="labelData" colSpan="3">
				<asp:button id="btnAgregar" runat="server" CausesValidation="False" Text="Agregar"></asp:button>&nbsp;
				<asp:button id="btnCancelarNP" runat="server" CausesValidation="False" Text="Cancelar"></asp:button></TD>
		</TR>
</table>
	</asp:panel>


    </ContentTemplate>
    <Triggers>
        <asp:AsyncPostBackTrigger ControlID="btnRepBuscar" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnCancelarNP" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnAgregar" EventName="Click" />
        <asp:AsyncPostBackTrigger ControlID="btnRepCancelar" EventName="Click" />
    </Triggers>
</asp:UpdatePanel>
