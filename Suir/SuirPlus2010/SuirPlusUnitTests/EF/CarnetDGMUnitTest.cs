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
    public class CarnetDGMUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdCarnet()
        {
            CarnetDGM carnet = new CarnetDGM();
            CarnetDGMRepository _RepCarnet = new CarnetDGMRepository();

            carnet = _RepCarnet.GetByIdCarnet(DefaultValues.IdCarnet);
            NUnit.Framework.Assert.True(true);
        }
    }
}
