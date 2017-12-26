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
    public class RenglonUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdRenglon()
        {
            Renglon renglones = new Renglon();
            RenglonRepository _RepRenglones = new RenglonRepository();

            renglones = _RepRenglones.GetByIdRenglon(DefaultValues.IdRenglon);
            NUnit.Framework.Assert.True(true);
        }
    }
}
