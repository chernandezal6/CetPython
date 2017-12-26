<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="error.aspx.vb" Inherits="Solicitudes_error" title="Error" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

			<TABLE align="center" class="td-content" id="table1" width="485" border="0">
				<TR>
					<TD class="FirstMenuText" align="center" background="../images/barramenu-bg.jpg">&nbsp;Mensaje 
						de Error
					</TD>
				</TR>
				<TR>
					<TD align="center">
						<asp:Label id="lblError" runat="server" EnableViewState="False" CssClass="error"></asp:Label></TD>
				</TR>
				<TR>
					<TD align="center">Se ha generado un error inesperado, favor contactar al servicio 
						al cliente para informar el detalle mostrado en rojo.<br />
                    </TD>
				</TR>
				<TR>
					<TD align="center">&nbsp;
						<asp:Button id="btnErrorCargaArchivo" runat="server" Text="Ir a Solicitudes"></asp:Button></TD>
				</TR>
			</TABLE>

</asp:Content>

