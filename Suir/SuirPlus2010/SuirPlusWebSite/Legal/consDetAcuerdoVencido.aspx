<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDetAcuerdoVencido.aspx.vb" Inherits="Legal_consDetAcuerdosVencidos" title="Detalle Acuerdos de Pago Vencidos" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

        <div class="header" align="left">
            Detalle Acuerdos de Pago Vencidos
        </div><br />
     
 <table align="left" id="Table0" width="500px">
   <tr>
     <td>
        <div class="subHeader" align="center"> Acuerdo de Pago #<asp:Label ID="lblIdAcuerdo" runat="server" CssClass="subHeader"
                Font-Bold="True" Font-Size="12pt" Visible="False" Font-Underline="True"></asp:Label>
            &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp; Cuota Vencida #<asp:Label ID="lblCuota" runat="server" CssClass="subHeader"
            Font-Bold="True" Font-Size="12pt" Visible="False" Font-Underline="True"></asp:Label></div>
        <div align="center">
            <br />
            <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Font-Size="9pt" Visible="False"></asp:Label>
        </div>   
            <br />
        <div align="center">
            <asp:Button ID="btnVolver" runat="server" CssClass="Button" Text="Volver" Visible="False" />
        </div>
     
 
    

<asp:panel ID="pnlDetalle" runat="server" Visible=false Width="500px">

    <TABLE id="Table3" style="width: 500px" class="td-content">
		<TR>
			<TD align="right">
                Rnc/Cédula:</TD>
            <td style="width: 103px">
                <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label></td>
            <td align="right">
                </td>
            <td>
                </td>
		</TR>
    <tr>
        <td align="right">
            Razón Social:</td>
        <td colspan="3">
            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
        <tr>
            <td align="right">
                Teléfono1:</td>
            <td>
                <asp:Label ID="lblTel1" runat="server" CssClass="labelData"></asp:Label></td>
            <td align="right">
                Tipo Acuerdo:</td>
            <td>
                <asp:Label ID="lbltipoAcuerdo" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td align="right">
                Teléfono2:</td>
            <td style="width: 103px">
                <asp:Label ID="lblTel2" runat="server" CssClass="labelData"></asp:Label></td>
            <td align="right">
            Status:</td>
            <td>
                <asp:Label ID="lblstatus" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
    <tr>
        <td align="right">
            Fecha Registro:</td>
        <td>
            <asp:Label ID="lblFechaReg" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
        <tr>
            <td align="right" style="width: 83px">
            Fecha Término:</td>
            <td>
            <asp:Label ID="lblfechaTermino" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
    <tr>
        <td align="right">
            Nombres:</td>
        <td colspan="3">
            <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right">
            Tipo Documento:</td>
        <td style="width: 103px">
            <asp:Label ID="lblTipoDoc" runat="server" CssClass="labelData"></asp:Label></td>
        <td align="right">
            Nro. Documento:</td>
        <td>
            <asp:Label ID="lblNroDoc" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right">
            Dirección:</td>
        <td colspan="3">
            <asp:Label ID="lblDireccion" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right">
            Estado civil:</td>
        <td >
            <asp:Label ID="lblEstadoCivil" runat="server" CssClass="labelData"></asp:Label></td>
        <td align="right">
            Nacionalidad:</td>
        <td>
            <asp:Label ID="lblNacionalidad" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right">
            Período Inicial:</td>
        <td>
            <asp:Label ID="lblPeriodoIni" runat="server" CssClass="labelData"></asp:Label></td>
        <td align="right">
            Período Final:</td>
        <td>
            <asp:Label ID="lblPeriodoFin" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
        <tr>
            <td align="right" height="20">
            </td>
            <td height="20">
            </td>
            <td align="right" height="20">
            </td>
            <td height="20">
            </td>
        </tr>
    
    <tr>
        <td></td>
        <td></td>
        <td align="right">Total Vencido:</td>
        <td><asp:Label ID="lblTotal" runat="server" CssClass="labelData" Font-Size="9pt"></asp:Label></td>
    </tr>
    
</TABLE>


    <TABLE align="left" id="Table1" width="500px">
		<TR>
			<TD>
			<asp:GridView id="gvDetAcuerdosVencidos" runat="server" AutoGenerateColumns="False" CellPadding="3" Width="100%">
				<Columns>
					
                    <asp:TemplateField HeaderText="Referencia">
                        <ItemStyle HorizontalAlign="Center" Wrap="False"></ItemStyle>
                        <ItemTemplate>
                            <asp:Label id="lblReferencia" runat="server" Text='<%# formateaReferencia(Eval("ID_REFERENCIA")) %>' Visible="true" />
                        </ItemTemplate>
                    </asp:TemplateField>
                    <asp:BoundField DataField="TOTAL_GENERAL_FACTURA" HeaderText="TOTAL"  DataFormatString="{0:c}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Right" Wrap="False"/>
                    </asp:BoundField>                    
					<asp:BoundField DataField="FECHA_LIMITE_PAGO" HeaderText="FECHA LIMITE PAGO"  DataFormatString="{0:d}" HtmlEncode="False">
                        <ItemStyle HorizontalAlign="Center" Wrap="False"/>
                        <HeaderStyle Wrap="False" />
                    </asp:BoundField>

				</Columns>
			</asp:GridView>
           
	       </TD>
		</TR>
	
		<TR>
			<TD align="right" style="text-align: right; height: 177px;">
			<div align="left" class="subHeader">
			                <asp:Label ID="Label1" runat="server" CssClass="subHeader" Font-Bold="True" Font-Size="9pt">Registro CRM</asp:Label>&nbsp;
			</div>	

	<table style="width: 100%;" class="td-content">
         <tr>
                                  <td align="right" style="width: 87px">Contacto:</td>
                                  <td align="left">
                                      <asp:TextBox ID="txtContacto" runat="server" MaxLength="150" Width="280px" EnableViewState="False"></asp:TextBox>
                                      <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ControlToValidate="txtContacto"
                                          CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True" ValidationGroup="CRMRegistro">Requerido</asp:RequiredFieldValidator>
                                  </td>
                              </tr>
         <tr>
                                  <td align="right" style="width: 87px" valign="top">
                                      Descripción:<br />
                                  </td>
                                  <td align="left">
                                      <asp:TextBox ID="txtDescripcion" runat="server" Height="58px" MaxLength="150" TextMode="MultiLine" CssClass="input" Width="280px" EnableViewState="False"></asp:TextBox>
                                      <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ControlToValidate="txtDescripcion"
                                          CssClass="error" Display="Dynamic" ErrorMessage="RequiredFieldValidator" SetFocusOnError="True" ValidationGroup="CRMRegistro">Requerida</asp:RequiredFieldValidator>
                                  </td>
                              </tr>
         <tr>
                                  <td align="right" style="width: 87px">
                                  </td>
                                  <td align="right">
                                      <br />
                                      <asp:Button ID="btnContactado" runat="server" Text="Contactado" ValidationGroup="CRMRegistro" />
                                      <asp:Button ID="btncancelar" runat="server" CssClass="Button" Text="Volver" />
                                  </td>
                              </tr>
    </table>
         </TD>
		</TR>
	</TABLE>
</asp:panel> &nbsp;&nbsp;

 &nbsp;&nbsp;

 </td>
 </tr>
 </table>  
</asp:Content>

