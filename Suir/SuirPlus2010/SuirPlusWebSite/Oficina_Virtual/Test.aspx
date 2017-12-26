<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusOficinaVirtual.master" AutoEventWireup="false" CodeFile="Test.aspx.vb" Inherits="Oficina_Virtual_Test" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <style>
        .Probando {
            width: 30%;
            height: auto;
            margin: auto;
        }

        .LateralLeft {
            width: auto;
            height: auto;
            float: left;
            margin: auto;
            position: absolute;
            background-color: #4580B7;
            color: white;
            text-align: center;
            padding-bottom: 10px;
        }

        .Lanueva {
            width: 100%;
            margin: auto;
            float: right;
            height: 40px;
            background-color: #FFF;
            border: 1px solid #63AD22;
            text-align: right;
            padding-top: 5px;
            padding-right: 5px;
            border-radius: 5px;
        }
        .botones {
            width: 12.6%;
            text-align: -webkit-right;
            right: 0;
        }
        .textos {
            width: 80%;
            padding: 6px;
            margin: 0;
            float: left;
            text-align: -webkit-auto;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div class="Probando">
        <%--<div class="Lanueva">
            <div class="textos">
                <span>Hola Como estan todos!</span>
            </div>
            <div class="btn-group botones" data-toggle="buttons">
                <label class="btn btn-primary">
                    <input type="radio" name="options" id="option2" autocomplete="off">
                    Radio 2
                </label>
                <label class="btn btn-primary">
                    <input type="radio" name="options" id="option3" autocomplete="off">
                    Radio 3
                </label>
            </div>
        </div>--%>

        <ul class="list-group">
            <li class="list-group-item">
                <input type="checkbox" value="">
                Cras justo odio, estoy probando a ver como esto baja de linea para poder cuadrarlo y evaluar la manera corecta de hacerlo.
            </li>
            <li class="list-group-item">
                <input type="checkbox" value="">
                Cras justo odio
            </li>
            <li class="list-group-item">
                <input type="checkbox" value="">
                Cras justo odio
            </li>
            <li class="list-group-item">
                <input type="checkbox" value="">
                Cras justo odio
            </li>
        </ul>

        <div class="checkbox">
            <label>
                <input type="checkbox" value="">
                Option one is this and that&mdash;be sure to include why it's great
            </label>
        </div>
        <div class="checkbox disabled">
            <label>
                <input type="checkbox" value="" disabled>
                Option two is disabled
            </label>
        </div>
    </div>
</asp:Content>

