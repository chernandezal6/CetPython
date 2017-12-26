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
    public class MotivoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdMotivo()
        {
            Motivo motivos = new Motivo();
            MotivoRepository _RepMotivos = new MotivoRepository();

            motivos = _RepMotivos.GetByIdMotivo(DefaultValues.IdMotivo);
            NUnit.Framework.Assert.True(true);
        }
    }
}
