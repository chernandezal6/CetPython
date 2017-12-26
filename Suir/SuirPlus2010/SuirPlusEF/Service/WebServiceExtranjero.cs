using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using SuirPlusEF.Framework;

namespace SuirPlusEF.Service
{
    public class WebServiceExtranjero : Framework.WebService<WebServiceExtranjero>
    {
        //ProcesarNSSExtranjero
        public ServiceResult ProcesarNSSExtranjero(ViewModels.vmSolicitudNSSExtranjero FormularioExtranjero, ref string nss)
        {            
            ServiceResult.AddMessage($"La solicitud de NSS para el extranjero {FormularioExtranjero.Nombres + " " + FormularioExtranjero.PrimerApellido} ha sido procesada.");
            nss= "123456789";
            ServiceResult.ServiceExecuted = true;
            return ServiceResult;
        }
    }
}
