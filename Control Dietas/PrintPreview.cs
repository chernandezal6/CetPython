using Microsoft.Reporting.WinForms;
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
    public partial class PrintPreview : Form
    {
        List<DietaP> Dieta;
        public PrintPreview()
        {
            InitializeComponent();
        }
        public PrintPreview(DietaP dieta)
        {
            InitializeComponent();
            Dieta = new List<DietaP>();
            Dieta.Add(dieta);

        }

        private void PrintPreview_Load(object sender, EventArgs e)
        {
            DietaPBindingSource.DataSource = Dieta;
            bindingSource1.DataSource = Dieta;
            empleadosBindingSource.DataSource = Dieta.FirstOrDefault().Empleado;
            reportViewer1.RefreshReport();
        }
    }
}
