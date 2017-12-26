using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using SuirPlus.DataBase; 
namespace SuirPlus.Empresas
{
    /// <summary>
    /// Clase para manejar los metodos del objecto empleador
    /// </summary>
    public partial class Empleador
    {
        
        
        #region "Metodos de la clase"
        private string getStatusAcuerdoString(StatusCobrosType status)
        {
            switch (status)
            {
                case StatusCobrosType.Auditoria:
                    return "A";
                case StatusCobrosType.Cobros:
                    return "C";
                case StatusCobrosType.Legal:
                    return "L";
                case StatusCobrosType.Rectificacion:
                    return "R";
                default:
                    return "N";
            }
        }

        public DataTable getRepresentantes()
        {
            string cmdStr = "Sre_Empleadores_Pkg.Get_Representantes";
            OracleParameter[] orParam = new OracleParameter[2];

            orParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            orParam[0].Value = this.RegistroPatronal;

            orParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            orParam[1].Direction = ParameterDirection.Output;

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, orParam);
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

        #region "Funciones Estaticas de Validacion, Busqueda y Actualizaciones "

        public static string insertaEmpleador(int idSectorEconomico,
                                                String idMunicipio,
                                                String rncCedula,
                                                String razonSocial,
                                                String nombreComercial,
                                                String calle,
                                                String numero,
                                                String edificio,
                                                String piso,
                                                String apartamento,
                                                String sector,
                                                String telefono1,
                                                String ext1,
                                                String telefono2,
                                                String ext2,
                                                String fax,
                                                String email,
                                                String tipoEmpresa,
                                                int?  sectorSalarial,
                                                Byte[] imageFile,
                                                String p_Id_Actividad,
                                                String p_Id_Zona_Franca,
                                                String p_Es_Zona_Franca,
                                                String p_tipo_zona_franca, 
            //String noPagaIDSS,
                                                String usuarioResponsable)
        {

            OracleParameter[] arrParam = new OracleParameter[26];

            arrParam[0] = new OracleParameter("p_ID_SECTOR_ECONOMICO", OracleDbType.Decimal, 2);
            arrParam[0].Value = idSectorEconomico;
            arrParam[1] = new OracleParameter("p_ID_MUNICIPIO", OracleDbType.NVarchar2, 6);
            arrParam[1].Value = idMunicipio;
            arrParam[2] = new OracleParameter("p_RNC_O_CEDULA", OracleDbType.NVarchar2, 11);
            arrParam[2].Value = rncCedula;
            arrParam[3] = new OracleParameter("p_RAZON_SOCIAL", OracleDbType.NVarchar2, 150);
            arrParam[3].Value = razonSocial;
            arrParam[4] = new OracleParameter("p_NOMBRE_COMERCIAL", OracleDbType.NVarchar2, 150);
            arrParam[4].Value = nombreComercial;
            arrParam[5] = new OracleParameter("p_CALLE", OracleDbType.NVarchar2, 150);
            arrParam[5].Value = calle;
            arrParam[6] = new OracleParameter("p_NUMERO", OracleDbType.NVarchar2, 12);
            arrParam[6].Value = numero;
            arrParam[7] = new OracleParameter("p_EDIFICIO", OracleDbType.NVarchar2, 25);
            arrParam[7].Value = edificio;
            arrParam[8] = new OracleParameter("p_PISO", OracleDbType.NVarchar2, 2);
            arrParam[8].Value = piso;
            arrParam[9] = new OracleParameter("p_APARTAMENTO", OracleDbType.NVarchar2, 10);
            arrParam[9].Value = apartamento;
            arrParam[10] = new OracleParameter("p_SECTOR", OracleDbType.NVarchar2, 150);
            arrParam[10].Value = sector;
            arrParam[11] = new OracleParameter("p_TELEFONO_1", OracleDbType.NVarchar2, 10);
            arrParam[11].Value = telefono1;
            arrParam[12] = new OracleParameter("p_EXT_1", OracleDbType.NVarchar2, 4);
            arrParam[12].Value = ext1;
            arrParam[13] = new OracleParameter("p_TELEFONO_2", OracleDbType.NVarchar2, 10);
            arrParam[13].Value = telefono2;
            arrParam[14] = new OracleParameter("p_EXT_2", OracleDbType.NVarchar2, 4);
            arrParam[14].Value = ext2;
            arrParam[15] = new OracleParameter("p_FAX", OracleDbType.NVarchar2, 10);
            arrParam[15].Value = fax;
            arrParam[16] = new OracleParameter("p_EMAIL", OracleDbType.NVarchar2, 50);
            arrParam[16].Value = email;
            arrParam[17] = new OracleParameter("p_TIPO_EMPRESA", OracleDbType.NVarchar2, 2);
            arrParam[17].Value = tipoEmpresa;
            arrParam[18] = new OracleParameter("p_sector_salarial", OracleDbType.Int32);
            arrParam[18].Value = sectorSalarial;
            arrParam[19] = new OracleParameter("p_documentos_registro", OracleDbType.Blob);
            arrParam[19].Value = imageFile;
            arrParam[20] = new OracleParameter("p_Id_Actividad", OracleDbType.NVarchar2 ,5);
            arrParam[20].Value = p_Id_Actividad;
            arrParam[21] = new OracleParameter("p_Id_Zona_Franca", OracleDbType.NVarchar2, 5);
            arrParam[21].Value = p_Id_Zona_Franca;
            arrParam[22] = new OracleParameter("p_Es_Zona_Franca", OracleDbType.NVarchar2, 1);
            arrParam[22].Value = p_Es_Zona_Franca;
            arrParam[23] = new OracleParameter("p_tipo_zona_franca", OracleDbType.NVarchar2, 1);
            arrParam[23].Value = p_tipo_zona_franca;
            arrParam[24] = new OracleParameter("p_ULT_USUARIO_ACT", OracleDbType.NVarchar2, 35);
            arrParam[24].Value = usuarioResponsable;
            arrParam[25] = new OracleParameter("P_ResultNumber", OracleDbType.NVarchar2, 500);
            arrParam[25].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.empleadores_crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[25].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string insertaEmpleadorTMP(String RNC,
                                        String RazonSocial, String NombreComercial,
                                        String status, String TipoEmpresa,
                                        int? sectorSalarial, int SectorEconomico,
                                        String Actividad, String TipoZonaFranca,
                                        String Parque, String Calle,
                                        String Numero, String Apartamento,
                                        String Sector, String Provincia, String Municipio,
                                        String Telefono1, String Ext1,
                                        String Telefono2, String Ext2,
                                        String Fax, String Email, 
                                        String R_Cedula_Pasaporte,
                                        String R_Telefono1, String R_Ext1, 
                                        String R_Telefono2, String R_Ext2, String User, DateTime Date, int idSol)
        {

            OracleParameter[] arrParam = new OracleParameter[31];

            arrParam[0] = new OracleParameter("Rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = RNC;
            arrParam[1] = new OracleParameter("razon_social", OracleDbType.NVarchar2, 150);
            arrParam[1].Value = RazonSocial;
            arrParam[2] = new OracleParameter("nombre_comercial", OracleDbType.NVarchar2, 150);
            arrParam[2].Value = NombreComercial;
            arrParam[3] = new OracleParameter("status", OracleDbType.NVarchar2, 1);
            arrParam[3].Value = status;
            arrParam[4] = new OracleParameter("tipo_empresa", OracleDbType.NVarchar2, 2);
            arrParam[4].Value = TipoEmpresa;
            arrParam[5] = new OracleParameter("sector_salarial", OracleDbType.NVarchar2, 9);
            arrParam[5].Value = sectorSalarial;
            arrParam[6] = new OracleParameter("id_sector_economico", OracleDbType.Int16, 2);
            arrParam[6].Value = SectorEconomico;
            arrParam[7] = new OracleParameter("id_actividad_eco", OracleDbType.NVarchar2, 6);
            arrParam[7].Value = Actividad;
            arrParam[8] = new OracleParameter("tipo_zona_franca", OracleDbType.NVarchar2, 1);
            arrParam[8].Value = TipoZonaFranca;
            arrParam[9] = new OracleParameter("parque", OracleDbType.NVarchar2, 50);
            arrParam[9].Value = Parque;
            arrParam[10] = new OracleParameter("calle", OracleDbType.NVarchar2, 150);
            arrParam[10].Value = Calle;
            arrParam[11] = new OracleParameter("numero", OracleDbType.NVarchar2, 12);
            arrParam[11].Value = Numero;
            arrParam[12] = new OracleParameter("apartamento", OracleDbType.NVarchar2, 100);
            arrParam[12].Value = Apartamento;
            arrParam[13] = new OracleParameter("sector", OracleDbType.NVarchar2, 100);
            arrParam[13].Value = Sector;
            arrParam[14] = new OracleParameter("provincia", OracleDbType.NVarchar2, 100);
            arrParam[14].Value = Provincia;
            arrParam[15] = new OracleParameter("id_municipio", OracleDbType.NVarchar2, 6);
            arrParam[15].Value = Municipio;
            arrParam[16] = new OracleParameter("telefono_1", OracleDbType.NVarchar2, 10);
            arrParam[16].Value = Telefono1;
            arrParam[17] = new OracleParameter("ext_1", OracleDbType.NVarchar2, 4);
            arrParam[17].Value = Ext1;
            arrParam[18] = new OracleParameter("telefono_2", OracleDbType.NVarchar2, 10);
            arrParam[18].Value = Telefono2;
            arrParam[19] = new OracleParameter("ext_2", OracleDbType.NVarchar2, 4);
            arrParam[19].Value = Ext2;
            arrParam[20] = new OracleParameter("fax", OracleDbType.NVarchar2, 10);
            arrParam[20].Value = Fax;
            arrParam[21] = new OracleParameter("email", OracleDbType.NVarchar2, 50);
            arrParam[21].Value = Email;
            arrParam[22] = new OracleParameter("cedula_representante", OracleDbType.NVarchar2, 11);
            arrParam[22].Value = R_Cedula_Pasaporte;
            arrParam[23] = new OracleParameter("telefono_rep_1", OracleDbType.NVarchar2, 10);
            arrParam[23].Value = R_Telefono1;
            arrParam[24] = new OracleParameter("ext_rep_1", OracleDbType.NVarchar2, 4);
            arrParam[24].Value = R_Ext1;
            arrParam[25] = new OracleParameter("telefono_rep_2", OracleDbType.NVarchar2, 10);
            arrParam[25].Value = R_Telefono2;
            arrParam[26] = new OracleParameter("ext_rep_2", OracleDbType.NVarchar2, 4);
            arrParam[26].Value = R_Ext2;
            arrParam[27] = new OracleParameter("ult_usuario_act", OracleDbType.NVarchar2, 35);
            arrParam[27].Value = User;
            arrParam[28] = new OracleParameter("ult_fecha_act", OracleDbType.Date);
            arrParam[28].Value = Date;
            arrParam[29] = new OracleParameter("ID_SOLICITUD", OracleDbType.Int32);
            arrParam[29].Value = idSol;
            arrParam[30] = new OracleParameter("P_ResultNumber", OracleDbType.NVarchar2, 500);
            arrParam[30].Direction = ParameterDirection.Output;

            String cmdStr = "Suirplus.sel_solicitudes_pkg.Insertar_Emp_Tmp";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[30].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string insertaEmpleadorDGII(String rncCedula,
            String razonSocial,
            String nombreComercial,
            String calle,
            String numero,
            String edificio,
            String piso,
            String apartamento,
            String idMunicipio,
            String telefono1,
            String email,
            String tipoEmpresa,
            DateTime fechaConst,
            DateTime fechaIni)
        {

            OracleParameter[] arrParam = new OracleParameter[16];

            arrParam[0] = new OracleParameter("p_RNC_CEDULA", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rncCedula;
            arrParam[1] = new OracleParameter("p_RAZON_SOCIAL", OracleDbType.NVarchar2, 150);
            arrParam[1].Value = razonSocial;
            arrParam[2] = new OracleParameter("p_NOMBRE_COMERCIAL", OracleDbType.NVarchar2, 150);
            arrParam[2].Value = nombreComercial;
            arrParam[3] = new OracleParameter("p_CALLE", OracleDbType.NVarchar2, 150);
            arrParam[3].Value = calle;
            arrParam[4] = new OracleParameter("p_NUMERO", OracleDbType.NVarchar2, 12);
            arrParam[4].Value = numero;
            arrParam[5] = new OracleParameter("p_EDIFICIO", OracleDbType.NVarchar2, 25);
            arrParam[5].Value = edificio;
            arrParam[6] = new OracleParameter("p_PISO", OracleDbType.NVarchar2, 2);
            arrParam[6].Value = piso;
            arrParam[7] = new OracleParameter("p_APARTAMENTO", OracleDbType.NVarchar2, 10);
            arrParam[7].Value = apartamento;
            arrParam[8] = new OracleParameter("p_TELEFONO_1", OracleDbType.NVarchar2, 10);
            arrParam[8].Value = telefono1;
            arrParam[9] = new OracleParameter("p_EMAIL", OracleDbType.NVarchar2, 50);
            arrParam[9].Value = email;
            arrParam[10] = new OracleParameter("p_DIRECCION", OracleDbType.NVarchar2, 150);
            arrParam[10].Value = "";
            arrParam[11] = new OracleParameter("p_TIPO_EMPRESA", OracleDbType.NVarchar2, 2);
            arrParam[11].Value = tipoEmpresa;
            arrParam[12] = new OracleParameter("p_COD_MUNICIPIO", OracleDbType.NVarchar2, 6);
            arrParam[12].Value = idMunicipio;
            arrParam[13] = new OracleParameter("p_fecha_inicio_actividades", OracleDbType.Date);
            arrParam[13].Value = fechaIni;
            arrParam[14] = new OracleParameter("p_fecha_nac_const", OracleDbType.Date);
            arrParam[14].Value = fechaConst;
            arrParam[15] = new OracleParameter("P_ResultNumber", OracleDbType.NVarchar2, 500);
            arrParam[15].Direction = ParameterDirection.Output;

            String cmdStr = "Dgi_Maestro_Empleadores_Pkg.maestro_empleador_crear";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[15].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }


        /// <summary>
        /// Validacion inicial de empleadores para su empadronamiento.
        /// </summary>
        /// <param name="rncCedula"></param>
        /// <returns></returns>
        public static string busquedaInicial(String rncCedula,String tipoempresa)
        {

            OracleParameter[] arrParam = new OracleParameter[14];

            arrParam[0] = new OracleParameter("p_RNC_CEDULA", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rncCedula;

            arrParam[1] = new OracleParameter("p_RAZON_SOCIAL", OracleDbType.NVarchar2, 150);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_NOMBRE_COMERCIAL", OracleDbType.NVarchar2, 150);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_CALLE", OracleDbType.NVarchar2, 150);
            arrParam[3].Direction = ParameterDirection.Output;

            arrParam[4] = new OracleParameter("p_NUMERO", OracleDbType.NVarchar2, 12);
            arrParam[4].Direction = ParameterDirection.Output;

            arrParam[5] = new OracleParameter("p_EDIFICIO", OracleDbType.NVarchar2, 25);
            arrParam[5].Direction = ParameterDirection.Output;

            arrParam[6] = new OracleParameter("p_PISO", OracleDbType.NVarchar2, 2);
            arrParam[6].Direction = ParameterDirection.Output;

            arrParam[7] = new OracleParameter("p_APARTAMENTO", OracleDbType.NVarchar2, 10);
            arrParam[7].Direction = ParameterDirection.Output;

            arrParam[8] = new OracleParameter("p_TELEFONO_1", OracleDbType.NVarchar2, 10);
            arrParam[8].Direction = ParameterDirection.Output;

            arrParam[9] = new OracleParameter("p_EMAIL", OracleDbType.NVarchar2, 50);
            arrParam[9].Direction = ParameterDirection.Output;

            arrParam[10] = new OracleParameter("p_COD_MUNICIPIO", OracleDbType.NVarchar2, 4);
            arrParam[10].Direction = ParameterDirection.Output;

            arrParam[11] = new OracleParameter("p_id_provincia", OracleDbType.NVarchar2, 6);
            arrParam[11].Direction = ParameterDirection.Output;

            arrParam[12] = new OracleParameter("p_tipo_empresa", OracleDbType.NVarchar2, 2);
            arrParam[12].Value = tipoempresa;
            arrParam[12].Direction = ParameterDirection.InputOutput;

            arrParam[13] = new OracleParameter("p_ResultNumber", OracleDbType.NVarchar2, 400);
            arrParam[13].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.empleadores_verificar_existe";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);

                // Preparando retorno del metodo con la siguiente estructura
                // RETORNO|RAZON SOCIAL|NOMBRE COMERCIAL|CALLE|NUMERO|EDIFICIO|PISO|APARTAMENTO|TELEFONO1|EMAIL|COD MUNICIPIO|TIPO EMPRESA | COD PROVINCIA

                String retorno, razonSocial, codProvincia, nombreComercial, calle, numero, edificio, piso, apartamento, telefono1, email, codMunicipio, tipoEmpresa;

                retorno = (arrParam[13].Value.ToString() == "0" ? arrParam[13].Value.ToString() + "||" : arrParam[13].Value.ToString() + "|");
                razonSocial = arrParam[1].Value.ToString() + "|";
                nombreComercial = arrParam[2].Value.ToString() + "|";
                calle = arrParam[3].Value.ToString() + "|";
                numero = arrParam[4].Value.ToString() + "|";
                edificio = arrParam[5].Value.ToString() + "|";
                piso = arrParam[6].Value.ToString() + "|";
                apartamento = arrParam[7].Value.ToString() + "|";
                telefono1 = arrParam[8].Value.ToString() + "|";
                email = arrParam[9].Value.ToString() + "|";
                codMunicipio = arrParam[10].Value.ToString() + "|";
                tipoEmpresa = arrParam[12].Value.ToString() + "|";
                codProvincia = arrParam[11].Value.ToString();


                return retorno + razonSocial + nombreComercial + calle + numero + edificio + piso + apartamento + telefono1 + email + codMunicipio + tipoEmpresa + codProvincia;
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }
        
        public static DataTable getConsSRLEmp(string rncCedula, string periodo)
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_rnc", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(rncCedula);
            arrParam[1] = new OracleParameter("p_periodo", OracleDbType.Decimal, 6);
            arrParam[1].Value = Utilitarios.Utils.verificarNulo(periodo);
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;

            arrParam[3] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sfc_factura_pkg.get_facturas_srl";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getEmpleador(int registroPatronal, string rncCedula)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(registroPatronal);
            arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2);
            arrParam[1].Value = Utilitarios.Utils.verificarNulo(rncCedula);

            arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.empleadores_select";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getEmpleadorDatos(string rnc)
        {


            //throw new Exception(numerolote.ToString() + fechaIni.ToString() + fechaFin.ToString());

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2);
            arrParam[0].Value = rnc;
            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Empleadores_Pkg.empleadores_rnc_select";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getUtimosOficios(int idRegistroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Emp_Crm_Pkg.GetUltimosOficios";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getUtimosCert(int idRegistroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_registro_patronal", OracleDbType.Decimal);
            arrParam[0].Value = idRegistroPatronal;
            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Emp_Crm_Pkg.GetUltimasCert";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }
        
        public static DataTable consultaEmpleador(int registroPatronal, string rncCedula,string nombreComercial, string razonSocial,string telefono, int pageNum, Int16 pagesize)
        {
            OracleParameter[] arrParam = new OracleParameter[8];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(registroPatronal);

            arrParam[1] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[1].Value = Utilitarios.Utils.verificarNulo(rncCedula);

            arrParam[2] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2, 150);
            arrParam[2].Value = Utilitarios.Utils.verificarNulo(nombreComercial);

            arrParam[3] = new OracleParameter("p_razon_Social", OracleDbType.NVarchar2, 150);
            arrParam[3].Value = Utilitarios.Utils.verificarNulo(razonSocial);

            arrParam[4] = new OracleParameter("p_telefono", OracleDbType.NVarchar2, 10);
            arrParam[4].Value = Utilitarios.Utils.verificarNulo(telefono);

            arrParam[5] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[5].Value = pageNum;

            arrParam[6] = new OracleParameter("p_pagesize", OracleDbType.Int16);
            arrParam[6].Value = pagesize;

            arrParam[7] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.pageConsulta_Empleadores";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static string AsignarSectorSalarial( Int32 RegistroPatronal, Int32 SectorSalarial, string UltUsuarioAct) 
        {
            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(RegistroPatronal);

            arrParam[1] = new OracleParameter("p_id_sector_salarial ", OracleDbType.Int32);
            arrParam[1].Value = Utilitarios.Utils.verificarNulo(SectorSalarial);

            arrParam[2] = new OracleParameter("p_ult_usuario_act", OracleDbType.Varchar2,35);
            arrParam[2].Value = Utilitarios.Utils.verificarNulo(UltUsuarioAct);

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.empleadores_edit_cod_salarial";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                return ex.ToString(); 

            }

        }
        /// <summary>
        /// Metodo para buscar el empleador para agregarle el sector salarial
        /// </summary>
        /// <param name="rncCedula">RNC del empleador</param>
        /// <param name="razonSocial">El nombre de la Razon Social</param>
        /// <returns></returns>
        public static DataTable ConsEmpleadorSinSectorSalarial(string rncCedula, string razonSocial)
        {
            OracleParameter[] arrParam = new OracleParameter[3];


            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = Utilitarios.Utils.verificarNulo(rncCedula);

            arrParam[1] = new OracleParameter("p_razon_Social", OracleDbType.NVarchar2, 150);
            arrParam[1].Value = Utilitarios.Utils.verificarNulo(razonSocial);

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;


            String cmdStr = "Sre_Empleadores_Pkg.ConsEmpleadorSinSectorSalarial";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }
        public static DataTable getEmpleadoresConAcuerdoDePago()
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Empleadores_Pkg.Empleadores_Con_AcuerdoPago";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }
        
        public static OracleDataReader getRazonSocialList(string prefixText, Int16 count)
        {
            string cmdStr = "Sre_Empleadores_Pkg.get_Empleadores_byRazon";
            OracleParameter[] arrParam = new OracleParameter[3];
            OracleDataReader reader;

            arrParam[0] = new OracleParameter("p_criterio", OracleDbType.Varchar2, ParameterDirection.Input);
            arrParam[0].Value = prefixText;

            arrParam[1] = new OracleParameter("p_registros", OracleDbType.Int16, ParameterDirection.Input);
            arrParam[1].Value = count;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                reader = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return reader;
        }
        
        public static OracleDataReader getNombreComercialList(string prefixText, Int16 count)
        {
            string cmdStr = "Sre_Empleadores_Pkg.get_Empleadores_byNombre";
            OracleParameter[] arrParam = new OracleParameter[3];
            OracleDataReader reader;

            arrParam[0] = new OracleParameter("p_criterio", OracleDbType.Varchar2, ParameterDirection.Input);
            arrParam[0].Value = prefixText;

            arrParam[1] = new OracleParameter("p_registros", OracleDbType.Int16, ParameterDirection.Input);
            arrParam[1].Value = count;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                reader = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return reader;

        }
        public static OracleDataReader getNombrePSS(string prefixText, Int16 count)
        {
            string cmdStr = "Sre_Empleadores_Pkg.get_PSS_byNombre";
            OracleParameter[] arrParam = new OracleParameter[3];
            OracleDataReader reader;

            arrParam[0] = new OracleParameter("p_criterio", OracleDbType.Varchar2, ParameterDirection.Input);
            arrParam[0].Value = prefixText;

            arrParam[1] = new OracleParameter("p_registros", OracleDbType.Int16, ParameterDirection.Input);
            arrParam[1].Value = count;

            arrParam[2] = new OracleParameter("p_iocursor", OracleDbType.RefCursor, ParameterDirection.Output);

            try
            {
                reader = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return reader;

        }
        public static bool isRegistrado(string rnc)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.IsRncRegistrado";
            string result = string.Empty;

            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();

                if (result == "1")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static string getRazonSocialEnDGII(string rnc)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_rnc_o_cedula", OracleDbType.NVarchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sel_solicitudes_pkg.getRazonSocialEnDGII";
            string result = string.Empty;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return result;
        }

        public static void desmarcaRectificacion(int idRegPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[2];
            string cmdStr = "Sre_Empleadores_Pkg.actualiza_status_cobro";

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = idRegPatronal;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                if (arrParam[1].Value.ToString() != "0")
                    throw new Exception(arrParam[1].Value.ToString());

            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public static DataTable getDocumentoEmpleador(int regPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("pidregistropatronal ", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("piocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("presultnumber", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Empleadores_Pkg.getDocumentoEmpleador";


        
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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }
        public static string setDocumentoEmpleador(int regPatronal, byte[] documento, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_documento", OracleDbType.Blob);
            arrParam[1].Value = documento;

            arrParam[2] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[2].Value = usuario;

            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Empleadores_Pkg.setDocumentoEmpleador";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                throw ex;
            }
        }

        public static DataTable getClaseEmpresa()
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[0].Direction = ParameterDirection.Output;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.getClaseEmpresa";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[1].Value.ToString() != "0")
                    throw new Exception(arrParam[1].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getDocClaseEmpresa(Int32 id_clase_empresa)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_clase_empresa", OracleDbType.Int32);
            arrParam[0].Value = id_clase_empresa;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.getDocClaseEmpresa";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[2].Value.ToString() != "0")
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getDGIIEmpleador(String rnc)
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_rnc_emp", OracleDbType.Varchar2, 11);
            arrParam[0].Value = rnc;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Varchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.getDgiiEmpleador";

            try
            {
                DataSet ds = DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam);

                if (arrParam[2].Value.ToString() != "0")
                    throw new Exception(arrParam[2].Value.ToString().Split('|')[1]);

                if (ds.Tables.Count > 0)
                {
                    return ds.Tables[0];
                }

                return new DataTable("No Hay Data");
            }

            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

	    public static string ActualizarEmpresa(int IdRegistroPatronal, 
                                               string RazonSocial, 
                                               string NombreComercial, 
                                               int CodSector,
                                               int idSectorEconomico, 
                                               decimal Capital,
                                               string IdTipoEmpresa
                                               
                                          )
		{
			OracleParameter[] arrParam = new OracleParameter[8];
		
			arrParam[0] = new OracleParameter("p_idRegPatronal",OracleDbType.Int32 );
			arrParam[0].Value= IdRegistroPatronal;

			arrParam[1] = new OracleParameter("p_razon_social", OracleDbType.NVarchar2,100);
			arrParam[1].Value= RazonSocial;

			arrParam[2] = new OracleParameter("p_nombre_comercial", OracleDbType.NVarchar2,100);
			arrParam[2].Value= NombreComercial;

			arrParam[3] = new OracleParameter("p_cod_sector", OracleDbType.Int32);
			arrParam[3].Value= CodSector;

            arrParam[4] = new OracleParameter("p_id_sector_economico", OracleDbType.Int32);
			arrParam[4].Value= idSectorEconomico;

            arrParam[5] = new OracleParameter("p_capital", OracleDbType.Decimal, 2);
			arrParam[5].Value= Capital;

            arrParam[6] = new OracleParameter("p_tipo_empresa", OracleDbType.NVarchar2, 2);
			arrParam[6].Value= IdTipoEmpresa;

            //arrParam[7] = new OracleParameter("p_status_cobro", OracleDbType.NVarchar2, 1);
            //arrParam[7].Value= StatusCobro;
    
			arrParam[7] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 2000);
			arrParam[7].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Empleadores_Pkg.ActualizaRegistroEmpresa";
		   
             try
             {
                 DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                 return arrParam[7].Value.ToString();
             }
             catch (Exception ex)
             {
                 throw ex;
             }	   
      
		}

        public static bool PermitePago(int  registroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = registroPatronal;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Empleadores_Pkg.Permitir_Pago";
            string result = string.Empty;

            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();

                if (result == "N")
                {
                    return false;
                }
                else
                {
                    return true;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static bool ExisteMovimiento(int registroPatronal)
        {
            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = registroPatronal;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "Sre_Empleadores_Pkg.isExisteMovimiento";
            string result = string.Empty;

            try
            {

                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                result = arrParam[1].Value.ToString();

                if (result == "Si")
                {
                    return true;
                }
                else
                {
                    return false;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

        }

        public static DataTable getInformesAuditoria(int regPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_registro_patronal ", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_RESULTNUMBER", OracleDbType.NVarchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_INFORMES_AUDITORIA_PKG.getInformes";



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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static string GuardarInformeAuditoria(int regpatronal, Byte[] ImageFile, string descripcion,string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[5];

            
            arrParam[0] = new OracleParameter("p_imagen", OracleDbType.Blob);
            arrParam[0].Value = ImageFile;
            arrParam[1] = new OracleParameter("p_registro_patronal", OracleDbType.Int32);
            arrParam[1].Value = regpatronal;
            arrParam[2] = new OracleParameter("p_descripcion", OracleDbType.NVarchar2);
            arrParam[2].Value = descripcion;
            arrParam[3] = new OracleParameter("p_ult_usuario_act", OracleDbType.NVarchar2);
            arrParam[3].Value = usuario;
            arrParam[4] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[4].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_INFORMES_AUDITORIA_PKG.cargarimagen";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[4].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }

        public static Byte[] getArchivoInforme(int IdInforme)
        {
            byte[] img = null;
            OracleDataReader odr = null;
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_informe ", OracleDbType.Int32);
            arrParam[0].Value = IdInforme;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_RESULTNUMBER", OracleDbType.NVarchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "SRE_INFORMES_AUDITORIA_PKG.getArchivoInforme";



            try
            {
                odr = DataBase.OracleHelper.ExecuteDataReader(CommandType.StoredProcedure, cmdStr, arrParam);
                if (odr.HasRows)
                {
                    odr.Read();
                    if (!odr.IsDBNull(0))
                    {
                        img = new byte[(odr.GetBytes(0, 0, null, 0, int.MaxValue))];
                        odr.GetBytes(0, 0, img, 0, img.Length);
                    }

                }

                odr.Close();

            }

            catch (Exception ex)
            {

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }

            return img;
        }

        public static DataTable getMensajesAlerta(int regPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Get_Mensajes";



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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }




        public static DataTable getMensajesEmpleador(int regPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Get_Mensajes_Empleador";



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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }


        public static DataTable getMensajesLeidosyPendientes(int regPatronal, int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pagenum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pagesize;


            arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Get_Mensajes_Leidos_Pendientes";



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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getMensajesArchivados(int regPatronal,int pagenum, int pagesize)
        {

            OracleParameter[] arrParam = new OracleParameter[4];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_pagenum", OracleDbType.Int32);
            arrParam[1].Value = pagenum;

            arrParam[2] = new OracleParameter("p_pagesize", OracleDbType.Int32);
            arrParam[2].Value = pagesize;


            arrParam[3] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[3].Direction = ParameterDirection.Output;


            String cmdStr = "sre_empleadores_pkg.Get_Mensajes_Archivados";



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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getMensajeLeer(int regPatronal, int id_mensaje)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("id_mensaje", OracleDbType.Int32);
            arrParam[1].Value = id_mensaje;

            arrParam[2] = new OracleParameter("io_cursor", OracleDbType.RefCursor);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Get_Mensaje_Leer";



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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }



        public static string MarcarMensajeLeido(int regPatronal, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[3];


            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;
            arrParam[1] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[1].Value = usuario;
            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[2].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Actualizar_Mensaje";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[2].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }




        public static string ActualizarMensajeEmpleador(int regPatronal,  int id_mensaje, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];


            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;
            arrParam[1] = new OracleParameter("p_id_mensaje", OracleDbType.Int32);
            arrParam[1].Value = id_mensaje;
            arrParam[2] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[2].Value = usuario;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Actualizar_Mensaje_Empleador";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }


        public static string MarcarMensajeArchivado(int regPatronal, int id_mensaje, string usuario)
        {

            OracleParameter[] arrParam = new OracleParameter[4];


            arrParam[0] = new OracleParameter("p_id_registro_patronal", OracleDbType.Int32);
            arrParam[0].Value = regPatronal;
            arrParam[1] = new OracleParameter("p_id_mensaje", OracleDbType.Int32);
            arrParam[1].Value = id_mensaje;
            arrParam[2] = new OracleParameter("p_usuario", OracleDbType.NVarchar2);
            arrParam[2].Value = usuario;
            arrParam[3] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 500);
            arrParam[3].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Marcar_Mensaje_Archivado";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[3].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }


        public static string getmensajes_sin_leer(int regPatronal)
        {

            OracleParameter[] arrParam = new OracleParameter[2];

            arrParam[0] = new OracleParameter("p_id_registro_patronal ", OracleDbType.Int64);
            arrParam[0].Value = regPatronal;

            arrParam[1] = new OracleParameter("p_resultnumber", OracleDbType.Int32);
            arrParam[1].Direction = ParameterDirection.Output;

            String cmdStr = "sre_empleadores_pkg.Get_Mensajes_sin_leer";

            try
            {
                DataBase.OracleHelper.ExecuteNonQuery(CommandType.StoredProcedure, cmdStr, arrParam);
                return arrParam[1].Value.ToString();
            }
            catch (Exception ex)
            {
                Exepciones.Log.LogToDB(ex.ToString());
                throw ex;

            }
        }



        public static DataTable getTrabajadorSalarioTipoEmpresa(string periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_periodo ", OracleDbType.Decimal,6);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;



            String cmdStr = "sre_estadisticas_pkg.Trab_rango_sal_tipo_empresa";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }


        public static DataTable getTrabajadorRangoSalario(string periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_periodo ", OracleDbType.Decimal, 6);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;



            String cmdStr = "sre_estadisticas_pkg.Trab_rango_salario";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getTrabajadorPorGenero(string periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_periodo ", OracleDbType.Decimal, 6);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;



            String cmdStr = "sre_estadisticas_pkg.Trab_por_genero";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }



        public static DataTable getTrabajadorPorRangoEdad(string periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_periodo ", OracleDbType.Decimal, 6);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;



            String cmdStr = "sre_estadisticas_pkg.Trab_por_rango_edad";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }

        public static DataTable getCantidadTrabajadoresEmpresas(string periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_periodo ", OracleDbType.Decimal, 6);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;



            String cmdStr = "sre_estadisticas_pkg.Empresas_cant_trabajadores";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }


        public static DataTable getMasTrabajadoresEmpresas(string periodo)
        {

            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_periodo ", OracleDbType.Decimal, 6);
            arrParam[0].Value = periodo;

            arrParam[1] = new OracleParameter("p_iocursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.Int32);
            arrParam[2].Direction = ParameterDirection.Output;



            String cmdStr = "sre_estadisticas_pkg.Empresas_mas_trabajadores";

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

                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());

                throw ex;

            }
        }



        #endregion

        }
        #endregion
     /// <summary>
    /// Enumerador utilizado para manejar el estatus de cobros de un empleador.
    /// </summary>
    public enum StatusCobrosType
    {
        Normal,
        Rectificacion,
        Legal,
        Cobros,
        Auditoria
    }

       
    }