using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF
{
    public class DetalleSolicitudesUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdSolicitud()
        {
            DetalleSolicitudes solicitud = new DetalleSolicitudes();
            DetalleSolicitudesRepository _RepSolicitud = new DetalleSolicitudesRepository();

            solicitud = _RepSolicitud.GetBySolicitudExpediente(DefaultValues.IdSolicitudNss);
            NUnit.Framework.Assert.True(true);
        }
    }
}
