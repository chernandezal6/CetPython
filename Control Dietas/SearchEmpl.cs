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
    public partial class SearchEmpl : Form
    {
        public SearchEmpl()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            int code = 0;
            if(int.TryParse(textBox1.Text,out code))
            {
                new EmpleadosManage(FormMode.Edit,code).Show();
            }
            else
            {
                MessageBox.Show("Codigo invalido!");
                textBox1.Focus();
            }
            
        }

        private void SearchEmpl_Load(object sender, EventArgs e)
        {

        }
    }
}
