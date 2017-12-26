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
    public class ArchivoUnitTest
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdRecepcion()
        {

            Archivo archivo = new Archivo();
            ArchivoRepository _RepArchivos = new ArchivoRepository();

            archivo = _RepArchivos.GetByIdRecepcion(DefaultValues.IdRecepcion);
            NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFramework")]
        public void ForeignKeys()
        {
            EntidadRecaudadoraRepository _RepEntRecaudadora = new EntidadRecaudadoraRepository();
            TipoMovimientoRepository _RepTipoMovimiento = new TipoMovimientoRepository(_RepEntRecaudadora.db);
            UsuarioRepository _RepUsuario = new UsuarioRepository(_RepEntRecaudadora.db);
            ErrorRepository _RepError = new ErrorRepository();

            EntidadRecaudadora entidadRecaudadora = _RepEntRecaudadora.GetByIdEntidadRecaudadora(DefaultValues.IdEntidadRecaudadora);
            TipoMovimiento tipoMovimiento = _RepTipoMovimiento.GetByIdTipoMovimiento(DefaultValues.IdTipoMovimiento);
            Usuario usuarioActualiza = _RepUsuario.GetByUsername(DefaultValues.IdUsuario);
            Error error = _RepError.GetByIdError(DefaultValues.IdError);

            Archivo archivo = new Archivo { IdRecepcion = DefaultValues.IdRecepcion, EntidadRecaudadora = entidadRecaudadora, TipoMovimiento = tipoMovimiento, UsuarioActualiza = usuarioActualiza, Error = error };

            Int32 Entidad = archivo.EntidadRecaudadora.IdEntidadRecaudadora;
            string Tipo = archivo.TipoMovimiento.IdTipoMovimiento;
            string Usuario = archivo.UltimoUsuarioActualiza;
            string Error = archivo.Error.IdError;

            NUnit.Framework.Assert.True(true);

        }
    }
}
