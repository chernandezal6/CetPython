
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Control_Dietas
{
    public partial class AddEditDieta : Form
    {
        DireccionCalidadEntities db = new DireccionCalidadEntities();
        get_dieta_Result2 dieta = null;
        public AddEditDieta()
        {
            InitializeComponent();
        }
        public AddEditDieta(string mode,int id=0)
        {
            InitializeComponent();
            switch (mode)
            {
                case "add":
                    ////ponemos el form con los textbox sin bloqueo
                    button1.Text = "Crear";
                    if (txtDietaID.Enabled == false)
                    {
                        txtDietaID.BackColor= Color.White;
                    }
                    break;
                case "edit":
                    button1.Text = "Guardar";
                    ///ponemos el form con algunos texbox bloqueados
                    groupBox1.Enabled = false;
                    if (id > 0)
                    {
                      dieta = db.get_dieta(id).FirstOrDefault();
                    }
                    break;
                default:
                    break;
            }

        }
        private void SetDietaControls()
        {
            txtDietaID.Text = dieta.ID.ToString();
            txtMemo.Text = dieta.Memo;
            txtCartaRuta.Text = dieta.CartaRuta;
            txtNombre.Text = dieta.Nombre;
            txtCodigoEmpl.Text = dieta.Codigo;
            txtAsignacionMax.Text = String.Format("{0:c}", dieta.ASIGACION_MAX);
            txtFechaSalida.Value = dieta.HoraFecha_Partida.Value;
            txtFechaRetorno.Value = dieta.HoraFecha_Retorno.Value;
            txtHoraSalida.Value = dieta.HoraFecha_Partida.Value;
            txtHoraRetorno.Value = dieta.HoraFecha_Retorno.Value;
            txtTotal.Text = checkIncomes(dieta.HoraFecha_Partida.Value, dieta.HoraFecha_Retorno.Value, int.Parse(dieta.Codigo)).ToString();
            //txtFechaCreacion = dieta.
            richTextBox1.Text = dieta.Actividad;
            button3.Enabled = true;

        }
        private void AddEditDieta_Load(object sender, EventArgs e)
        {
            // TODO: This line of code loads data into the 'sismopaDataSet.Provincia_Zona' table. You can move, or remove it, as needed.
            this.provincia_ZonaTableAdapter.Fill(this.sismopaDataSet.Provincia_Zona);
            if (dieta != null)
                SetDietaControls();

           

        }

        private void groupBox1_Enter(object sender, EventArgs e)
        {

        }
        
        private float GetElapsedTime(DateTime fechaIni, DateTime fechaRet, TimeFormat tipoDeInfo)
        {
            float elapsed = 0.0F;

            //Obtenemos el tiempo transcurrido
            TimeSpan timeElapsed = fechaRet.Subtract(fechaIni);
            switch (tipoDeInfo)
            {
                case TimeFormat.Segundos:
                    return (float)timeElapsed.TotalSeconds;

                case TimeFormat.Minutos:
                    return (float)timeElapsed.TotalMinutes;

                case TimeFormat.Horas:
                    return timeElapsed.Hours;

                case TimeFormat.Dias:
                    return timeElapsed.Days;


            }

            return elapsed;
        }
        private int GetElapsedMins(DateTime entity)
        {
            int mins = 0;
            mins = (entity.Hour * 60) + entity.Minute;
            return mins;
        }
        private float checkIncomes(DateTime salida, DateTime retorno,int codigoEmpl)
        {
            float incomes = 0;
            List<Day> Days = new List<Day>();
            if (retorno.Date == salida.Date)
            {
                Day d = new Day();
                ///verificamos desatuno 
               
                int mins = salida.Hour * 60 + salida.Minute;

               /// Debug.WriteLine(DateTime.Parse(dateTimePicker1.Value.ToShortTimeString()));
                if (mins < 451)
                {
                   d.Desayuno = true;
                }
                else
                {
                    d.Desayuno = false;
                }
                ///////verificamos el almuerzo
                if ((GetElapsedMins(retorno) >= 451 && GetElapsedMins(retorno) >= 781) ||
                    (d.Desayuno == true && GetElapsedMins(retorno) >= 781))
                {
                    d.Almuerzo = true;



                }
                else
                {
                    d.Almuerzo = false;
                }
                ///////////Verificamos la Cena
                if (GetElapsedMins(retorno) >= 1141)
                {
                    d.Cena = true;
                }
                else
                {
                   d.Cena = false;
                }
                Days.Add(d);
            }
            else
            {

                for (DateTime i = salida.Date; i < retorno.Date; i = i.AddDays(1))
                {
                    Day d = new Day();

                    //verificamos si es el dia de salida
                    if (i == salida.Date)
                    {
                        d.Date = i;
                        //verificamos que la salida sea menor a las 7:30
                        if ((salida.Hour * 60 + salida.Minute) < 451)
                        {
                            d.Desayuno = true;
                        }
                        else
                        {
                            d.Desayuno = false;
                        }
                        d.Almuerzo = true;
                        d.Cena = true;
                        d.Alojamiento = true;
                        Days.Add(d);
                    }
                    else
                    {
                        d.Date = i;
                        d.Desayuno = true;
                        d.Almuerzo = true;
                        d.Cena = true;
                        d.Alojamiento = true;
                        Days.Add(d);
                    }
                }
                Day returnDay = new Day()
                {
                    Date = retorno,
                    Desayuno = true
                };
                //verificamos que sea a partir de las 8:00 am o le haya tocado desayuno
                if ((returnDay.Date.Hour * 60 + returnDay.Date.Minute) >= 781)
                {
                    returnDay.Almuerzo = true;
                }
                else
                {
                    returnDay.Almuerzo = false;
                }
                if ((returnDay.Date.Hour * 60 + returnDay.Date.Minute) >= 1141)
                {
                    returnDay.Cena = true;
                }
                returnDay.Alojamiento = false;

                Days.Add(returnDay);
            }
            int cat = db.empleados.Where(x => x.CODIGO == codigoEmpl).FirstOrDefault().CATEGORIAID.Value;
            Categoria ct  = db.Categoria.Where(x=>x.ID==cat).FirstOrDefault();
            foreach (Day day in Days)
            {
                if (day.Desayuno)
                {
                    incomes += (float)ct.Desayuno.Value;
                }
                if (day.Almuerzo)
                {
                    incomes += (float)ct.Almuerzo.Value;
                }
                if (day.Cena)
                {
                    incomes += (float)ct.Cena.Value;
                }
                if (day.Alojamiento)
                {
                    incomes += (float)ct.Alojamiento.Value;
                }
            }
            return incomes;
        }
        private DateTime combineDateAndTime(DateTime date, DateTime time)
        {
            DateTime d = date;
            DateTime t = time;
            DateTime combined = new DateTime(d.Year, d.Month, d.Day, t.Hour, t.Minute, t.Second);
            return combined;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            if (dieta == null)
            {
                dietas d = new dietas();
                int code = int.Parse(txtCodigoEmpl.Text);
                empleados empleado = db.empleados.FirstOrDefault(x => x.CODIGO == code);
                DietaP dietp = new DietaP()
                {
                    Salida = combineDateAndTime(txtFechaSalida.Value, txtHoraSalida.Value),
                    Retorno = combineDateAndTime(txtFechaRetorno.Value, txtHoraRetorno.Value),
                    Empleado = empleado

                };
                dietp.cat = empleado.Categoria;
                dietp.AsignacionDiaria = (float)dietp.cat.AsignacionMax;
                dietp.CreateDietaFromValues();
                dietp.GetDietaPrint();
                dietas diet = new dietas()
                {
                    HoraFecha_Partida= dietp.Salida,
                    HoraFecha_Retorno = dietp.Retorno,
                    CartaRuta = txtCartaRuta.Text,
                    Memo = txtMemo.Text,
                    Actividad = richTextBox1.Text,
                    Provincia = comboBox1.SelectedText,
                    Codigo = txtCodigoEmpl.Text,
                    Nombre = txtNombre.Text
                    

                };
                db.dietas.Add(diet);
                if (db.SaveChanges() > 0)
                {
                    MessageBox.Show(String.Format("Se ha creado la dieta {0}",diet.ID));
                }

            }
        }

        private void txtCodigoEmpl_TextChanged(object sender, EventArgs e)
        {
          int codigo_empl = 0;
            if (!String.IsNullOrEmpty(txtCodigoEmpl.Text))
            {
                 codigo_empl = int.Parse(txtCodigoEmpl.Text);
            }
           empleados empl = db.empleados.Where(x => x.CODIGO == codigo_empl).FirstOrDefault();
            if(empl!=null)
            txtNombre.Text = String.Format("{0} {1}", empl.NOMBRES, empl.APELLIDOS);
        }

        private void chCalidadAgua_CheckedChanged(object sender, EventArgs e)
        {
            label11.Visible = chCalidadAgua.Checked;
            chTransporte.Enabled = chCalidadAgua.Checked;
            dateTimePicker3.Visible = chCalidadAgua.Checked;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            int code = int.Parse(txtCodigoEmpl.Text);
            empleados empleado = db.empleados.FirstOrDefault(x => x.CODIGO == code);
            DietaP dietp = new DietaP()
            {
                Salida = combineDateAndTime(txtFechaSalida.Value, txtHoraSalida.Value),
                Retorno = combineDateAndTime(txtFechaRetorno.Value, txtHoraRetorno.Value),
                Empleado = empleado,
                Actividad = richTextBox1.Text
                
            };
            dietp.cat =empleado.Categoria;
            dietp.AsignacionDiaria = (float)dietp.cat.AsignacionMax;
            dietp.CreateDietaFromValues();
            dietp.GetDietaPrint();
            new PrintPreview(dietp).Show();

        }

        private void comboBox1_SelectedValueChanged(object sender, EventArgs e)
        {
           
        }

        private void chTransporte_CheckedChanged(object sender, EventArgs e)
        {
            checkBox3.Enabled= chTransporte.Checked;
            dateTimePicker5.Visible = chTransporte.Checked;
        }

        private void checkBox3_CheckedChanged(object sender, EventArgs e)
        {
            dateTimePicker7.Visible = checkBox3.Checked;
            chAuditoria.Enabled = checkBox3.Checked;
        }

        private void chAuditoria_CheckedChanged(object sender, EventArgs e)
        {
            dateTimePicker4.Visible = chAuditoria.Checked;
            chFinanciero.Enabled = chAuditoria.Checked;
        }

        private void chFinanciero_CheckedChanged(object sender, EventArgs e)
        {
            dateTimePicker6.Visible = chFinanciero.Checked;
            checkBox6.Enabled = chFinanciero.Checked;
        }

        private void checkBox6_CheckedChanged(object sender, EventArgs e)
        {
            dateTimePicker8.Visible = checkBox6.Checked;
            checkBox7.Enabled = checkBox6.Checked;
        }

        private void checkBox7_CheckedChanged(object sender, EventArgs e)
        {
           
        }

        //private File PrintDieta(DietaP dieta)
        //{

        //        LocalReport lr = new LocalReport();
        //        string path = Path.Combine("~/Reports", "Dieta.rdlc");
        //        if (System.IO.File.Exists(path))
        //        {
        //            lr.ReportPath = path;
        //        }
        //        else
        //        {
        //            return View("Index");
        //        }

        //        List<reporteDiarioCloracion> cm = new List<reporteDiarioCloracion>();
        //        using (sismopaEntities dc = new sismopaEntities())
        //        {

        //            cm = (from a in dc.reporteDiarioCloracion where a.Fecha.Value.Year == fecha.Value.Year && a.Fecha.Value.Month == fecha.Value.Month && a.Fecha.Value.Day == fecha.Value.Day select a).ToList();
        //            if (!string.IsNullOrEmpty(provincia))
        //            {
        //                cm = (from a in dc.reporteDiarioCloracion where a.Fecha.Value.Year == fecha.Value.Year && a.Fecha.Value.Month == fecha.Value.Month && a.Fecha.Value.Day == fecha.Value.Day && a.codigo_provincia == provincia select a).ToList();
        //            }
        //        }
        //        ReportDataSource rd = new ReportDataSource("DataSet1", cm);
        //        lr.DataSources.Add(rd);
        //        string reportType = id;
        //        string mimeType;
        //        string encoding;
        //        string fileNameExtension;



        //        string deviceInfo =

        //        "<DeviceInfo>" +
        //        "  <OutputFormat>" + id + "</OutputFormat>" +
        //        "  <PageWidth>14in</PageWidth>" +
        //        "  <PageHeight>8.5in</PageHeight>" +
        //        "  <MarginTop>0.5in</MarginTop>" +
        //        "  <MarginLeft>0.19685in</MarginLeft>" +
        //        "  <MarginRight>0.19685in</MarginRight>" +
        //        "  <MarginBottom>0.5in</MarginBottom>" +
        //        "</DeviceInfo>";

        //        Warning[] warnings;
        //        string[] streams;
        //        byte[] renderedBytes;

        //        renderedBytes = lr.Render(
        //            reportType,
        //            deviceInfo,
        //            out mimeType,
        //            out encoding,
        //            out fileNameExtension,
        //            out streams,
        //            out warnings);


        //        return File(renderedBytes, mimeType);

        //}
    }
}
