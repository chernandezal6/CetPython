<%@ Page Language="VB" MasterPageFile="~/SuirPlus.master" AutoEventWireup="false" CodeFile="consARS.aspx.vb" Inherits="Empleador_consARS" title="Consulta ARS" %>
<%@ Register Src="~/Controles/ucExportarExcel.ascx" TagName="ucExportarExcel" TagPrefix="uc1" %>

<asp:Content ID="Content1" ContentPlaceHolderID="MainContent" Runat="Server">
<asp:label id="lblMensaje" runat="server" cssclass="error"></asp:label>

<asp:Panel ID="pnlGeneral" runat="server" Visible="false">
    <asp:updatepanel id="updMain" runat="server" updatemode="Conditional">
        <contenttemplate>
            <div class="header">Consulta de Afiliación al Seguro Familiar de Salud</div>            
            <br />
            <br />
            <table id="Table3" cellpadding="0" cellspacing="0">
                <tr>
                    <td style="height: 173px">
                        <asp:gridview id="gvArs" runat="server" autogeneratecolumns="false" enableviewstate="true">
                            <columns>
                                <asp:boundfield datafield="id_nss" headertext="NSS">
                                    <itemstyle horizontalalign="Center" />
                                    <headerstyle horizontalalign="Center" />
                                </asp:boundfield>
                                <asp:boundfield datafield="no_documento" headertext="Cédula">
                                    <itemstyle horizontalalign="Center" />
                                    <headerstyle horizontalalign="Center" />
                                </asp:boundfield>
                                <asp:boundfield datafield="nombres" headertext="Nombres" >
                                    <itemstyle horizontalalign="Left" width="150px" />
                                    <headerstyle horizontalalign="Center" />
                                </asp:boundfield>
                                <asp:boundfield datafield="apellidos" headertext="Apellidos" >
                                    <itemstyle horizontalalign="Left" width="150px" />
                                    <headerstyle horizontalalign="Center" />
                                </asp:boundfield>
                                <asp:boundfield datafield="status" headertext="Estado" >
                                    <itemstyle horizontalalign="Left" />
                                    <headerstyle horizontalalign="Center" />
                                </asp:boundfield>
                                <asp:boundfield datafield="tipo" headertext="Tipo" >
                                    <itemstyle horizontalalign="Left" />
                                    <headerstyle horizontalalign="Center" />
                                </asp:boundfield>
                                <asp:boundfield datafield="ars_des" headertext="Nombre ARS" >
                                    <itemstyle horizontalalign="Left" width="350px" />
                                    <headerstyle horizontalalign="Center" />
                                </asp:boundfield>
                                <asp:templatefield headertext="Visualizar">
                                    <itemtemplate>
                                        <asp:imagebutton id="imgDependientes" runat="server" imageurl="~/images/detalle.gif" CommandName= "ImgDep" CommandArgument="Buscar" ></asp:imagebutton>
                                        <asp:linkbutton id="lnkDependientes" runat="server" text="Nucleo Familiar" CommandName= "btnDep" CommandArgument="Buscar" ></asp:linkbutton>
                                    </itemtemplate>
                                </asp:templatefield>
                            </columns>
                        </asp:gridview>
                    </td>
                </tr>
                
                <tr>
                    <td style="height: 14px">
                        <asp:LinkButton ID="btnLnkFirstPage" runat="server" CommandName="First" CssClass="linkPaginacion"
                            OnCommand="NavigationLink_Click" Text="<< Primera"></asp:LinkButton>&nbsp;|
                        <asp:LinkButton ID="btnLnkPreviousPage" runat="server" CommandName="Prev" CssClass="linkPaginacion"
                            OnCommand="NavigationLink_Click" Text="< Anterior"></asp:LinkButton>&nbsp; Página
                        [<asp:Label ID="lblCurrentPage" runat="server"></asp:Label>] de
                        <asp:Label ID="lblTotalPages" runat="server"></asp:Label>&nbsp;
                        <asp:LinkButton ID="btnLnkNextPage" runat="server" CommandName="Next" CssClass="linkPaginacion"
                            OnCommand="NavigationLink_Click" Text="Próxima >"></asp:LinkButton>&nbsp;|
                        <asp:LinkButton ID="btnLnkLastPage" runat="server" CommandName="Last" CssClass="linkPaginacion"
                            OnCommand="NavigationLink_Click" Text="Última >>"></asp:LinkButton>&nbsp;
                        <asp:Label ID="lblPageSize" runat="server" Visible="False"></asp:Label>
                        <asp:Label ID="lblPageNum" runat="server" Visible="False"></asp:Label>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Total de Empleados:&nbsp;<asp:Label ID="lblTotalRegistros" runat="server" CssClass="error"></asp:Label>
                        <br />
                    </td>
                </tr>
                
                <tr>
                    <td id="tdNucleoFamiliar" runat="server" visible="false">
                        <fieldset style="width:500px">
                            <legend>Composición del Núcleo Familiar</legend>
                            <div style="height: 4px"></div>
                            <asp:gridview id="gvNucleo" runat="server" autogeneratecolumns="false">
                                <columns>
                                    <asp:boundfield datafield="Nombres" itemstyle-width="350px" headertext="Nombres" headerstyle-horizontalalign="Center" itemstyle-horizontalalign="left" />
                                    <asp:boundfield datafield="Tipo" itemstyle-width="100px" headertext="Tipo" headerstyle-horizontalalign="Center" itemstyle-horizontalalign="left" />
                                    <asp:boundfield datafield="Parentesco" itemstyle-width="150px" headertext="Parentesco" headerstyle-horizontalalign="Center" itemstyle-horizontalalign="left" />
                                    <asp:boundfield datafield="Estatus" itemstyle-width="100px" headertext="Estatus" headerstyle-horizontalalign="Center" itemstyle-horizontalalign="left" />
                                </columns>
                            </asp:gridview>
                        </fieldset>   
                    </td>
                </tr>               
            </table>  
                <uc1:ucExportarExcel id="UcExp" runat="server" Visible="true"></uc1:ucExportarExcel>
        </contenttemplate>
        <triggers>
            <asp:asyncpostbacktrigger controlid="btnLnkFirstPage" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnLnkNextPage" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnLnkPreviousPage" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="btnLnkLastPage" eventname="Click" />
            <asp:asyncpostbacktrigger controlid="gvArs" eventname="RowCommand" />
            <asp:PostBackTrigger ControlID="UcExp" />
        </triggers>
        <Triggers>
            <asp:PostBackTrigger ControlID="UcExp" />
        </Triggers>
    </asp:updatepanel>
</asp:Panel>    
</asp:Content>