<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="sfsReporteLicencia.aspx.vb" Inherits="Novedades_sfsReporteLicencia" title="Reporte de Licencia" %>

<%@ Register Src="../Controles/ucInfoEmpleado.ascx" TagName="ucInfoEmpleado" TagPrefix="uc1" %>
<%@ Register src="../Controles/ucGridNovPendientes.ascx" tagname="ucGridNovPendientes" tagprefix="uc2" %>
<%@ Register src="../Controles/ucImpersonarRepresentante.ascx" tagname="ucImpersonarRepresentante" tagprefix="uc3" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

<script language="javascript" type="text/javascript">
       
        $(function pageLoad(sender, args) {
            // Datepicker
            $.datepicker.setDefaults($.extend({ showMonthAfterYear: false }, $.datepicker.regional['es']));
            $(".fecha").datepicker($.datepicker.regional['es']);
      });
    </script> 
    <asp:UpdatePanel ID="UpdatePanel1" runat="server">
    <ContentTemplate>
    <uc3:ucImpersonarRepresentante ID="ucImpersonarRepresentante1" runat="server" />
    <fieldset style="width: 585px; margin-left: 60px">
   <legend class="header" style="font-size: 14px">Registro de Licencia pre y post Natal</legend>
   <br />
   <table class="td-content" id="Table1" style="margin-left: 17px; width: 550px"  cellspacing="0" cellpadding="0">
				<tr>
					<%--<td rowspan="4"><img src="../images/deuda.jpg" alt="" width="220" height="89" />
					</td>--%>
					<td>
					<br />
					<span style="font-size: 14px; font-weight: bold; margin-left: 60px; color:#016BA5; font-family: Arial">Afiliada</span>
						<table style="margin-left: 60px">
							<tr>
							    
							    
								<td>Cédula o NSS:</td>
								<td><asp:textbox id="txtCedulaNSS" runat="server" Width="100px" MaxLength="11"></asp:textbox><asp:requiredfieldvalidator id="RequiredFieldValidator1" runat="server" ControlToValidate="txtCedulaNSS" Display="Dynamic">*</asp:requiredfieldvalidator></td>
								<td align="right"><asp:button id="btnConsultar" runat="server" Text="Buscar"></asp:button>
									<asp:button id="btnCancelar" runat="server" Text="Cancelar" CausesValidation="False"></asp:button></td>
							</tr>
							<tr>
								<td align="center" colspan="2">
                  <asp:regularexpressionvalidator id="regExpRncCedula" runat="server" 
                    ControlToValidate="txtCedulaNSS" Display="Dynamic"
										ValidationExpression="^[0-9]+$" ErrorMessage="NSS o Cédula invalido." Font-Bold="True"></asp:regularexpressionvalidator></td>
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
            
            

<div class="td-content" id="fiedlsetDatos" runat="server" visible="false" style="width: 93%; margin-left: 17px">
    <br />
<span style="margin-left: 12px">Fecha de licencia:</span>
    <asp:TextBox ID="txtFeLi" runat="server" CssClass="fecha" style="margin-left: 24px" onkeypress="return false;" ></asp:TextBox> 
    
<asp:Button ID="btnSubmit" ValidationGroup="fecha" style="margin-left: 14px; width: 90px" runat="server" Text="Insertar" />
<asp:Button ID="btnCancelar1" style="margin-left: 10px; width: 90px" runat="server" Text="Cancelar" />
    
    <br />
    <br />
</div>

<br />
  <div style="margin-left: 16px;">
	<span id="errorSexo" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>
    <span id="errorSta" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>	
    <span id="errorG" runat="server" style="margin-left: 1px;"  class="error" visible="false"></span>
    </div>
</fieldset>
<br />

<fieldset runat="server" id="fiedlsetDatos1" 
       style="width: 1024px;" visible="false">
<legend class="header" style="font-size: 14px"><span style="font-size: 14px">Aplicar novedades</span> 

    </legend>
    <asp:Button ID="btnAplicar" runat="server" ValidationGroup="n" style="margin-left: 360px; float: left " Text="Aplicar novedades" />
    <br />
    <br />
    <fieldset>
<uc2:ucGridNovPendientes Visible="true" ID="ucGridNovPendientes1" runat="server" />
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

