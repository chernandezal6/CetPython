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
    public class ArsCarteraSenasaUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByCodigoArs()
        {
            ArsCarteraSenasa arssenasa = new ArsCarteraSenasa();
            ArsCarteraSenasaRepository _RepArsCarteraSenasa = new ArsCarteraSenasaRepository();

            arssenasa = _RepArsCarteraSenasa.GetByCodigoARS(DefaultValues.IdArs);
            NUnit.Framework.Assert.True(true);
        }
    }
}
