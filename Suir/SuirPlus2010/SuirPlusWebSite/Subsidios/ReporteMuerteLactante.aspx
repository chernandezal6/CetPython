<%@ Page Language="C#" AutoEventWireup="true" CodeFile="ReporteMuerteLactante.aspx.cs"
    Inherits="Subsidios_ReporteMuerteLactante" EnableTheming="false" %>


<head runat="server" id="Header">
<script type="text/javascript">

    var tieneErrores = false;
    //var lactanteLoop;

    $(function () {

        $(".button").button();
        $(".fecha").datepicker($.datepicker.regional['es']);

        $("#tituloMensajes").hide();
        $("#tituloErrores").hide();
        $("#titulitoErrores").hide();

        $("#insertarML").click(ReportarMuerteLactante);
        $("#cancelarML").click(CancelarMuerteLactante);
    });

    function ReportarMuerteLactante() {


        if ($("input:checked").length == 0) {

            $("#tituloMensajes").hide();
            $("#tituloErrores").show();
            $("#titulitoErrores").show();

            $("#erroresML").append('<li><span class="error"> Debe seleccionar el Lactante fallecido </span></li>');
            return;
           }

        $("#mensajesML").html("");
        $("#erroresML").html("");

        $("#tituloMensajes").hide();
        $("#tituloErrores").hide();
        $("#titulitoErrores").hide();

        $("#insertarML").attr('disabled', true);
        $("#cancelarML").attr('disabled', true);
        tieneErrores = false;

        try {
            $("input:checked").each(function (id, value) {

                var fila = $(value).parent().parent();

                var nss = fila.find("td:nth-child(3)").html();
                var IdLactante = fila.find("td:nth-child(1)").html();
                var NombreLactante = fila.find("td:nth-child(4)").html();
                var FechaMuerte = fila.find("td:nth-child(6)").find("input").val();

                if (FechaMuerte.length == 0) {

                    console.log("entre");

                    $("#tituloMensajes").hide();
                    $("#tituloErrores").show();
                    $("#titulitoErrores").show();

                    $("#erroresML").append('<li><span class="error">Favor, verificar la fecha de defunción y el lactante seleccionado</span></li>');

                    tieneErrores = true;
                    return;
                }
                else {
                    var Url = loc + "/RegistrarMuerteLactante";
                    var data = '{ nss: "' + $("#nss").html() + '", registropatronal: "' + $("#registropatronalregistro").val() + '", fechamuerte: "' + FechaMuerte + '",' + 'idlactante: "' + IdLactante + '",' + 'usuariomuerte: "' + $("#usuarioregistro").val() + '" }';

                    Util.llamarWS(Url, data, function (infoML) {

                        try {
                            if (infoML.d != 'OK') {
                                $("#tituloErrores").show();
                                $("#titulitoErrores").show();
                                $("#erroresML").append('<li><span class="error"> Lactante ' + NombreLactante + ': ' + infoML.d + '</span></li>');
                                $("#insertarML").attr('disabled', false);
                                $("#cancelarML").attr('disabled', false);
                                tieneErrores = true;
                            }
                            else {
                                $("#tituloMensajes").show();
                                $("#mensajesML").append('<li><span class="labelData"> Lactante ' + NombreLactante + ': ' + "El reporte de muerte de lactante se hizo sastifactoriamente..." + '</span></li>');
                            }
                        }
                        catch (e) {
                            $("#tituloErrores").show();
                            $("#titulitoErrores").show();
                            $("#erroresML").append('<li><span class="error"> Lactante ' + NombreLactante + ': ' + e + '</span></li>');
                            $("#insertarML").attr('disabled', false);
                            $("#cancelarML").attr('disabled', false);
                            tieneErrores = true;
                        }

                    }, ajaxFailed, true);
                }

            });

            if (tieneErrores) {
                //no aplica
                $("#insertarML").attr('disabled', false);
                $("#cancelarML").attr('disabled', false);
            }
            else {
                Exito("El reporte de muerte de lactante se hizo sastifactoriamente...");
            }
        } catch (e) {
            $("#tituloErrores").show();
            $("#titulitoErrores").show();
            $("#erroresML").append('<li><span class="error"> Lactante ' + NombreLactante + ': ' + e + '</span></li>');
            $("#insertarML").attr('disabled', false);
            $("#cancelarML").attr('disabled', false);
            tieneErrores = true;
        }
    }
    function CancelarMuerteLactante() {
        $("#formML").html("");
    }

</script>
</head>
<form id="formML" action="ReporteMuerteLactante.aspx" method="post" runat="server">
<fieldset style="width: 280px;">
    <legend class="header" style="font-size: 14px; font-weight: normal;">Reporte Muerte
        Lactante</legend>
    <br />
    <legend style="font-size: 11px; color: #016BA5">Seleccione de la lista el o los lactantes
        que fallecieron</legend>
    <br />
    <asp:gridview id="gvLactantes" runat="server" autogeneratecolumns="False">
                    <Columns>
                        <asp:BoundField DataField="id_lactante" HeaderText="Id" />
                        <asp:BoundField DataField="SECUENCIA" HeaderText="Secuencia" >
                            <ItemStyle HorizontalAlign="Center" />
                        </asp:BoundField>
                        <asp:BoundField DataField="NSS" ItemStyle-HorizontalAlign="Center" 
                            HeaderText="NSS" >
                        <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:BoundField>
                        <asp:BoundField DataField="NOMBRES" HeaderText="Nombre" >
                            <ItemStyle Wrap="False" />
                        </asp:BoundField>
                        <asp:BoundField DataField="FECHANACIMIENTO" HeaderText="Fecha Nacimiento" 
                            DataFormatString="{0:dd/MM/yyyy}" >
                            <HeaderStyle Wrap="False" />
                        </asp:BoundField>
                        <asp:TemplateField HeaderText="Fecha de Defunción">
                            <ItemTemplate>
                                <asp:TextBox ID="tbFechaDefLact" runat="server" CssClass="fecha" Wrap="False" onkeypress="return false;"></asp:TextBox>
                               </ItemTemplate>
                            <HeaderStyle Wrap="False" />
                            <ItemStyle Wrap="False" />
                        </asp:TemplateField>
                        <asp:TemplateField ItemStyle-HorizontalAlign="Center" HeaderText="Murio?">
                            <ItemTemplate>
                                <asp:CheckBox ID="chkbLactante" runat="server" Checked="false"/>
                            </ItemTemplate>
                            <ItemStyle HorizontalAlign="Center"></ItemStyle>
                        </asp:TemplateField>
                    </Columns>
                </asp:gridview>
    <br />
    <br />
    <input type="button" name="insertarML" class="button" id="insertarML" value="Insertar" />
    <input type="button" name="cancelarML" class="button" id="cancelarML" value="Cancelar" />
    <br />
</fieldset>
<br />
<div>
    <span class="Titulo" id="tituloMensajes">Mensajes</span>
    <ul id="mensajesML" title="Mensajes" />
</div>
<br />
<div>
    <span class="Titulo" style="color: #FF0000;" id="tituloErrores">Errores</span><br />
    <span class="Titulo" style="color: #FF0000; font-size:x-small;" id="titulitoErrores">Para corregir estos errores, oprima cancelar e intente nuevamente</span>
    <ul id="erroresML" title="Errores" />
</div>
</form>
<br />
<br />
<br />
<br />
