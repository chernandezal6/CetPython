<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consAnalisisRecaudo.aspx.vb" Inherits="DGII_consAnalisisRecaudo" title="Consulta Análisis de Recaudo" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">


	<script language="javascript" type="text/javascript">
     function Sel()
     {
            if ((document.aspnetForm.ctl00$MainContent$txtNro.value.length) < 10)
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[1].selected = true;
            }
            else
            {
                document.aspnetForm.ctl00$MainContent$drpTipoConsulta.options[0].selected = true;
            }
     }
	</script>
	
<div align="left" class="header">Consulta Análisis de Recaudo</div>
    <br />
    <table class="tblWithImagen" style="BORDER-COLLAPSE: collapse" cellspacing="1" cellpadding="1">
        <tr>
            <td colspan="3" align="center" class="listHeader" style="height: 15px"></td>
        </tr>
        <tr>
            <td rowspan="4" >
                <img src="../images/calcfactura.jpg"  alt="" />
             </td>
            <td style="text-align: right" >
                <br />
                <asp:dropdownlist id="drpTipoConsulta" runat="server" CssClass="dropDowns" width="105px">
				<asp:ListItem Value="R">Nro. Referencia</asp:ListItem>
				<asp:ListItem Value="A">Nro. Autorizaci&#243;n</asp:ListItem></asp:dropdownlist></td>
            <td align="left">
                <br />
                <asp:TextBox onKeyPress="checkNum()" OnKeyUp="Sel()" onChange="Sel()" id="txtNro" runat="server" MaxLength="16"></asp:TextBox>&nbsp;</td>
        </tr>
        <tr>
            <td style="text-align: center" colspan="2" >
			    <asp:Button id="btBuscar" runat="server" Text="Buscar"></asp:Button>&nbsp;&nbsp;&nbsp;
			    <asp:Button id="btLimpiar" runat="server" Text="Limpiar" EnableViewState="False" CausesValidation="False"></asp:Button></td>
        </tr>
    </table>

