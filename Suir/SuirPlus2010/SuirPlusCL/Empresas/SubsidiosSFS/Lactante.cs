using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using SuirPlus.DataBase;
using SuirPlus.Exepciones;
using Oracle.ManagedDataAccess.Client;
namespace SuirPlus.Empresas.SubsidiosSFS
{
    public class Lactante : FrameWork.Objetos 
    {
        #region "Contructores de la Clase"
        public Lactante()
        {
        }

        public Lactante(UInt32 idNSSMadre, UInt32 secuenciaParto)
        {
            this.IdNSSMadre = idNSSMadre;
            this.SecuenciaParto = secuenciaParto;
            CargarDatos();
        }
        #endregion

        #region "Miembros y Propiedades de la Clase"
                UInt32 idNSSMadre;

                public UInt32 IdNSSMadre
                {
                    get { return idNSSMadre; }
                    set { idNSSMadre = value; }
                }

                UInt32 secuenciaParto;

                public UInt32 SecuenciaParto
                {
                    get { return secuenciaParto; }
                    set { secuenciaParto = value; }
                }

                UInt32 secuenciaLactante;

                public UInt32 SecuenciaLactante
                {
                    get { return secuenciaLactante; }
                    set { secuenciaLactante = value; }
                }

                UInt32 idNSSLactante;

                public UInt32 IdNSSLactante
                {
                    get { return idNSSLactante; }
                    set { idNSSLactante = value; }
                }

                string nombres;

                public string Nombres
                {
                    get { return nombres; }
                    set { nombres = value; }
                }

                string primerApellido;

                public string PrimerApellido
                {
                    get { return primerApellido; }
                    set { primerApellido = value; }
                }


                string segundoApellido;

                public string SegundoApellido
                {
                    get { return segundoApellido; }
                    set { segundoApellido = value; }
                }


                string sexo;

                public string Sexo
                {
                    get { return sexo; }
                    set { sexo = value; }
                }

                DateTime fechaNacimiento;

                public DateTime FechaNacimiento
                {
                    get { return fechaNacimiento; }
                    set { fechaNacimiento = value; }
                }

                string nUI;

                public string NUI
                {
                    get { return nUI; }
                    set { nUI = value; }
                }


                DateTime fechaDefuncion;

                public DateTime FechaDefuncion
                {
                    get { return fechaDefuncion; }
                    set { fechaDefuncion = value; }
                }


                DateTime fechaRegistro;

                public DateTime FechaRegistro
                {
                    get { return fechaRegistro; }
                    set { fechaRegistro = value; }
                }


                string status;

                public string Status
                {
                    get { return status; }
                    set { status = value; }
                }


                UInt32 iDRegistroPatronalNC;

                public UInt32 IDRegistroPatronalNC
                {
                    get { return iDRegistroPatronalNC; }
                    set { iDRegistroPatronalNC = value; }
                }


                string usuarioNC;

                public string UsuarioNC
                {
                    get { return usuarioNC; }
                    set { usuarioNC = value; }
                }


                DateTime fechaRegistroNC;

                public DateTime FechaRegistroNC
                {
                    get { return fechaRegistroNC; }
                    set { fechaRegistroNC = value; }
                }



                UInt32 iDRegistroPatronalML;

                public UInt32 IDRegistroPatronalML
                {
                    get { return iDRegistroPatronalML; }
                    set { iDRegistroPatronalML = value; }
                }


                string usuarioML;

                public string UsuarioML
                {
                    get { return usuarioML; }
                    set { usuarioML = value; }
                }

                DateTime fechaRegistroML;

                public DateTime FechaRegistroML
                {
                    get { return fechaRegistroML; }
                    set { fechaRegistroML = value; }
                }
        #endregion

        #region "Metedos de la Clase"

            public static DataTable getLactantes(UInt32 idNSSMadre, UInt32 secuenciaParto)
            {

                OracleParameter[] arrParam = new OracleParameter[4];

                arrParam[0] = new OracleParameter("p_id_nss_madre", OracleDbType.Decimal);
                arrParam[0].Value = idNSSMadre;

                arrParam[1] = new OracleParameter("p_secuencia_parto", OracleDbType.Date);
                arrParam[1].Value = secuenciaParto;

                arrParam[2] = new OracleParameter("p_result_number", OracleDbType.NVarchar2, 200);
                arrParam[2].Direction = ParameterDirection.Output;

                arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
                arrParam[3].Direction = ParameterDirection.Output;

                String cmdStr = "SFS_SUBSIDIOS_PKG.Lista_Lactantes_Constructor_1";

                try
                {
                    DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);
                    if (ds.Tables.Count > 0)
                    {
                        return ds.Tables[0];
                    }
                    return new DataTable("No Hay Data");
                }

