<%@ Control Language="VB" AutoEventWireup="false" CodeFile="ucSolicitud.ascx.vb" Inherits="Controles_ucSolicitud" %>
<style type="text/css">
    .style5
    {
        width: 134px;
    }
    .style8
    {
        width: 100px;
    }
    .style9
    {
        width: 98px;
    }
    .style10
    {
        width: 15%;
    }
</style>
<script language="javascript" type="text/javascript">
<!--

function table1_onclick() {

}

// -->
</script>


<div class="subHeader" align="left"><asp:label id="lblTitulo" runat="server" Visible="False">Información de la solicitud</asp:label></div>
<asp:panel id="pnlGeneral" Visible="False" EnableViewState="False" Runat="server">
	<TABLE class="td-content" id="table1" cellPadding="1" border="0" 
        language="javascript" onclick="return table1_onclick()">
		<TR>
			<TD align="left" class="style5">Nro. Solicitud</TD>
			<TD  align="left">
				<asp:Label ID="lblIdSolicitud" runat="server" CssClass="labelData"></asp:Label></TD>
		</TR>
        <tr>
            <td align="left" class="style5">
				Estatus</td>
            <td colspan="1" align="left">
                <asp:Label ID="lblEstatus" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style5">
                RNC o Cédula</td>
            <td colspan="1" align="left">
                <asp:Label ID="lblRnc" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style5">
				Razón Social</td>
            <td colspan="1" align="left">
				<asp:Label ID="lblRazonSocial" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
		<TR>
			<TD align="left" class="style5">Nombre Comercial</TD>
			<TD colspan="1" align="left">
				<asp:Label ID="lblNombreComercial" runat="server" CssClass="labelData"></asp:Label>
				</TD>
		</TR>
        <tr>
            <td align="left" class="style5">
				Ced. Representante</td>
            <td colspan="1" align="left">
                <asp:Label ID="lblCedulaRepresentante" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
		<TR>
			<TD align="left" class="style5">Representante</TD>
			<TD align="left">
				<asp:Label ID="lblRepresentante" runat="server" CssClass="labelData"></asp:Label>
				</TD>
		</TR>
        <tr>
            <td align="left" class="style5">
				Operador</td>
            <td>
                <asp:Label ID="lblOperador" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
		<TR>
			<TD align="left" nowrap="noWrap" class="style5">Fecha Registro</TD>
			<TD align="left">
				<asp:Label ID="lblFechaRegistro" runat="server" CssClass="labelData"></asp:Label>
				</TD>
		</TR>
        <tr>
            <td align="left" nowrap="nowrap" class="style5">
				Tipo Solicitud</td>
            <td>
                <asp:Label ID="lblTipoSolicitud" runat="server" CssClass="error"></asp:Label>
            </td>
        </tr>
       </TABLE>
       
	    <asp:Panel id="pnlEmail" Visible="False" Runat="server" Width="402px" 
        Wrap="False">
		<TABLE class="td-content" id="table6" cellSpacing="3" cellPadding="1" border="0">
			<TR>
				<TD align="left" class="style5">Correo Electrónico</TD>
			    <td>
					<asp:Label ID="lblEmailRepresentante" runat="server" CssClass="labelData"></asp:Label>
                </td>
			</TR>
		</table>
		</asp:Panel>
		<asp:Panel id="pnlTelefonos" Visible="False" Runat="server" Width="401px">
		<TABLE class="td-content" id="table7" cellSpacing="3" cellPadding="1" width="550" border="0">
			<TR>
				<TD align="left" class="style5">Teléfono1</TD>
				<TD>
					<asp:Label ID="lblTelefono1" runat="server" CssClass="labelData"></asp:Label></TD>
			</TR>
			<TR>
				<TD align="left" class="style5">
					Teléfono2</TD>
				<TD>
					<asp:label id="lblTelefono2" runat="server" CssClass="labelData"></asp:label></TD>
			</TR>
		</table>			
		</asp:Panel>
		<asp:Panel id="pnlFax" Visible="False" Runat="server" Width="400px">
		<TABLE class="td-content" id="table8" cellSpacing="3" cellPadding="1" Width="550"border="0">
			<TR>
				<TD align="left" class="style5">No. de Fax</TD>
			    <td>
					<asp:Label ID="lblFax" runat="server" CssClass="labelData"></asp:Label>
                </td>
			</TR>
		</table>	
		</asp:Panel>        
        
		<TABLE class="td-content" id="Table9" cellSpacing="3" cellPadding="1" Width="550" border="0">        
		<TR>
			<TD align="left">Comentarios</TD>
		</TR>
        <tr>
            <td align="left" valign="top">
                <asp:TextBox ID="txtComentarios" runat="server" Height="99px" 
                    TextMode="MultiLine" Width="97%" ReadOnly="True" Font-Names="Verdana" 
                    Font-Size="X-Small"></asp:TextBox></td>
        </tr>
	</TABLE>
	
	</asp:panel>	
