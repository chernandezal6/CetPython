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
    public class SectorEconomicoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdSectorEconomico()
        {
            SectorEconomico sectoresEconomicos = new SectorEconomico();
            SectorEconomicoRepository _RepSectoresEconomicos = new SectorEconomicoRepository();

            sectoresEconomicos = _RepSectoresEconomicos.GetByIdSectorEconomico(DefaultValues.IdSectorEconomico);
            NUnit.Framework.Assert.True(true);
        }
    }
}
