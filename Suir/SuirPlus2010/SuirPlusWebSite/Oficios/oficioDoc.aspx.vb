
Partial Class Oficios_oficioDoc1
    Inherits System.Web.UI.Page


    Private Sub Page_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load

        If Request("codOficio") Is Nothing Or Request("codOficio") = "" Then
            Response.Write("Oficio no suministrado...")
            Response.End()
        End If


        If Not IsPostBack Then

            Dim tmpOfc As SuirPlus.Empresas.Oficio = Nothing

            Try

                tmpOfc = New SuirPlus.Empresas.Oficio(Request("codOficio"))

            Catch ex As Exception
                Response.Write(ex)
                Response.Write("Oficio no suministrado...")
                Response.End()
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString())
            End Try

            Dim tmpStr As String = ""

            Dim oficioconf As New SuirPlus.Config.Configuracion(SuirPlus.Config.ModuloEnum.Oficios)

            Me.lblTesorero.Text = oficioconf.Field1
            Me.lblTesoreroPuesto.Text = oficioconf.Field3

            Me.lblUsuario.Text = Microsoft.VisualBasic.StrConv(tmpOfc.NombreUsuarioSolicita, VbStrConv.ProperCase)
            Me.lblDpto.Text = tmpOfc.Departamento
            Me.lblAccion.Text = tmpOfc.AccionDes
            Me.lblNoOficio.Text = tmpOfc.IdOficio
            Me.lblFecha.Text = tmpOfc.FechaSolicita
            Me.lblObservaciones.Text = tmpOfc.ObsSolicita

            Me.lblTextoAccion.Text = tmpOfc.TextoAccion
            Me.lblTextoMotivo.Text = tmpOfc.TextoMotivo

            If tmpOfc.IdAccion = 1 Then
                Me.lblTextoMotivo.Text = Me.lblTextoMotivo.Text & "<b><br><br> Recargos recalculados hasta el periodo " & Right(tmpOfc.PeriodoFinProceso.ToString(), 2) & "-" & Left(tmpOfc.PeriodoFinProceso.ToString(), 4) & ".</b>"

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir '"Firmado y Sellado por el Dpto. de Control y Análisis de las Operaciones"
            End If

            If tmpOfc.IdAccion = 1 Or tmpOfc.IdAccion = 2 Or tmpOfc.IdAccion = 3 Or tmpOfc.IdAccion = 7 Then
                Me.dlNotificaciones.DataSource = tmpOfc.Detalle
                Me.dlNotificaciones.DataBind()
            End If


            If tmpOfc.Status = "C" Then Me.lblEstatus.Text = tmpOfc.DescStatus

            Me.lblAutorizadoPor.Text = oficioconf.Field3

            If (tmpOfc.IdAccion = 2) Then
                Me.pnlDetalle.Visible = True

                Me.lblAutorizadoPor.Visible = True
                Me.lblAutorizadoPor.Text = oficioconf.Field3

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True
                'Me.lblRevisadoPorBE.Visible = False

                'Me.lblProcesadoPorBE.Visible = False
                Me.lblprocesadoPor.Text = oficioconf.PROG_Mails
                Me.lblprocesadoPor.Visible = True
            ElseIf (tmpOfc.IdAccion = 3) Then
                Me.pnlDetalle.Visible = True

                Me.lblAutorizadoPor.Visible = True
                Me.lblAutorizadoPor.Text = oficioconf.Field3
                'Me.lblAutorizadoPorBE.Visible = False

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True
                'Me.lblRevisadoPorBE.Visible = False

                'Me.lblProcesadoPorBE.Visible = False
                Me.lblprocesadoPor.Text = oficioconf.PROG_Mails
                Me.lblprocesadoPor.Visible = True

            ElseIf (tmpOfc.IdAccion = 4) Then
                Me.pnlDetalle.Visible = False

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True

                Me.lblprocesadoPor.Text = oficioconf.PROG_Mails
                Me.lblprocesadoPor.Visible = True
                'Me.lblProcesadoPor3.Visible = False
            ElseIf (tmpOfc.IdAccion = 5) Then
                Me.pnlDetalle.Visible = False

                'Me.lblProcesadoPor3.Visible = True
                Me.lblprocesadoPor.Text = oficioconf.Other1_Mails
                Me.lblprocesadoPor.Visible = True
                'Me.lblprocesadoPor.Visible = False

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True

            ElseIf (tmpOfc.IdAccion = 6) Then
                Me.pnlDetalle.Visible = False

                'Me.lblProcesadoPor3.Visible = True
                Me.lblprocesadoPor.Text = oficioconf.Other1_Mails
                Me.lblprocesadoPor.Visible = True
                'Me.lblprocesadoPor.Visible = False

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True

            ElseIf (tmpOfc.IdAccion = 7) Then
                Me.pnlDetalle.Visible = True

                'Me.lblRevisadoPorBE.Visible = True
                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True
                Me.labelRevisadoPor.Visible = True

                'Me.lblProcesadoPorBE.Visible = True
                Me.lblprocesadoPor.Text = oficioconf.Other3_Mails
                Me.lblprocesadoPor.Visible = True


                Me.lblAutorizadoPor.Text = oficioconf.Field3
                Me.lblAutorizadoPor.Visible = True

            ElseIf (tmpOfc.IdAccion = 8) Then
                Me.pnlDetalle.Visible = False

                'Me.lblprocesadoPor.Visible = False
                'Me.lblAutorizadoPor.Visible = False
                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir '"Firmado y Sellado por Control y Análisis de las Operaciones"
                Me.lblRevisadoPor.Visible = True
                'Me.lblRevisadoPorBE.Visible = True


                'Me.lblAutorizadoPorBE.Visible = True
                Me.lblAutorizadoPor.Text = oficioconf.Other3_DIR
                Me.lblAutorizadoPor.Visible = True


                'Me.lblProcesadoPorBE.Visible = True
                Me.lblprocesadoPor.Text = oficioconf.Other3_Mails
                Me.lblprocesadoPor.Visible = True
            ElseIf (tmpOfc.IdAccion = 9) Or (tmpOfc.IdAccion = 10) Or (tmpOfc.IdAccion = 11) Or (tmpOfc.IdAccion = 12) Or
                (tmpOfc.IdAccion = 13) Or (tmpOfc.IdAccion = 14) Or (tmpOfc.IdAccion = 15) Then
                Me.pnlDetalle.Visible = False

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True

                Me.lblprocesadoPor.Text = oficioconf.PROG_Mails
                Me.lblprocesadoPor.Visible = True

            Else
                Me.pnlDetalle.Visible = True
                'Me.lblProcesadoPor3.Visible = False
                Me.lblprocesadoPor.Text = oficioconf.PROG_Mails
                Me.lblprocesadoPor.Visible = True

                Me.lblRevisadoPor.Text = oficioconf.ArchivesDir
                Me.lblRevisadoPor.Visible = True

            End If


        End If


    End Sub

    Private Function getTextoAccion(ByVal textoAccion As String, ByVal razonSocial As String, ByVal rnc As String) As String

        Dim tmpStr As String = Replace(textoAccion, "%RAZON_SOCIAL%", "<b>" + razonSocial + "</b>")
        tmpStr = Replace(tmpStr, "%RNC/CEDULA%", "<b>" + rnc + "</b>")

        Return tmpStr

    End Function

End Class
