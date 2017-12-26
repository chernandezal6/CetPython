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
    public class MotivoNoImpresionUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdAccion()
        {
            MotivoNoImpresion motivos = new MotivoNoImpresion();
            MotivoNoImpresionRepository _RepMotivoNoImpresion = new MotivoNoImpresionRepository();

            motivos = _RepMotivoNoImpresion.GetByIdMotivo(DefaultValues.IdMotivoNoImpresion);
            NUnit.Framework.Assert.True(true);
        }
    }
}
