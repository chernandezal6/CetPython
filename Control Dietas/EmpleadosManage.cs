using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Control_Dietas
{
    public partial class EmpleadosManage : Form
    {
        FormMode Mode;
        empleados Empl;
        DireccionCalidadEntities db = new DireccionCalidadEntities();

        public EmpleadosManage()
        {
            InitializeComponent();
        }

        public EmpleadosManage(FormMode modo,int codigo=0)
        {
            Mode = modo;
            if(codigo>0)
             Empl = loadEmpl(codigo);
            InitializeComponent();
        }
        private void label6_Click(object sender, EventArgs e)
        {

        }

        private void textBox12_TextChanged(object sender, EventArgs e)
        {

        }

        private void EmpleadosManage_Load(object sender, EventArgs e)
        {
            switch (Mode)
            {
                case FormMode.Add:
                    ///////llenamos el comboBox de categorias
                    LoadCategorias();
                    
                    break;
                case FormMode.Edit:
                    groupBox1.Enabled = false;
                    LoadCategorias();
                    comboBox1.SelectedValue = Empl.CATEGORIAID;
                    txtCodigo.Text = Empl.CODIGO.Value.ToString();
                    txtCedula.Text = Empl.CEDULA;
                    txtNombre.Text = Empl.NOMBRES;
                    txtApellidos.Text = Empl.APELLIDOS;
                    txtDireccion.Text = Empl.DIRECCION;
                    txtOtraDireccion.Text = Empl.OTRA_DIRECCION;
                    txtTelefono.Text = Empl.TELEFONO;
                    txtCelular.Text = Empl.CELULAR;
                    txtCelularOtro.Text = Empl.CELULAR_OTRO;
                    txtEmail.Text = Empl.EMAIL;
                    FillCategoriaValues();
                    break;
            }
        }
        private empleados loadEmpl(int codigo)
        {
            empleados empl = null;
            empl = db.empleados.Where(e => e.CODIGO == codigo).FirstOrDefault();
            return empl;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            switch (Mode)
            {
                case FormMode.Add:
                    empleados empl = new empleados();

                    db.empleados.Add(empl);
                    
                    if (db.SaveChanges() > 0)
                    {
                        asignacion_max asm = new asignacion_max();
                        asm.EMP_COD = empl.CODIGO;
                        db.asignacion_max.Add(asm);
                        if (db.SaveChanges() > 0)
                        {
                            Mode = FormMode.Edit;
                        }
                    }
                    break;
                case FormMode.Edit:
                    Empl.CATEGORIAID = int.Parse(comboBox1.SelectedValue.ToString());
                    Empl.CODIGO = int.Parse(txtCodigo.Text);
                    Empl.CEDULA = txtCedula.Text;
                    Empl.NOMBRES= txtNombre.Text;
                    Empl.APELLIDOS= txtApellidos.Text;
                    Empl.DIRECCION = txtDireccion.Text;
                    Empl.OTRA_DIRECCION= txtOtraDireccion.Text;
                    Empl.TELEFONO =txtTelefono.Text;
                    Empl.CELULAR = txtCelular.Text;
                    Empl.CELULAR_OTRO= txtCelularOtro.Text;
                    Empl.EMAIL =txtEmail.Text;
                    Empl.CATEGORIAID = int.Parse(comboBox1.SelectedValue.ToString());
                    db.SaveChanges();
                    break;
            }
        }

        private void comboBox1_SelectedValueChanged(object sender, EventArgs e)
        {

        }

        private void comboBox1_SelectionChangeCommitted(object sender, EventArgs e)
        {
            FillCategoriaValues();
        }
        private void FillCategoriaValues()
        {
            int id = int.Parse(comboBox1.SelectedValue.ToString());
            var cat = db.Categoria.Where(x => x.ID == id).FirstOrDefault();
            txtAsignacioMax.Value = (decimal)cat.AsignacionMax;
            txtDesayuno.Value = (decimal)cat.Desayuno;
            txtAlmuerzo.Value = (decimal)cat.Almuerzo;
            txtCena.Value = (decimal)cat.Cena;
            txtAlojamiento.Value = (decimal)cat.Alojamiento;
        }
        private void LoadCategorias()
        {
            var list = (from c in db.Categoria select new { Nombre = c.Categoria1, value = c.ID }).OrderByDescending(c => c.value).ToList();
            comboBox1.Items.Add("Seleccione Categoria");
            comboBox1.ValueMember = "value";
            comboBox1.DisplayMember = "Nombre";
            comboBox1.DataSource = list;
        }
    }
}
