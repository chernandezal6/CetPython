<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" MaintainScrollPositionOnPostback="true" AutoEventWireup="false" CodeFile="sfsRegistroTutor.aspx.vb" Inherits="Novedades_sfsRegistroTutor" title="Reporte registro de Tutor" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register Src="../Controles/ucInfoEmpleado.ascx" TagName="ucInfoEmpleado" TagPrefix="uc1" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

    <script language="javascript" type="text/javascript">
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
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
 <fieldset style="width: 585px; margin-left: 60px">
   <legend class="header" style="font-size: 14px">Registro de Tutor</legend>
   <br />
   <table class="td-content" id="Table1" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
				<tr>
					<%--<td rowspan="4"><img src="../images/deuda.jpg" alt="" width="220" height="89" />
					</td>--%>
					<td style="width: 468px">
					<br />
					<span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Afiliada</span>
						<table style="margin-left: 60px">
							<tr>
							    
								<td>Cédula o NSS Madre:</td>
								<td><asp:textbox id="txtCedulaNSS" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic">*</asp:requiredfieldvalidator></td>
								<td align="right"><asp:button id="btnConsultar" runat="server" Text="Buscar"></asp:button>
									<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2"><%--<asp:regularexpressionvalidator id="regExpRncCedula" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic"
										ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="NSS o Cédula invalido."></asp:regularexpressionvalidator>--%><asp:RegularExpressionValidator 
                    ID="regExpRncCedula" runat="server" ControlToValidate="txtCedulaNSS" 
                    Display="Dynamic" ErrorMessage="NSS o Cédula invalido." Font-Bold="True" 
                    ValidationExpression="^[0-9]+$"></asp:RegularExpressionValidator>
                </td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
			<br />
			<asp:label id="lblMsg" cssclass="error" style="margin-left: 17px" EnableViewState="False" Runat="server"></asp:label>
			<div id="divConsulta" visible="false" runat="server">
            <table cellspacing="0" cellpadding="0" style="margin-left: 17px" width="93%">
					<tr>
						<td>
                            <br />
							<uc1:ucInfoEmpleado ID="UcEmpleado" runat="server" />
                            <br />
						</td>
					</tr>
				</table>
				<br />
            </div>
            
            <span id="spanInfo" runat="server" visible="True" 
         style="margin-left: 17px; font-weight: bold" enableviewstate="True">
         </span><table class="td-content" id="Table2" runat="server" visible="false" style="margin-left: 17px; width: 94%"  cellspacing="0" cellpadding="0">
				<tr>
					
					<td>
					    <span ID="tutor" runat="server" visible="True">Digite la cédula del Tutor o 
                        Apoderado designado por la Embarazada:</span>
                        <br />
					<br />
					<span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Tutor</span>
						<table style="margin-left: 60px">
							<tr>
							    
								<td>Cédula o NSS Tutor:</td>
								<td><asp:textbox id="txtCeduNssTutor" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator2" ValidationGroup="tutor" runat="server" ControlToValidate="txtCeduNssTutor" Display="Dynamic">*</asp:requiredfieldvalidator></td>
								<td align="right"><asp:button id="btnTutor" ValidationGroup="tutor" runat="server" Text="Buscar"></asp:button>
									<asp:button id="btnCancel"  runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2"><%--<asp:regularexpressionvalidator id="Regularexpressionvalidator1" runat="server" ControlToValidate="txtCeduNssTutor" Display="Dynamic"
										ValidationExpression="^(\d{9}|\d{11})$" ErrorMessage="NSS o Cédula invalido."></asp:regularexpressionvalidator>--%></td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
            <asp:label id="lblErrorTutor" cssclass="error" style="margin-left: 17px" EnableViewState="False" Runat="server"></asp:label>
            <div id="divInfoTutor" visible="false" runat="server">
            <table cellspacing="0" cellpadding="0" style="margin-left: 17px" width="93%">
					<tr>
						<td>
                            <br />
							<uc1:ucInfoEmpleado ID="UcInfoEmpleado1" runat="server" />
                            <br />
						</td>
					</tr>
				</table>
				<br />
            </div>
     <asp:Label ID="lblMsg2" Runat="server" cssclass="label-Blue" 
         EnableViewState="False" style="margin-left: 17px"></asp:Label>
&nbsp;<div id="fiedlsetDatos"  runat="server" visible="false">
    <br />
                
                &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                
                <asp:Button ID="btnRegistrar" style="margin-left: 62px; width: 90px" runat="server"  ValidationGroup="cuenta" Text="Insertar" />
                <asp:Button ID="btnCancelar1" runat="server" style="margin-left: 4px; width: 90px" Text="Cancelar" />
                <br />
                
                
            </div>
           
            <br />
            
</fieldset><br />
&nbsp;<fieldset runat="server" id="fiedlsetDatos1" style="width: 1024px;" 
            visible="false">
<legend class="header" style="font-size: 14px"><span style="font-size: 14px">Aplicar novedades</span> 

    </legend>
    <asp:Button ID="btnAplicar" runat="server" ValidationGroup="n" style="margin-left: 360px; float: left " Text="Aplicar novedades" />
    <br />
    <br />
    <fieldset>
<uc2:ucGridNovPendientes ID="ucGridNovPendientes1" runat="server" />
        </fieldset>
</fieldset>
</ContentTemplate>
</asp:UpdatePanel>
<asp:UpdateProgress ID="UpdateProgress1" runat="server">
        <ProgressTemplate>
            <div id="Indicator">
                <img alt="indicator.gif" src="../images/ajaxIndicator.gif" />
                Procesando ...
            </div>
        </ProgressTemplate>
    </asp:UpdateProgress>
</asp:Content>

