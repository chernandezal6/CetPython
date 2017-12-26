using Oracle.ManagedDataAccess.Client;
using System.Data;
using System;
using SuirPlus.DataBase;

namespace SuirPlus.SolicitudesEnLinea
{
	/// <summary>
	/// Summary description for structCancelacion.
	/// </summary>
	public struct structCancelacion
	{
      
//		public int IdTipoSolicitud;
//		public string TipoSolicitud;
//		public int IdStatus;
//		public string DescripcionStatus;
//		public string TipoCancelacion;
//		public DateTime FechaRegistro;
//		public DateTime FechaCierre;
//		public DateTime FechaEntrega;
//		public string RazonSocial;
//		public string NombreComercial;
		public string RNC;
		public string Cargo;
		public string Telefono;
		public string Motivo;
		public string RncCancelar;
		public string Representante;
		public string RepresentanteNombre;
		public string Operador;
		public string OperadorNombre;

		public string UsuarioModifico;
		public string Comentarios;
		public string Fax;
		public string Email;


		public static DataTable getDetalleFactura(int IdSolicitud)
		{

			OracleParameter[] arrParam  = new OracleParameter[3];

			arrParam[0] = new OracleParameter("p_IdSolicitud", OracleDbType.Decimal);
			arrParam[0].Value = IdSolicitud;

			arrParam[1] = new OracleParameter("p_IOCursor", OracleDbType.RefCursor);
			arrParam[1].Direction = ParameterDirection.Output;

			arrParam[2] = new OracleParameter("p_resultnumber", OracleDbType.NVarchar2, 200);
			arrParam[2].Direction = ParameterDirection.Output;

			String cmdStr= "sel_solicitudes_pkg.getDetCancelacion";

			try
			{
				return DataBase.OracleHelper.ExecuteDataset(CommandType.StoredProcedure, cmdStr, arrParam).Tables[0];
			}
			catch(Exception ex)
			{
				throw ex;
			}

		}



	}
}
