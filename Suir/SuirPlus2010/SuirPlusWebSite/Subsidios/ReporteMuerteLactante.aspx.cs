using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;


public partial class Subsidios_ReporteMuerteLactante : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {
        try
        {
            gvLactantes.DataSource = SuirPlus.Subsidios.Lactante.ObtenerLactantes(Convert.ToInt32(Request.QueryString["nssMadre"]));
            gvLactantes.DataBind();
        }
        catch
        {}


    }
}