<asp:panel id="pnlSolInformacion" Visible="False" EnableViewState="False" Runat="server">
	<TABLE class="td-content" id="Table2" cellSpacing="2" cellPadding="1" width="550">
        <tr>
            <td align="left" class="style8">
                Nro. Solicitud</td>
            <td align="left">
                <asp:Label ID="lblSolicitanteIDSolicitud" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
				Solicitante</td>
            <td>
                <asp:Label ID="lblSolicitante" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
                Cédula o Pasaporte</td>
            <td align="left">
                <asp:Label ID="lbSolicitantelCedula" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
                Dirección</td>
            <td align="left">
                <asp:Label ID="lblSolicitanteDireccion" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
				Teléfono</td>
            <td>
                <asp:Label ID="lblSolicitanteTelefono" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
<tr>
            <td align="left" class="style8" >
				Celular</td>
            <td>
                <asp:Label ID="lblSolicitanteCelular" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
<tr>
            <td align="left" class="style8" >
				Fax</td>
            <td>
                <asp:Label ID="lblSolicitanteFax" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
				Correo Electrónico</td>
            <td>
                <asp:Label ID="lblSolicitanteEmail" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>

		<TR>
			<TD align="left" class="style8" >
                Nombre de la Persona Física o Jurídica:</TD>
			<TD align="left">
				<asp:Label ID="lblSolicitanteInstitucion" runat="server" 
            CssClass="labelData"></asp:Label></TD>
		</TR>
        <tr>
            <td align="left" class="style8" >
                Cargo</td>
            <td align="left">
                <asp:Label ID="lblSolicitanteCargo" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>

        <tr>
            <td align="left" class="style8" >
                Información Solicitada</td>
            <td align="left">
                <asp:Label ID="lblInfoSolicitada" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
				Motivo Solicitud</td>
            <td>
                <asp:Label ID="lblMotivoSolicitud" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
				Autoridad Pública</td>
            <td>
                <asp:Label ID="lblSolicitanteAutoridad" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
				Medio Recibe Info.</td>
            <td>
                <asp:Label ID="lblSolicitanteMedio" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
                <tr>
            <td align="left" class="style8" >
				Lugar Recibe Info.</td>
            <td>
                <asp:Label ID="lblSolicitanteLugar" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
                Fecha Registro</td>
            <td align="left">
                <asp:Label ID="lblSolicitanteFechaRegistro" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style8" >
				Tipo Solicitud</td>
            <td align="left">
				<asp:Label ID="lblSolicitanteTipoSolicitud" runat="server" CssClass="error"></asp:Label>
            </td>
        </tr>

        
		<TR>
			<TD align="left" valign="top" class="style8">Comentarios</TD>
			<TD align="left">
                </TD>
		</TR>
        <tr>
            <td align="left" colspan="2" >
                <asp:TextBox ID="txtSolicitanteComentario" runat="server" Height="99px" 
                    Font-Names="Verdana" Font-Size="X-Small" TextMode="MultiLine" Width="97%" 
                    ReadOnly="True"></asp:TextBox></td>
        </tr>

	</TABLE>