<asp:label id="lblFormError" runat="server" CssClass="error" Font-Size="9pt"></asp:label>
				<asp:RequiredFieldValidator id="RequiredFieldValidator" runat="server" Display="Dynamic" ErrorMessage="Nro. de Referencia y/o Autorizacion es requerido."
					ControlToValidate="txtNro" Font-Bold="True"></asp:RequiredFieldValidator>
				<asp:regularexpressionvalidator id="RegularExpressionValidator3" runat="server" Display="Dynamic" ValidationExpression="0*[1-9][0-9]*"
					ErrorMessage="Referencia y/o Autorización Inválida" ControlToValidate="txtNro" Font-Bold="True"></asp:regularexpressionvalidator><asp:label CssClass="error" id="lblMensaje" runat="server" EnableViewState="False" /><br />
			<asp:panel id="pnlResultado" runat="server" Visible="False">

			<asp:label id="lblResultado" runat="server" CssClass="subHeader"></asp:label><br />
				<TABLE class="td-content" id="table3" cellSpacing="3" cellPadding="0" border="0" style="width: 800px">
					<TR>
						<TD class="LabelDataGreen" align="right" style="width: 120px">RNC:</TD>
						<TD style="width: 300px" align="left"><asp:label id="lblrnc" runat="server" CssClass="LabelDataGris"></asp:label></TD>
						
						<TD class="LabelDataGreen" align="right" style="width: 120px">Status:</TD>
						<TD style="WIDTH: 200px" colSpan="3" align="left">
							<asp:label id="lblstatus" runat="server" CssClass="LabelDataGris"></asp:label></TD>
					<TR>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Razón Social:</TD>
						<TD style="width: 300px" align="left">
							<asp:label id="lblrazonsocial" runat="server" CssClass="LabelDataGris"></asp:label></TD>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Fecha Emisión:</TD>
						<TD colSpan="3" style="width: 200px" align="left">
							<asp:label id="lblfechaemision" runat="server" CssClass="LabelDataGris"></asp:label></TD>
					</TR>
					<TR>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Importe:</TD>
						<TD style="width: 300px" align="left">
							<asp:label id="lblimporte" runat="server" CssClass="LabelDataGris"></asp:label></TD>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Recargo:</TD>
						<TD colSpan="3" style="width: 200px" align="left">
							<asp:label id="lblrecargo" runat="server" CssClass="LabelDataGris"></asp:label></TD>
					</TR>
					<TR>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Intereses:</TD>
						<TD style="width: 300px" align="left">
							<asp:label id="lblIntereses" runat="server" CssClass="LabelDataGris"></asp:label></TD>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Total a Pagar:</TD>
						<TD colSpan="3" style="width: 200px" align="left">
							<asp:label id="lbltotalapagar" runat="server" CssClass="LabelDataGris"></asp:label></TD>
					</TR>
					<TR>
						<TD class="LabelDataGreen" align="right" style="width: 120px">No Autorización:</TD>
						<TD style="width: 300px" align="left">
							<asp:label id="lblnumeroautorizacion" runat="server" CssClass="LabelDataGris"></asp:label></TD>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Fecha Desautorización:</TD>
						<TD style="width: 200px" align="left">
							<asp:label id="lblfechadesautorizo" runat="server" CssClass="LabelDataGris"></asp:label></TD>
					</TR>
					<TR>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Fecha Autorización:</TD>
						<TD style="width: 300px" align="left">
							<asp:label id="lblfechaautorizo" runat="server" CssClass="LabelDataGris"></asp:label></TD>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Usuario Desautorizó:</TD>
						<TD colSpan="3" style="width: 200px" align="left">
							<asp:label id="lblusuariodesautorizo" runat="server" CssClass="LabelDataGris"></asp:label></TD>
					</TR>
					<TR>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Usuario Autorización:</TD>
						<TD style="width: 300px" align="left">
							<asp:label id="lblusuarioautorizo" runat="server" CssClass="LabelDataGris"></asp:label></TD>
						<TD class="LabelDataGreen" align="right" style="width: 120px">Entidad Recaudadora:</TD>
						<TD colSpan="3" style="width: 200px" align="left">
							<asp:label id="lblentidadrecaudadora" runat="server" CssClass="LabelDataGris"></asp:label></TD>
					</TR>
				</TABLE>
			<br>
			<TABLE id="tblDetalle1" cellSpacing="1" cellPadding="1" border="0">
				<TR>
					<TD colSpan="3">
					<asp:GridView id="gvDetalle" runat="server" AutoGenerateColumns="False" CssClass="gridBorder" CellPadding="3">
							<Columns>
								<asp:Boundfield DataField="id_recepcion" HeaderText="Lote">
									<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
								</asp:Boundfield>
								<asp:Boundfield DataField="secuencia_mov_recaudo" HeaderText="Secuencia">
									<HeaderStyle HorizontalAlign="Center"></HeaderStyle>
                                    <ItemStyle HorizontalAlign="Center" />
								</asp:Boundfield>
								<asp:Boundfield DataField="tipo_envio" HeaderText="Tipo Env&#237;o">
                                    <ItemStyle HorizontalAlign="Center" />
                                </asp:Boundfield>
								<asp:Boundfield DataField="entidad_recaudadora_des" HeaderText="Entidad Recaudadora">
                                    <ItemStyle Wrap="False" />
                                </asp:Boundfield>
								<asp:Boundfield DataField="fecha_carga" HeaderText="Fecha Carga" DataFormatString="{0:d}" HtmlEncode="False"></asp:Boundfield>
								<asp:Boundfield DataField="error_des" HeaderText="Error">
                                    <ItemStyle Wrap="False" />
                                </asp:Boundfield>
								<asp:Boundfield DataField="id_referencia_isr" HeaderText="Referencia"></asp:Boundfield>
								<asp:Boundfield DataField="no_autorizacion" HeaderText="Autorizaci&#243;n"></asp:Boundfield>
								<asp:Boundfield DataField="monto" HeaderText="Monto" DataFormatString="{0:c}" HtmlEncode="False"></asp:Boundfield>
								<asp:Boundfield DataField="fecha_pago" HeaderText="Fecha Pago" DataFormatString="{0:d}" HtmlEncode="False"></asp:Boundfield>
								<asp:Boundfield DataField="lote_aclaracion" HeaderText="Lote aclaraci&#243;n"></asp:Boundfield>
								<asp:Boundfield DataField="secuencia_aclaracion" HeaderText="Secuencia Aclaraci&#243;n"></asp:Boundfield>
								<asp:Boundfield DataField="status" HeaderText="Status"></asp:Boundfield>
								<asp:Boundfield DataField="id_referencia_aclaracion" HeaderText="Referencia Aclaraci&#243;n"></asp:Boundfield>
								<asp:Boundfield DataField="no_autorizacion_aclaracion" HeaderText="Autorizaci&#243;n Aclaraci&#243;n"></asp:Boundfield>
								<asp:Boundfield DataField="monto_aclaracion" HeaderText="Monto aclaraci&#243;n" DataFormatString="{0:c}" HtmlEncode="False"></asp:Boundfield>
								<asp:Boundfield DataField="fecha_aclaracion" HeaderText="Fecha aclaraci&#243;n" DataFormatString="{0:d}" HtmlEncode="False"></asp:Boundfield>
							</Columns>
							</asp:GridView>
				</TD>
				</tr>
			</TABLE>
			
			</asp:panel>
</asp:Content>

