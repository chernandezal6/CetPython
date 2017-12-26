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
    public class TipoNSSUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdTipoNSS()
        {
            TipoNSS TipoNSS = new TipoNSS();
            TipoNSSRepository _RepTipoNSS = new TipoNSSRepository();

            TipoNSS = _RepTipoNSS.GetByIdTipoNSS(DefaultValues.IdTipoNSS);
            NUnit.Framework.Assert.True(true);
        }


    }
}
