using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using CrudWebApp.Models;

namespace CrudWebApp.Presentacion
{
    public partial class Contact : System.Web.UI.Page
    {
        private string nombres;
        private object convert;

        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            Contact d = new Contact();
            d.nombres = txtnombre.Text;
            d.contaco = txtContacto.Text;
            d.email = txtEmail.Text;
            d.dpFecha = Convert.ToDateTime(dpFecha.SelectedDate.ToShortDateString());

        }
    }
}