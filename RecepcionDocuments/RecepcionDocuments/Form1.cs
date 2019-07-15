using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Security;
using System.Security.Permissions;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using RecepcionDocuments.Model;

namespace RecepcionDocuments
{
    public partial class Form1 : Form
    {


        public Form1()
        {
            InitializeComponent();
        }


        #region HELPER
        private void Refrescar()
        {
            using (DocRecepcionEntities db = new DocRecepcionEntities())
            {
                var lst = from d in db.RecepcionDoc
                          select new { d.id, d.No_memo, d.Name, d.RealNameMemo,d.Recibido_por, d.Entregado_por,d.Fecha_registro};

                dataGridView1.DataSource = lst.ToList();

            }
        }

        private void Buscar()
        {
            using (DocRecepcionEntities db = new DocRecepcionEntities())
            {
                var lst = from d in db.RecepcionDoc
                          where d.No_memo.Contains(txtNoMemo.Text) && d.Name.Contains(txtNombreDoc.Text)
                          select new {d.id, d.No_memo, d.Name, d.RealNameMemo, d.Recibido_por, d.Entregado_por, d.Fecha_registro };

                if (lst == null)
                {
                    MessageBox.Show("El numero de documento no existe");
                }
                else
                {
                    dataGridView1.DataSource = lst.ToList();
                }
                
            }
        }
        #endregion
        private void Button1_Click(object sender, EventArgs e)
        {
            openFileDialog1.InitialDirectory = "c://";
            openFileDialog1.Filter = "Todos los archivos (*.*)|*.*";
            openFileDialog1.FilterIndex = 1;
            openFileDialog1.RestoreDirectory = true;

            if (openFileDialog1.ShowDialog() == DialogResult.OK)
            {
                txtPath.Text = openFileDialog1.FileName;
            }
        }

        private void Button2_Click(object sender, EventArgs e)
        {
            if (txtNombreDoc.Text.Trim().Equals("") || txtNoMemo.Text.Trim().Equals(""))
            {
                MessageBox.Show("el numero del Documento o Nombre del archivo es obligatorio");
                return;
            }
            Byte[] file = null;
            Stream mystream = openFileDialog1.OpenFile();
            using(MemoryStream ms = new MemoryStream())
            {
                mystream.CopyTo(ms);
                file = ms.ToArray();

            }

            using (DocRecepcionEntities db = new DocRecepcionEntities())
            {
                RecepcionDoc oDocument = new RecepcionDoc();
                oDocument.No_memo = txtNoMemo.Text.ToUpper();
                oDocument.Name = txtNombreDoc.Text.ToUpper().Trim();
                oDocument.DocPath = file;
                oDocument.RealNameMemo = openFileDialog1.SafeFileName;
                oDocument.Recibido_por = txtRecibidoPor.Text.ToUpper();
                oDocument.Entregado_por = txtEntregadoPor.Text.ToUpper();
               // oDocument.Asunto = txtAsunto.Text;
                oDocument.Fecha_registro = dateTimePicker1.Value;

                db.RecepcionDoc.Add(oDocument);
                db.SaveChanges();
                
                //Si el campo esta vacio traeme todos los registros
                Refrescar();
                txtNoMemo.Text = String.Empty;
                txtNombreDoc.Text = String.Empty;
                txtPath.Text = String.Empty;
                txtAsunto.Text = String.Empty;
                txtEntregadoPor.Text = String.Empty;
                txtRecibidoPor.Text = String.Empty;
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            Refrescar();
        }

        private void Button4_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void Button3_Click(object sender, EventArgs e)

        {
            if(dataGridView1.Rows.Count>0)
            {
                int id = int.Parse(dataGridView1.Rows[dataGridView1.CurrentRow.Index].Cells[0].Value.ToString());

                using (DocRecepcionEntities db = new DocRecepcionEntities())
                {
                    var oDocument = db.RecepcionDoc.Find(id);

                    string path = AppDomain.CurrentDomain.BaseDirectory;
                    string folder = path + "/temp/";
                    string fullFillPath = folder + oDocument.RealNameMemo;

                        if (!Directory.Exists(folder))
                            Directory.CreateDirectory(folder);

                        //if (File.Exists(fullFillPath))
                        //    Directory.Delete(fullFillPath);

                        File.WriteAllBytes(fullFillPath, oDocument.DocPath);
                        Process.Start(fullFillPath);
        
                }
            }
        }

        private void BtnBuscar_Click(object sender, EventArgs e)
        {
            Buscar();
            //Si el campo esta vacio traeme todos los registros
            if (txtNoMemo.Text == String.Empty)
                Refrescar();
            txtNoMemo.Text = String.Empty;
            txtNombreDoc.Text = String.Empty;
            txtPath.Text = String.Empty;
            txtAsunto.Text = String.Empty;
            txtEntregadoPor.Text = String.Empty;
            txtRecibidoPor.Text = String.Empty;            
        }
    }
}
