using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using System.Collections.Generic;
using SuirPlusEF.Repositories;
using System;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Service
{
    public class ServEvaluacionVisual
    {
        public ServEvaluacionVisual() {
        }

        public string EnviarCola(int idSolicitud,Ciudadano ciudadano, IList<Ciudadano> coincidencias) {
            Console.WriteLine($"insertar en evaluacion visual la solicitud" + idSolicitud + " " +ciudadano.Nombres);
            try {
                //insertamos el encabezado de la evaluacion Visual
                //EvaluacionVisual ev = new EvaluacionVisual {
                //    IdSolicitud = idSolicitud,
                //    NroDocumento = ciudadano.NroDocumento,
                //    FechaInicioEvaluacionVisual = DateTime.Now,
                //    FechaFinEvaluacionVisual=DateTime.Now,
                //    Estatus = "PE",
                //    RazonEvaluacion = "Prueba evaluacion visual"                 
                //};
                //EvaluacionVisualRepository _repEV = new EvaluacionVisualRepository();                
                //_repEV.Add(ev);

                //insertamos las coincidencias encontradas en el detalle de evaluacion visual
                //DetalleEvaluacionVisual detEV = new DetalleEvaluacionVisual();
                //DetEvaluacionVisualRepository _repDetEV = new DetEvaluacionVisualRepository(_repEV.db);
                //Console.WriteLine($"insertar el detalle de la evaluacion visual " + ev.IdEvaluacionVisual);
                //foreach (Ciudadano c in coincidencias)
                //{
                //    detEV.IdEvaluacionVisual = ev.IdEvaluacionVisual;
                //    detEV.IdNSS = c.IdNSS;
                //    _repDetEV.Add(detEV);
                //}
                return "";
            }
            catch (Exception ex) {
                Console.WriteLine($"este es el error " + ex.ToString());
                return "";
            }
        }

        public string EnviarColaExtranjero(DetalleSolicitudes detGeneralNSS)
        {

            // Grabar en las tablas que esta haciendo armando, usando los repositorios e iterando sobre coincidencias

            return "";
        }

        public bool NUIEstaEnCola(DocumentoNUI documento) {
            EvaluacionVisualRepository _RepEvaluacionVisual = new EvaluacionVisualRepository();
            EvaluacionVisual evaluacionVisual = new EvaluacionVisual();

            evaluacionVisual = _RepEvaluacionVisual.GetByNroDocumentoEnCola(documento.NumeroSinGuiones());
            if (evaluacionVisual != null)
            {
                return true;
            }
            return false;
        }

        public bool CEDEstaEncola(DocumentoCedula documento) {
 
            EvaluacionVisualRepository _RepEvaluacionVisual = new EvaluacionVisualRepository();
            EvaluacionVisual evaluacionVisual = new EvaluacionVisual();

            evaluacionVisual = _RepEvaluacionVisual.GetByNroDocumentoEnCola(documento.NumeroSinGuiones());
            if (evaluacionVisual != null)
            {
                return true;
            }
            return false;
        }

        public bool ExpedienteEstaEnCola(string documento)
        {

            // Buscar en las tablas que armando esta haciendo, Pendiente.
      

            return false;
        }

    }
}
