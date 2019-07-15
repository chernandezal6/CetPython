using System;
using System.Windows.Forms;
using Mycrud.Module;

namespace Mycrud
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            using (CrudEntities db = new CrudEntities())
            {
                var lst = from d in db.table
                          select d;
                dataGridView1.DataSource = lst.ToList();

            }
        }
    }
}
