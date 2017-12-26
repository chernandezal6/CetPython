<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="BienvenidaOFV.aspx.vb" Inherits="Oficina_Virtual_BienvenidaOFV" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <script type="text/javascript">
        $('.carousel').carousel({
            interval: 1000,
            pause: "hover"
        });

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="Raya"></div>
    <div class="well left-bock" style="width: auto; margin-left: 20px; margin-right: 20px;">
        <h1>
            Bienvenido
            <br />
            <small>
                Esta es la plataforma para las consultas de la Oficina Virtual de la Tesorería de la Seguridad Social.
            </small>
        </h1>
    </div>
    <div class="Raya"></div>
    <span style="margin-left: 30px;">Para nuevos usuarios por favor  <a href="RegistroSolicitudUsuario.aspx">Registrese aquí</a></span>
    <br />
    <span style="margin-left: 30px;">Usuarios Registrados <a href="LoginOficinaVirtual.aspx">Ingrese aquí</a></span>
    <%--<div style="width: 80%; margin: 30px; height: 600px">
        <div id="carousel-example-generic" class="carousel slide" data-ride="carousel">
        <!-- Indicators -->
        <ol class="carousel-indicators">
            <li data-target="#carousel-example-generic" data-slide-to="0" class="active"></li>
            <li data-target="#carousel-example-generic" data-slide-to="1"></li>
            <li data-target="#carousel-example-generic" data-slide-to="2"></li>
        </ol>

        <!-- Wrapper for slides -->
        <div class="carousel-inner" role="listbox">
            <div class="item active">
                <img src="../images/VirtualOF.JPG" alt="1100x600"/>
                <div class="carousel-caption">
                    <h3>Bienvenido</h3>
                    <small>
                        Esta es la oficina virtual de la Tesorería de la Seguridad Social
                    </small>
                </div>
            </div>
            <div class="item">
                <img src="../images/VirtualOF.JPG" alt="1100x600"/>
                <div class="carousel-caption">
                    <h3>Segunda Pantalla</h3>
                    <small>Otra Pantalla del carousel</small>
                </div>
            </div>
            <div class="item">
                <img src="../images/VirtualOF.JPG" alt="1100x600"/>
                <div class="carousel-caption">
                    <h3>Tercera Pantalla</h3>
                    <small>Otra Pantalla del carousel</small>
                </div>
            </div>
        </div>

        <!-- Controls -->
        <a class="left carousel-control" href="#carousel-example-generic" role="button" data-slide="prev">
            <span class="glyphicon glyphicon-chevron-left" aria-hidden="true"></span>
            <span class="sr-only">Previous</span>
        </a>
        <a class="right carousel-control" href="#carousel-example-generic" role="button" data-slide="next">
            <span class="glyphicon glyphicon-chevron-right" aria-hidden="true"></span>
            <span class="sr-only">Next</span>
        </a>
    </div>
    </div>   --%>


</asp:Content>

