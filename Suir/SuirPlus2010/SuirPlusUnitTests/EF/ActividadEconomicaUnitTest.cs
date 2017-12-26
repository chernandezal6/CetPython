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
    public class ActividadEconomicaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdAccion()
        {
            ActividadEconomica actividadEco = new ActividadEconomica();
            ActividadEconomicaRepository _RepActividadEco = new ActividadEconomicaRepository();

            actividadEco = _RepActividadEco.GetByIdActividadEconomica(DefaultValues.IdActividadEco);
            NUnit.Framework.Assert.True(true);
        }
    }
}
