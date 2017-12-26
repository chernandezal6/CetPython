using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF
{
    public class TipoMovimientoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdMovimiento()
        {

            TipoMovimiento TipoMovimiento = new TipoMovimiento();
            TipoMovimientoRepository _RepTipoMovimientos = new TipoMovimientoRepository();

            TipoMovimiento = _RepTipoMovimientos.GetByIdTipoMovimiento(DefaultValues.IdTipoMovimiento);
            NUnit.Framework.Assert.True(true);
        }
    }
}
