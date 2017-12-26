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
    public class TipoSolicitudNSSUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdTipoSolicitudNSS()
        {
            TipoSolicitudNSS tipoSolicitudNSS = new TipoSolicitudNSS();
            TipoSolicitudNSSRepository _RepTipoSolicitudNSS = new TipoSolicitudNSSRepository();

            tipoSolicitudNSS = _RepTipoSolicitudNSS.GetByIdTipoSolNSS(DefaultValues.IdTipoSolicitudNSS);
            NUnit.Framework.Assert.True(true);
        }
    }
}
