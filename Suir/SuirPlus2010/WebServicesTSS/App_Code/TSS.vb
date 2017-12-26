Imports System.Web
Imports System.Web.Services
Imports System.Web.Services.Protocols
Imports System.Data
Imports SuirPlus

<WebService(Namespace:="http://www.tss2.gov.do/wsTSS/TSS")> _
<WebServiceBinding(ConformsTo:=WsiProfiles.BasicProfile1_1)> _
<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> _
Public Class TSS
    Inherits System.Web.Services.WebService

    Private myFact As Empresas.Facturacion.FacturaSS
    Public ReadOnly Property IP() As String
        Get
            Return HttpContext.Current.Request.ServerVariables("LOCAL_ADDR")
        End Get
    End Property



    <WebMethod(Description:="Metodo para autorizar una referencia de pago de la TSS. <br><br>" & _
    "Esta función devuelve un String con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>14</b>|Esta Referencia ya fue autorizada o pagada <br>" & _
    "d) <b>23</b>|Debe pagar las facturas anteriores primero <br>" & _
    "")> _
    Public Function AutorizarReferencia(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As String


        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

            If tssfac.RNC.Length < 1 Then
                Return Err.RefNoValida
            End If

            Dim prueba As String = tssfac.Estatus()

            Dim algo As String = tssfac.TotalGeneralFormateadoC
        Catch ex As Exception

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Err.RefNoValida, "E")
            Catch ex12 As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
            End Try

            Return Err.RefNoValida
        End Try

        ' Verificar si esta autorizada o pagada la factura
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)


            If tssfac.IDTipoFacura.ToUpper = "U" And tssfac.StatusGeneracion.ToUpper = "P" Then
                Return Err.RefNoValida
            End If


            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fue autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If tssfac.Estatus.ToUpper = "REVOCADA" Then
                Throw New Exception("Está Revocada")
            End If

            If tssfac.Estatus.ToUpper = "RECALCULADA" Then
                Throw New Exception("Está Recalculada")
            End If

        Catch ex As Exception

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Err.RefYaPagada, "E")
            Catch ex12 As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
            End Try

            Return Err.RefYaPagadaTSS
        End Try


        Me.myFact = New Empresas.Facturacion.FacturaSS(NroReferencia)

        Dim resultado As String = Me.myFact.AutorizarFactura(UserName)

        If resultado = "0" Then

            Dim ref As New Empresas.Facturacion.FacturaSS(NroReferencia)

            Dim Devuelta As String
            Devuelta = ref.NroAutorizacion & "|" & Msg.FacturaAutorizada

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(ref.NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Devuelta, "A")
            Catch ex12 As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
            End Try

            Return Devuelta

        Else
            If resultado = "999" Then
                Try
                    Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Err.DebePagarAnterior, "E")
                Catch ex12 As Exception
                    SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
                End Try
                Return Err.DebePagarAnterior
            Else
                Return resultado
            End If
        End If

    End Function

    <WebMethod(Description:="Metodo para autorizar una referencia de pago de la TSS. <br><br>" & _
    "Esta función devuelve un String con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br> Se utiliza el monto para validar el monto total de la factura. " & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>14</b>|Esta Referencia ya fue autorizada o pagada <br>" & _
    "d) <b>22</b>|Monto de la referencia incorrecto <br>" & _
    "e) <b>23</b>|Debe pagar las facturas anteriores primero <br>" & _
    "")> _
    Public Function AutorizarReferenciaMnt(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String, ByVal Monto As String) As String

        Dim msgABC As String = ""

        If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then
            Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

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
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

            If tssfac.IDTipoFacura.ToUpper = "U" And tssfac.StatusGeneracion.ToUpper = "P" Then
                Return Err.RefNoValida
            End If


            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fue autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If tssfac.Estatus.ToUpper = "REVOCADA" Then
                Throw New Exception("Está Revocada")
            End If

            If tssfac.Estatus.ToUpper = "RECALCULADA" Then
                Throw New Exception("Está Recalculada")
            End If

            Try
                If tssfac.TotalGeneral <> Convert.ToDecimal(Monto) Then
                    Throw New Exception("Monto Incorrecto")
                End If
            Catch ex As Exception
                Throw New Exception("Monto Incorrecto")
            End Try

        Catch ex As Exception

            If ex.Message = "Ya fue autorizada" Then
                Return Err.RefYaPagadaTSS
            ElseIf ex.Message = "Ya fue pagada" Then
                Return Err.RefYaPagadaTSS
            ElseIf ex.Message = "Monto Incorrecto" Then
                Return Err.MontoIncorrecto
            Else
                Return Err.RefYaPagadaTSS
            End If

        End Try

        Me.myFact = New Empresas.Facturacion.FacturaSS(NroReferencia)

        Dim resultado As String = Me.myFact.AutorizarFactura(UserName)

        If resultado = "0" Then
            Dim ref As New Empresas.Facturacion.FacturaSS(NroReferencia)

            Dim Devuelta As String
            Devuelta = ref.NroAutorizacion & "|" & Msg.FacturaAutorizada

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(ref.NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Devuelta, "A")
            Catch ex12 As Exception
                SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
            End Try

            Return Devuelta

        Else
            If resultado = "999" Then
                Return Err.DebePagarAnterior
            Else
                Return resultado
            End If
        End If

    End Function

    <WebMethod(Description:="Metodo para autorizar una referencia de pago de la TSS. <br><br>" & _
    "Esta función devuelve un XML con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>14</b>|Esta Referencia ya fue autorizada, pagada,recalculada o revocada. <br>" & _
    "d) <b>23</b>|Debe pagar las facturas anteriores primero <br>" & _
    "")> _
    Public Function AutorizarReferenciaExt(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As System.Xml.XmlDocument

        ''SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.Text, "insert into dev(texto) values('" + UserName + " " + Password + " " + NroReferencia + "')")

        Dim ds As New DataSet
        Dim doc As New System.Xml.XmlDocument()
        Dim msgABC As String = ""

        If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then
            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>10</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Err.UsuarioPass.ToString() + " | " + Left(msgABC, 100) + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)

            ''Try
            Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            'Catch ex As Exception

            'End Try

            Return doc
            ''Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

            If tssfac.RNC.Length < 1 Then
                Dim Retorno As String = ""

                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "</DetalleAutorizacion>"

                doc.LoadXml(Retorno)

                Try
                    Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
                Catch ex As Exception

                End Try

                Return doc
            End If

        Catch ex As Exception
            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida.ToString() + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            Catch ex3 As Exception

            End Try

            Return doc
        End Try

        ' Verificar si esta autorizada o pagada la factura
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

            If tssfac.IDTipoFacura.ToUpper = "U" And tssfac.StatusGeneracion.ToUpper = "P" Then
                Throw New Exception("No Valida")
            End If


            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fue autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If tssfac.Estatus.ToUpper = "REVOCADA" Then
                Throw New Exception("Está Revocada")
            End If

            If tssfac.Estatus.ToUpper = "RECALCULADA" Then
                Throw New Exception("Está Recalculada")
            End If

            If tssfac.Estatus = "" Then
                Throw New Exception("Ya fue pagada")
            End If

        Catch ex As Exception
            Dim Retorno As String = ""

            If ex.Message = "No Valida" Then
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"

            Else
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>14</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.RefYaPagadaTSS.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            End If






            doc.LoadXml(Retorno)

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            Catch ex2 As Exception
            End Try

            Return doc
        End Try

        Me.myFact = New Empresas.Facturacion.FacturaSS(NroReferencia)

        Dim resultado As String = Me.myFact.AutorizarFactura(UserName)

        If resultado = "0" Then

            Dim ref As New Empresas.Facturacion.FacturaSS(NroReferencia)
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
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "A")
            Catch ex As Exception

            End Try

            Return doc
        Else

            Dim Retorno As String = ""

            If resultado = "999" Then
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>1</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.DebePagarAnterior + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            Else
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>1</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + resultado.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            End If

            doc.LoadXml(Retorno)

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            Catch ex As Exception

            End Try

            Return doc
        End If

    End Function
    ''
    <WebMethod(Description:="Metodo para autorizar una referencia de pago de la TSS. <br><br>" & _
   "Esta función devuelve un XML con el Numero de Autorización, en caso de que haya un error se devuelve el codigo mas la descripción." & _
   "<br> Se utiliza el monto para validar el monto total de la factura. " & _
   "<br><br> Los Errores que devuelve son: <br> " & _
   "a) <b>10</b>|Error en el Usuario o Password <br>" & _
   "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
   "c) <b>14</b>|Esta Referencia ya fue autorizada, pagada,recalculada o revocada. <br>" & _
   "d) <b>23</b>|Debe pagar las facturas anteriores primero <br>" & _
   "e) <b>22</b>|Monto de la referencia incorrecto <br>" & _
   "")> _
    Public Function AutorizarReferenciaExtMnt(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String, ByVal Monto As String) As System.Xml.XmlDocument

        ''SuirPlus.DataBase.OracleHelper.ExecuteNonQuery(CommandType.Text, "insert into dev(texto) values('" + UserName + " " + Password + " " + NroReferencia + "')")

        Dim ds As New DataSet
        Dim doc As New System.Xml.XmlDocument()
        Dim msgABC As String = ""

        If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then
            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>10</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Err.UsuarioPass.ToString() + " | " + msgABC + "</DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)

            ''Try
            Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            'Catch ex As Exception

            'End Try

            Return doc
            ''Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

            If tssfac.RNC.Length < 1 Then
                Dim Retorno As String = ""

                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "</DetalleAutorizacion>"

                doc.LoadXml(Retorno)

                Try
                    Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
                Catch ex As Exception

                End Try

                Return doc
            End If

        Catch ex As Exception
            Dim Retorno As String = ""

            Retorno = Retorno + "<DetalleAutorizacion>"
            Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
            Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida.ToString() + " </DescripcionMensaje>"
            Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
            Retorno = Retorno + "</DetalleAutorizacion>"

            doc.LoadXml(Retorno)

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            Catch ex3 As Exception

            End Try

            Return doc
        End Try

        ' Verificar si esta autorizada o pagada la factura
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)


            If tssfac.IDTipoFacura.ToUpper = "U" And tssfac.StatusGeneracion.ToUpper = "P" Then
                Throw New Exception("No Valida")
            End If

            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fue autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If tssfac.Estatus.ToUpper = "REVOCADA" Then
                Throw New Exception("Está Revocada")
            End If

            If tssfac.Estatus.ToUpper = "RECALCULADA" Then
                Throw New Exception("Está Recalculada")
            End If

            If tssfac.Estatus = "" Then
                Throw New Exception("Ya fue pagada")
            End If

            Try
                If tssfac.TotalGeneral <> Convert.ToDecimal(Monto) Then
                    Throw New Exception("Monto Incorrecto")
                End If
            Catch ex As Exception
                Throw New Exception("Monto Incorrecto")
            End Try

        Catch ex As Exception
            Dim Retorno As String = ""

            If ex.Message = "Monto Incorrecto" Then
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>22</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.MontoIncorrecto + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            ElseIf ex.Message = "No Valida" Then
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>13</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.RefNoValida + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            Else
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>14</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.RefYaPagadaTSS.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            End If



            doc.LoadXml(Retorno)

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            Catch ex2 As Exception
            End Try

            Return doc
        End Try

        Me.myFact = New Empresas.Facturacion.FacturaSS(NroReferencia)

        Dim resultado As String = Me.myFact.AutorizarFactura(UserName)

        If resultado = "0" Then

            Dim ref As New Empresas.Facturacion.FacturaSS(NroReferencia)
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
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "A")
            Catch ex As Exception

            End Try

            Return doc
        Else

            Dim Retorno As String = ""

            If resultado = "999" Then
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>23</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + Err.DebePagarAnterior + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            Else
                Retorno = Retorno + "<DetalleAutorizacion>"
                Retorno = Retorno + "<CodigoMensaje>1</CodigoMensaje>"
                Retorno = Retorno + "<DescripcionMensaje> " + resultado.ToString() + " </DescripcionMensaje>"
                Retorno = Retorno + "<NumeroAutorizacion></NumeroAutorizacion>"
                Retorno = Retorno + "<ValorPagado>0</ValorPagado>"
                Retorno = Retorno + "</DetalleAutorizacion>"
            End If

            doc.LoadXml(Retorno)

            Try
                Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Retorno, "E")
            Catch ex As Exception

            End Try

            Return doc
        End If

    End Function

    <WebMethod(Description:="Metodo para cancelar la autorización de una referencia de pago de la TSS. <br><br>" & _
    "Esta función devuelve un 0 en caso de que la referencia haya sido cancelada satisfactoriamente, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>15</b>|Esta Referencia ya fue reportada como pagada <br>" & _
    "d) <b>16</b>|Debe cancelarla el usuario que la autorizó <br>" & _
    "")> _
    Public Function CancelarAutorizacion(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As String

        If Seg.CheckUserPass(UserName, Password, IP) = False Then
            Return Err.UsuarioPass
        End If

        ' Verificar si existe la referencia
        Try

            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

            ' Verificar si esta pagada la factura
            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            ' Verifica si no es el mismo usuario
            'SI VIENE EN UN ROL ESPECIFICO , DEBE CONTINUAR DE LO CONTRARIO DEBE SER EL MISMO QUE LA AUTORIZO

            If Not SuirPlus.Seguridad.Autorizacion.isInRol(UserName, "58") Then
                If (CStr(UserName.ToString.ToUpper()) <> CStr(tssfac.UsuarioAutorizo.ToString.ToUpper())) Then
                    Throw New Exception("Usuario diferente")
                End If
            End If


            ' Dim algo As String = tssfac.TotalGeneralFormateadoC
            Dim resultado As String = tssfac.DesAutorizarFactura(UserName, Now())

            tssfac = Nothing

            If resultado = "0" Then
                Return resultado
            Else
                Return resultado
            End If

        Catch ex As Exception

            If ex.Message = "Ya fue pagada" Then
                Try
                    Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Err.RefYaPagada, "E")
                Catch ex12 As Exception
                    SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
                End Try

                Return Err.RefYaPagada
            ElseIf ex.Message = "Usuario diferente" Then

                Try
                    Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Err.UsuarioDiferente, "E")
                Catch ex12 As Exception
                    SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
                End Try

                Return Err.UsuarioDiferente
            Else

                Try
                    Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, Err.RefNoValida, "E")
                Catch ex12 As Exception
                    SuirPlus.Exepciones.Log.LogToDB(ex12.ToString())
                End Try

                Return Err.RefNoValida
            End If

        End Try

        ' Verificar si esta pagada la factura
        'Try
        'Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

        'If tssfac.Estatus = "PA" Then
        'Throw New Exception("Ya fue pagada")
        'End If

        'Catch ex As Exception
        'Return Err.RefYaRepPagada
        'End Try

        ' Verifica si es el mismo usuario
        'Try
        'Dim tssfact As New Empresas.Facturacion.FacturaSS(NroReferencia)
        'If (CStr(UserName.ToString()) <> CStr(tssfact.UsuarioAutorizo.ToString())) Then
        'Throw New Exception("Usuario Diferente")
        'End If
        'Catch ex As Exception
        'Return Err.UsuarioDiferente
        'End Try

        'Me.myFact = New Empresas.Facturacion.FacturaSS(NroReferencia)

        'Dim resultado As String = Me.myFact.DesAutorizarFactura(UserName, Now())

        'If resultado = "0" Then
        'Return resultado
        'Else
        'Return resultado
        'End If

    End Function

    <WebMethod(Description:="Consulta de notificaciones pendiente de pago por numero de referencia.<br><br>" & _
    "Esta función devuelve un dataset con el numero de referencia consultado, en caso de que haya un error se devuelve el codigo mas la descripción." & _
    "<br><br> Los Errores que devuelve son: <br> " & _
    "a) <b>10</b>|Error en el Usuario o Password <br>" & _
    "b) <b>13</b>|Esta Referencia no se encuentra en nuestras bases de datos <br>" & _
    "c) <b>14</b>|Esta Referencia ya fue autorizada, pagada,recalculada o revocada. <br>" & _
    "d) <b>25</b>|Tiene movimientos pendientes, debe entrar al SuirPlus y aplicarlos para proceder a pagar este Nro. de Referencia<br>" & _
    "e) <b>23</b>|Debe pagar las facturas anteriores primero <br>" & _
    "")> _
    Public Function ConsultaPorReferencia(ByVal UserName As String, ByVal Password As String, ByVal NroReferencia As String) As DataSet
        Dim ds As New DataSet("ConsultaPorReferencia")
        Dim msgABC As String = ""

        ' Verificar Usuario & Password
        If Seg.CheckUserPass(UserName, Password, msgABC, IP) = False Then

            Seg.AgregarMensajeDeError(ds, Err.UsuarioPass + msgABC)

            Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, "ConsultaPorReferencia: " + Err.UsuarioPass + msgABC, "E")

            Return ds

        End If

        ' Verificar si existe la referencia
        Try
            Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)


            If tssfac.IDTipoFacura.ToUpper = "U" And tssfac.StatusGeneracion.ToUpper = "P" Then
                Throw New Exception("No Valida")
            End If

            If tssfac.NroAutorizacion <> 0 Then
                Throw New Exception("Ya fué autorizada")
            End If

            If tssfac.Estatus.ToUpper = "PAGADA" Then
                Throw New Exception("Ya fue pagada")
            End If

            If tssfac.Estatus.ToUpper = "REVOCADA" Then
                Throw New Exception("Está Revocada")
            End If

            If tssfac.Estatus.ToUpper = "RECALCULADA" Then
                Throw New Exception("Está Recalculada")
            End If

            ' para ver si este empleador, dueño de la referencia consultada, tiene movimientos pendientes
            Dim emp As New SuirPlus.Empresas.Empleador(tssfac.RegistroPatronal)

            If Not emp.PermitirPago Then
                emp = Nothing
                Throw New Exception("Tiene movimientos pendientes")
            Else
                emp = Nothing
            End If


            Dim resultado As String = SuirPlus.Empresas.Facturacion.Factura.ValidarReferenciaAntigua(NroReferencia)

            If resultado = "999" Then
                Throw New Exception("Debe Pagar Anterior")
            End If

        Catch ex As Exception

            If ex.Message = "Ya fué autorizada" Then
                Seg.AgregarMensajeDeError(ds, Err.RefYaPagadaTSS)
            ElseIf ex.Message = "Ya fué pagada" Then
                Seg.AgregarMensajeDeError(ds, Err.RefYaPagadaTSS)
            ElseIf ex.Message = "Está Revocada" Then
                Seg.AgregarMensajeDeError(ds, Err.RefYaPagadaTSS)
            ElseIf ex.Message = "Está Recalculada" Then
                Seg.AgregarMensajeDeError(ds, Err.RefYaPagadaTSS)
            ElseIf ex.Message = "Tiene movimientos pendientes" Then
                Seg.AgregarMensajeDeError(ds, Err.MovimientosPendientes)
            ElseIf ex.Message = "Debe Pagar Anterior" Then
                Seg.AgregarMensajeDeError(ds, Err.DebePagarAnterior)
            Else
                Seg.AgregarMensajeDeError(ds, Err.RefNoValida)
            End If

            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Return ds

        End Try

        ' Verificar si esta autorizada o pagada la factura
        'Try
        'Dim tssfac As New Empresas.Facturacion.FacturaSS(NroReferencia)

        'If tssfac.NroAutorizacion <> 0 Then
        'Throw New Exception("Ya fué autorizada")
        'End If

        'If tssfac.Estatus.ToUpper = "PAGADA" Then
        'Throw New Exception("Ya fué pagada")
        'End If

        'If tssfac.Estatus.ToUpper = "CANCELADA" Then
        'Throw New Exception("Está cancelada")
        'End If

        'Catch ex As Exception
        'Seg.AgregarMensajeDeError(ds, Err.RefYaPagada)
        'Return ds
        'End Try

        'Return ds

        ds.Tables.Add(SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(Empresas.Facturacion.Factura.eConcepto.SDSS, "", NroReferencia, "").Copy())

        Try
            Bancos.TransaccionesIB.InsertarTransaccionIB(NroReferencia, Empresas.Facturacion.Factura.eConcepto.SDSS, UserName, Password, ds.GetXml, "A")
        Catch ex As Exception

        End Try

        Return ds



    End Function

    <WebMethod(Description:="Consulta de las notificaciones pendiente de pagos por RNC" & _
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
            ''Seg.AgregarMensajeDeError(ds, Err.RNCNoValido)
            Seg.AgregarErrorTecnico(ds, ex.ToString())
            Return ds
        End Try

        Try
            ''ds.Tables.Add(SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(Empresas.Facturacion.Factura.eConcepto.SDSS, RNC).Copy())
            ds.Tables.Add(SuirPlus.Empresas.Facturacion.Factura.getRefsDisponiblesParaPagoWS(RNC, Empresas.Facturacion.Factura.eConcepto.SDSS).Copy())
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
            ds.Tables.Add(SuirPlus.Empresas.Facturacion.Factura.getNotificacionesPendientePago(Empresas.Facturacion.Factura.eConcepto.SDSS, RNC, CodigoNomina).Copy())
        Catch ex As Exception
            Seg.AgregarMensajeDeError(ds, ex.ToString())
        End Try

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

        Try
            ds.Tables.Add(Empresas.Facturacion.Factura.getAutorizaciones(UserName, Referencia, Empresas.Facturacion.Factura.eConcepto.SDSS).Copy)
        Catch ex As Exception
            ds = New DataSet
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
        End If

        ds.Tables.Add(Empresas.Facturacion.Factura.getAutorizaciones(UserName, "", Empresas.Facturacion.Factura.eConcepto.SDSS).Copy)

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

        Return Err.HabilParaPagar

    End Function

End Class
