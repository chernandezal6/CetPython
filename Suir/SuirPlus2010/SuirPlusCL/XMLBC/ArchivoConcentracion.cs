using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Data;
using Oracle.ManagedDataAccess.Client;  
using SuirPlus.DataBase;
namespace SuirPlus.XMLBC
{
    public partial class ArchivoConcentracion 
    {

        #region "Propiedades del encabezado del archivo"

                public string EntidadReceptora { get; set; }
                public string FechaTransmision { get; set; }
                public string NombreArchivo { get; set; }
                public string NroLote { get; set; }
                public string Proceso { get; set; }
                public string SubProceso { get; set; }
        #endregion

        #region "Propiedades del Sumario del archivo"
            public decimal Monto_Aclarado { get; set; }
            public int Numero_Registros { get; set; }
            public decimal Total_Ajuste { get; set; }
            public decimal Total_Liquidar { get; set; }
            public decimal Total_Liquidar_Ajuste { get; set; }
        #endregion

        #region "Metodos y Constructor del objecto"
                    public ArchivoConcentracion() { }
                    public ArchivoConcentracion(string nombrearchivo)
                    {
                        this.NombreArchivo = nombrearchivo;
                        getEncabezado();
                    }
                    public void getEncabezado()
                    {
                        OracleParameter[] arrParam = new OracleParameter[3];

                        arrParam[0] = new OracleParameter("p_nombre_archivo", OracleDbType.Varchar2);
                        arrParam[0].Value = this.NombreArchivo;

                        arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
                        arrParam[1].Direction = ParameterDirection.Output;

                        arrParam[2] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
                        arrParam[2].Direction = ParameterDirection.Output;

                        string cmdStri = "BC_ManejoArchivoXML_PKG.getArchivoEncConcentracion";
                        
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
                                SubProceso = dt.Rows[0].Field<String>("sub_proceso");
                                FechaTransmision = Convert.ToString(dt.Rows[0].Field<DateTime>("fechatransmision"));
                                EntidadReceptora = dt.Rows[0].Field<String>("entidadreceptora");
                                NroLote = dt.Rows[0].Field<String>("nrolote");
                                Numero_Registros = dt.Rows[0].Field<Int32>("totalregistros");
                                Total_Liquidar_Ajuste = dt.Rows[0].Field<Decimal>("liquidarsinajuste");
                                Monto_Aclarado = dt.Rows[0].Field<Decimal>("montoaclarado");
                                Total_Ajuste = dt.Rows[0].Field<Decimal>("totalajuste");
                                Total_Liquidar = dt.Rows[0].Field<Decimal>("totalliquidar");
                                
                            }
                            else
                                throw new Exception("No Hay Datos.");
                        }
                        catch (OracleException oex)
                        {
                            throw new Exception(oex.Message);
                        }

                    }
                    public DataTable getDetalle()
                    {
                        OracleParameter[] arrParam = new OracleParameter[3];

                        arrParam[0] = new OracleParameter("p_nombre_archivo", OracleDbType.Varchar2);
                        arrParam[0].Value = this.NombreArchivo;

                        arrParam[1] = new OracleParameter("p_io_cursor", OracleDbType.RefCursor);
                        arrParam[1].Direction = ParameterDirection.Output;

                        arrParam[2] = new OracleParameter("p_result", OracleDbType.NVarchar2, 200);
                        arrParam[2].Direction = ParameterDirection.Output;

                        string cmdStri = "BC_ManejoArchivoXML_PKG.getArchvioDetConcentracion";
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
                            throw new Exception(oex.Message);
                        }
                        return dt;
                    }

            #endregion
     


    }
}
