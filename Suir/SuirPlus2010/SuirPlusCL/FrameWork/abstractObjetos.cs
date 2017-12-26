using System;
using SuirPlus;

namespace SuirPlus.FrameWork
{
    public struct ConfirmarMaternidad
    {
        public String NombreMadre;
        public String NSSMadre;
        public String CedulaMadre;
        public String SexoMare;
        public String FechaNacimientoMadre;
        public String SexoEmpleadoMadre;
        public String Celular;
        public String Email;
        public String FechaDiagnostico;
        public String FechaEstimadaParto;
        public String Telefono;
        public String RNC;
        public String EmprezaReporteEmbarazo;
        public String ApellidoTutor;
        public String NombreTutor;
        public String NoDocumentoTutor;
        public String RNCLicencia;
        public String FechaLicencia;
        public String Destinatario;
        public String DisplayDestinatario;
        public String EntidadRecaudadora;
        public String DisplayEntidadRecaudadora;
        public String NoCuenta;
        public String TipoCuenta;
        public String DisplayTipoCuenta;
        public String EmpresaReportoLicencia;
        public String DatosMaternidad;
        public String Usuario;
    }

	/// <summary>
	/// Clase abstracta que deben implementar todos los objetos.
	/// </summary>
	public abstract class Objetos
	{

		/// <summary>
		/// Campo de auditoria, ultimo usuario que actualizo la tabla, este campo es actualizado por un trigger
		/// </summary>
        protected DateTime myUltimaFechaActualizacion;
		/// <summary>
		/// Campo de auditoria que almacena ultima fecha y hora en que se actualizo o  inserto un registro
		/// </summary>
		protected string myUltimoUsuarioActualizo;


		public DateTime UltimaFechaActualizacion
		{
			get {return this.myUltimaFechaActualizacion;}
		}
		public string UltimoUsuarioActualizo
		{
			get {return this.myUltimoUsuarioActualizo;}
		}



		/// <summary>
		/// Metodo abstracto que deben implementar los objetos para cargar los datos necesarios para su creción.
		/// </summary>
		public abstract void CargarDatos();

		/// <summary>
		/// Metodo abstracto que deben implementar los objetos para guardar los cambios a la base de datos
		/// </summary>
		/// <param name="UsuarioResponsable">Recibe como parametro el usuario que esta modificando el registro</param>
		/// <returns>Retorna 0 si se guardo todo bien, de lo contrario un error.</returns>
		public abstract String GuardarCambios(string UsuarioResponsable);

	}
}
