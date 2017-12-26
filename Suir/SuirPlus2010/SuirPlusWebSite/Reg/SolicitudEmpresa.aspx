<%@ Page Title="" Language="VB" MasterPageFile="~/SuirPlusExterno.master" AutoEventWireup="false" CodeFile="SolicitudEmpresa.aspx.vb" Inherits="Reg_SolicitudEmpresa" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="Server">
    <link href="../css/Formulario.css" rel="stylesheet" />
    <style>
        #registroempresa {
            margin-left: 20px;
            margin-top: -25px;
            color: black;
        }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">
    <div id="registroempresa">
        <h2 class="Titulos"><strong>Bienvenido al Portal de Registro de Empresas</strong></h2>
        <h3 style="color:#63AD22" class="letras">Para realizar el registro de empresas puede seguir los pasos a continuación
        </h3>
        <div class="numberlist">

            <ol>
                <li><a href="RegUsuarioEmp.aspx" class="letras">Registro de Usuario</a>
                    <fieldset class="letrasTexto">
                        En esta página podrá crear el usuario basado a dos tipos de Documentos que son Cedula y/o Pasaporte.
                        En caso de que el pasaporte no exista en nuestra base de datos, el formulario les pedirá más información para poder registrarse, estos datos serán:
                        <ul>
                            <li>Nombre</li>
                            <li>Apellido</li>
                            <%--<li>Nacionalidad</li>
                            <li>Fecha de nacimiento</li>
                            <li>Sexo</li>--%>
                        </ul>
                    </fieldset>
                </li>
                <li><a href="LoginPage.aspx" class="letras">Autenticarse en el Portal</a>
                    <fieldset class="letrasTexto">
                        Luego de haberse registrado podrá iniciar sesión en el portal, En el cual se validara las credenciales provistas, si estas resultan ser validas será re direccionado a la pantalla de Registro de Empresas.
                    <table>
                        <tr>
                            <td>
                                <img src="../images/Siguiente.png" style="width: 50px;" /></td>
                            <td>
                                <img src="../images/Autenticarse.JPG" style="width: 300px;" /></td>
                            <td>
                                <img src="../images/Siguiente.png" style="width: 50px;" /></td>
                            <td>
                                <img src="../images/Inicio.JPG" style="width: 300px;" /></td>
                        </tr>
                    </table>
                    </fieldset>
                </li>
                <li><a href="RegNuevaEmp.aspx" class="letras">Registro de Empresa</a>
                    <fieldset class="letrasTexto">
                    En esta página podrá iniciar el proceso de registro de empresa, siguiendo un flujo simple de pasos el cual garantiza la eficiencia del proceso.<br />
                    <strong>Flujo:</strong> Registro o Continuación -> Tipo de Empresa -> Formulario -> Cargar Documentos Requeridos -> Resumen de Solicitud

                    <br />
                    <strong>Consideraciones:</strong> durante el proceso de registro, al completar el formulario usted recibirá un código de solicitud el cual debe de guardar, pues ese número le permitirá consultar el estatus de su solicitud.
                    <br />
                    Buena Suerte!!!



                </fieldset>
                </li>


            </ol>
        </div>
    </div>
</asp:Content>

