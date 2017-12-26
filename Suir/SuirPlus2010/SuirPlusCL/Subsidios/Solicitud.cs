using System;
using SuirPlus.DataBase;
using System.Data;
using SuirPlus.Utilitarios;
using Oracle.ManagedDataAccess.Client;
namespace SuirPlus.Subsidios
{
    public class Solicitud : FrameWork.Objetos
    {

        #region "Propiedades de la clase"
        public Decimal NroSolicitud { get; set; }
        public Int32 NSS { get; set; }
        public Int32 Secuencia { get; set; }
        public Nullable<Int32> Padecimiento { get; set; }
        public String CategoriaSalario { get; set; }
        public Nullable<Int32> Nomina { get; set; }
        public TipoSubsidio Tipo { get; set; }
        #endregion

        #region "Metodos de la clase"

        public Solicitud() { }

         public Solicitud(int NroSolicitud)
         {
             this.CargarDatos();
         }
         /// <summary>
         /// Metodo que devuelve las solicitudes por empresa
         /// </summary>
         /// <param name="RegistroPatronal"></param>
         /// <returns>Devuelve las solicitudes por Empresa</returns>
         public DataTable SolicitudesPorEmpresa(int RegistroPatronal)
         {
             return new DataTable();
         }

         public override void CargarDatos()
         {
             throw new NotImplementedException();
            
         }

         public override string GuardarCambios(string UsuarioResponsable)
         {
             throw new NotImplementedException();
         }

        #endregion



    }
}
