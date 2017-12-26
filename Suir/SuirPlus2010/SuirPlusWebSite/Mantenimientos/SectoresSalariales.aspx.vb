Imports SuirPlus
Imports System.Data

Partial Class Mantenimientos_SectoresSalariales
    Inherits BasePage

    Protected Sub Mantenimientos_SectoresSalariales_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        If Not Page.IsPostBack Then
            CargarSectoresSalariales()
        End If
    End Sub

    Protected Sub btn_cancelar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_cancelar.Click
        Response.Redirect("SectoresSalariales.aspx")
    End Sub

    Protected Sub CargarSectoresSalariales()
        Dim dt As DataTable
        Try
            dt = Mantenimientos.SectoresSalariales.getSectoresSalariales()
            ddl_sectores_salarial.DataTextField = "descripcion"
            ddl_sectores_salarial.DataValueField = "id"
            ddl_sectores_salarial.DataSource = dt
            ddl_sectores_salarial.DataBind()
            ddl_sectores_salarial.Items.Insert(0, New ListItem("<-- Seleccione -->", "-1"))
        Catch ex As Exception
            lbl_error.Visible = True
            lbl_error.Text = ex.Message
        End Try
    End Sub

    Protected Sub btn_nuevo_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_nuevo.Click
        Me.txt_descripcion.Text = String.Empty
        Me.tr_agregar.Visible = True
        Me.tr_mostrar.Visible = False
        Me.btn_grabar.Visible = True
        Me.btn_nuevo.Visible = False
        Me.btn_cancelar.Visible = True
        fsEscalaSalarial.Visible = False
    End Sub

    Protected Sub activarSectores()
        Me.tr_agregar.Visible = False
        Me.tr_mostrar.Visible = True
        Me.btn_grabar.Visible = False
        Me.btn_nuevo.Visible = True
        Me.btn_cancelar.Visible = False

    End Sub

    Protected Sub btn_grabar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_grabar.Click
        Try
            If txt_descripcion.Text <> String.Empty Then
                Mantenimientos.SectoresSalariales.NuevoSectorSalarial(txt_descripcion.Text, UsrUserName)
                CargarSectoresSalariales()
                activarSectores()
            Else
                lbl_error.Visible = True
                lbl_error.Text = "El Sector Salarial es requerido."
            End If
        Catch ex As Exception
            lbl_error.Visible = True
            lbl_error.Text = ex.Message
        End Try
    End Sub

    Protected Sub btn_cancelar_det_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_cancelar_det.Click
        Limpiar()
    End Sub

    Protected Sub Limpiar()
        txt_inicio.Text = String.Empty
        txt_final.Text = String.Empty
        txt_salario.Text = String.Empty
        lbl_error.Text = String.Empty

    End Sub

    Protected Sub btn_agregar_Click(ByVal sender As Object, ByVal e As System.EventArgs) Handles btn_agregar.Click
        Try
            If (ddl_sectores_salarial.SelectedIndex > 0) And (txt_inicio.Text <> String.Empty) And (txt_salario.Text <> String.Empty) Then
                Mantenimientos.SectoresSalariales.NuevaEscalaSalarial(ddl_sectores_salarial.SelectedValue, txt_inicio.Text, txt_final.Text, txt_salario.Text, UsrUserName)
                CargarEscalasSalariales()
                Limpiar()
            Else
                lbl_error.Visible = True
                lbl_error.Text = "El sector salarial, la fecha inicio y el salario son requeridos."
            End If


        Catch ex As Exception
            lbl_error.Visible = True
            lbl_error.Text = ex.Message
        End Try
    End Sub

    Protected Sub CargarEscalasSalariales()
        Dim dt As DataTable
        Try
            dt = Mantenimientos.SectoresSalariales.getEscalasSalariales(CInt(ddl_sectores_salarial.SelectedValue))
            If dt.Rows.Count > 0 Then
                gvEscalasSalariales.SelectedIndex = -1
                gvEscalasSalariales.DataSource = dt
                gvEscalasSalariales.DataBind()

            Else
                gvEscalasSalariales.DataSource = Nothing
                gvEscalasSalariales.DataBind()

            End If
        Catch ex As Exception
            lbl_error.Visible = True
            lbl_error.Text = ex.Message
        End Try
    End Sub

    Protected Sub ddl_sectores_salarial_SelectedIndexChanged(ByVal sender As Object, ByVal e As System.EventArgs) Handles ddl_sectores_salarial.SelectedIndexChanged

        CargarEscalasSalariales()
        fsEscalaSalarial.Visible = True
        Limpiar()
    End Sub

    Protected Sub gvEscalasSalariales_RowCreated(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewRowEventArgs) Handles gvEscalasSalariales.RowCreated
        If e.Row.RowType = DataControlRowType.DataRow Then

            CType(e.Row.FindControl("ibEditar"), ImageButton).CommandArgument = e.Row.RowIndex

        End If
    End Sub


    Protected Sub gvEscalasSalariales_RowCommand(ByVal sender As Object, ByVal e As System.Web.UI.WebControls.GridViewCommandEventArgs) Handles gvEscalasSalariales.RowCommand

        Dim index As Integer = Convert.ToInt32(e.CommandArgument)
        Me.gvEscalasSalariales.SelectedIndex = index

        Me.txt_inicio.Text = IIf(gvEscalasSalariales.Rows(index).Cells(1).Text = "&nbsp;", String.Empty, gvEscalasSalariales.Rows(index).Cells(1).Text)
        Me.txt_final.Text = IIf(gvEscalasSalariales.Rows(index).Cells(2).Text = "&nbsp;", String.Empty, gvEscalasSalariales.Rows(index).Cells(2).Text)
        'Me.txt_salario.Text = IIf(gvEscalasSalariales.Rows(index).Cells(4).Text = "&nbsp;", String.Empty, gvEscalasSalariales.Rows(index).Cells(4).Text)

        Dim lblSal As Label = CType(gvEscalasSalariales.Rows(index).FindControl("lblSalarioMin"), Label)
        txt_salario.Text = lblSal.Text

    End Sub


End Class
