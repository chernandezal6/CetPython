Imports Microsoft.VisualBasic

Public Class AssemblyInfo

    Public Shared Function VersionInfo() As String
        Return System.Reflection.Assembly.GetExecutingAssembly().GetName().Version.ToString()
    End Function


End Class
