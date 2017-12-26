<%@ WebHandler Language="C#" Class="Sub" %>

using System;
using System.Web;
using SuirPlus.Empresas;

public class Sub : IHttpHandler {
    
    public void ProcessRequest (HttpContext context) {

        //switch (switch_on)
        //{
        //    default:
        //}
        //ConsultaCedula(context);
    }


    public void ConsultaCedula(HttpContext context) {

        Trabajador emp = new Trabajador(Trabajador.TrabajadorDocumentoType.Cedula, context.Request["cedula"]);

        HttpContext.Current.Response.Write(context.Request.Form);
        
        HttpContext.Current.Response.Write("[{\"nombres\": \"" + emp.Nombres + "\"}]");
        
    }
 
    public bool IsReusable {
        get {
            return false;
        }
    }

}