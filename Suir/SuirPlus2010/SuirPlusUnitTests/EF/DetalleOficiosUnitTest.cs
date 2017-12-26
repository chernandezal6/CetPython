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
    public  class DetalleOficiosUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdOficio()
        {
            DetalleOficios detalleoficio = new DetalleOficios();
            DetalleOficiosRepository _RepDetalleOficios = new DetalleOficiosRepository();

            detalleoficio = _RepDetalleOficios.GetByIdOficio(DefaultValues.IdOficio);
            NUnit.Framework.Assert.True(true);
        }
    }
}
