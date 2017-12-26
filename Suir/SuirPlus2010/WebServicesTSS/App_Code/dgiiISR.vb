Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports suirplus

<WebService(Namespace:="http://tempuri.org/")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class dgiiISR
     Inherits System.Web.Services.WebService
    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property

    Private myFact As Empresas.Facturacion.LiquidacionISR
    <WebMethod(Description:="Metodo para autorizar una referencia de pago de la ISR. <br><br>" & _
  "Esta función devuelve un String con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
  "<br><br> Los Errores que devuelve son: <br> " & _
  "a) <b>10</b>|Error en el Usuario o Password <br>" & _
  "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
  "c) <b>14</b>|Esta Referencia ya fue autorizada o pagada <br>" & _
  "d) <b>17</b>|Esta factura debe estar vigente o su total debe ser mayor que 0 parA ser autorizada <br>" & _
  "e) <b>18</b>|Fuera de periodo de pago <br>" & _
  "")> _
    Public Function AutorizarReferencia(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As String

        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If tssfac.RNC.Length < 1 Then
                Return Err.RefNoValida
            End If

            Dim prueba As String = tssfac.Estatus()

            Dim algo As String = tssfac.TotalGeneralFormateadoC
        Catch ex As Exception
            Return Err.RefNoValida
        End Try

        ' Verificar si esta autorizada o pagada la factura
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fue autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If tssfac.Estatus.ToUpper = "CANCELADA" Then
                Throw New Exception("Está cancelada")
            End If

        Catch ex As Exception
            Return Err.RefYaPagada
        End Try


        Me.myFact = New Empresas.Facturacion.LiquidacionISR(NroReferencia)

        Dim resultado As String = Me.myFact.AutorizarFactura(UserName)

        If resultado = "0" Then
            Dim ref As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            Dim Devuelta As String
            Devuelta = ref.NroAutorizacion & "|" & Msg.FacturaAutorizada

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(ref.NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Devuelta, "A")
            Catch ex12 As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
            End Try

            Return ref.NroAutorizacion & "|" & Msg.FacturaAutorizada
        ElseIf resultado = "Esta factura debe estar vigente o su total debe ser mayor que 0 parA ser autorizada" Then
            Return Err.FacturaVigente
        ElseIf resultado = "Está fuera del período de pago para estos impuestos" Then
            Return Err.FueraFechaPago
        Else
            Return resultado
        End If

    End Function

    <WebMethod(Description:="Metodo para autorizar una referencia de pago de la ISR. <br><br>" & _
  "Esta función devuelve un String con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
  "<br><br> Los Errores que devuelve son: <br> " & _
  "a) <b>10</b>|Error en el Usuario o Password <br>" & _
  "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
  "c) <b>14</b>|Esta Referencia ya fue autorizada o pagada <br>" & _
  "d) <b>17</b>|Esta factura debe estar vigente o su total debe ser mayor que 0 parA ser autorizada <br>" & _
  "e) <b>18</b>|Fuera de periodo de pago <br>" & _
  "f) <b>22</b>|Monto de la referencia incorrecto <br>" & _
  "")> _
    Public Function AutorizarReferenciaMnt(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String, ByVal Monto As String) As String

        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If tssfac.RNC.Length < 1 Then
                Return Err.RefNoValida
            End If

            Dim prueba As String = tssfac.Estatus()

            Dim algo As String = tssfac.TotalGeneralFormateadoC
        Catch ex As Exception
            Return Err.RefNoValida
        End Try

        ' Verificar si esta autorizada o pagada la factura
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fue autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If tssfac.Estatus.ToUpper = "CANCELADA" Then
                Throw New Exception("Está cancelada")
            End If

            ' Para validar el monto de la referencia a pagar
            Try
                If tssfac.TotalGeneral <> Convert.ToDecimal(Monto) Then
                    Throw New Exception("Monto Incorrecto")
                End If
            Catch ex As Exception
                Throw New Exception("Monto Incorrecto")
            End Try

        Catch ex As Exception

            If ex.Message = "Ya fue autorizada" Then
                Return Err.RefYaPagada
            ElseIf ex.Message = "Ya fue pagada" Then
                Return Err.RefYaPagada
            ElseIf ex.Message = "Monto Incorrecto" Then
                Return Err.MontoIncorrecto
            Else
                Return Err.RefYaPagada
            End If

        End Try


        Me.myFact = New Empresas.Facturacion.LiquidacionISR(NroReferencia)

        Dim resultado As String = Me.myFact.AutorizarFactura(UserName)

        If resultado = "0" Then
            Dim ref As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            Dim Devuelta As String
            Devuelta = ref.NroAutorizacion & "|" & Msg.FacturaAutorizada

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(ref.NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Devuelta, "A")
            Catch ex12 As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
            End Try

            Return Devuelta

        ElseIf resultado = "Esta factura debe estar vigente o su total debe ser mayor que 0 parA ser autorizada" Then
            Return Err.FacturaVigente
        ElseIf resultado = "Está fuera del período de pago para estos impuestos" Then
            Return Err.FueraFechaPago
        Else
            Return resultado
        End If

    End Function

    <WebMethod(Description:="Metodo para autorizar una referencia de pago del ISR. <br><br>" & _
    "Esta función devuelve un XML con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>14</b>|Esta Referencia ya fue autorizada o pagada <br>" & _
    "")> _
    Public Function AutorizarReferenciaExt(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As System.Xml.XmlDocument

        Dim ds As New DataSet
        Dim doc As New System.Xml.XmlDocument
        Dim msgABC As String = ""

        If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then
            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>10</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Err.UsuarioPass.ToString() + " | " + Left(msgABC, 100) + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)
            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Retorno, "E")
            Catch ex As Exception

            End Try
            Return doc
            ''Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim isrfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If isrfac.RNC.Length < 1 Then
                Dim Retorno As String = ""

                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "</DetalleAutorizacion>"

                doc.LoadXml(Retorno)
                Try
                    Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Retorno, "E")
                Catch ex As Exception

                End Try
                Return doc
            End If

            Dim prueba As String = isrfac.Estatus()

            Dim algo As String = isrfac.TotalGeneralFormateadoC
        Catch ex As Exception
            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida.ToString() + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)
            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Retorno, "E")
            Catch ex2 As Exception

            End Try
            Return doc
        End Try

        ' Verificar si esta autorizada o pagada la factura
        Try
            Dim isrfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If isrfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fue autorizada")
            End If

            If isrfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If isrfac.Estatus.ToUpper = "CANCELADA" Then
                Throw New Exception("Está cancelada")
            End If

            If isrfac.Estatus = "" Then
                Throw New Exception("Ya fue pagada")
            End If

        Catch ex As Exception
            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>14</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Err.RefYaPagada.ToString() + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)
            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Retorno, "E")
            Catch ex2 As Exception

            End Try
            Return doc
        End Try


        Me.myFact = New Empresas.Facturacion.LiquidacionISR(NroReferencia)

        Dim resultado As String = Me.myFact.AutorizarFactura(UserName)

        If resultado = "0" Then

            Dim ref As New Empresas.Facturacion.LiquidacionISR(NroReferencia)
            ''Return ref.NroAutorizacion & "|" & Msg.FacturaAutorizada

            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>0</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Msg.FacturaAutorizada.ToString() + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion> " + ref.NroAutorizacion.ToString() + " </NumeroAutorizacion>"
            Retorno = Retorno + "<ValorPagado>" + ref.TotalGeneral.ToString() + "</ValorPagado>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)
            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Retorno, "A")
            Catch ex2 As Exception

            End Try
            Return doc

        Else

            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>1</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + resultado.ToString() + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, Retorno, "E")
            Catch ex2 As Exception

            End Try


            Return doc
        End If

    End Function

    <WebMethod(Description:="Metodo para cancelar la autorización de una referencia de pago de la ISR. <br><br>" & _
    "Esta función devuelve un 0 en caso de que la referencia haya sido cancelada satisfactoriamente, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>15</b>|Esta Referencia ya fue reportada como pagada <br>" & _
    "")> _
    Public Function CancelarAutorizacion(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As String

        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)
            Dim algo As String = tssfac.TotalGeneralFormateadoC
        Catch ex As Exception
            Return Err.RefNoValida
        End Try

        ' Verificar si esta pagada la factura
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

        Catch ex As Exception
            Return Err.RefYaRepPagada
        End Try

        ' Verifica si no es el mismo usuario
        'SI VIENE EN UN ROL ESPECIFICO , DEBE CONTINUAR DE LO CONTRARIO DEBE SER EL MISMO QUE LA AUTORIZO
        Dim fact As New Empresas.Facturacion.LiquidacionISR(NroReferencia)
        If Not SuirPlus.Seguridad.Autorizacion.isInRol(UserName, "58") Then
            If (CStr(UserName.ToString.ToUpper()) <> CStr(fact.UsuarioAutorizo.ToString.ToUpper())) Then
                Throw New Exception("Usuario diferente")
            End If
        End If


        Me.myFact = New Empresas.Facturacion.LiquidacionISR(NroReferencia)

        Dim resultado As String = Me.myFact.DesAutorizarFactura(UserName, Now())

        If resultado = "0" Then
            Return resultado
        Else
            Return resultado
        End If

    End Function

    <WebMethod(Description:="Consulta de notificaciones pendiente de pago por numero de referencia.<br><br>" & _
    "Esta función devuelve un dataset con el numero de referencia consultado, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>14</b>|Esta Referencia ya fue autorizada o pagada <br>" & _
    "")> _
    Public Function ConsultaPorReferencia(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As DataSet
        Dim ds As New DataSet("ConsultaPorReferencia")
        Dim msgABC As String = ""

        'Verificar Usuario & Password
        If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)

            Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, "ConsultaPorReferencia: " + Err.UsuarioPass + msgABC, "E")

            Return ds

        End If


        'Verifica si esta habil para pagar
        If HabilParaPagar(UserName, Password) = "21|No" Then
            Seg.AgregarMensajeDeError(ds, Err.FueraFechaPago)
            Return ds
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)
            Dim algo As String = tssfac.TotalGeneralFormateadoC
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.RefNoValida)
            Return ds
        End Try

        ' Verificar si esta autorizada o pagada la factura
        Try
            Dim tssfac As New Empresas.Facturacion.LiquidacionISR(NroReferencia)

            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fué autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fué pagada")
            End If

            If tssfac.Estatus.ToUpper = "CANCELADA" Then
                Throw New Exception("Está cancelada")
            End If

        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.RefYaPagada)
            Return ds
        End Try

        '        Return ds
        Try

            ''Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.ISR, UserName, Password, )

            ds.Tables.Add(SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(Empresas.Facturacion.Factura.eConcepto.ISR, "", NroReferencia, "").Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.RefNoValida)
        End Try

        Return ds

    End Function

    <WebMethod(Description:="Consulta de las notificaciones pendiente de pagos por RNC.<br><br>" & _
    "Esta función devuelve un dataset con los numero de referencia que tiene pendiente este RNC, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    " <br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>11</b>|Este RNC no se encuentra en nuestras bases de datos <br>" & _
    "c) En caso de que no tenga referencias pendiente de pago el datatable estara vacio. <br>" & _
    "")> _
    Public Function ConsultaPorRNC(ByVal UserName As String, ByVal Password As String, ByVal RNC As String) As DataSet

        Dim ds As New DataSet("ConsultasPorRNC")

        'Verificar Usuario & Password
        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
            Return ds
        End If

        ' Verificar si el RNC existe
        Try
            Dim emp As New Empresas.Empleador(RNC)
            Dim rz As String = emp.RazonSocial()
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
            Return ds
        End Try

        Try
            ds.Tables.Add(SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(Empresas.Facturacion.Factura.eConcepto.ISR, RNC).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.ToString())
        End Try

        Return ds

    End Function
    <WebMethod(Description:="Consulta de las notificaciones pendiente de pagos por RNC y Código de Nómina" & _
      "Esta función devuelve un dataset con los numero de referencia que tiene pendiente este RNC, en caso de que haya un error se devuelve el codigo mas la descripción." & _
      " <br><br> Los Errores que devuelve son: <br> " & _
      "a) <b>10</b>|Error en el Usuario o Password <br>" & _
      "b) <b>11</b>|Este RNC no se encuentra en nuestras bases de datos <br>" & _
      "c) <b>19</b>|Código de Nómina Inválido <br>" & _
      "d) En caso de que no tenga referencias pendiente de pago el datatable estara vacio. <br>" & _
      "", MessageName:="ConsultaPorRNCNomina")> _
    Public Function ConsultaPorRNCNomina(ByVal UserName As String, ByVal Password As String, ByVal RNC As String, ByVal CodigoNomina As String) As DataSet

        Dim ds As New DataSet("ConsultasPorRNC")

        'Verificar Usuario & Password
        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
            Return ds
        End If

        ' Verificar si el RNC existe
        Try
            Dim emp As New Empresas.Empleador(RNC)
            Dim rz As String = emp.RazonSocial()
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
            Return ds
        End Try
        ' Verificar codigo Nomina
        If CodigoNomina <> "" Then
            Try
                Dim emp As New Empresas.Empleador(RNC)
                Dim rz As String = emp.RegistroPatronal
                Dim nom As New Empresas.Nomina(rz, CodigoNomina)

            Catch ex As Exception
                Seg.AgregarMensajeDeError(ds, Err.CodigoNominaInvalido)
                Return ds
            End Try
        End If

        Try
            If CodigoNomina = "" Then
                CodigoNomina = 6321
            Else
                CodigoNomina = CodigoNomina
            End If
            ds.Tables.Add(SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(Empresas.Facturacion.Factura.eConcepto.ISR, RNC, CodigoNomina).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.ToString())
        End Try

        Return ds

    End Function
    <WebMethod(Description:="Consulta de todas las autorizaciones de pago no canceladas. <br><br>" & _
    "Esta función devuelve un dataset con los numero de referencia que estan autorizados y no han sido reportados como pagados, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "En caso de que no hayan referencias pendientes autorizadas y no reportadas como pagadas, el datatable estara vacio. " & _
    "")> _
    Public Function ConsultaAutorizadoNoPagado(ByVal UserName As String, ByVal Password As String) As DataSet
        Dim ds As New DataSet

        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
            Return ds
        End If


        ds.Tables.Add(Empresas.Facturacion.Factura.getAutorizaciones(UserName, "", Empresas.Facturacion.Factura.eConcepto.ISR).Copy)

        Return ds


    End Function

    <WebMethod(Description:="Consulta de todas las autorizaciones de pago no canceladas por el número de referencia. <br><br>" & _
  "Esta función devuelve un dataset con los numero de referencia que estan autorizados y no han sido reportados como pagados, en caso de que haya un error se devuelve el codigo mas la descripción." & _
  "<br><br> Los Errores que devuelve son: <br> " & _
  "a) <b>10</b>|Error en el Usuario o Password <br>" & _
  "En caso de que no hayan referencias pendientes autorizadas y no reportadas como pagadas, el datatable estara vacio. " & _
  "", MessageName:="ConsultaAutorizadoNoPagadoRef")> _
    Public Function ConsultaAutorizadoNoPagadoRef(ByVal UserName As String, ByVal Referencia As String, ByVal Password As String) As DataSet
        Dim ds As New DataSet

        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass)
            Return ds
        End If

        ds.Tables.Add(Empresas.Facturacion.Factura.getAutorizaciones(UserName, Referencia, Empresas.Facturacion.Factura.eConcepto.ISR).Copy)

        Return ds


    End Function

    <WebMethod(Description:="Metodo para verificar si dicha Referencia esta habil para pagar. <br><br>" & _
 "Esta función devuelve un Si, en el caso de que este Habil Para pagar y No de lo contrario." & _
 "<br><br> Los Errores que devuelve son: <br> " & _
 "a) <b>21</b>|No <br>" & _
 "")> _
    Public Function HabilParaPagar(ByVal UserName As String, ByVal Password As String) As String

        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Return Err.UsuarioPass
        End If

        Dim Resultado As String
        Resultado = SuirPlus.Empresas.Facturacion.LiquidacionISR.HabilPagar()

        If Resultado = "1" Then
            Return Err.HabilParaPagar
        ElseIf Resultado = "0" Then
            Return Err.NoHabilParaPagar
        End If

        Return True

    End Function

End Class
