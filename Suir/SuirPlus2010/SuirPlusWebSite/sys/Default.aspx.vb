
Partial Class sys_Default
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        Dim asm As System.Reflection.Assembly
        asm = Reflection.Assembly.GetExecutingAssembly()


        For Each tipo In asm.GetTypes()

            Response.Write(tipo.FullName)


            If tipo.IsSubclassOf(GetType(System.Web.UI.Page)) Then

                Response.Write("Si")

            Else

                Response.Write("No")
            End If

            Response.Write("<br>")







        Next

        ' var asm = Assembly.GetExecutingAssembly();
        '    String listado;

        '    listado = "";

        '    foreach (Type tipo in asm.GetTypes())
        '    {

        '        listado = listado + " // " + tipo.FullName;

        '        if (tipo.IsSubclassOf(typeof(System.Web.Mvc.ViewPage)))
        '        {
        '            listado = listado + ": Si";


        '        }
        'Else
        '        {
        '            listado = listado + ": No";
        '        }



        '    }
    End Sub
End Class
