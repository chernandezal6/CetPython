using System;
using System.Data;
using System.Linq;
using System.Windows.Forms;
using CrudWindowsForms.Modelo;

namespace WindowsFormsCrud
{
    public partial class Form1 : Form
    {
        
        public Form1()
        {
            InitializeComponent();
        }
        private void Form1_Load(object sender, EventArgs e)
        {
            Refrescar();
        }

        //
        // HELPER
        //
        #region HELPER
        private void Refrescar()
        {
            using (CrudEntities db = new CrudEntities())
            {
                var lst = from d in db.crudtable
                          select d;
                dataGridView1.DataSource = lst.ToList();
            }
        }

        private int? Getid()
        {
            try
            {
                return int.Parse(dataGridView1.Rows[dataGridView1.CurrentRow.Index].Cells[0].Value.ToString());
            }
            catch
            {
                return null;
            }
        }
        #endregion

        //
        //
        //
        private void Button1_Click(object sender, EventArgs e)
        {
            CrudWindowsForms.Formulario.frm_Datos ofrm_Datos = new CrudWindowsForms.Formulario.frm_Datos();
            ofrm_Datos.ShowDialog();
            Refrescar();

        }

        private void Button2_Click(object sender, EventArgs e)
        {
            int? id = Getid();
            if (id != null)
            {                
                CrudWindowsForms.Formulario.frm_Datos ofrm_Datos = new CrudWindowsForms.Formulario.frm_Datos(id);
                ofrm_Datos.ShowDialog();

                Refrescar();
            }
        }

    }

}
