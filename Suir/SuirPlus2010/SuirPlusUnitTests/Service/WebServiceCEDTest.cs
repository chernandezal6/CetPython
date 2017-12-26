using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;
using SuirPlusEF.GenericModels;
using SuirPlusEF.Service;
using System;

namespace SuirPlusUnitTests.Service
{
   public class WebServiceCEDTest
    {
        [Test]
        [Category("Service")]
        public void ConsultabyCED()
        {
            DocumentoCedula documento = new DocumentoCedula("00111941480");
            WebServiceCedulaModel wsCEDModel = new WebServiceCedulaModel();
            WebServiceCedula ws = new WebServiceCedula();
            SuirPlusEF.Framework.ServiceResult sr = new SuirPlusEF.Framework.ServiceResult();

          //  Console.WriteLine("entre " + documento.NumeroConGuiones());

           // sr = ws.ConsultaByCedula(documento, ref wsCEDModel);

           // Console.WriteLine("Mensajes acumulados: " + sr.Message());
           // Console.WriteLine("saliiii " + sr.Exception + "  " + wsCEDModel.Nombres);


          //  NUnit.Framework.StringAssert.AreEqualIgnoringCase("CHARLIE LORENZO", wsCEDModel.Nombres);

        }

    }
}
