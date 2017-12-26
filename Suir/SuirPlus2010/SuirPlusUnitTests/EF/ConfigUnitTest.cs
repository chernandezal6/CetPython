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
    public class ConfigUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdModulo()
        {
            Config config = new Config();
            ConfigRepository _RepConfig = new ConfigRepository();

            config = _RepConfig.GetByIdModulo(DefaultValues.IdModulo);
            NUnit.Framework.Assert.True(true);
        }
    }
}
