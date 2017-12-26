using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusEF.ViewModels;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Service
{
    public class SolicitudAsignacion
    {

        private int mySolicitud;

        public SolicitudAsignacion()
        {
        }

        public SolicitudAsignacion(int Solicitud)
        {
            this.mySolicitud = Solicitud;
        }

        public int Crear(string doc, string tipoDoc, string username, string regPatronal)
        {
            int tipoSolicitud = 0;
            string DocumentoNUICED = string.Empty;
            string cola = string.Empty;

            if (tipoDoc == "C")
            {
                //para formatear el documento enviado
                DocumentoCedula documento = new DocumentoCedula(doc);
                DocumentoNUICED = documento.NumeroSinGuiones();
                tipoSolicitud = 3;
            }
            else if (tipoDoc == "U")
            {
                DocumentoNUI documento = new DocumentoNUI(doc);
                DocumentoNUICED = documento.NumeroSinGuiones();
                tipoSolicitud = 2;
            }
            else
            {
                return 0;
            }
            try
            {
                //instanciamos el servicio para solicitud de asignacion de nss
                SolicitudNSS sol = new SolicitudNSS();
                sol.FechaSolicitud = DateTime.Now;
                sol.IdTipo = tipoSolicitud;
                sol.UsuarioSolicita = username;
                if (regPatronal != null)
                {
                    sol.IdRegPatronal = Convert.ToInt32(regPatronal);
                }
                sol.UltimoUsuarioActualiza = username;
                sol.UltimaFechaActualizacion = DateTime.Now;

                // Insertar con el Repositorio la solicitud
                SolicitudNSSRepository _RepSolNSS = new SolicitudNSSRepository();
                _RepSolNSS.Add(sol);

                //creamos el detalle de la solicitud
                DetalleSolicitudesRepository _repDetSolNSS = new DetalleSolicitudesRepository();
                DetalleSolicitudes detSolNSS = new DetalleSolicitudes();

                detSolNSS.IdSolicitud = sol.IdSolicitud;
                detSolNSS.Documento = DocumentoNUICED;
                detSolNSS.Secuencia = 1;
                detSolNSS.IdTipoDocumento = tipoDoc;
                detSolNSS.IdEstatus = 1;
                detSolNSS.UltimaFechaActualizacion = DateTime.Now;
                detSolNSS.UltimoUsuarioActualiza = username;

                _repDetSolNSS.Add(detSolNSS);

                //PROCESAMOS LA SOLICITUD
                Procesar(sol.IdSolicitud);

                return sol.IdSolicitud;
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public int CrearSolicitudExtranjero(vmSolicitudNSSExtranjero vm, string username, string regPatronal)
        {
            //instanciamos el servicio para solicitud de asignacion de nss
            SolicitudNSS sol = new SolicitudNSS();
            NroExpediente carnetDGM = new NroExpediente(vm.NoDocumento);

            sol.FechaSolicitud = DateTime.Now;
            sol.IdTipo = 4;
            sol.UsuarioSolicita = username;
            if (regPatronal != null)
            {
                sol.IdRegPatronal = Convert.ToInt32(regPatronal);
            }
            sol.UltimoUsuarioActualiza = username;
            sol.UltimaFechaActualizacion = DateTime.Now;

            // Insertar con el Repositorio la solicitud
            SolicitudNSSRepository _RepSolNSS = new SolicitudNSSRepository();
            _RepSolNSS.Add(sol);

            //creamos el detalle de la solicitud
            DetalleSolicitudesRepository _repDetSolGral = new DetalleSolicitudesRepository();
            DetalleSolicitudes detSolicitud = new DetalleSolicitudes();
            detSolicitud.IdSolicitud = sol.IdSolicitud;
            detSolicitud.Secuencia = 1;
            detSolicitud.IdEstatus = 1;
            detSolicitud.Documento = vm.NoDocumento;
            detSolicitud.IdTipoDocumento = vm.TipoDocumento;
            detSolicitud.Nombres = vm.Nombres.ToUpper();
            detSolicitud.PrimerApellido = vm.PrimerApellido.ToUpper();
            detSolicitud.SegundoApellido = vm.SegundoApellido.ToUpper();
            detSolicitud.FechaNacimiento = vm.FechaNacimiento;
            detSolicitud.Sexo = vm.Sexo;
            detSolicitud.IMAGEN_SOLICITUD = vm.Imagen;
            detSolicitud.IdNacionalidad = vm.IdNacionalidad;
            detSolicitud.UltimoUsuarioActualiza = username;
            detSolicitud.UltimaFechaActualizacion = DateTime.Now;

            _repDetSolGral.Add(detSolicitud);

            //PROCESAMOS LA SOLICITUD
            Procesar(sol.IdSolicitud);

            return sol.IdSolicitud;
        }

        public void Procesar(int IdSolicitud)
        {
            // Buscar por ese # Solicitud en el Repositorio de Solicitudes
            SolicitudNSSRepository _RepSol = new SolicitudNSSRepository();
            SolicitudNSS sol = new SolicitudNSS();
            AsignacionNSS servAsignacion = new AsignacionNSS();
            try
            {
                sol = _RepSol.GetById(IdSolicitud);
                //Console.WriteLine("Procesamos la solicitud de tipo : " +  sol.tipoSolicitudNSS.Descripcion + "/" + sol.IdSolicitud);
                servAsignacion.ProcesarSolicitud(sol.IdSolicitud, "OPERACIONES");
                //Console.WriteLine("salimos de procesar la solicitud..." + sol.IdSolicitud);
            }
            catch (Exception ex)
            {
                SuirPlus.Exepciones.Log.LogToDB(ex.ToString());
                //Console.WriteLine("error " + ex.ToString());                
            }

        }

    }
}