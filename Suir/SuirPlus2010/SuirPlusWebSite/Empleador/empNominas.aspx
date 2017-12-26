<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="empNominas.aspx.vb" Inherits="Empleador_empNominas" title="Nominas" %>

<%@ Register Src="../Controles/ucImpersonarRepresentante.ascx" TagName="ucImpersonarRepresentante"
    TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">

			<div class="header">
                <uc1:ucImpersonarRepresentante ID="UcImpersonarRepresentante1" runat="server" />
                Nóminas&nbsp;
			</div>
			
			<asp:label id="lblMensajeDeError" runat="server" Visible="False" EnableViewState="False" CssClass="error"></asp:label><br />
			<!-- Panel de listado --><asp:panel id="pnlListado" Runat="server">
				<asp:Button id="btnNuevoRep" runat="server" Text="Nueva Nómina"></asp:Button>
				<BR>
                <br />
                <asp:GridView ID="dgNominas" runat="server" AutoGenerateColumns="false">
                <Columns>
						<asp:BoundField DataField="id_nomina" HeaderText="C&#243;digo">
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
						<asp:BoundField DataField="nomina_des" HeaderText="Descripci&#243;n"></asp:BoundField>
                        <asp:BoundField DataField="tipo_des" HeaderText="Tipo"></asp:BoundField>
                        <asp:TemplateField>
                            <ItemTemplate>
        		                <asp:ImageButton id="iBtnEditar" runat="server" BorderWidth="0px" CommandName="Editar" ImageUrl="../images/editar.gif"
        							ToolTip="Editar" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.id_nomina") %>'></asp:ImageButton>&nbsp;
        						<asp:ImageButton id="iBtnBorrar" runat="server" BorderWidth="0px" CommandName="Borrar" ImageUrl="../images/error.gif"
        							ToolTip="Borrar" CommandArgument='<%# DataBinder.Eval(Container, "DataItem.id_nomina") %>'></asp:ImageButton>&nbsp;
        						<asp:Label id=lblID runat="server" Visible="false" Text='<%# DataBinder.Eval(Container, "DataItem.id_nomina") %>'>
        						</asp:Label>
                            </ItemTemplate>

                        </asp:TemplateField>                    
		
				</Columns>
            </asp:GridView>
			<BR>

			</asp:panel>
			<!-- Fin del panel de listado -->
			<!-- Panel de detalle --><asp:panel id="pnlDetalle" Runat="server" Visible="False">
				<TABLE class="td-content" cellSpacing="0" cellPadding="0" width="520" border="0">
					<TR>
						<TD class="error" align="left" colSpan="4" height="7"></TD>
					</TR>
					<TR>
						<TD class="subHeader" align="left" colSpan="4">Información General</TD>
					</TR>
					<TR>
						<TD class="error" align="left" colSpan="4" height="7"></TD>
					</TR>
					<TR>
						<TD align="right" width="145">Descripción&nbsp;</TD>
						<TD class="labelData" width="294" colSpan="3">
							<asp:TextBox id="txtDescripcion" runat="server" Width="240px" MaxLength="80">N&#243;mina Administrativa </asp:TextBox></TD>
					</TR>
					<TR>
						<TD align="right" width="145">Tipo&nbsp;</TD>
						<TD class="labelData" width="294" colSpan="3">
							<asp:dropdownlist id="ddlTipoNomina" runat="server" CssClass="dropDowns">
							</asp:dropdownlist></TD>
					</TR>
					<TR>
						<TD colSpan="4" height="10"></TD>
					</TR>
					<TR>
						<TD colSpan="4">
							<HR SIZE="1">
						</TD>
					</TR>
					<TR>
						<TD vAlign="top" align="left" width="70%" colSpan="3" nowrap="nowrap"><FONT color="red">*</FONT> Información 
							obligatoria.</TD>
						<TD align="right" width="30%" nowrap="nowrap">
							<asp:button id="btnAceptar" runat="server" Text="Aceptar"></asp:button>&nbsp;
							<asp:button id="btnCancelar" runat="server" Text="Cancelar"></asp:button>&nbsp; 
							&nbsp;<BR>
						</TD>
					</TR>
				</TABLE>
			</asp:panel>

</asp:Content>

