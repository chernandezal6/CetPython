namespace CrudWindForm.Presentacion
{
    partial class FrmCrud
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
            this.lbApellidos = new System.Windows.Forms.Label();
            this.txtApellidos = new System.Windows.Forms.TextBox();
            this.lbFechaReg = new System.Windows.Forms.Label();
            this.lbTelefonos = new System.Windows.Forms.Label();
            this.mkTelefonos = new System.Windows.Forms.MaskedTextBox();
            this.lbDireccion = new System.Windows.Forms.Label();
            this.txtDireccion = new System.Windows.Forms.TextBox();
            this.lbEmail = new System.Windows.Forms.Label();
            this.btnGuardar = new System.Windows.Forms.Button();
            this.imagVideo = new System.Windows.Forms.PictureBox();
            this.btnStart = new System.Windows.Forms.Button();
            this.btnStop = new System.Windows.Forms.Button();
            this.btnContinuar = new System.Windows.Forms.Button();
            this.imagCaptura = new System.Windows.Forms.PictureBox();
            this.btnCapturar = new System.Windows.Forms.Button();
            this.btnSave = new System.Windows.Forms.Button();
            this.txtNombres = new System.Windows.Forms.TextBox();
            this.lbNombres = new System.Windows.Forms.Label();
            this.lbIdentificacion = new System.Windows.Forms.Label();
            this.txtIdentificacion = new System.Windows.Forms.TextBox();
            this.txtcorreo = new System.Windows.Forms.TextBox();
            this.dateTimePicker1 = new System.Windows.Forms.DateTimePicker();
            ((System.ComponentModel.ISupportInitialize)(this.imagVideo)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.imagCaptura)).BeginInit();
            this.SuspendLayout();
            // 
            // lbApellidos
            // 
            this.lbApellidos.AutoSize = true;
            this.lbApellidos.Location = new System.Drawing.Point(71, 102);
            this.lbApellidos.Name = "lbApellidos";
            this.lbApellidos.Size = new System.Drawing.Size(49, 13);
            this.lbApellidos.TabIndex = 21;
            this.lbApellidos.Text = "Apellidos";
            // 
            // txtApellidos
            // 
            this.txtApellidos.Location = new System.Drawing.Point(139, 99);
            this.txtApellidos.Name = "txtApellidos";
            this.txtApellidos.Size = new System.Drawing.Size(218, 20);
            this.txtApellidos.TabIndex = 26;
            // 
            // lbFechaReg
            // 
            this.lbFechaReg.AutoSize = true;
            this.lbFechaReg.Location = new System.Drawing.Point(41, 131);
            this.lbFechaReg.Name = "lbFechaReg";
            this.lbFechaReg.Size = new System.Drawing.Size(79, 13);
            this.lbFechaReg.TabIndex = 9;
            this.lbFechaReg.Text = "Fecha Registro";
            // 
            // lbTelefonos
            // 
            this.lbTelefonos.AutoSize = true;
            this.lbTelefonos.Location = new System.Drawing.Point(69, 154);
            this.lbTelefonos.Name = "lbTelefonos";
            this.lbTelefonos.Size = new System.Drawing.Size(54, 13);
            this.lbTelefonos.TabIndex = 22;
            this.lbTelefonos.Text = "Telefonos";
            // 
            // mkTelefonos
            // 
            this.mkTelefonos.Location = new System.Drawing.Point(139, 151);
            this.mkTelefonos.Mask = "(999)000-0000";
            this.mkTelefonos.Name = "mkTelefonos";
            this.mkTelefonos.Size = new System.Drawing.Size(106, 20);
            this.mkTelefonos.TabIndex = 29;
            // 
            // lbDireccion
            // 
            this.lbDireccion.AutoSize = true;
            this.lbDireccion.Location = new System.Drawing.Point(74, 180);
            this.lbDireccion.Name = "lbDireccion";
            this.lbDireccion.Size = new System.Drawing.Size(52, 13);
            this.lbDireccion.TabIndex = 23;
            this.lbDireccion.Text = "Direccion";
            // 
            // txtDireccion
            // 
            this.txtDireccion.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.txtDireccion.Location = new System.Drawing.Point(139, 177);
            this.txtDireccion.MaxLength = 50;
            this.txtDireccion.Name = "txtDireccion";
            this.txtDireccion.Size = new System.Drawing.Size(218, 20);
            this.txtDireccion.TabIndex = 28;
            // 
            // lbEmail
            // 
            this.lbEmail.AutoSize = true;
            this.lbEmail.Location = new System.Drawing.Point(88, 206);
            this.lbEmail.Name = "lbEmail";
            this.lbEmail.Size = new System.Drawing.Size(35, 13);
            this.lbEmail.TabIndex = 8;
            this.lbEmail.Text = "E-mail";
            // 
            // btnGuardar
            // 
            this.btnGuardar.BackColor = System.Drawing.SystemColors.ActiveCaption;
            this.btnGuardar.Location = new System.Drawing.Point(282, 229);
            this.btnGuardar.Name = "btnGuardar";
            this.btnGuardar.Size = new System.Drawing.Size(75, 39);
            this.btnGuardar.TabIndex = 13;
            this.btnGuardar.Text = "Guardar";
            this.btnGuardar.UseVisualStyleBackColor = false;
            this.btnGuardar.Click += new System.EventHandler(this.BtnGuardar_Click_1);
            // 
            // imagVideo
            // 
            this.imagVideo.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.imagVideo.BackColor = System.Drawing.SystemColors.HighlightText;
            this.imagVideo.Location = new System.Drawing.Point(440, 47);
            this.imagVideo.Name = "imagVideo";
            this.imagVideo.Size = new System.Drawing.Size(197, 172);
            this.imagVideo.TabIndex = 14;
            this.imagVideo.TabStop = false;
            // 
            // btnStart
            // 
            this.btnStart.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStart.Location = new System.Drawing.Point(440, 225);
            this.btnStart.Name = "btnStart";
            this.btnStart.Size = new System.Drawing.Size(53, 35);
            this.btnStart.TabIndex = 16;
            this.btnStart.Text = "&Start";
            this.btnStart.UseVisualStyleBackColor = true;
            // 
            // btnStop
            // 
            this.btnStop.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnStop.Location = new System.Drawing.Point(496, 225);
            this.btnStop.Name = "btnStop";
            this.btnStop.Size = new System.Drawing.Size(52, 35);
            this.btnStop.TabIndex = 17;
            this.btnStop.Text = "&Stop";
            this.btnStop.UseVisualStyleBackColor = true;
            // 
            // btnContinuar
            // 
            this.btnContinuar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnContinuar.Location = new System.Drawing.Point(562, 225);
            this.btnContinuar.Name = "btnContinuar";
            this.btnContinuar.Size = new System.Drawing.Size(75, 35);
            this.btnContinuar.TabIndex = 18;
            this.btnContinuar.Text = "&Continuar";
            this.btnContinuar.UseVisualStyleBackColor = true;
            // 
            // imagCaptura
            // 
            this.imagCaptura.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.imagCaptura.BackColor = System.Drawing.SystemColors.HighlightText;
            this.imagCaptura.Location = new System.Drawing.Point(658, 47);
            this.imagCaptura.Name = "imagCaptura";
            this.imagCaptura.Size = new System.Drawing.Size(203, 172);
            this.imagCaptura.TabIndex = 15;
            this.imagCaptura.TabStop = false;
            // 
            // btnCapturar
            // 
            this.btnCapturar.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnCapturar.Location = new System.Drawing.Point(658, 225);
            this.btnCapturar.Name = "btnCapturar";
            this.btnCapturar.Size = new System.Drawing.Size(75, 35);
            this.btnCapturar.TabIndex = 19;
            this.btnCapturar.Text = "&Capturar";
            this.btnCapturar.UseVisualStyleBackColor = true;
            // 
            // btnSave
            // 
            this.btnSave.Anchor = ((System.Windows.Forms.AnchorStyles)((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Right)));
            this.btnSave.Location = new System.Drawing.Point(786, 225);
            this.btnSave.Name = "btnSave";
            this.btnSave.Size = new System.Drawing.Size(75, 35);
            this.btnSave.TabIndex = 20;
            this.btnSave.Text = "&Guardar";
            this.btnSave.UseVisualStyleBackColor = true;
            // 
            // txtNombres
            // 
            this.txtNombres.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.txtNombres.Location = new System.Drawing.Point(139, 73);
            this.txtNombres.MaxLength = 50;
            this.txtNombres.Name = "txtNombres";
            this.txtNombres.Size = new System.Drawing.Size(218, 20);
            this.txtNombres.TabIndex = 10;
            // 
            // lbNombres
            // 
            this.lbNombres.AutoSize = true;
            this.lbNombres.Location = new System.Drawing.Point(74, 76);
            this.lbNombres.Name = "lbNombres";
            this.lbNombres.Size = new System.Drawing.Size(49, 13);
            this.lbNombres.TabIndex = 7;
            this.lbNombres.Text = "Nombres";
            // 
            // lbIdentificacion
            // 
            this.lbIdentificacion.AutoSize = true;
            this.lbIdentificacion.Location = new System.Drawing.Point(33, 50);
            this.lbIdentificacion.Name = "lbIdentificacion";
            this.lbIdentificacion.Size = new System.Drawing.Size(90, 13);
            this.lbIdentificacion.TabIndex = 24;
            this.lbIdentificacion.Text = "No. Identificacion";
            // 
            // txtIdentificacion
            // 
            this.txtIdentificacion.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.txtIdentificacion.Location = new System.Drawing.Point(139, 47);
            this.txtIdentificacion.MaxLength = 11;
            this.txtIdentificacion.Name = "txtIdentificacion";
            this.txtIdentificacion.Size = new System.Drawing.Size(106, 20);
            this.txtIdentificacion.TabIndex = 25;
            // 
            // txtcorreo
            // 
            this.txtcorreo.Anchor = ((System.Windows.Forms.AnchorStyles)(((System.Windows.Forms.AnchorStyles.Top | System.Windows.Forms.AnchorStyles.Bottom) 
            | System.Windows.Forms.AnchorStyles.Left)));
            this.txtcorreo.Location = new System.Drawing.Point(139, 203);
            this.txtcorreo.MaxLength = 50;
            this.txtcorreo.Name = "txtcorreo";
            this.txtcorreo.Size = new System.Drawing.Size(218, 20);
            this.txtcorreo.TabIndex = 11;
            // 
            // dateTimePicker1
            // 
            this.dateTimePicker1.Location = new System.Drawing.Point(139, 126);
            this.dateTimePicker1.Name = "dateTimePicker1";
            this.dateTimePicker1.Size = new System.Drawing.Size(200, 20);
            this.dateTimePicker1.TabIndex = 30;
            // 
            // FrmCrud
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.SystemColors.MenuHighlight;
            this.ClientSize = new System.Drawing.Size(873, 417);
            this.Controls.Add(this.dateTimePicker1);
            this.Controls.Add(this.txtIdentificacion);
            this.Controls.Add(this.lbIdentificacion);
            this.Controls.Add(this.lbNombres);
            this.Controls.Add(this.txtNombres);
            this.Controls.Add(this.lbApellidos);
            this.Controls.Add(this.txtApellidos);
            this.Controls.Add(this.lbFechaReg);
            this.Controls.Add(this.lbTelefonos);
            this.Controls.Add(this.mkTelefonos);
            this.Controls.Add(this.lbDireccion);
            this.Controls.Add(this.txtDireccion);
            this.Controls.Add(this.lbEmail);
            this.Controls.Add(this.txtcorreo);
            this.Controls.Add(this.btnGuardar);
            this.Controls.Add(this.imagVideo);
            this.Controls.Add(this.btnStart);
            this.Controls.Add(this.btnStop);
            this.Controls.Add(this.btnContinuar);
            this.Controls.Add(this.imagCaptura);
            this.Controls.Add(this.btnCapturar);
            this.Controls.Add(this.btnSave);
            this.MaximizeBox = false;
            this.MinimizeBox = false;
            this.Name = "FrmCrud";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "Registros";
            this.Load += new System.EventHandler(this.FrmCrud_Load);
            ((System.ComponentModel.ISupportInitialize)(this.imagVideo)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.imagCaptura)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Label lbApellidos;
        private System.Windows.Forms.TextBox txtApellidos;
        private System.Windows.Forms.Label lbFechaReg;
        private System.Windows.Forms.Label lbTelefonos;
        private System.Windows.Forms.MaskedTextBox mkTelefonos;
        private System.Windows.Forms.Label lbDireccion;
        private System.Windows.Forms.TextBox txtDireccion;
        private System.Windows.Forms.Label lbEmail;
        private System.Windows.Forms.Button btnGuardar;
        private System.Windows.Forms.PictureBox imagVideo;
        private System.Windows.Forms.Button btnStart;
        private System.Windows.Forms.Button btnStop;
        private System.Windows.Forms.Button btnContinuar;
        private System.Windows.Forms.PictureBox imagCaptura;
        private System.Windows.Forms.Button btnCapturar;
        private System.Windows.Forms.Button btnSave;
        private System.Windows.Forms.TextBox txtNombres;
        private System.Windows.Forms.Label lbNombres;
        private System.Windows.Forms.Label lbIdentificacion;
        private System.Windows.Forms.TextBox txtIdentificacion;
        private System.Windows.Forms.TextBox txtcorreo;
        private System.Windows.Forms.DateTimePicker dateTimePicker1;
    }
}