</asp:panel>
<asp:panel id="pnlCancelacion" runat="server" Visible="False" EnableViewState="False">
	<TABLE class="td-content" id="Table3" cellSpacing="3" cellPadding="0" width="550" border="0">
		<TR>
			<TD align="left" height="5">Nro. Solicitud</TD>
			<TD height="5" align="left">
				<asp:Label ID="lblCancelacionIDSolicitud" runat="server" 
            CssClass="labelData"></asp:Label></TD>
		</TR>
        <tr>
            <td align="left">
				RNC&nbsp;</td>
            <td align="left">
				<asp:Label ID="lblCancelacionRNC" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" style="height: 12px">
                Razón Social</td>
            <td align="left" style="height: 12px">
                <asp:Label ID="lblCancelacionRazonSocial" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left">
				&nbsp;Teléfono</td>
            <td align="left">
                <asp:Label ID="lblCancelacionTelefono" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left">
                Contacto</td>
            <td align="left">
                <asp:Label ID="lblCancelacionContacto" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
		<TR>
			<TD align="left">
                Email&#160;</TD>
		    <td>
				<asp:Label ID="lblCancelacionEmail" runat="server" CssClass="labelData"></asp:Label>
            </td>
		</TR>
		<TR>
			<TD align="left">
                &#160;Fax</TD>
			<TD align="left">
				<asp:Label ID="lblCancelacionFax" runat="server" CssClass="labelData"></asp:Label></TD>
		</TR>
		<TR>
			<TD align="left">
                Cargo</TD>
			<TD align="left">
				<asp:Label ID="lblCancelacionCargo" runat="server" CssClass="labelData"></asp:Label></TD>
		</TR>
        <tr>
            <td align="left">
                Fecha Registro</td>
            <td align="left">
                <asp:Label ID="lblCanFechaRegistro" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left">
				Tipo Solicitud</td>
            <td align="left">
				<asp:Label ID="lblCancelacionSolicitud" runat="server" CssClass="error"></asp:Label>
            </td>
        </tr>
		<asp:Panel id="pnlRNCCancelar" Visible="False" Runat="server">
			<TR>
				<TD align="left">RNC a Cancelar&nbsp;</TD>
				<TD colSpan="3">
					<asp:label CssClass="labelData" id="lblCancelacionRNCCancelar" runat="server"></asp:label></TD>
			</TR>
		</asp:Panel>
		<asp:Panel id="pnlFacturas" Visible="False" Runat="server">
			<TR>
				<TD class="subHeader" colSpan="4" height="10">Facturas a cancelar</TD>
			</TR>
			<TR>
				<TD colSpan="4" height="10">
					<asp:GridView id="dgFacturas" Visible="False" runat="server" AutoGenerateColumns="False" Width="70%">
						<Columns>
							<asp:BoundField DataField="ID_REFERENCIA" HeaderText="Notificaci&#243;n">
								<HeaderStyle Width="60%"></HeaderStyle>
							</asp:BoundField>
							<asp:BoundField DataField="TIPO" HeaderText="Tipo Cancelaci&#243;n">
								<HeaderStyle HorizontalAlign="Center" Width="40%"></HeaderStyle>
								<ItemStyle HorizontalAlign="Center"></ItemStyle>
							</asp:BoundField>
						</Columns>
					</asp:GridView></TD>
			</TR>
			<TR>
				<TD colSpan="4" height="10"></TD>
			</TR>
		</asp:Panel>
		<TR>
			<TD class="subHeader" colSpan="2" align="left">Motivo de la Solicitud</TD>
		</TR>
		<TR>
			<TD colSpan="2" align="left">
				<asp:label CssClass="labelData" id="lblCancelacionMotivo" runat="server"></asp:label></TD>
		</TR>

        <tr>
            <td align="left" colspan="2">
                &nbsp;</td>
        </tr>

        <tr>
            <td align="left" class="subHeader">
                Comentarios</td>
            <td align="left">
                &nbsp;</td>
        </tr>
        <tr>
            <td align="left" colspan="2">
                <asp:TextBox ID="txtComentarioCancelacion" Font-Names="Verdana" Font-Size="X-Small" 
                    runat="server" Height="99px" TextMode="MultiLine"
                    Width="97%" ReadOnly="True"></asp:TextBox></td>
        </tr>
	</TABLE>
