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
    public partial class Form1 : System.Windows.Forms.Form
    {
        DireccionCalidadEntities db = new DireccionCalidadEntities();
        public Form1()
        {
            
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            LoadDietasNoPagadas();
            dataGridView1.Size = new Size(height: this.Size.Height - 100, width: this.Width -100);
            dataGridView1.AutoSizeColumnsMode = DataGridViewAutoSizeColumnsMode.Fill;
            dataGridView1.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            

        }
        private void LoadDietasNoPagadas()
        {
            var dietas = db.GetDietasNoPagadas2.ToList();
            dataGridView1.DataSource = dietas;
            
            
        }

        private void Form1_ResizeEnd(object sender, EventArgs e)
        {
            dataGridView1.Size = new Size(height: this.ClientSize.Height - 25, width: this.ClientSize.Width - 20);
        }

        private void dataGridView1_CellContentDoubleClick(object sender, DataGridViewCellEventArgs e)
        {
           int ID= (int)dataGridView1.Rows[e.RowIndex].Cells[0].Value;
            get_dieta_Result2 dieta = db.get_dieta(ID).FirstOrDefault();
            AddEditDieta aed = new AddEditDieta("edit", ID);
            aed.ShowDialog();
            if(aed.DialogResult== DialogResult.OK)
            {
                this.LoadDietasNoPagadas();
            }
        }

        private void agregarToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new EmpleadosManage(FormMode.Add).Show();
        }

        private void editarToolStripMenuItem_Click(object sender, EventArgs e)
        {
            new SearchEmpl().ShowDialog();
        }

        private void toolStripButton1_Click(object sender, EventArgs e)
        {
            new AddEditDieta("add").ShowDialog();
        }

        private void toolStrip1_ItemClicked(object sender, ToolStripItemClickedEventArgs e)
        {

        }
    }
}
