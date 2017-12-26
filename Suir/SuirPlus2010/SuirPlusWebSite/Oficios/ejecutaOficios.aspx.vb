Imports SuirPlus
Partial Class Oficios_ejecutaOficios
    Inherits BasePage
    Private Property RegPatRep() As Integer
        Get
            If ViewState("RegPatRep") Is Nothing Then
                Return -1
            Else
                Return ViewState("RegPatRep")
            End If
        End Get
        Set(ByVal value As Integer)
            ViewState("RegPatRep") = value
        End Set
    End Property
    Private Sub btnCancelarOficio_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelarOficio.Click
        Me.buscaOficio()
    End Sub

    Private Sub buscaOficio()

        Dim tmpOfc As SuirPlus.Empresas.Oficio

        Try
            tmpOfc = New SuirPlus.Empresas.Oficio(Me.txtCodOficio.Text)

        Catch ex As Exception

            Me.lblMsg.Text = "Este oficio no fue encontrado."
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            Return
        End Try

        'Validando el estatus
        If tmpOfc.Status = "C" Then
            Me.lblMsg.Text = "Este oficio fue cancelado por " & tmpOfc.NombreUsuarioProcesa & ", en fecha " & tmpOfc.FechaProcesa.ToShortDateString()
            Return
        ElseIf tmpOfc.Status = "A" Then
            Me.lblMsg.Text = "Este oficio fue procesado por " & tmpOfc.NombreUsuarioProcesa & ", en fecha " & tmpOfc.FechaProcesa.ToShortDateString()
            Return
        End If

        Me.pnlForm.Visible = False
        Me.pnlResult.Visible = True

        Me.lblAccion.Text = tmpOfc.AccionDes
        Me.lblGeneradoPor.Text = tmpOfc.NombreUsuarioSolicita
        Me.lblOficioNo.Text = tmpOfc.IdOficio
        Me.lblRazonSocial.Text = tmpOfc.RazonSocial
        Me.lblObsSol.Text = tmpOfc.ObsSolicita
        Me.RegPatRep = tmpOfc.IdRegistroPatronal

        If tmpOfc.IdAccion = 8 Then
            CargarRepresentante(tmpOfc.IdRegistroPatronal)
        End If

    End Sub


    Private Sub CargarRepresentante(ByVal RegPatronal As Integer)
        Me.gvRepresentante.DataSource = Empresas.Representante.getRepresentanteLista(RegPatronal)
        Me.gvRepresentante.DataBind()

        If gvRepresentante.Rows.Count > 0 Then
            tblRepresentantes.Visible = True
        End If

    End Sub

    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        Me.lblMsg.Text = ""
        Me.lblMsg.ForeColor = Drawing.Color.Red

        'btnCancelarOficio2.Attributes.Add("onclick", "this.disabled=true;" + ClientScript.GetPostBackEventReference(btnCancelarOficio2, "").ToString())


        If Not IsPostBack Then Me.iniForm()

    End Sub

    Private Sub iniForm()

        Me.pnlForm.Visible = True
        Me.pnlResult.Visible = False
        Me.txtCodOficio.Text = ""
        Me.txtObs.Text = ""
        Me.btnCancelarOficio2.Enabled = True

    End Sub

    Private Sub btnCancelar2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelar2.Click, btnCancelar.Click
        Me.iniForm()

    End Sub

    Private Sub btnCancelarOficio2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles btnCancelarOficio2.Click
        'Validar que se haya seleccionado un representante si es un oficio de alta
        If gvRepresentante.Rows.Count > 0 Then
            Dim isSelect As Boolean = False
            For Each row As GridViewRow In gvRepresentante.Rows
                If CType(row.FindControl("chkActivar"), CheckBox).Checked = True Then
                    isSelect = True
                End If
            Next

            If isSelect = False Then
                lblMsg.Text = "Debe activar un representante para poder dar de alta a este empleador."
                Exit Sub
            End If
        End If



        btnCancelarOficio2.Enabled = False
        Dim str As String = String.Empty

        Try

            str = SuirPlus.Empresas.Oficio.aplicaOficio(Me.lblOficioNo.Text, Me.UsrUserName.ToUpper, Me.txtObs.Text, Me.GetIPAddress())

            If Split(str, "|")(0) = "0" Then
                Dim result As String

                'Si es Alta empleador activamos los representantes
                If gvRepresentante.Rows.Count > 0 Then
                    For Each row As GridViewRow In gvRepresentante.Rows
                        Dim isActivo As String = "I"
                        If CType(row.FindControl("chkActivar"), CheckBox).Checked = True Then
                            isActivo = "A"
                        End If

                        result = Empresas.Representante.ActivarRepresentante(Me.UsrUserName, CType(row.FindControl("lblNssRep"), Label).Text, Me.RegPatRep, isActivo)
                    Next
                End If

                iniForm()
                Me.lblMsg.Text = Split(str, "|")(1)
                Me.lblMsg.ForeColor = Drawing.Color.Blue

            Else
                Me.lblMsg.Text = Split(str, "|")(1)
            End If

        Catch ex As Exception
            SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
        End Try

    End Sub

End Class
