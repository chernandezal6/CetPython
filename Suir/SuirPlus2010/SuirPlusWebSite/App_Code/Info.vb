Imports System.Data

Public Class Info
    Private oConnString As String = getConnString()


    Public sSQLBancoTSS As String = "Select Banco, Total, Facturas from sfc_est_por_banco where TIPO = 'TSS' and Facturas > 0"
    Public sSQLBancoTSS2 As String = "Select Banco, Total, Facturas from sfc_est_por_banco_2 where TIPO = 'TSS' and Facturas > 0 And fecha_registro = trunc(sysdate) order by  Total desc"

    Public sSQLBancoISR As String = "Select Banco, Total, Facturas from sfc_est_por_banco where TIPO = 'ISR' and Facturas > 0"
    Public sSQLBancoIR17 As String = "Select Banco, Total, Facturas from sfc_est_por_banco where TIPO = 'IR17' and Facturas > 0"
    Public sSQLBancoINF As String = "Select Banco, Total, Facturas from sfc_est_por_banco where TIPO = 'INF' and Facturas > 0"

    Public sSQLHoraTSS As String = "Select Hora, Total, Facturas from sfc_est_por_hora where Tipo = 'TSS' and Facturas > 0"
    Public sSQLHoraTSS2 As String = "Select Hora, Total, Facturas from sfc_est_por_hora_2 where Tipo = 'TSS' and Facturas > 0 and fecha_registro = trunc(sysdate) order by to_date(substr(hora,1,8),'HH:MI AM')"
    Public sSQLHoraISR As String = "Select Hora, Total, Facturas from sfc_est_por_hora where Tipo = 'ISR' and Facturas > 0"
    Public sSQLHoraIR17 As String = "Select Hora, Total, Facturas from sfc_est_por_hora where Tipo = 'IR17' and Facturas > 0"
    Public sSQLHoraINF As String = "Select Hora, Total, Facturas from sfc_est_por_hora where Tipo = 'INF' and Facturas > 0"

    Public sSQLopSolAE As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'C' and Cantidad > 0"
    Public sSQLopSolMov As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'D' and Cantidad > 0"
    Public sSQLopSolEmp As String = "select INITCAP(Descripcion)Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'E' and Cantidad > 0"
    Public sSQLopSolCer As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'F' and Cantidad > 0"

    Public sSQLopSolWTSS As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'A' and Cantidad > 0 order by cantidad desc"
    Public sSQLopSolCCG As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'B' and Cantidad > 0 order by cantidad desc"
    Public sSQLopSolCerTip As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'G' and Cantidad > 0 order by cantidad desc"
    Public sSQLopSolCerUsu As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'H' and Cantidad > 0 order by cantidad desc"
    Public sSQLopSolAbiTip As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'I' and Cantidad > 0 order by cantidad desc"
    Public sSQLopSolAbiSts As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'J' and Cantidad > 0 order by cantidad desc"

    Public sSQLlglAcuerdosPagosStatus As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'K' and Cantidad > 0"
    Public sSQLlglAcuerdosPagosDepto As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'L' and Cantidad > 0"

    Public sSQLlglLey18907Hoy As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'M' and Cantidad > 0 order by descripcion"
    Public sSQLlglLey18907All As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'N' and Cantidad > 0 order by descripcion"
    Public sSQLlglSolxUsrHoy As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'O' and Cantidad > 0 order by descripcion"
    Public sSQLlglSolxUsrAll As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'P' and Cantidad > 0 order by descripcion"
    Public sSQLlglAcuxUsrHoy As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'Q' and Cantidad > 0 order by descripcion desc"
    Public sSQLlglAcuxUsrAll As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'R' and Cantidad > 0 order by descripcion desc"

    ' --**Cantidad de trabajadores (distintos) por los cuales se ha pagado Salud.
    Public sSQLAfiliadosSfsPA As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'S' and Cantidad > 0 order by descripcion desc"

    '--**Cantidad de trabajadores que tienen en nomina las empresas que se han acogido a la Ley 189-07
    Public sSQLTraEnLey18907 As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'T' and Cantidad > 0 order by descripcion desc"

    '-- Cantidad de empresas acogidas a la Ley 189-07
    Public sSQLEmpEnLey18907 As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'U' and Cantidad > 0 order by descripcion desc"

    ' -- Cantidad de empresas acogidas a la Ley 189-07 que tienen acuerdo de pago
    Public sSQLEmpEnLey18907ConAP As String = "select Descripcion, Cantidad from sfc_est_op_t t where Tipo = 'V' and Cantidad > 0 order by descripcion desc"


    Public Function getData(ByVal Tipo As String) As DataSet
        Dim oConn As New Oracle.ManagedDataAccess.Client.OracleConnection(getConnString())
        oConn.Open()
        Dim ds As New DataSet("Data")
        Dim da As New Oracle.ManagedDataAccess.Client.OracleDataAdapter(Tipo, oConn)
        da.Fill(ds, "Data")
        oConn.Close()
        Return ds
    End Function

    Public Function getConnString() As String

        Dim connectionString = ConfigurationManager.ConnectionStrings("OracleDbContext").ConnectionString

        Return connectionString

    End Function


End Class