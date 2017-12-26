using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using SuirPlus.DataBase;
using SuirPlus.Exepciones; 
namespace SuirPlus.Empresas.SubsidiosSFS 
{
    public class Tutor: FrameWork.Objetos
    {


        #region "Constructores de la Clase"
        public Tutor()
        {
        }
        public Tutor(int idnssmadre)
        {
            this.NssMadre = idnssmadre;
            CargarDatos();
        }
        #endregion

        #region "Miembros y Propiedades de la clase"
        private int idNssMadre;

        public int NssMadre
        {
            get { return idNssMadre; }
            set { idNssMadre = value; }
        }
        private int secuenciaParto;

        public int SecuenciaParto
        {
            get { return secuenciaParto; }
            set { secuenciaParto = value; }
        }

        private int idNssTutor;

        public int NssTutor
        {
            get { return idNssTutor; }
            set { idNssTutor = value; }
        }
        private string status;

        public string Status
        {
            get { return status; }
            set { status = value; }
        }
        private int idRegistroPatronalRT;

        public int RegistroPatronalRegistroTutor
        {
            get { return idRegistroPatronalRT; }
            set { idRegistroPatronalRT = value; }
        }
        private string usuarioRT;

        public string UsuarioRegistroTutor
        {
            get { return usuarioRT; }
            set { usuarioRT = value; }
        }
        private DateTime fechaRegistroRT;

        public DateTime FechaRegistroRT
        {
            get { return fechaRegistroRT; }
            set { fechaRegistroRT = value; }
        }

        private string cuentaBanco;

        public string CuentaBanco
        {
            get { return cuentaBanco; }
            set { cuentaBanco = value; }
        }

        private int idEntidadRecaudadora;

        public int IdEntidadRecaudadora
        {
            get { return idEntidadRecaudadora; }
            set { idEntidadRecaudadora = value; }
        }

        private string cedula;

        public string NroDocumento
        {
            get { return cedula; }
            set { cedula = value; }
        }

        private string nombres;

        public string Nombres
        {
            get { return nombres; }
            set { nombres = value; }
        }

        private string primerApellido;

        public string PrimerApellido
        {
            get { return primerApellido; }
            set { primerApellido = value; }
        }

        private string segundoApellido;

        public string SegundoApellido
        {
            get { return segundoApellido; }
            set { segundoApellido = value; }
        }
        private string entidadRecaudadora;

        public string DescripcionEntidadRecaudadora
        {
            get
            {
                return this.entidadRecaudadora;
            }
            set
            {
                this.entidadRecaudadora = value;
            }
        }
        #endregion

        #region "Metodos de la clase"

        /// <summary>
        /// Metodo para obtener el tutor de una determinada madre
        /// </summary>
        /// <param name="IdNssMadre">IdNssMadre</param>
        /// <returns>DataTable</returns>
        private DataTable getTutor(int IdNssMadre)
        {
            OracleParameter[] parameters = new OracleParameter[3];
            OracleParameter p_io_cursor, p_result_number;
            
            (parameters[0] = new OracleParameter("p_id_nss_madre", OracleDbType.Decimal)).Value = IdNssMadre;
             parameters[1] = (p_io_cursor = new OracleParameter("p_io_cursor", OracleDbType.RefCursor, ParameterDirection.Output));
            (parameters[2] = (p_result_number = new OracleParameter("p_result_number", OracleDbType.Varchar2, ParameterDirection.Output))).Size = 1024;

            try
                {
                    return OracleHelper.ExecuteDataset(CommandType.StoredProcedure, "SFS_SUBSIDIOS_PKG.CargarDatosTutor", parameters).Tables[0];    
                }
            catch (InvalidNSSException ex)
                {
                    throw new InvalidNSSException(IdNssMadre);
                    Exepciones.Log.LogToDB(ex.ToString());
                    throw ex;
                    
                }
         }

        public override void CargarDatos()
        {
            DataTable dt = null;

            try
            {
                dt = this.getTutor(this.NssMadre);

                if (dt.Rows.Count > 0)
                {
                    this.idNssMadre = Convert.ToInt32(dt.Rows[0]["ID_NSS_MADRE"]);
                    this.secuenciaParto = Convert.ToInt32(dt.Rows[0]["SECUENCIA"]);
                    this.idNssTutor = Convert.ToInt32(dt.Rows[0]["ID_NSS_TUTOR"]);
                    this.status = dt.Rows[0]["STATUS"].ToString();
                    if (!(dt.Rows[0]["ID_REGISTRO_PATRONAL_RT"] is DBNull))
                        this.idRegistroPatronalRT = Convert.ToInt32(dt.Rows[0]["ID_REGISTRO_PATRONAL_RT"]);
                    this.fechaRegistroRT = Convert.ToDateTime(dt.Rows[0]["FECHA_REGISTRO_RT"]);
                    this.usuarioRT = dt.Rows[0]["USUARIO_RT"].ToString();
                    this.nombres = dt.Rows[0]["NOMBRES"].ToString();
                    this.primerApellido = dt.Rows[0]["PRIMER_APELLIDO"].ToString();
                    this.segundoApellido = dt.Rows[0]["SEGUNDO_APELLIDO"].ToString();
                    this.cedula = dt.Rows[0]["NO_DOCUMENTO"].ToString();
                    this.cuentaBanco = dt.Rows[0]["cuenta_banco"].ToString();
                    
                }
            }
            catch (DataNoFoundException ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public override string GuardarCambios(string UsuarioResponsable)
        {
            return string.Empty;
        }

        #endregion

        
    }
}
