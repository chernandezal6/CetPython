Imports System.Data
Imports SuirPlus
Imports SuirPlus.Utilitarios.Utils


Partial Class Consultas_consPin
    Inherits BasePage




    Private Sub ListarRepresentacionLocal()
        Dim dtMDT As DataTable

        Try
            dtMDT = SuirPlus.MDT.General.listarRepresentacionLocal()

            If dtMDT.Rows.Count > 0 Then

                Me.ddlRepresentacionLocal.DataSource = dtMDT
                Me.ddlRepresentacionLocal.DataValueField = "ID_REPRESENTANTE"
                Me.ddlRepresentacionLocal.DataTextField = "DESCRIPCION_REPRESENTACION"
                Me.ddlRepresentacionLocal.DataBind()
                Me.ddlRepresentacionLocal.Items.Insert(0, New ListItem("--Seleccione--", "0"))

            Else
                Me.ddlRepresentacionLocal.Items.Add("error al cargar la data")
            End If

        Catch ex As Exception
            Me.LblError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub Page_Load1(sender As Object, e As System.EventArgs) Handles Me.Load
        If Not Me.IsInPermiso("351") Then
            fldPin.Visible = False
            Lblmsjerror.Visible = True
            Lblmsjerror.Text = "No tiene permisos para visualizar esta consulta"
            Exit Sub
        End If
        If Not Page.IsPostBack Then
            ListarRepresentacionLocal()
        End If



    End Sub

    Protected Sub BindDatosGenerales()
        Dim dtDatos As DataTable

        Try
            dtDatos = SuirPlus.MDT.General.getInformacionPin(txtNroRecibo.Text, txtCodigoAprobacion.Text, ddlRepresentacionLocal.Text)
            If dtDatos.Rows.Count > 0 Then
                LblMonto.Text = Me.formateaSalario(dtDatos.Rows(0)("MONTO").ToString)
                LblBalance.Text = Me.formateaSalario(dtDatos.Rows(0)("BALANCE").ToString)
                lblRazonSocial.Text = dtDatos.Rows(0)("RAZON_SOCIAL").ToString
                lblStatusPin.Text = dtDatos.Rows(0)("STATUS").ToString
                lblFecha.Text = String.Format("{0:d}", dtDatos.Rows(0)("FECHA_VENTA"))
                divInfoPin.Visible = True
                tblInfoPin.Visible = True

            Else
                divInfoPin.Visible = False
                tblInfoPin.Visible = False
                LblError.Visible = True
                LblError.Text = "No existen criterio para esta busqueda"
            End If
        Catch ex As Exception
            LblError.Visible = True
            Me.LblError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As System.EventArgs) Handles btnBuscar.Click
        BindDatosGenerales()
        BindGridHistorial()
    End Sub

    Protected Sub BtnLimpiar_Click(sender As Object, e As System.EventArgs) Handles BtnLimpiar.Click
        Response.Redirect("consPin.aspx")
    End Sub


    Protected Sub BindGridHistorial()

        Dim dtHistorial As DataTable
        Try
            dtHistorial = SuirPlus.MDT.General.getHistorialPin(txtNroRecibo.Text, txtCodigoAprobacion.Text)

            If dtHistorial.Rows.Count > 0 Then
                Me.gvHistorial.DataSource = dtHistorial
                Me.gvHistorial.DataBind()
                divHistorialPin.Visible = True
            Else
                divHistorialPin.Visible = False
            End If
            dtHistorial = Nothing



        Catch ex As Exception
            LblError.Visible = True
            Me.LblError.Text = ex.Message
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try


    End Sub
    Protected Function formateaPeriodo(ByVal Periodo As Object) As String
        If Not IsDBNull(Periodo) Then
            Return Utilitarios.Utils.FormateaPeriodo(Periodo)
        Else
            Return String.Empty
        End If
    End Function

    Protected Function formateaReferencia(ByVal nroReferencia As Object) As String
        If Not IsDBNull(nroReferencia) Then
            Return Utilitarios.Utils.FormateaReferencia(nroReferencia)
        Else
            Return String.Empty
        End If
    End Function
    Public Function formateaSalario(ByVal salario As String) As String
        Dim salFormatear As Double
        Dim res As String

        If Not IsNumeric(salario) Then
            Return salario
        Else
            salFormatear = CDbl(salario)
            res = String.Format("{0:c}", salFormatear)
            Return res
        End If



    End Function
End Class
