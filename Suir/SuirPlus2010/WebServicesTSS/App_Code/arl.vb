Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports SuirPlus
' To allow this Web Service to be called from script, using ASP.NET AJAX, uncomment the following line.
' <System.Web.Script.Services.ScriptService()> _
<WebService(Namespace:="http://www.tss2.gov.do/wsTSS/ARL")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class ARL
    Inherits System.Web.Services.WebService
    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property

    <WebMethod(Description:="Consulta de afiliado al SSDS.<br><br>" & _
    "Esta función devuelve un datatable con el la información del afiliado, en caso de que haya un error se devuelve el código mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password.<br>" & _
    "b) <b>11</b>|Este RNC no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>61</b>|Cédula Inválida.<br>" & _
 "")> _
    Public Function ConsultaAfiliado(ByVal Usuario As String,
                                        ByVal Pass As String,
                                        ByVal RNC As String,
                                        ByVal Cedula As String) As DataSet

        Dim ds As New DataSet("ConsultasARL")
        Dim res As String = String.Empty
        Dim regPatronal = String.Empty

        'Verificar Usuario & Password
        If Seg.CheckUserPass(Usuario, Pass, IP) = False Then
            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
            Return ds
        End If
        ' Verificar si el RNC existe
        Try
            If RNC <> String.Empty Then
                Dim emp As New Empresas.Empleador(RNC)
                Dim rz As String = emp.RazonSocial()
                regPatronal = emp.RegistroPatronal

                If rz = Nothing Then
                    Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
                    Return ds
                End If
            Else
                Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
                Return ds
            End If
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
            Return ds
        End Try

        ' Verificar si la cedula es valida
        Try
            If Cedula <> String.Empty Then
                If Not (SuirPlus.Utilitarios.TSS.existeCiudadano("C", Cedula)) Then
                    Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
                    Return ds
                End If
            Else
                Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
                Return ds
            End If
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
            Return ds
        End Try

        ' buscamos la informacion del afiliado
        Try

            ds.Tables.Add(Afiliacion.Afiliaciones.getAfiliado(RNC, Cedula).Copy())

        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Return ds
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Historico de Descuento afiliado al SSDS.<br><br>" & _
    "Esta función devuelve un datatable con el la información del afiliado, en caso de que haya un error se devuelve el código mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password.<br>" & _
    "b) <b>11</b>|Este RNC no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>61</b>|Cédula Inválida.<br>" & _
    "d) <b>62</b>|Año Inválido.<br>" & _
 "")> _
    Public Function HistoricoDescuento(ByVal Usuario As String,
                                     ByVal Pass As String,
                                     ByVal RNC As String,
                                     ByVal Cedula As String,
                                     ByVal Ano As String) As DataSet

        Dim ds As New DataSet("ConsultasARL")

        Dim res As String = String.Empty
        Dim regPatronal = String.Empty

        'Verificar Usuario & Password
        If Seg.CheckUserPass(Usuario, Pass, IP) = False Then
            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
            Return ds
        End If
        ' Verificar si el RNC existe
        Try
            If RNC <> String.Empty Then
                Dim emp As New Empresas.Empleador(RNC)
                Dim rz As String = emp.RazonSocial()
                regPatronal = emp.RegistroPatronal

                If rz = Nothing Then
                    Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
                    Return ds
                End If
                'Else
                '    Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
                '    Return ds
            End If
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
            Return ds
        End Try

        ' Verificar si la cedula es valida
        Try
            If Cedula <> String.Empty Then
                If Not (SuirPlus.Utilitarios.TSS.existeCiudadano("C", Cedula)) Then
                    Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
                    Return ds
                End If
            Else
                Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
                Return ds
            End If
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.CedulaErr)
            Return ds
        End Try

        ' Verificar si el año es válido
        If Ano <> String.Empty Then
            If Not IsNumeric(Ano) Or Ano < "2003" Then
                Seg.AgregarMensajeDeError(ds, Err.AñoErr)
                Return ds
            End If
        End If

        ' buscamos la informacion del afiliado

        Try
            ds.Tables.Add(Afiliacion.Afiliaciones.getHistoricoDescuento(RNC, Cedula, Ano).Copy())
        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Return ds
        End Try


        Return ds

    End Function

    <WebMethod(Description:="Catálogo Tipo Referencia.<br><br>" & _
"Esta función devuelve un databable con un listado de los diferentes tipos de referencias disponibles, en caso de que haya un error se devuelve el código mas la descripción." & _
"<br><br> Los Errores que devuelve son: <br> " & _
"a) <b>10</b>|Error en el Usuario o Password.<br>" & _
"")> _
    Public Function CatalogoTipoReferencia(ByVal Usuario As String, ByVal Pass As String) As DataSet

        Dim ds As New DataSet("CatalogoTipoReferencia")

        Dim res As String = String.Empty
        Dim regPatronal = String.Empty

        'Verificar Usuario & Password
        If Seg.CheckUserPass(Usuario, Pass, IP) = False Then
            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
            Return ds
        End If

        Try
            ds.Tables.Add(Empresas.Facturacion.FacturaSS.getTiposReferencias().Copy())
        Catch ex As Exception
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Return ds
        End Try

        Return ds

    End Function
End Class