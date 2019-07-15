namespace Control_Dietas
{
    partial class AddEditDieta
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.label17 = new System.Windows.Forms.Label();
            this.txtFechaCreacion = new System.Windows.Forms.DateTimePicker();
            this.txtMemo = new System.Windows.Forms.TextBox();
            this.txtCartaRuta = new System.Windows.Forms.TextBox();
            this.txtDietaID = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label1 = new System.Windows.Forms.Label();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.txtCodigoEmpl = new System.Windows.Forms.TextBox();
            this.txtNombre = new System.Windows.Forms.TextBox();
            this.label5 = new System.Windows.Forms.Label();
            this.lblNombre = new System.Windows.Forms.Label();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.label9 = new System.Windows.Forms.Label();
            this.txtHoraRetorno = new System.Windows.Forms.DateTimePicker();
            this.label10 = new System.Windows.Forms.Label();
            this.txtHoraSalida = new System.Windows.Forms.DateTimePicker();
            this.label8 = new System.Windows.Forms.Label();
            this.txtFechaRetorno = new System.Windows.Forms.DateTimePicker();
            this.label7 = new System.Windows.Forms.Label();
            this.txtFechaSalida = new System.Windows.Forms.DateTimePicker();
            this.txtTotal = new System.Windows.Forms.TextBox();
            this.txtAsignacionMax = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.label16 = new System.Windows.Forms.Label();
            this.dateTimePicker8 = new System.Windows.Forms.DateTimePicker();
            this.label15 = new System.Windows.Forms.Label();
            this.dateTimePicker7 = new System.Windows.Forms.DateTimePicker();
            this.label14 = new System.Windows.Forms.Label();
            this.dateTimePicker6 = new System.Windows.Forms.DateTimePicker();
            this.label13 = new System.Windows.Forms.Label();
            this.dateTimePicker5 = new System.Windows.Forms.DateTimePicker();
            this.label12 = new System.Windows.Forms.Label();
            this.dateTimePicker4 = new System.Windows.Forms.DateTimePicker();
            this.label11 = new System.Windows.Forms.Label();
            this.dateTimePicker3 = new System.Windows.Forms.DateTimePicker();
            this.checkBox7 = new System.Windows.Forms.CheckBox();
            this.checkBox6 = new System.Windows.Forms.CheckBox();
            this.chFinanciero = new System.Windows.Forms.CheckBox();
            this.chAuditoria = new System.Windows.Forms.CheckBox();
            this.checkBox3 = new System.Windows.Forms.CheckBox();
            this.chTransporte = new System.Windows.Forms.CheckBox();
            this.chCalidadAgua = new System.Windows.Forms.CheckBox();
            this.groupBox5 = new System.Windows.Forms.GroupBox();
            this.button3 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.button1 = new System.Windows.Forms.Button();
            this.label18 = new System.Windows.Forms.Label();
            this.comboBox1 = new System.Windows.Forms.ComboBox();
            this.sismopaDataSet = new Control_Dietas.sismopaDataSet();
            this.provinciaZonaBindingSource = new System.Windows.Forms.BindingSource(this.components);
            this.provincia_ZonaTableAdapter = new Control_Dietas.sismopaDataSetTableAdapters.Provincia_ZonaTableAdapter();
            this.label19 = new System.Windows.Forms.Label();
            this.richTextBox1 = new System.Windows.Forms.RichTextBox();
            this.groupBox1.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox3.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox5.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)(this.sismopaDataSet)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.provinciaZonaBindingSource)).BeginInit();
            this.SuspendLayout();
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.label17);
            this.groupBox1.Controls.Add(this.txtFechaCreacion);
            this.groupBox1.Controls.Add(this.txtMemo);
            this.groupBox1.Controls.Add(this.txtCartaRuta);
            this.groupBox1.Controls.Add(this.txtDietaID);
            this.groupBox1.Controls.Add(this.label3);
            this.groupBox1.Controls.Add(this.label2);
            this.groupBox1.Controls.Add(this.label1);
            this.groupBox1.Location = new System.Drawing.Point(13, 13);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(366, 129);
            this.groupBox1.TabIndex = 0;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Datos de Registro";
            this.groupBox1.Enter += new System.EventHandler(this.groupBox1_Enter);
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label17.Location = new System.Drawing.Point(6, 100);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(155, 13);
            this.label17.TabIndex = 14;
            this.label17.Text = "FECHA CREACION DIETA";
            // 
            // txtFechaCreacion
            // 
            this.txtFechaCreacion.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.txtFechaCreacion.Location = new System.Drawing.Point(173, 99);
            this.txtFechaCreacion.Name = "txtFechaCreacion";
            this.txtFechaCreacion.Size = new System.Drawing.Size(153, 20);
            this.txtFechaCreacion.TabIndex = 13;
            // 
            // txtMemo
            // 
            this.txtMemo.Location = new System.Drawing.Point(168, 69);
            this.txtMemo.Name = "txtMemo";
            this.txtMemo.Size = new System.Drawing.Size(158, 20);
            this.txtMemo.TabIndex = 5;
            // 
            // txtCartaRuta
            // 
            this.txtCartaRuta.Location = new System.Drawing.Point(168, 39);
            this.txtCartaRuta.Name = "txtCartaRuta";
            this.txtCartaRuta.Size = new System.Drawing.Size(158, 20);
            this.txtCartaRuta.TabIndex = 4;
            // 
            // txtDietaID
            // 
            this.txtDietaID.Enabled = false;
            this.txtDietaID.Location = new System.Drawing.Point(168, 13);
            this.txtDietaID.Name = "txtDietaID";
            this.txtDietaID.Size = new System.Drawing.Size(158, 20);
            this.txtDietaID.TabIndex = 3;
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label3.Location = new System.Drawing.Point(7, 69);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(44, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "MEMO";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label2.Location = new System.Drawing.Point(7, 44);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(107, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "CARTA DE RUTA";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(7, 20);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(20, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "ID";
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.txtCodigoEmpl);
            this.groupBox2.Controls.Add(this.txtNombre);
            this.groupBox2.Controls.Add(this.label5);
            this.groupBox2.Controls.Add(this.lblNombre);
            this.groupBox2.Controls.Add(this.txtAsignacionMax);
            this.groupBox2.Controls.Add(this.label6);
            this.groupBox2.Location = new System.Drawing.Point(13, 148);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(739, 116);
            this.groupBox2.TabIndex = 1;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Datos del Empleado";
            // 
            // txtCodigoEmpl
            // 
            this.txtCodigoEmpl.Location = new System.Drawing.Point(168, 19);
            this.txtCodigoEmpl.Name = "txtCodigoEmpl";
            this.txtCodigoEmpl.Size = new System.Drawing.Size(158, 20);
            this.txtCodigoEmpl.TabIndex = 10;
            this.txtCodigoEmpl.TextChanged += new System.EventHandler(this.txtCodigoEmpl_TextChanged);
            // 
            // txtNombre
            // 
            this.txtNombre.Location = new System.Drawing.Point(168, 49);
            this.txtNombre.Name = "txtNombre";
            this.txtNombre.Size = new System.Drawing.Size(338, 20);
            this.txtNombre.TabIndex = 9;
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label5.Location = new System.Drawing.Point(13, 24);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(126, 13);
            this.label5.TabIndex = 7;
            this.label5.Text = "CODIGO EMPLEADO";
            // 
            // lblNombre
            // 
            this.lblNombre.AutoSize = true;
            this.lblNombre.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.lblNombre.Location = new System.Drawing.Point(13, 56);
            this.lblNombre.Name = "lblNombre";
            this.lblNombre.Size = new System.Drawing.Size(60, 13);
            this.lblNombre.TabIndex = 6;
            this.lblNombre.Text = "NOMBRE";
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.richTextBox1);
            this.groupBox3.Controls.Add(this.label19);
            this.groupBox3.Controls.Add(this.comboBox1);
            this.groupBox3.Controls.Add(this.label18);
            this.groupBox3.Controls.Add(this.label9);
            this.groupBox3.Controls.Add(this.txtHoraRetorno);
            this.groupBox3.Controls.Add(this.label10);
            this.groupBox3.Controls.Add(this.txtHoraSalida);
            this.groupBox3.Controls.Add(this.label8);
            this.groupBox3.Controls.Add(this.txtFechaRetorno);
            this.groupBox3.Controls.Add(this.label7);
            this.groupBox3.Controls.Add(this.txtFechaSalida);
            this.groupBox3.Controls.Add(this.txtTotal);
            this.groupBox3.Controls.Add(this.label4);
            this.groupBox3.Location = new System.Drawing.Point(13, 270);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(739, 217);
            this.groupBox3.TabIndex = 11;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Detalles del Viaje";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label9.Location = new System.Drawing.Point(292, 137);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(107, 13);
            this.label9.TabIndex = 18;
            this.label9.Text = "HORA RETORNO";
            // 
            // txtHoraRetorno
            // 
            this.txtHoraRetorno.CustomFormat = "HH:mm";
            this.txtHoraRetorno.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.txtHoraRetorno.Location = new System.Drawing.Point(410, 132);
            this.txtHoraRetorno.Name = "txtHoraRetorno";
            this.txtHoraRetorno.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.txtHoraRetorno.ShowUpDown = true;
            this.txtHoraRetorno.Size = new System.Drawing.Size(102, 20);
            this.txtHoraRetorno.TabIndex = 17;
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label10.Location = new System.Drawing.Point(13, 137);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(90, 13);
            this.label10.TabIndex = 16;
            this.label10.Text = "HORA SALIDA";
            // 
            // txtHoraSalida
            // 
            this.txtHoraSalida.CustomFormat = "HH:mm";
            this.txtHoraSalida.Format = System.Windows.Forms.DateTimePickerFormat.Custom;
            this.txtHoraSalida.Location = new System.Drawing.Point(156, 131);
            this.txtHoraSalida.Name = "txtHoraSalida";
            this.txtHoraSalida.ShowUpDown = true;
            this.txtHoraSalida.Size = new System.Drawing.Size(118, 20);
            this.txtHoraSalida.TabIndex = 15;
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label8.Location = new System.Drawing.Point(292, 107);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(112, 13);
            this.label8.TabIndex = 14;
            this.label8.Text = "FECHA RETORNO";
            // 
            // txtFechaRetorno
            // 
            this.txtFechaRetorno.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.txtFechaRetorno.Location = new System.Drawing.Point(410, 101);
            this.txtFechaRetorno.Name = "txtFechaRetorno";
            this.txtFechaRetorno.RightToLeft = System.Windows.Forms.RightToLeft.No;
            this.txtFechaRetorno.Size = new System.Drawing.Size(102, 20);
            this.txtFechaRetorno.TabIndex = 13;
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label7.Location = new System.Drawing.Point(13, 106);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(95, 13);
            this.label7.TabIndex = 12;
            this.label7.Text = "FECHA SALIDA";
            // 
            // txtFechaSalida
            // 
            this.txtFechaSalida.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.txtFechaSalida.Location = new System.Drawing.Point(156, 100);
            this.txtFechaSalida.Name = "txtFechaSalida";
            this.txtFechaSalida.Size = new System.Drawing.Size(118, 20);
            this.txtFechaSalida.TabIndex = 11;
            // 
            // txtTotal
            // 
            this.txtTotal.Location = new System.Drawing.Point(156, 184);
            this.txtTotal.Name = "txtTotal";
            this.txtTotal.Size = new System.Drawing.Size(135, 20);
            this.txtTotal.TabIndex = 10;
            // 
            // txtAsignacionMax
            // 
            this.txtAsignacionMax.Enabled = false;
            this.txtAsignacionMax.Location = new System.Drawing.Point(168, 75);
            this.txtAsignacionMax.Name = "txtAsignacionMax";
            this.txtAsignacionMax.Size = new System.Drawing.Size(118, 20);
            this.txtAsignacionMax.TabIndex = 9;
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label4.Location = new System.Drawing.Point(13, 187);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(47, 13);
            this.label4.TabIndex = 7;
            this.label4.Text = "TOTAL";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label6.Location = new System.Drawing.Point(13, 82);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(113, 13);
            this.label6.TabIndex = 6;
            this.label6.Text = "ASIGNACION MAX";
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.label16);
            this.groupBox4.Controls.Add(this.dateTimePicker8);
            this.groupBox4.Controls.Add(this.label15);
            this.groupBox4.Controls.Add(this.dateTimePicker7);
            this.groupBox4.Controls.Add(this.label14);
            this.groupBox4.Controls.Add(this.dateTimePicker6);
            this.groupBox4.Controls.Add(this.label13);
            this.groupBox4.Controls.Add(this.dateTimePicker5);
            this.groupBox4.Controls.Add(this.label12);
            this.groupBox4.Controls.Add(this.dateTimePicker4);
            this.groupBox4.Controls.Add(this.label11);
            this.groupBox4.Controls.Add(this.dateTimePicker3);
            this.groupBox4.Controls.Add(this.checkBox7);
            this.groupBox4.Controls.Add(this.checkBox6);
            this.groupBox4.Controls.Add(this.chFinanciero);
            this.groupBox4.Controls.Add(this.chAuditoria);
            this.groupBox4.Controls.Add(this.checkBox3);
            this.groupBox4.Controls.Add(this.chTransporte);
            this.groupBox4.Controls.Add(this.chCalidadAgua);
            this.groupBox4.Location = new System.Drawing.Point(775, 13);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(406, 307);
            this.groupBox4.TabIndex = 12;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "STATUS";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label16.Location = new System.Drawing.Point(214, 190);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(122, 13);
            this.label16.TabIndex = 23;
            this.label16.Text = "fecha salida Nomina";
            // 
            // dateTimePicker8
            // 
            this.dateTimePicker8.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dateTimePicker8.Location = new System.Drawing.Point(217, 205);
            this.dateTimePicker8.Name = "dateTimePicker8";
            this.dateTimePicker8.Size = new System.Drawing.Size(118, 20);
            this.dateTimePicker8.TabIndex = 22;
            this.dateTimePicker8.Visible = false;
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label15.Location = new System.Drawing.Point(35, 190);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(116, 13);
            this.label15.TabIndex = 21;
            this.label15.Text = "fecha salida RRHH";
            // 
            // dateTimePicker7
            // 
            this.dateTimePicker7.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dateTimePicker7.Location = new System.Drawing.Point(38, 205);
            this.dateTimePicker7.Name = "dateTimePicker7";
            this.dateTimePicker7.Size = new System.Drawing.Size(118, 20);
            this.dateTimePicker7.TabIndex = 20;
            this.dateTimePicker7.Visible = false;
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label14.Location = new System.Drawing.Point(215, 119);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(139, 13);
            this.label14.TabIndex = 19;
            this.label14.Text = "fecha salida Financiero";
            // 
            // dateTimePicker6
            // 
            this.dateTimePicker6.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dateTimePicker6.Location = new System.Drawing.Point(218, 134);
            this.dateTimePicker6.Name = "dateTimePicker6";
            this.dateTimePicker6.Size = new System.Drawing.Size(118, 20);
            this.dateTimePicker6.TabIndex = 18;
            this.dateTimePicker6.Visible = false;
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label13.Location = new System.Drawing.Point(35, 119);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(141, 13);
            this.label13.TabIndex = 17;
            this.label13.Text = "fecha salida Transporte";
            // 
            // dateTimePicker5
            // 
            this.dateTimePicker5.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dateTimePicker5.Location = new System.Drawing.Point(38, 134);
            this.dateTimePicker5.Name = "dateTimePicker5";
            this.dateTimePicker5.Size = new System.Drawing.Size(118, 20);
            this.dateTimePicker5.TabIndex = 16;
            this.dateTimePicker5.Visible = false;
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label12.Location = new System.Drawing.Point(215, 46);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(130, 13);
            this.label12.TabIndex = 15;
            this.label12.Text = "fecha salida Auditoria";
            // 
            // dateTimePicker4
            // 
            this.dateTimePicker4.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dateTimePicker4.Location = new System.Drawing.Point(218, 61);
            this.dateTimePicker4.Name = "dateTimePicker4";
            this.dateTimePicker4.Size = new System.Drawing.Size(118, 20);
            this.dateTimePicker4.TabIndex = 14;
            this.dateTimePicker4.Visible = false;
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label11.Location = new System.Drawing.Point(30, 46);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(105, 13);
            this.label11.TabIndex = 13;
            this.label11.Text = "fecha salida DCA";
            this.label11.Visible = false;
            // 
            // dateTimePicker3
            // 
            this.dateTimePicker3.Format = System.Windows.Forms.DateTimePickerFormat.Short;
            this.dateTimePicker3.Location = new System.Drawing.Point(33, 61);
            this.dateTimePicker3.Name = "dateTimePicker3";
            this.dateTimePicker3.Size = new System.Drawing.Size(118, 20);
            this.dateTimePicker3.TabIndex = 12;
            this.dateTimePicker3.Visible = false;
            // 
            // checkBox7
            // 
            this.checkBox7.AutoSize = true;
            this.checkBox7.Enabled = false;
            this.checkBox7.Location = new System.Drawing.Point(154, 253);
            this.checkBox7.Name = "checkBox7";
            this.checkBox7.Size = new System.Drawing.Size(63, 17);
            this.checkBox7.TabIndex = 6;
            this.checkBox7.Text = "Pagada";
            this.checkBox7.UseVisualStyleBackColor = true;
            this.checkBox7.CheckedChanged += new System.EventHandler(this.checkBox7_CheckedChanged);
            // 
            // checkBox6
            // 
            this.checkBox6.AutoSize = true;
            this.checkBox6.Enabled = false;
            this.checkBox6.Location = new System.Drawing.Point(217, 170);
            this.checkBox6.Name = "checkBox6";
            this.checkBox6.Size = new System.Drawing.Size(62, 17);
            this.checkBox6.TabIndex = 5;
            this.checkBox6.Text = "Nomina";
            this.checkBox6.UseVisualStyleBackColor = true;
            this.checkBox6.CheckedChanged += new System.EventHandler(this.checkBox6_CheckedChanged);
            // 
            // chFinanciero
            // 
            this.chFinanciero.AutoSize = true;
            this.chFinanciero.Enabled = false;
            this.chFinanciero.Location = new System.Drawing.Point(217, 99);
            this.chFinanciero.Name = "chFinanciero";
            this.chFinanciero.Size = new System.Drawing.Size(75, 17);
            this.chFinanciero.TabIndex = 4;
            this.chFinanciero.Text = "Financiero";
            this.chFinanciero.UseVisualStyleBackColor = true;
            this.chFinanciero.CheckedChanged += new System.EventHandler(this.chFinanciero_CheckedChanged);
            // 
            // chAuditoria
            // 
            this.chAuditoria.AutoSize = true;
            this.chAuditoria.Enabled = false;
            this.chAuditoria.Location = new System.Drawing.Point(218, 26);
            this.chAuditoria.Name = "chAuditoria";
            this.chAuditoria.Size = new System.Drawing.Size(67, 17);
            this.chAuditoria.TabIndex = 3;
            this.chAuditoria.Text = "Auditoria";
            this.chAuditoria.UseVisualStyleBackColor = true;
            this.chAuditoria.CheckedChanged += new System.EventHandler(this.chAuditoria_CheckedChanged);
            // 
            // checkBox3
            // 
            this.checkBox3.AutoSize = true;
            this.checkBox3.Enabled = false;
            this.checkBox3.Location = new System.Drawing.Point(33, 170);
            this.checkBox3.Name = "checkBox3";
            this.checkBox3.Size = new System.Drawing.Size(58, 17);
            this.checkBox3.TabIndex = 2;
            this.checkBox3.Text = "RRHH";
            this.checkBox3.UseVisualStyleBackColor = true;
            this.checkBox3.CheckedChanged += new System.EventHandler(this.checkBox3_CheckedChanged);
            // 
            // chTransporte
            // 
            this.chTransporte.AutoSize = true;
            this.chTransporte.Enabled = false;
            this.chTransporte.Location = new System.Drawing.Point(33, 99);
            this.chTransporte.Name = "chTransporte";
            this.chTransporte.Size = new System.Drawing.Size(77, 17);
            this.chTransporte.TabIndex = 1;
            this.chTransporte.Text = "Transporte";
            this.chTransporte.UseVisualStyleBackColor = true;
            this.chTransporte.CheckedChanged += new System.EventHandler(this.chTransporte_CheckedChanged);
            // 
            // chCalidadAgua
            // 
            this.chCalidadAgua.AutoSize = true;
            this.chCalidadAgua.Location = new System.Drawing.Point(33, 26);
            this.chCalidadAgua.Name = "chCalidadAgua";
            this.chCalidadAgua.Size = new System.Drawing.Size(107, 17);
            this.chCalidadAgua.TabIndex = 0;
            this.chCalidadAgua.Text = " Calidad de Agua";
            this.chCalidadAgua.UseVisualStyleBackColor = true;
            this.chCalidadAgua.CheckedChanged += new System.EventHandler(this.chCalidadAgua_CheckedChanged);
            // 
            // groupBox5
            // 
            this.groupBox5.Controls.Add(this.button3);
            this.groupBox5.Controls.Add(this.button2);
            this.groupBox5.Controls.Add(this.button1);
            this.groupBox5.Location = new System.Drawing.Point(775, 387);
            this.groupBox5.Name = "groupBox5";
            this.groupBox5.Size = new System.Drawing.Size(406, 100);
            this.groupBox5.TabIndex = 13;
            this.groupBox5.TabStop = false;
            this.groupBox5.Text = "Controles";
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(204, 50);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(75, 23);
            this.button3.TabIndex = 2;
            this.button3.Text = "Imprimir";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // button2
            // 
            this.button2.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.button2.Location = new System.Drawing.Point(101, 50);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(75, 23);
            this.button2.TabIndex = 1;
            this.button2.Text = "Cancelar";
            this.button2.UseVisualStyleBackColor = true;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(6, 50);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 0;
            this.button1.Text = "button1";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label18.Location = new System.Drawing.Point(13, 37);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(135, 13);
            this.label18.TabIndex = 19;
            this.label18.Text = "PROVINCIA VISITADA";
            // 
            // comboBox1
            // 
            this.comboBox1.DataSource = this.provinciaZonaBindingSource;
            this.comboBox1.DisplayMember = "Provincia";
            this.comboBox1.FormattingEnabled = true;
            this.comboBox1.Location = new System.Drawing.Point(156, 28);
            this.comboBox1.Name = "comboBox1";
            this.comboBox1.Size = new System.Drawing.Size(198, 21);
            this.comboBox1.TabIndex = 20;
            this.comboBox1.ValueMember = "Codigo";
            // 
            // sismopaDataSet
            // 
            this.sismopaDataSet.DataSetName = "sismopaDataSet";
            this.sismopaDataSet.SchemaSerializationMode = System.Data.SchemaSerializationMode.IncludeSchema;
            // 
            // provinciaZonaBindingSource
            // 
            this.provinciaZonaBindingSource.DataMember = "Provincia_Zona";
            this.provinciaZonaBindingSource.DataSource = this.sismopaDataSet;
            // 
            // provincia_ZonaTableAdapter
            // 
            this.provincia_ZonaTableAdapter.ClearBeforeFill = true;
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label19.Location = new System.Drawing.Point(13, 68);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(73, 13);
            this.label19.TabIndex = 21;
            this.label19.Text = "ACTIVIDAD";
            // 
            // richTextBox1
            // 
            this.richTextBox1.Location = new System.Drawing.Point(156, 55);
            this.richTextBox1.Name = "richTextBox1";
            this.richTextBox1.Size = new System.Drawing.Size(356, 35);
            this.richTextBox1.TabIndex = 22;
            this.richTextBox1.Text = "";
            // 
            // AddEditDieta
            // 
            this.AcceptButton = this.button1;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.button2;
            this.ClientSize = new System.Drawing.Size(1206, 533);
            this.Controls.Add(this.groupBox5);
            this.Controls.Add(this.groupBox4);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Name = "AddEditDieta";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "Agregar o Editar Dieta";
            this.Load += new System.EventHandler(this.AddEditDieta_Load);
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox3.ResumeLayout(false);
            this.groupBox3.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.groupBox5.ResumeLayout(false);
            ((System.ComponentModel.ISupportInitialize)(this.sismopaDataSet)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.provinciaZonaBindingSource)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox txtMemo;
        private System.Windows.Forms.TextBox txtCartaRuta;
        private System.Windows.Forms.TextBox txtDietaID;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox txtCodigoEmpl;
        private System.Windows.Forms.TextBox txtNombre;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label lblNombre;
        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.DateTimePicker txtFechaRetorno;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.DateTimePicker txtFechaSalida;
        private System.Windows.Forms.TextBox txtTotal;
        private System.Windows.Forms.TextBox txtAsignacionMax;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.DateTimePicker txtHoraRetorno;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.DateTimePicker txtHoraSalida;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.DateTimePicker dateTimePicker8;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.DateTimePicker dateTimePicker7;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.DateTimePicker dateTimePicker6;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.DateTimePicker dateTimePicker5;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.DateTimePicker dateTimePicker4;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.DateTimePicker dateTimePicker3;
        private System.Windows.Forms.CheckBox checkBox7;
        private System.Windows.Forms.CheckBox checkBox6;
        private System.Windows.Forms.CheckBox chFinanciero;
        private System.Windows.Forms.CheckBox chAuditoria;
        private System.Windows.Forms.CheckBox checkBox3;
        private System.Windows.Forms.CheckBox chTransporte;
        private System.Windows.Forms.CheckBox chCalidadAgua;
        private System.Windows.Forms.GroupBox groupBox5;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.DateTimePicker txtFechaCreacion;
        private System.Windows.Forms.ComboBox comboBox1;
        private System.Windows.Forms.Label label18;
        private sismopaDataSet sismopaDataSet;
        private System.Windows.Forms.BindingSource provinciaZonaBindingSource;
        private sismopaDataSetTableAdapters.Provincia_ZonaTableAdapter provincia_ZonaTableAdapter;
        private System.Windows.Forms.RichTextBox richTextBox1;
        private System.Windows.Forms.Label label19;
    }
}