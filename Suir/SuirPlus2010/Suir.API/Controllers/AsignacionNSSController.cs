using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using SuirPlusEF.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace Suir.API.Controllers
{
    public class AsignacionNSSController : ApiController
    {

        [HttpGet]
        public IHttpActionResult ProcesarNUI(string documento) {

            // curl http://localhost:PUERTOTUYO/api/AsignacionNSS/procesarnui/123123123

            SolicitudAsignacion sol = new SolicitudAsignacion();
            SolicitudNSS solicitudNSS = new SolicitudNSS();
            DocumentoNUI doc = new DocumentoNUI(documento);
            var NUI = doc.NumeroSinGuiones();

            //instanciamos el servicio para solicitud de asignacion de nss

            solicitudNSS.FechaSolicitud = DateTime.Now;
            solicitudNSS.IdTipo = 2;
            solicitudNSS.UsuarioSolicita = "OPERACIONES";

            //var IdSol = sol.Crear(solicitudNSS, NUI);


            //return Ok(IdSol);
            return null;

        }

    }
}
