Imports System.Data

Partial Class EstadisticasGenerales
    Inherits System.Web.UI.Page

    Dim InfoEstadisticasGenerales As New Info

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        'Cargar las estadisticas generales

        Try

            Me.CargarDS()

        Catch ex As Exception
            Me.lblMsg.Text = ex.Message

        End Try

    End Sub

    Protected Sub CargarDS()
        Try

            Dim dsAfiliados As New DataSet
            Dim dsTrabajadores As New DataSet
            Dim dsEmpresas As New DataSet
            Dim dsEmpresasAP As New DataSet


            'Obtenemos la Cantidad de trabajadores (distintos) por los cuales se ha pagado Salud.
            dsAfiliados = Nothing
            dsAfiliados = InfoEstadisticasGenerales.getData(InfoEstadisticasGenerales.sSQLAfiliadosSfsPA)

            Me.lblDescripcionSFS.Text = dsAfiliados.Tables(0).Rows(0)(0).ToString
            Me.lblAfiliadosSFS.Text = FormatNumber(dsAfiliados.Tables(0).Rows(0)(1).ToString, 0)


            'Obtenemos la Cantidad de trabajadores que tienen en nomina las empresas que se han acogido a la Ley 189-07.
            dsTrabajadores = Nothing
            dsTrabajadores = InfoEstadisticasGenerales.getData(InfoEstadisticasGenerales.sSQLTraEnLey18907)

            Me.lblDescripcionTrab.Text = dsTrabajadores.Tables(0).Rows(0)(0).ToString
            Me.lblTrabajadores.Text = FormatNumber(dsTrabajadores.Tables(0).Rows(0)(1).ToString, 0)

            'Obtenemos la Cantidad de empresas acogidas a la Ley 189-07.
            dsEmpresas = Nothing
            dsEmpresas = InfoEstadisticasGenerales.getData(InfoEstadisticasGenerales.sSQLEmpEnLey18907)

            Me.lblDescripcionEmp.Text = dsEmpresas.Tables(0).Rows(0)(0).ToString
            Me.lblEmpresas.Text = FormatNumber(dsEmpresas.Tables(0).Rows(0)(1).ToString, 0)


            'Obtenemos la Cantidad de empresas acogidas a la Ley 189-07 que tienen acuerdo de pago.
            dsEmpresasAP = Nothing
            dsEmpresasAP = InfoEstadisticasGenerales.getData(InfoEstadisticasGenerales.sSQLEmpEnLey18907ConAP)

            Me.lblDescripcionEmpAp.Text = dsEmpresasAP.Tables(0).Rows(0)(0).ToString
            Me.lblEmpresasAP.Text = FormatNumber(dsEmpresasAP.Tables(0).Rows(0)(1).ToString, 0)

        Catch ex As Exception
            Throw ex
        End Try

    End Sub

End Class
