<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consDetAcuerdoPago.aspx.vb" Inherits="Legal_consDetAcuerdoPago" title="Detalle Acuerdo de Pago" %>
<%@ register src="../Controles/Legal/ucDocumentosLeyFacPago.ascx" tagname="ucDocumentosLeyFacPago" tagprefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

<div class="header" align="left">Detalle Acuerdo de Pago #<asp:Label ID="lblIdAcuerdo" runat="server" CssClass="header"
        Font-Bold="True" Font-Size="11pt" Visible="False"></asp:Label><br />
</div>
<TABLE id="Table4" style="width: 500px">
	<TR>
	   <TD>
     <div align="center">
        <asp:Label ID="lblMsg" runat="server" CssClass="error" Font-Bold="True" Font-Size="11pt"
        Visible="False"></asp:Label><br />
         &nbsp;</div>    
        <div align="center">
            <asp:Button ID="btnVolver" runat="server" CssClass="Button" Text="Volver" Visible="False" />
        </div>       
        
<asp:panel ID="pnlInfo" runat="server" Visible=true Width="500px" >
    <TABLE id="Table3" style="width: 500px" class="td-content">
		<TR>
			<TD style="width: 80px" align="right">
                Rnc/Cédula:</TD>
            <td style="width: 109px">
                <asp:Label ID="lblRNC" runat="server" CssClass="labelData"></asp:Label></td>
            <td align="right" style="width: 77px">
                </td>
            <td>
                </td>
		</TR>
    <tr>
        <td align="right" style="width: 80px">
            Razón Social:</td>
        <td colspan="3">
            <asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
        <tr>
            <td align="right" style="width: 80px">
                Teléfono1:</td>
            <td colspan="" style="width: 109px">
                <asp:Label ID="lblTel1" runat="server" CssClass="labelData"></asp:Label></td>
            <td align="right" style="width: 77px">
                Tipo Acuerdo:</td>
            <td>
                <asp:Label ID="lbltipoAcuerdo" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
        <tr>
            <td align="right" style="width: 80px">
                Teléfono2:</td>
            <td colspan="" style="width: 109px">
                <asp:Label ID="lblTel2" runat="server" CssClass="labelData"></asp:Label></td>
            <td align="right" style="width: 77px">
            Status:</td>
            <td>
                <asp:Label ID="lblstatus" runat="server" CssClass="labelData"></asp:Label></td>
        </tr>
    <tr>
        <td align="right" style="width: 80px">
            Fecha Registro:</td>
        <td colspan="3">
            <asp:Label ID="lblFechaReg" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right" style="width: 80px">
            Nombres:</td>
        <td colspan="3">
            <asp:Label ID="lblNombres" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right" style="width: 80px">
            Tipo Documento:</td>
        <td style="width: 109px">
            <asp:Label ID="lblTipoDoc" runat="server" CssClass="labelData"></asp:Label></td>
        <td align="right" style="width: 80px">
            Nro. Documento:</td>
        <td>
            <asp:Label ID="lblNroDoc" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right" style="width: 80px">
            Dirección:</td>
        <td colspan="3">
            <asp:Label ID="lblDireccion" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right" style="width: 80px">
            Estado civil:</td>
        <td style="width: 109px">
            <asp:Label ID="lblEstadoCivil" runat="server" CssClass="labelData"></asp:Label></td>
        <td align="right" style="width: 77px">
            Sexo:</td>
        <td>
            <asp:Label ID="lblSexo" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right" style="width: 80px">
            Nacionalidad:</td>
        <td colspan="3" style="width: 93px">
            <asp:Label ID="lblNacionalidad" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
    <tr>
        <td align="right" style="width: 80px; height: 14px;">
            Período Inicial:</td>
        <td style="width: 109px; height: 14px;">
            <asp:Label ID="lblPeriodoIni" runat="server" CssClass="labelData"></asp:Label></td>
        <td align="right" style="width: 77px; height: 14px;">
            Período Final:</td>
        <td style="height: 14px">
            <asp:Label ID="lblPeriodoFin" runat="server" CssClass="labelData"></asp:Label></td>
    </tr>
</TABLE>

    <TABLE id="Table1" width="500px">
		<TR>
			<TD style="width: 528px">
                <br />
                <asp:GridView id="gvDetAcuerdoPago2" runat="server" AutoGenerateColumns="False" CellPadding="1" Width="100%">
                    <Columns>
                        <asp:BoundField DataField="cuota" HeaderText="Cuotas">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="Referencias" HeaderText="Referencias">
                            <ItemStyle HorizontalAlign="Left" />
                            <HeaderStyle HorizontalAlign="Left" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FechaLimite" HeaderText="FechaL&#237;mitePago" DataFormatString="{0:d}" HtmlEncode="False">
                            <ItemStyle HorizontalAlign="Center" />
                            <HeaderStyle HorizontalAlign="Center" />
                        </asp:BoundField>    
                    </Columns>
                </asp:GridView>
                <br /><div align=right>
                <asp:LinkButton ID="lnkVerSolicitud" runat="server">Ver Solicitud</asp:LinkButton>
                <asp:Label ID="Label1" runat="server" Font-Bold="False" Font-Size="Larger" Text="|"
                    Width="2px"></asp:Label>&nbsp;
                <asp:LinkButton ID="lnkVerAcuerdo" runat="server">Ver Acuerdo de Pago</asp:LinkButton>
            </div>	
                <br />
                <asp:Label ID="lblTituloComent" runat="server" CssClass="subHeader" Visible="False">Comentario</asp:Label>&nbsp;
                <asp:Label ID="lblComentErr" runat="server" CssClass="error" Font-Bold="True" Font-Size="9pt"
                    Visible="False">El Comentario es Requerido</asp:Label>
                &nbsp;
                <br />
                <asp:TextBox ID="txtComentario" runat="server" Height="72px" TextMode="MultiLine"
                    Width="98%" Visible="False"></asp:TextBox><br />
                </TD>
		</TR>
	</TABLE>	

    <TABLE id="Table2" width="500px">
		<TR>
			<TD align="right" style="width: 497px">	
	<asp:panel ID="pnlCI" runat="server" Visible=false Width="100%" >
	    <asp:Button ID="btnVerificado" runat="server" Text="Verificado" />
        <asp:Button ID="btnRechazarCI" runat="server" Text="Rechazar" />
        <asp:Button ID="btnRegresarCI" runat="server" Text="Regresar" />
	</asp:panel>
	<asp:panel ID="pnlTS" runat="server" Visible=false Width="100%">
	    <asp:Button ID="btnAprobado" runat="server" Text="Aprobado" />
        <asp:Button ID="btnRechazarTS" runat="server" Text="Devolver a Control Interno" />
        <asp:Button ID="btnRegresarTS" runat="server" Text="Regresar" />
	</asp:panel>
	<asp:panel ID="pnlCB" runat="server" Visible=false Width="100%">
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
                                      <asp:Button ID="btnVolverCB" runat="server" CssClass="Button" Text="Volver" />
                                  </td>
                              </tr>
        </table>
	</asp:panel>
			
         </TD>
		</TR>
	</TABLE><uc1:ucdocumentosleyfacpago id="UcImagen" runat="server" /> 
	</asp:panel>
	
        </TD>
	  </TR>
	</TABLE>
				 
</asp:Content>

