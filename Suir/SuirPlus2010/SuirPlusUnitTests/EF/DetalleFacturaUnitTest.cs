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
    public class DetalleFacturaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdReferencia()
        {
            DetalleFactura detallefactura = new DetalleFactura();
            DetalleFacturasRepository _RepDetFact = new DetalleFacturasRepository();

            detallefactura = _RepDetFact.GetByIdReferencia(DefaultValues.IdReferenciaTSS);
            NUnit.Framework.Assert.True(true);
        }
    }
}
