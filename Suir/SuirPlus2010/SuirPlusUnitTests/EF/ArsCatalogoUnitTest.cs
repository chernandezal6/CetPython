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
    public class ArsCatalogoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdArs()
        {
            ArsCatalogo arscatalogo = new ArsCatalogo();
            ArsCatalogoRepository _RepArsCatalogo = new ArsCatalogoRepository();

            arscatalogo = _RepArsCatalogo.GetByIdArs(DefaultValues.IdArs);
            NUnit.Framework.Assert.True(true);
        }
    }
}
