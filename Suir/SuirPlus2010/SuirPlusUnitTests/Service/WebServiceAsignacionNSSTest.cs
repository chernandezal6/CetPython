using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;
using SuirPlusEF.Service;
using SuirPlusEF.GenericModels;
using SuirPlusEF.ViewModels;

namespace SuirPlusUnitTests.Service
{

    public class WebServiceAsignacionNSSTest
    {
        //[Test]
        //[Category("Service")]
        //public void CrearSolicitudAsignacionNSSNUI()
        //{            
        //    SolicitudNSS solicitudNSS = new SolicitudNSS();
        //    DocumentoNUI documento = new DocumentoNUI(DefaultValues.NroDocumentoNUI);
        //    var NUI = documento.NumeroSinGuiones();

        //    //instanciamos el servicio para solicitud de asignacion de nss
        //    SolicitudAsignacion sol = new SolicitudAsignacion();

        //    solicitudNSS.FechaSolicitud = DateTime.Now;
        //    solicitudNSS.IdTipo = 2;
        //    solicitudNSS.UsuarioSolicita = "OPERACIONES";

        //    var IdSol = sol.Crear(NUI, "U", "OPERACIONES");

        //    //buscamos la solicitud insertada para asegurarnos que inserto
        //    SolicitudNSS newSolicitud = new SolicitudNSS();
        //    SolicitudNSSRepository _RepSolicitudNSS = new SolicitudNSSRepository();
        //    newSolicitud = _RepSolicitudNSS.GetById(IdSol);

        //    Console.WriteLine("esta es la solicitud creada: " + newSolicitud.IdSolicitud);
        //    NUnit.Framework.StringAssert.AreEqualIgnoringCase(solicitudNSS.UsuarioSolicita, newSolicitud.UsuarioSolicita);
        //}

        //[Test]
        //[Category("ServiceData")]
        //public void CrearSolicitudAsignacionNSSCED()
        //{
        //    SolicitudNSS solicitudNSS = new SolicitudNSS();
        //    DocumentoCedula documento = new DocumentoCedula(DefaultValues.NroDocumentoCedula);
        //    var CED = documento.NumeroSinGuiones();

        //    //instanciamos el servicio para solicitud de asignacion de nss
        //    SolicitudAsignacion sol = new SolicitudAsignacion();

        //    solicitudNSS.FechaSolicitud = DateTime.Now;
        //    solicitudNSS.IdTipo = 1;
        //    solicitudNSS.UsuarioSolicita = "OPERACIONES";

        //    var IdSol = sol.Crear(CED, "C", "OPERACIONES");

        //    //buscamos la solicitud insertada para asegurarnos que inserto
        //    SolicitudNSS newSolicitud = new SolicitudNSS();
        //    SolicitudNSSRepository _RepSolicitudNSS = new SolicitudNSSRepository();
        //    newSolicitud = _RepSolicitudNSS.GetById(IdSol);

        //    Console.WriteLine("esta es la solicitud creada: " + newSolicitud.IdSolicitud);
        //    NUnit.Framework.StringAssert.AreEqualIgnoringCase(solicitudNSS.UsuarioSolicita, newSolicitud.UsuarioSolicita);
        //}

        //[Test]
        //[Category("Service")]
        //public void CrearSolicitudAsignacionNSS()
        //{
        //    //buscamos la solicitud insertada para asegurarnos que inserto
        //    SolicitudAsignacion _ServSolicitud = new SolicitudAsignacion();
        //    Console.Write("El Numero de solicitud es: " + _ServSolicitud.Crear("00102149002", "C","HMINAYA"));
        //    NUnit.Framework.Assert.True(true);
        //}

    }

}
