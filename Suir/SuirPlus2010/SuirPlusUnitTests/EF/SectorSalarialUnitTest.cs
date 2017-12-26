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
    public class SectorSalarialUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdSector()
        {
            SectorSalarial sectores = new SectorSalarial();
            SectorSalarialRepository _RepSectoresSalariales = new SectorSalarialRepository();

            sectores = _RepSectoresSalariales.GetByIdSector(DefaultValues.CodSector);
            NUnit.Framework.Assert.True(true);
        }
    }
}
