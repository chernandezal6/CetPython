using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;
using CrudWindForm.Models;
using System.Data.SqlClient;

namespace CrudWindForm
{
    public partial class frmLogin : Form
    {
        public frmLogin()
        {
            InitializeComponent();
        }

        private void BtnSalir_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void BtnLogin_Click(object sender, EventArgs e)
        {
           
            using(CrudEntities3 db = new CrudEntities3())
            {

            
            login ologin = new login();
            var log1 = from d in db.login
                       where d.usr_name == txtUserName.Text 
                       where d.password ==  txtPassword.Text
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
        private void FrmLogin_Load(object sender, EventArgs e)
        {
            
        }
    }
}
