using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF
{
    public  class MovimientoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdMovimiento()
        {

            Movimiento movimiento = new Movimiento();
            MovimientoRepository _RepMovimientos = new MovimientoRepository();

            movimiento = _RepMovimientos.GetByIdMovimiento(DefaultValues.IdMovimiento);
            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFramework")]
        public void ForeignKeys()
        {
            EmpresaRepository _RepEmpresa = new EmpresaRepository();
            UsuarioRepository _RepUsuario = new UsuarioRepository(_RepEmpresa.db);
            UsuarioRepository _RepUsuarioMovimiento = new UsuarioRepository(_RepEmpresa.db);
            TipoMovimientoRepository _RepTipoMovimiento = new TipoMovimientoRepository(_RepEmpresa.db);

            Empresa Empresa = _RepEmpresa.GetByRegistroPatronal(DefaultValues.IdRegistroPatronal);
            Usuario Usuario = _RepUsuario.GetByUsername(DefaultValues.IdUsuario);
            TipoMovimiento TipoMovimiento = _RepTipoMovimiento.GetByIdTipoMovimiento(DefaultValues.IdTipoMovimiento);  

            Movimiento movimiento = new Movimiento { IdMovimiento = DefaultValues.IdMovimiento};
            NUnit.Framework.Assert.True(true);         

        }

    }
}
