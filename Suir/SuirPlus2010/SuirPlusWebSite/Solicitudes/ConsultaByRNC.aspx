<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="ConsultaByRNC.aspx.vb" Inherits="Solicitudes_ConsultaByRNC" title="Consulta de solicitud por RNC" %>
<%@ Register TagPrefix="uc1" TagName="ucSolicitudByRNC" Src="../Controles/ucSolicitudByRNC.ascx" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
      <br />
	       <div class="header">Consulta de solicitud por RNC</div>
	  <br />
	<table id="table4" cellSpacing="3" cellPadding="0" width="550" border="0">
		<TR>
		<TD style="width: 516px">
			<TABLE class="td-content" id="Table1" cellSpacing="2" cellPadding="0" align="left">
				<TR>
					<TD rowSpan="4" style="width: 215px; height: 91px"><IMG height="89" 
                            src="../images/EnLinea.jpg">
					</TD>
					<TD style="width: 265px; height: 91px">
						<TABLE id="Table2">
							<TR>
								<TD style="width: 70px">RNC/Cédula:</TD>
								<TD>
									<asp:textbox id="txtRNC" runat="server" Width="101px" MaxLength="11"></asp:textbox>
								</TD>
							</TR>
							<TR>
								<TD align="right" colSpan="2">
									<asp:button id="btnConsultar" runat="server" Text="Consultar" Width="57px"></asp:button>&nbsp;
									<asp:button id="btnCancelar" tabIndex="1" runat="server" Text="Limpiar"></asp:button>
								</TD>
							</TR>
						</TABLE>
					</TD>
				</TR>
			</TABLE>
			                        <br />
			                        <br />
                    <div style="height: 63px; width: 442px" visible="False" runat="server" 
                id="divSolicitud">
                        <TABLE class="td-content" cellSpacing=0 cellPadding="2">
                            <TR>
                                <TD style="WIDTH: 22%;">
                                    <br />
                                    Razón Social</TD>
                                <TD  style="height: 16px">
                                    <br />
                                    <asp:label id="lblRazonSocial" runat="server" CssClass="labelData"></asp:label> 
                                </TD>
                            </TR>
                            <TR>
                                <TD style="width: 22%">Nombre Comercial<br />
                                </TD>
                                <TD>
                                    <asp:label id="lblNombreComercial" runat="server" CssClass="labelData"></asp:label> 
                                    <br />
                                </TD>
                            </TR>
                            <TR>
                                <TD style="width: 22%">&nbsp;</TD>
                                <TD>
                                    &nbsp;</TD>
                            </TR>
                        </TABLE>			
			        </div>
			<br />
			<asp:label cssClass="error" id="lblMensaje" runat="server" EnableViewState="False"></asp:label>
			<br />
			
			<asp:panel id="pnlResultados" runat="server" Width="100%">
			    <uc1:ucSolicitudByRNC id="ctrlByRNC" runat="server"></uc1:ucSolicitudByRNC>
			</asp:panel>			
		</TD>
	    </TR>
	</TABLE>
</asp:Content>

