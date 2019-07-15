using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using CrudWindowsForms.Modelo;

namespace CrudWindowsForms.Formulario
{
    
    public partial class frm_Datos : Form
    {
        public int? id;
        crudtable otabla = null;
        public frm_Datos(int? id= null)
        {
            InitializeComponent();
            this.id = id;

            if (id != null)
                CargarDatos();
        }

        public void CargarDatos()
        {
            using (CrudEntities db = new CrudEntities())
            {
                otabla = db.crudtable.Find(id);
                txtnombres.Text = otabla.nombre;
                txtcorreo.Text = otabla.correo;
                dtpfechanacimiento.Value = otabla.fecha_nac;

            }
        }
        private void Frm_Datos_Load(object sender, EventArgs e)
        {
          
        }

        private void Button1_Click(object sender, EventArgs e)
        {
            using (CrudEntities db = new CrudEntities())
            {
                if(id==null)
                    otabla = new crudtable();

                otabla.nombre = txtnombres.Text;
                otabla.correo = txtcorreo.Text;
                otabla.fecha_nac = dtpfechanacimiento.Value;

               // if(id==null)
                db.crudtable.Add(otabla);
               // else
               // {
               //     db.Entry(otabla).State= System.Data.Entity.EntityState.Modified;
               // }

                db.SaveChanges();
                this.Close();
            }
        }
    }
}
