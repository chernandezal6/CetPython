Imports System.Data

Partial Class Mantenimientos_insertupdateParametros
    Inherits BasePage

    Protected Sub Page_Load1(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        If Not IsPostBack Then
            bindDrpParametros()
        End If

        Me.lblError.Text = String.Empty

    End Sub

    Private Sub bindDrpParametros()

        'Llenamos el listbox de parametros
        Me.drpParametro.DataSource = SuirPlus.Mantenimientos.Parametro.getParametros(-1)
        Me.drpParametro.DataTextField = "parametro_des"
        Me.drpParametro.DataValueField = "id_parametro"
        Me.drpParametro.DataBind()

        'Agregamos un nuevo item con valor 0
        Me.drpParametro.Items.Add(New ListItem("Nuevo...", "0"))
        Me.drpParametro.SelectedValue = "0"

    End Sub

    Protected Sub btnGrabar_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGrabar.Click

        Me.lblError.CssClass = "error"
        'Si el selected value es 0 entonces creamos un nuevo parametro
        If Me.drpParametro.SelectedValue = "0" Then
            Dim result As String
            Try
                result = SuirPlus.Mantenimientos.Parametro.nuevoParametro(Me.txtDescripcion.Text, _
                                                                          Me.drpTipoParam.SelectedValue, _
                                                                          Me.txtTipoCalculo.Text, _
                                                                          Me.UsrUserName)

                'Llenamos el list para que se vea el nuevo parametro creado
                bindDrpParametros()
                Me.drpParametro.SelectedValue = result
                Me.btnGrabarDetalle.Enabled = True
            Catch ex As Exception
                Me.lblError.Text = "Error mientras se crea el parámetro."
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try
        Else
            'De lo contrario actualizamos el seleccionado.
            Dim param As New SuirPlus.Mantenimientos.Parametro(Convert.ToInt32(Me.drpParametro.SelectedValue))
            param.Descripcion = Me.txtDescripcion.Text
            param.TipoParametro = Me.drpTipoParam.SelectedValue.ToString
            param.TipoCalculo = Me.txtTipoCalculo.Text
            Try
                param.GuardarCambios(Me.UsrUserName)
                Me.lblError.CssClass = "succes"
                Me.lblError.Text = "Proceso realizado satisfactoriamente"
            Catch ex As Exception
                Me.lblError.Text = "Error mientras se actualiza el parámetro. " & ex.ToString
                Me.lblError.CssClass = "error"
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
                Exit Sub
            End Try

            'Llenamos el List para presentar el parametro actualizado
            bindDrpParametros()
            'Y seleccionamos el parametro con el que se esta trabajando.
            Me.drpParametro.SelectedValue = param.IDParametro

        End If

    End Sub

    Private Sub drpParametro_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles drpParametro.SelectedIndexChanged

        If drpParametro.SelectedValue <> "0" Then

            Dim param As New SuirPlus.Mantenimientos.Parametro(Convert.ToInt32(Me.drpParametro.SelectedValue))
            Me.txtDescripcion.Text = param.Descripcion
            Me.drpTipoParam.SelectedValue = UCase(Left(param.TipoParametro, 1))
            Me.txtTipoCalculo.Text = param.TipoCalculo

            Me.dgDetalleParametros.DataSource = SuirPlus.Mantenimientos.Parametro.getDetalleParametros(param.IDParametro)
            Me.dgDetalleParametros.DataBind()
            Me.dgDetalleParametros.Visible = True
            Me.btnGrabarDetalle.Enabled = True

        Else

            Me.txtDescripcion.Text = String.Empty
            Me.txtTipoCalculo.Text = String.Empty
            Me.dgDetalleParametros.Visible = False
            Me.btnGrabarDetalle.Enabled = False

        End If

        Me.txtFechaIni.Text = String.Empty
        Me.txtFechaFin.Text = String.Empty
        Me.txtValorFecha.Text = String.Empty
        Me.txtValorTex.Text = String.Empty
        Me.txtValorNum.Text = String.Empty

    End Sub

    Protected Sub btnGrabarDetalle_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnGrabarDetalle.Click

        Me.lblError.CssClass = "error"
        Dim idParametro As Integer = Convert.ToInt32(Me.drpParametro.SelectedValue)

        Try
            If (getFechaParaProcedimiento(Me.txtFechaIni.Text) = String.Empty) Then
                Me.lblError.Text = "El Parametro debe tener una fecha de inicio obligatoria."
                Exit Sub
            End If
            SuirPlus.Mantenimientos.Parametro.nuevoDetParametro(idParametro, getFechaParaProcedimiento(Me.txtFechaIni.Text), _
                                                                             getFechaParaProcedimiento(Me.txtFechaFin.Text), _
                                                                             getFechaParaProcedimiento(Me.txtValorFecha.Text), _
                                                                             If(Me.txtValorNum.Text = String.Empty, "0.0", txtValorNum.Text), _
                                                                             Me.txtValorTex.Text, _
                                                                             Left(Me.drpAutorizado.SelectedValue, 1), _
                                                                             Me.UsrUserName)
        Catch ex As Exception
            Me.lblError.Text = "Error mientras se crea el detalle del parametro"
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Exit Sub
        End Try

        Me.dgDetalleParametros.DataSource = SuirPlus.Mantenimientos.Parametro.getDetalleParametros(idParametro)
        Me.dgDetalleParametros.DataBind()
        Me.dgDetalleParametros.Visible = True

        Me.lblError.CssClass = "succes"
        Me.lblError.Text = "Proceso realizado satisfactoriamente en el detalle."


        Me.btnLimpiar_Click(sender, e)

    End Sub

    Protected Sub dgDetalleParametros_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles dgDetalleParametros.RowCreated

        If e.Row.RowType = DataControlRowType.DataRow Then

            CType(e.Row.FindControl("imgBtReseteo"), ImageButton).CommandArgument = e.Row.RowIndex

        End If

    End Sub

    Private Function getFechaParaProcedimiento(ByVal fecha As String) As String

        If fecha = String.Empty Or fecha = "" Then
            Return String.Empty
        End If

        fecha = fecha.Replace("/", String.Empty)
        Dim fechaCompleta As String

        Dim dia As String = fecha.Substring(0, 2)
        Dim mes As String = fecha.Substring(2, 2)
        Dim anio As String = fecha.Substring(4, 4)

        fechaCompleta = mes & "/" & dia & "/" & anio

        Return fechaCompleta

    End Function

    Private Function getFechaParaPresentar(ByVal fecha As String) As String

        If fecha = String.Empty Or fecha = "" Then
            Return String.Empty
        End If

        fecha = fecha.Replace("/", String.Empty)
        Dim fechaCompleta As String

        Dim mes As String = fecha.Substring(0, 2)
        Dim dia As String = fecha.Substring(2, 2)
        Dim anio As String = fecha.Substring(4, 4)

        fechaCompleta = dia & "/" & mes & "/" & anio

        Return fechaCompleta

    End Function

    Protected Sub btnLimpiar_Click(ByVal sender As Object, ByVal e As System.EventArgs)
        Me.txtFechaIni.Text = String.Empty
        Me.txtFechaFin.Text = String.Empty
        Me.txtValorFecha.Text = String.Empty
        Me.txtValorNum.Text = String.Empty
        Me.txtValorTex.Text = String.Empty
        Me.dgDetalleParametros.SelectedIndex = -1
    End Sub

    Protected Sub dgDetalleParametros_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs)

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Me.dgDetalleParametros.SelectedIndex = index

        Me.txtFechaIni.Text = IIf(dgDetalleParametros.Rows(index).Cells(0).Text = "&nbsp;", String.Empty, dgDetalleParametros.Rows(index).Cells(0).Text)
        Me.txtFechaFin.Text = IIf(dgDetalleParametros.Rows(index).Cells(1).Text = "&nbsp;", String.Empty, dgDetalleParametros.Rows(index).Cells(1).Text)
        Me.txtValorFecha.Text = IIf(dgDetalleParametros.Rows(index).Cells(2).Text = "&nbsp;", String.Empty, dgDetalleParametros.Rows(index).Cells(2).Text)
        Me.txtValorNum.Text = IIf(dgDetalleParametros.Rows(index).Cells(3).Text = "&nbsp;", String.Empty, dgDetalleParametros.Rows(index).Cells(3).Text)
        Me.txtValorTex.Text = IIf(dgDetalleParametros.Rows(index).Cells(4).Text = "&nbsp;", String.Empty, dgDetalleParametros.Rows(index).Cells(4).Text)

    End Sub

    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs) Handles btnCancelar.Click
        drpParametro.SelectedValue = 0
        txtDescripcion.Text = ""
        drpTipoParam.SelectedValue = 0
        txtTipoCalculo.Text = ""
        dgDetalleParametros.Visible = False
    End Sub
End Class