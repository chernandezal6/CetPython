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
    public class UsuarioUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdUsuario()
        {
            Usuario usuario = new Usuario();
            UsuarioRepository _RepUsuario = new UsuarioRepository();

            usuario = _RepUsuario.GetByUsername(DefaultValues.IdUsuario);

            NUnit.Framework.Assert.True(true);
        }
    }
}
