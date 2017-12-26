using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Oracle.ManagedDataAccess.Client;
using System.Data;
using SuirPlus.DataBase; 
namespace SuirPlus.XMLBC
{
    public partial class ArchivoLiquidacion
    {

        #region "Propiedades del archivo"
        public String Proceso { get; set; }

        public String ArchivoXML { get; set; }

        public String CantDescargaArchivo { get; set; }

        public String CodBicEntidadCR { get; set; }

        public String CodBicEntidadDB { get; set; }

        public String ConceptoPago { get; set; }

        public String EstadoArchivoPortal { get; set; }

        public String FechaGeneracion { get; set; }

        public String FechaValorCRLBTR { get; set; }

        public String HoraGeneracion { get; set; }

        public String InformacionAdicional { get; set; }

        public String Moneda { get; set; }

        public String NombreArchivo { get; set; }

        public Int32 NombreLote { get; set; }

        public String Tipo { get; set; }

        public Double TotalMontoControl { get; set; }

        public Int32 TotalRegistroscontrol { get; set; }

        public String TRNopcrlbtr { get; set; }

        public String UsuarioDescargoArchivo { get; set; }
        #endregion

        #region "Constructores y Metodos del objecto"
        public ArchivoLiquidacion() { }

        public ArchivoLiquidacion(string nombrearchivo)
        {
            this.NombreArchivo = nombrearchivo;
            getEncabezado();

        }
        /// <summary>
        /// Metodo para obtener el encabezado del archivo de concentracion
        /// </summary>
        /// <param name="nombreArchivo">Nombre del archivo del que desea ver el encabezado</param>
        public void getEncabezado()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nombre_archivo", OracleDbType.Varchar2);
            arrParam[0].Value = this.NombreArchivo;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "BC_ManejoArchivoXML_PKG.getArchivoEncLiquidacion";

            try
            {

                DataTable dt = OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam).Tables[0];

                if (arrParam[2].Value.ToString() != ("0"))
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }

                if (dt.Rows.Count > 0)
                {
                  
                    NombreArchivo = dt.Rows[0].Field<String>("nombrearchivo");
                    Proceso = dt.Rows[0].Field<String>("proceso");
                    TRNopcrlbtr = dt.Rows[0].Field<String>("trn");
                    FechaGeneracion = Convert.ToString(dt.Rows[0].Field<DateTime>("fechageneracion"));
                    HoraGeneracion = Convert.ToString(dt.Rows[0].Field<DateTime>("horageneracion"));
                    NombreLote = dt.Rows[0].Field<Int32>("nombrelote");
                    ConceptoPago = dt.Rows[0].Field<String>("conceptopago");
                    CodBicEntidadDB = dt.Rows[0].Field<String>("entidaddebita");
                    CodBicEntidadCR = dt.Rows[0].Field<String>("entidadcredita");
                    FechaValorCRLBTR = Convert.ToString(dt.Rows[0].Field<DateTime>("fechaoperacion"));
                    TotalRegistroscontrol = dt.Rows[0].Field<Int32>("registrocontrol");

                    TotalMontoControl = dt.Rows[0].Field<Double>("totalcontrol");
                    Moneda = dt.Rows[0].Field<String>("moneda");

                }
                else
                {
                    throw new Exception("No hay Data");
                }

            }
            catch (OracleException oex)
            {

                Exepciones.Log.LogToDB(oex.ToString());
                throw oex;
            }
        }
        /// <summary>
        /// Metodo para obtener el detalle del archivo especificado
        /// </summary>
        /// <param name="nombrearchivo">Archivo del cual desea ver el detalle.</param>
        /// <returns>data table con el detalle del archvio</returns>
        public DataTable getDetalle()
        {
            OracleParameter[] arrParam = new OracleParameter[3];

            arrParam[0] = new OracleParameter("p_nombre_archivo", OracleDbType.Varchar2);
            arrParam[0].Value = NombreArchivo;

            arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
            arrParam[1].Direction = ParameterDirection.Output;

            arrParam[2] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
            arrParam[2].Direction = ParameterDirection.Output;

            string cmdStri = "BC_ManejoArchivoXML_PKG.getArchivoDetLiquidacion";
            DataTable dt;
            try
            {
                dt = OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStri, arrParam).Tables[0];

                if (arrParam[2].Value.ToString() != ("0"))
                {
                    throw new Exception(arrParam[2].Value.ToString());
                }
            }
            catch (OracleException oex)
            {

                Exepciones.Log.LogToDB(oex.ToString());
                throw oex;
            }
            return dt;

        }
        #endregion
       
    }
}
