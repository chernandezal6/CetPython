using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Expression.Encoder.Devices;
using System.IO;
using System.Windows.Forms;
using CrudWindForm.Models;
using CrudWindForm.Entidad;



namespace CrudWindForm.Presentacion
{
    public partial class FrmCrud : Form
    {
        public int? id;
        personas otabla = null;

        public FrmCrud(int? id=null)
        {
            InitializeComponent();
            this.id = id;

            if (id != null)
                CargarDatos();
        }
        WebCam webcam;
        private void FrmCrud_Load(object sender, EventArgs e)
        {
            webcam = new WebCam();
            webcam.InitializeWebCam(ref imagVideo);
        }

        private void CargarDatos()
        {
            using(CrudEntities3 db = new CrudEntities3())
            {
                otabla = db.personas.Find(id);
                txtIdentificacion.Text = otabla.identificacion;
                txtNombres.Text = otabla.Nombres;
                txtApellidos.Text = otabla.Apellidos;
                // dtpfechanac.Value = otabla.Fecha_registro;
                dateTimePicker1.Value = otabla.Fecha_registro;
                mkTelefonos.Text = otabla.Telefono;
                txtDireccion.Text = otabla.Direccion;
                txtcorreo.Text = otabla.Email;
               // otabla.Fecha_ult_act = DateTime.Now;
                //var imgLoc = "C:/Users/cethy.hernandez/Documents/Imagenes";
                //byte[] img = null;
                //FileStream fs = new FileStream(imgLoc, FileMode.Open, FileAccess.Read);
                //BinaryReader br = new BinaryReader(fs);
                //img = br.ReadBytes((int)fs.Length);
                //otabla.foto = img;

            }
        }
          
    /*    private void btnStart_Click(object sender, EventArgs e)
        {
            webcam.Start();
        }

        private void btnStop_Click(object sender, EventArgs e)
        {
            webcam.Stop();
        }

        private void btnContinuar_Click(object sender, EventArgs e)
        {
            webcam.Continue();
        }

        private void btnCaptura_Click(object sender, EventArgs e)
        {
            imagCaptura.Image = imagVideo.Image;
        }

        private void btnSave_Click(object sender, EventArgs e)
        {
            Helper.SaveImageCapture(imagCaptura.Image);
        }
*/
        private void BtnGuardar_Click_1(object sender, EventArgs e)
        {
            using (CrudEntities3 db = new CrudEntities3())
            {

                //--------------------------------------------------------------------------------------//
                try
                {
                    if (id == null)
                        otabla = new personas();

                    txtIdentificacion.Text = otabla.identificacion;
                    txtNombres.Text = otabla.Nombres;
                    txtApellidos.Text = otabla.Apellidos;
                    dateTimePicker1.Value = otabla.Fecha_registro;
                    //otabla.Fecha_registro = DateTime.Now.ToShortDateString(); 
                    mkTelefonos.Text = otabla.Telefono;
                    txtDireccion.Text = otabla.Direccion;
                    txtcorreo.Text = otabla.Email;
                   // otabla.Fecha_ult_act = DateTime.Now;
                    //var imgLoc = "C:/Users/cethy.hernandez/Documents/Imagenes";
                    ///byte[] img = null;
                    //FileStream fs = new FileStream(imgLoc, FileMode.Open, FileAccess.Read);
                    ///BinaryReader br = new BinaryReader(fs);
                    //img = br.ReadBytes((int)fs.Length);
                    //otabla.foto = img;

                }
                catch (Exception ex)
                {
                    MessageBox.Show(ex.Message);
                }
                //-------------------------------------------------------------------------------------//

                //agregamos los datos a nuestra tabla.
                if (id == null)
                    db.personas.Add(otabla);
                else
                {
                    db.Entry(otabla).State = System.Data.Entity.EntityState.Modified;
                }

                //si todo esta correcto guarda en la base datos.
                db.SaveChanges();
                this.Close();
            }
        }
    }
}
