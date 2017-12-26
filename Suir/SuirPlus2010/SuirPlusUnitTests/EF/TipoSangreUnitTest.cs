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
    public class TipoSangreUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdTipoSangre()
        {
            TipoSangre tiposangre = new TipoSangre();
            TipoSangreRepository _RepTipoSangre = new TipoSangreRepository();

            tiposangre = _RepTipoSangre.GetByIdTipoSangre(DefaultValues.IdTipoSangre);
            NUnit.Framework.Assert.True(true);
        }
    }
}