</asp:panel>
<asp:panel id="pnlSolicitudInformacionGeneral" runat="server" Visible="False" EnableViewState="False">
	<TABLE class="td-content" id="Table4" cellSpacing="2" cellPadding="1" width="550" border="0">
		<TR>
			<TD align="left">Nro.Solicitud</TD>
			<TD align="left">
				<asp:Label ID="lblInfoNroSolicitud" runat="server" CssClass="labelData"></asp:Label></TD>
		</TR>
        <tr>
            <td align="left" style="height: 14px">
				Cédula Solicitante</td>
            <td align="left" style="height: 14px">
				<asp:Label ID="lblInfoCedRepresentante" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
		<TR>
			<TD align="left">
                Solicitante</TD>
			<TD align="left">
				<asp:Label ID="lblInfoRepresentante" runat="server" 
            CssClass="labelData"></asp:Label></TD>
		</TR>
		<TR>
			<TD align="left">
				Teléfono</TD>
			<TD align="left">
				<asp:Label ID="lblInfoTelefono" runat="server" CssClass="labelData"></asp:Label></TD>
		</TR>
		<TR>
			<TD align="left"> Motivo</TD>
			<TD align="left">
				<asp:Label ID="lblInfoMotivo" runat="server" CssClass="labelData"></asp:Label>
				</TD>
		</TR>
		<TR>
			<TD align="left">
                Tipo Solicitud</TD>
		    <td>
				<asp:Label ID="lblInfoTipoSolicitud" runat="server" CssClass="error"></asp:Label>
            </td>
		</TR>
		<TR>
			<TD align="left">Fecha Solicitud</TD>
			<TD align="left">
				<asp:Label ID="lblInfoFechaSolicitud" runat="server" 
            CssClass="labelData"></asp:Label></TD>
		</TR>
        <tr>
            <td align="left">
				Celular</td>
            <td align="left">
				<asp:Label ID="lblInfoCelular" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left">
                Comentario</td>
            <td align="left">
                &nbsp;</td>
        </tr>
        <tr>
            <td align="left" colspan="2">
                <asp:TextBox ID="txtInfoComentario" Font-Names="Verdana" Font-Size="X-Small" 
                    runat="server" Height="99px" TextMode="MultiLine"
                    Width="97%" ReadOnly="True"></asp:TextBox></td>
        </tr>
	</TABLE>
</asp:panel>
<asp:Panel id="pnlSolicitudNovedades" runat="server" Visible="False" EnableViewState="False">
	<TABLE class="td-content" id="Table5" cellSpacing="2" cellPadding="1" width="550" border="0">
        <tr>
            <td align="left" class="style9">
                Nro.Solicitud</td>
            <td align="left">
                <asp:Label ID="lblNovNoSolicitud" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style9">
				RNC o Cédula</td>
            <td align="left">
				<asp:Label ID="lblNovRNC" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style9">
                Razón Social</td>
            <td align="left">
                <asp:Label ID="lblNovRazonSocial" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style9">
				Nombre Comercial</td>
            <td align="left">
				<asp:Label ID="lblNovNombreComercial" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
        <tr>
            <td align="left" class="style9">
                Cédula Representante</td>
            <td align="left">
                <asp:Label ID="lblNovCedRepresentante" runat="server" CssClass="labelData"></asp:Label>
            </td>
        </tr>
		<TR>
			<TD align="left" class="style9">
                Representante</TD>
		    <td>
				<asp:Label ID="lblNovRepresentante" runat="server" CssClass="labelData"></asp:Label>
            </td>
		</TR>
		<TR>
			<TD align="left" class="style9">
                Tipo Solicitud</TD>
			<TD align="left">
				<asp:Label ID="lblNovTipoSolicitud" runat="server" CssClass="error"></asp:Label>
				</TD>
		</TR>
		<TR>
			<TD align="left" class="style9">
                Fecha Solicitud</TD>
		    <td>
				<asp:Label ID="lblNovFechaSolicitud" runat="server" CssClass="labelData"></asp:Label>
            </td>
		</TR>
		<TR>
			<TD align="left" class="style9">
                Comentario</TD>
			<TD align="left">
				</TD>
		</TR>
		<TR>
			<TD align="left" colspan="2">
                <asp:TextBox ID="txtNovComentario" Font-Names="Verdana" 
            Font-Size="X-Small" runat="server" Height="99px" TextMode="MultiLine"
                    Width="97%" ReadOnly="True"></asp:TextBox></TD>
		</TR>
	</TABLE>
</asp:Panel>
<asp:panel id="pnlInfoCierre" Visible="False" Runat="server">
	<TABLE class="td-note" width="550">
		<TR>
			<TD align="right" class="style10">Fecha Cierre</TD>
			<TD>
				<asp:label id="lblFechaCierre" runat="server" CssClass="labelData"></asp:label></TD>
		</TR>
		<TR>
			<TD align="right" class="style10">Entregado A</TD>
			<TD>
				<asp:label id="lblEntreadoA" runat="server" CssClass="labelData"></asp:label></TD>
		</TR>
		<TR>
			<TD align="right" class="style10">Fecha Entrega</TD>
			<TD>
				<asp:label id="lblFechaEntrega" runat="server" CssClass="labelData"></asp:label></TD>
		</TR>
	</TABLE>
</asp:panel>
<asp:label class="error" id="lblMensaje" runat="server" EnableViewState="False" CssClass="error"></asp:label><asp:textbox id="txtIdSolicitud" runat="server" Visible="False" Width="16px"></asp:textbox>
