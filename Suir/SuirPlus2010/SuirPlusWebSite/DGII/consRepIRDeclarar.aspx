<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consRepIRDeclarar.aspx.vb" Inherits="DGII_consRepIRDeclarar" title="Declaración IR-13" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

        <div style="text-align:center">
		    <asp:label id="lblTitulo" runat="server" CssClass="header" Width="530px"> Declaración IR-4 del</asp:label>
            <br />
            <br />
		</div>	
		<div style="text-align:center">				
		<table id="Table1" style="WIDTH: 534px; HEIGHT: 126px" cellspacing="1" cellpadding="1"
				width="534" border="0" class="td-content">
				<tr>
					<td style="font-size:medium; text-align: justify;" >
                        <br />
						        Usted está solicitando realizar su declaración jurada 
								anual de las retenciones realizadas a sus asalariados en el año calendario 
								recién transcurrido. Eso significa que está <strong>totalmente de acuerdo</strong>
								con el reporte anterior <strong>y no desea realizar ninguna rectificación</strong>
								al respecto. Si pulsa continuar se realizará la declaración electrónica 
								generando los saldos a favor correspondientes.
                        <br />
                        <br />
						
					</td>
				</tr>

		</table>
	         <div style="text-align:center"> 
                <br />
	            <asp:Button id="btDeclarar" runat="server" Text="Continuar"></asp:Button>
                <asp:Button id="Button1" runat="server" Text="Cancelar"></asp:Button>
                <br />
            </div>
		</div>	
</asp:Content>

