namespace CrudWindowsForms.Formulario
{
    partial class frm_Datos
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
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.txtnombres = new System.Windows.Forms.TextBox();
            this.txtcorreo = new System.Windows.Forms.TextBox();
            this.dtpfechanacimiento = new System.Windows.Forms.DateTimePicker();
            this.button1 = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(12, 29);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 13);
            this.label1.TabIndex = 0;
            this.label1.Text = "Nombres";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(12, 62);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(38, 13);
            this.label2.TabIndex = 1;
            this.label2.Text = "Correo";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(10, 92);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(93, 13);
            this.label3.TabIndex = 2;
            this.label3.Text = "Fecha Nacimiento";
            // 
            // txtnombres
            // 
            this.txtnombres.Location = new System.Drawing.Point(109, 26);
            this.txtnombres.MaxLength = 50;
            this.txtnombres.Name = "txtnombres";
            this.txtnombres.Size = new System.Drawing.Size(195, 20);
            this.txtnombres.TabIndex = 3;
            // 
            // txtcorreo
            // 
            this.txtcorreo.Location = new System.Drawing.Point(109, 59);
            this.txtcorreo.MaxLength = 50;
            this.txtcorreo.Name = "txtcorreo";
            this.txtcorreo.Size = new System.Drawing.Size(195, 20);
            this.txtcorreo.TabIndex = 4;
            // 
            // dtpfechanacimiento
            // 
            this.dtpfechanacimiento.Location = new System.Drawing.Point(109, 86);
            this.dtpfechanacimiento.Name = "dtpfechanacimiento";
            this.dtpfechanacimiento.Size = new System.Drawing.Size(195, 20);
            this.dtpfechanacimiento.TabIndex = 5;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(228, 155);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(75, 23);
            this.button1.TabIndex = 6;
            this.button1.Text = "Guardar";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.Button1_Click);
            // 
            // frm_Datos
            // 
            this.ClientSize = new System.Drawing.Size(367, 196);
            this.Controls.Add(this.button1);
            this.Controls.Add(this.dtpfechanacimiento);
            this.Controls.Add(this.txtcorreo);
            this.Controls.Add(this.txtnombres);
            this.Controls.Add(this.label3);
            this.Controls.Add(this.label2);
            this.Controls.Add(this.label1);
            this.Name = "frm_Datos";
            this.ShowIcon = false;
            this.ShowInTaskbar = false;
            this.Text = "Datos Generales";
            this.Load += new System.EventHandler(this.Frm_Datos_Load);
            this.ResumeLayout(false);
            this.PerformLayout();

        }


        #endregion

        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.TextBox txtnombres;
        private System.Windows.Forms.TextBox txtcorreo;
        private System.Windows.Forms.DateTimePicker dtpfechanacimiento;
        private System.Windows.Forms.Button button1;
    }
}