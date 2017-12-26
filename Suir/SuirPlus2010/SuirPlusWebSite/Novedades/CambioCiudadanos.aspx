<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="CambioCiudadanos.aspx.vb" Inherits="CambioCiudadanos" title="Actualización Ciudadanos" %>

<%@ Register Src="../Controles/ucGridNovPendientes.ascx" TagName="ucGridNovPendientes" TagPrefix="uc4" %>

<%@ Register Src="../Controles/UC_DatePicker.ascx" TagName="UC_DatePicker" TagPrefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
   
    
      <script language="javascript" type="text/javascript">


          $(function pageLoad(sender, args) {

              // Datepicker
              $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
              $(".fecha").datepicker($.datepicker.regional['es']);
          });

       
         
 </script>
 
    
    <table id="Table4" style="width: 725px">
		<tr>
			<td valign="bottom" style="width: 480px"><asp:label id="lblTitulo1" runat="server" CssClass="header">Actualización de Ciudadanos Menores Nacionales, Extranjeros y Trabajadores Extranjeros</asp:label></td>
			<td style="text-align: right"><asp:panel id="pnlPendiente" Runat="server" Visible="False">
					<table class="td-note" id="Table5">
						<tr>
							<td class="subHeader">Personal Cancelado</td>
						</tr>
					</table>
				</asp:panel></td>
		</tr>
	</table>
        
    	<asp:panel id="pnlNuevaInfoGeneral" Runat="server"></asp:panel>
        <asp:panel id="pnlInfoGeneral" Runat="server"></asp:panel>
        
<asp:UpdatePanel ID="updGeneral" runat="server" UpdateMode="Conditional">
    <ContentTemplate>

<script language="javascript" type="text/javascript">

    function Sel() {
        try {
            if ((document.aspnetForm.ctl00$MainContent$ucCiudadano$txtRepDocumento.value.length) !== 10) {
                document.aspnetForm.ctl00$MainContent$ucCiudadano$ddRepTipoDoc.options[1].selected = true;
            }
            else {
                document.aspnetForm.ctl00$MainContent$ucCiudadano$ddRepTipoDoc.options[0].selected = true;
            }
        }
        catch (err) {
            //Handle errors here
        }
    }

    function numeralsOnly(evt) {
        evt = (evt) ? evt : event;
        var charCode = (evt.charCode) ? evt.charCode : ((evt.keyCode) ? evt.keyCode :
        ((evt.which) ? evt.which : 0));
        if (charCode > 31 && (charCode < 48 || charCode > 57)) {
            alert("Este campo solo permite valores numericos.");
            return false;
        }

        return true;
    }
</script>
<table class="td-Content" width="425">
	<TR>
		<TD class="sel" style="width: 85px">&nbsp;</TD>
	    <td>
            <asp:Label ID="lblMsg" runat="server" CssClass="error"></asp:Label>
        </td>
	</TR>
	<tr>
		<td height="3" class="sel" style="width: 85px">&nbsp;</td>
	    <td height="3">
        </td>
	</tr>
	<TR>
		
		<TD valign="bottom" style="width: 85px" class="sel">
            Nss Ciudadano:</TD>
	    <td style="width: 394px" valign="bottom">
            <asp:TextBox ID="txtIdNss" runat="server" MaxLength="9" onChange="Sel()" 
                OnKeyUp="Sel()" Width="105px"></asp:TextBox>
            &nbsp;
            <asp:Button ID="btnRepBuscar" runat="server" CausesValidation="False" 
                Text="Buscar" />
            <asp:Button ID="btnRepCancelar" runat="server" CausesValidation="False" 
                Text="Cancelar" />
            &nbsp;
            <asp:Image ID="imgRepBusca" runat="server" />
        </td>
	</TR>
	</table>
	<asp:panel id="pnlInfoPersona" Runat="server">
<table class="td-Content" width="425">
		<TR>
			<TD class="labelData" colspan="2" >
				<asp:label id="lblNombres" runat="server"></asp:label>
				<asp:label id="lblApellidos" runat="server"></asp:label>
                <asp:Label ID="lblIdNss" runat="server"></asp:Label>
            </TD>
		</TR>
		<asp:Panel id="pnlNSS" Runat="server">
			<TR>
				<TD >NSS&nbsp;</TD>
				<TD class="labelData" colSpan="3">
					<asp:label id="lblNss" runat="server"></asp:label></TD>
			</TR>
		</asp:Panel>
		<TR>
			<TD  align="right"></TD>
			<TD class="labelData">
				</TD>
		</TR>
		</table>
	</asp:panel>
	<asp:panel id="pnlNuevaPersona" Runat="server" Height="255px">
	<table class="td-Content" width="425">
		<TR>
			<TD class="subheader" colSpan="2"><b>Ingrese datos del ciudadano</b>
			</TD>
		</TR>
		<TR>
			<TD style="width: 76px">
				No Documento</TD>
			<TD class="labelData" >
				<asp:TextBox ID="TxtDoc" runat="server" Enabled="False" MaxLength="25" 
                    Width="124px"></asp:TextBox>
			</TD>
		</TR>
		<TR>
			<TD style="width: 76px">
				Nombres&nbsp;</TD>
			<TD class="labelData" >
				<asp:TextBox id="txtNombres" runat="server" MaxLength="50" Width="320px"></asp:TextBox>&nbsp;<FONT color="red">*</FONT></TD>
		</TR>
		<TR>
		    <td style="width: 76px">
                Primer apellido</td>
            <td class="labelData" style="HEIGHT: 19px">
                <asp:TextBox ID="txtApellidoPat" runat="server" MaxLength="40" Width="320px"></asp:TextBox>
                &nbsp;<font color="red">*</font></td>
		</TR>
		<tr>
            <td style="width: 76px">
                Segundo apellido</td>
            <td class="labelData" style="HEIGHT: 19px">
                <asp:TextBox ID="txtApellidoMat" runat="server" MaxLength="40" Width="320px"></asp:TextBox>
            </td>
        </tr>
		</table>
		
		<asp:Panel id="Panel2" Runat="server" Height="16px" Width="1314px">
		</asp:Panel>
			<table class="td-Content" width="425">
		<TR>
			<TD colSpan="2" height="10">
                <table class="td-Content" width="425">
                    <tr>
                        <td style="width: 109px">
                            Sexo</td>
                        <td class="labelData" style="HEIGHT: 19px">
                            <asp:DropDownList ID="ddSexo" runat="server" CssClass="dropDowns" Height="16px" 
                                Width="35px">
                                <asp:ListItem Value="F">F</asp:ListItem>
                                <asp:ListItem Value="M">M</asp:ListItem>
                            </asp:DropDownList>
                            &nbsp;<font color="red">*</font>
                        </td>
                    </tr>
                    <tr>
                        <td style="width: 109px">
                            Fecha Nacimiento&nbsp;</td>
                        <td class="labelData">
                            <asp:TextBox ID="txtFeNac" runat="server" CssClass="fecha" ></asp:TextBox>
                        </td>
                    </tr>
                </table>
            </TD>
		</TR>
		<TR>
			<TD  align="right" class="sel" style="height: 13px; text-align: center;" 
                colspan="2">
                <asp:Button ID="btnAgregar" runat="server" CausesValidation="False" 
                    Text="Actualizar Datos" />
                &nbsp;
                <asp:Button ID="btnCancelarNP" runat="server" CausesValidation="False" 
                    Text="Cancelar" />
            </TD>
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
</asp:Content>