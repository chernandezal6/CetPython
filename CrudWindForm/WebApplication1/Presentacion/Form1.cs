using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Expression.Encoder.Devices;
using System.Windows.Forms;
using CrudWindForm.Models;

namespace CrudWindForm
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

        #region HELPER
        private void Refrescar()
        {
            using (CrudEntities3 db = new CrudEntities3())
            {
                var lst = from d in db.personas select d;

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

        private void Buscar()
        {
            using (CrudEntities3 db = new CrudEntities3())
            {
                var lst = from d in db.personas
                          where d.Nombres.Contains(textBox1.Text)
                          select d;

                dataGridView1.DataSource = lst.ToList();
            }
        }
        private void Eliminar()
        {
            int? id = Getid();
            if (id != null)
            {
                using (CrudEntities3 db = new CrudEntities3())
                {
                    personas otable = db.personas.Find(id);
                    db.personas.Remove(otable);
                    db.SaveChanges();
                }

                Refrescar();

            }
        }
        #endregion

        private void btnNuevo_Click(object sender, EventArgs e)
        {
            Presentacion.FrmCrud ofrmCrud = new Presentacion.FrmCrud();
            ofrmCrud.ShowDialog();

            Refrescar();
            ofrmCrud.Close();
        }

        private void btnEditar_Click(object sender, EventArgs e)
        {
            int? id = Getid();
            if(id!= null)
            {
                Presentacion.FrmCrud ofrmCrud = new Presentacion.FrmCrud(id);
                ofrmCrud.ShowDialog();
                Refrescar();

            }
        }

        private void btnEliminar_Click(object sender, EventArgs e)
        {
                Eliminar();
                Refrescar();

            }

        private void BtnBuscar_Click(object sender, EventArgs e)
        {
            Buscar();
            //Si el campo esta vacio traeme todos los registros
            if (textBox1.Text == String.Empty)
                Refrescar();
            textBox1.Text = String.Empty;
        }

        private void BtnSalir_Click(object sender, EventArgs e)
        {
            this.Close();
        }
    }

 
}