                catch (Exception ex)
                {
                    Exepciones.Log.LogToDB(ex.ToString());

                    throw ex;
                }
            }

            public override void CargarDatos()
            {
                DataTable dt = null;
                try
                    {
                        dt = Empresas.SubsidiosSFS.Lactante.getLactantes(this.IdNSSMadre, this.SecuenciaParto);
                        if (dt.Rows.Count > 0)
                        {
                            if (!(dt.Rows[0]["ID_NSS_MADRE"] is DBNull))
                                this.idNSSMadre = Convert.ToUInt32(dt.Rows[0]["ID_NSS_MADRE"]);

                            if (!(dt.Rows[0]["SECUENCIA_PARTO"] is DBNull))
                                this.secuenciaParto = Convert.ToUInt32(dt.Rows[0]["SECUENCIA_PARTO"]);

                            if (!(dt.Rows[0]["SECUENCIA_LACTANTE"] is DBNull))
                                this.secuenciaLactante = Convert.ToUInt32(dt.Rows[0]["SECUENCIA_LACTANTE"]);

                            if (!(dt.Rows[0]["ID_NSS_LACTANTE"] is DBNull))
                                this.idNSSLactante = Convert.ToUInt32(dt.Rows[0]["ID_NSS_LACTANTE"]); ;

                            if (!(dt.Rows[0]["NOMBRES"] is DBNull))
                                this.nombres = dt.Rows[0]["NOMBRES"].ToString();

                            if (!(dt.Rows[0]["PRIMER_APELLIDO"] is DBNull))
                                this.primerApellido = dt.Rows[0]["PRIMER_APELLIDO"].ToString(); ;

                            if (!(dt.Rows[0]["SEGUNDO_APELLIDO"] is DBNull))
                                this.segundoApellido = dt.Rows[0]["SEGUNDO_APELLIDO"].ToString();

                            if (!(dt.Rows[0]["SEXO"] is DBNull))
                                this.sexo = dt.Rows[0]["SEXO"].ToString();

                            if (!(dt.Rows[0]["FECHA_NACIMIENTO"] is DBNull))
                                this.fechaNacimiento = Convert.ToDateTime(dt.Rows[0]["FECHA_NACIMIENTO"]);

                            if (!(dt.Rows[0]["NUI"] is DBNull))
                                this.nUI = dt.Rows[0]["NUI"].ToString();

                            if (!(dt.Rows[0]["FECHA_DEFUNCION"] is DBNull))
                                this.fechaDefuncion = Convert.ToDateTime(dt.Rows[0]["FECHA_DEFUNCION"]);

                            if (!(dt.Rows[0]["FECHA_REGISTRO"] is DBNull))
                                this.fechaRegistro = Convert.ToDateTime(dt.Rows[0]["FECHA_REGISTRO"]);

                            if (!(dt.Rows[0]["STATUS"] is DBNull))
                                this.status = dt.Rows[0]["STATUS"].ToString();

                            if (!(dt.Rows[0]["ID_REGISTRO_PATRONAL_NC"] is DBNull))
                                this.iDRegistroPatronalNC = Convert.ToUInt32(dt.Rows[0]["ID_REGISTRO_PATRONAL_NC"]);

                            if (!(dt.Rows[0]["USUARIO_NC"] is DBNull))
                                this.usuarioNC = dt.Rows[0]["USUARIO_NC"].ToString();

                            if (!(dt.Rows[0]["FECHA_REGISTRO_NC"] is DBNull))
                                this.fechaRegistroNC = Convert.ToDateTime(dt.Rows[0]["FECHA_REGISTRO_NC"]);

                            if (!(dt.Rows[0]["ID_REGISTRO_PATRONAL_ML"] is DBNull))
                                this.iDRegistroPatronalML = Convert.ToUInt32(dt.Rows[0]["ID_REGISTRO_PATRONAL_ML"]);

                            if (!(dt.Rows[0]["USUARIO_ML"] is DBNull))
                                this.usuarioML = dt.Rows[0]["USUARIO_ML"].ToString();

                            if (!(dt.Rows[0]["FECHA_REGISTRO_ML"] is DBNull))
                                this.fechaRegistroML = Convert.ToDateTime(dt.Rows[0]["FECHA_REGISTRO_ML"]);
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
