<%@ Page Language="VB" AutoEventWireup="false" MasterPageFile="~/SuirPlusOficinaVirtual.master" CodeFile="ConsNuecloFamiliarSolo.aspx.vb" Inherits="Oficina_Virtual_ConsultasInfEmpleo" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
            <div id="infoTitulo" class="panel panel-primary Center" style="border-color: #EFEFEF;" runat="server">
                <div class="panel-heading" style="text-align: center; height: 32px;">
                    <h4 id="Titulo" runat="server"></h4>
                </div>
            </div>
            <div class="bs-example">
                <div class="center-block bs-example" data-example-id="bordered-table" style="max-width: 800px; width: 50%; margin: auto;">
                    <asp:GridView ID="gvNucleoFamiliar" runat="server" AutoGenerateColumns="False"
                        Width="600px" EnableViewState="False" CssClass="table table-bordered">
                        <Columns>
                            <asp:BoundField DataField="NOMBRES" HeaderText="Nombre">
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                                <FooterStyle Wrap="False" />
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="TIPO" HeaderText="Tipo">
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                                <FooterStyle Wrap="False" />
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="PARENTESCO" HeaderText="Parentesco">
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                                <FooterStyle Wrap="False" />
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                            <asp:BoundField DataField="ID_NSS" HeaderText="NSS">
                                <ItemStyle HorizontalAlign="Left" Wrap="false" />
                                <FooterStyle Wrap="False" />
                                <HeaderStyle HorizontalAlign="Left" Wrap="False" />
                            </asp:BoundField>
                        </Columns>
                    </asp:GridView>
                </div>
            </div>
            <hr />
            <div style="text-align: center">
                <asp:Button ID="btnRegresar" runat="server" CssClass="btn btn-primary" Text="Regresar" />
            </div>
</asp:Content>
