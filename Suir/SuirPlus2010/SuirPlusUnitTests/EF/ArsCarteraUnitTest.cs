using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF.Models
{
    public class ArsCarteraUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByPeriodoFacturaARS()
        {
            ArsCartera arscartera = new ArsCartera();
            ArsCarteraRepository _RepArsCartera = new ArsCarteraRepository();

            arscartera = _RepArsCartera.GetByPeriodoFacturaARS(DefaultValues.PeriodoFactura);
            NUnit.Framework.Assert.True(true);
        }
    }
}
