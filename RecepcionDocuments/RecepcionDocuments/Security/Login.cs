using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using RecepcionDocuments.Model;
using System.Data.SqlClient;

namespace RecepcionDocuments.Security
{
    public partial class Login : Form
    {
        public Login()
        {
            InitializeComponent();
        }

        private void Button2_Click(object sender, EventArgs e)
        {
            {
                using (DocRecepcionEntities db = new DocRecepcionEntities())
                {
                    Login ologin = new Login();
                    var log1 = from d in db.Login
                               where d.Usuario == txtUsuario.Text
                               where d.Pass == txtPass.Text
                               select d;

                    if (log1.Count() == 1)
                    {
                        this.Hide();
                        Form1 listado = new Form1();
                        listado.Show();
                    }
                    else
                    {
                        MessageBox.Show("Favor verifique su Usuario o Password");
                    }
                }
            }
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
