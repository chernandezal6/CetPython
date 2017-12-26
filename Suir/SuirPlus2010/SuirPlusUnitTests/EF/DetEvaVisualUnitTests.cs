using NUnit.Framework;
using SuirPlusEF.Models;
using SuirPlusEF.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SuirPlusUnitTests.Framework;

namespace SuirPlusUnitTests.EF.Models
{
    public class DetEvaVisualUnitTests
    {
        [Test]
        [Category("EntityFramework")]
        public void GetByIdEvaluacion()
        {
            //DetalleEvaluacionVisual detevaluacionvisual = new DetalleEvaluacionVisual();
            //DetEvaluacionVisualRepository _RepDetEvaVisual = new DetEvaluacionVisualRepository();

            //detevaluacionvisual = _RepDetEvaVisual.GetByIdEvaluacion(DefaultValues.IdEvaluacionVisual);
            //NUnit.Framework.Assert.True(true);
        }

        [Test]
        [Category("EntityFramework")]
        public void ForeignKeys()
        {
            //EvaluacionVisualRepository _RepEvaVisual = new EvaluacionVisualRepository();
            //EvaluacionVisual EvaVisual = new EvaluacionVisual();
            
            //EvaVisual = _RepEvaVisual.GetByIdEvaluacion(DefaultValues.IdEvaluacionVisual);

            //DetalleEvaluacionVisual DetEvaVisual = new DetalleEvaluacionVisual { EvaluacionVisual = EvaVisual };
            //NUnit.Framework.Assert.True(true);
        }

        //[Test]
        //[Category("EntityFrameworkINS")]
        //public void NSSInsertarCiudadano()
        //{
        //    DetalleEvaluacionVisual detevaluacionvisual = new DetalleEvaluacionVisual();
        //    DetEvaluacionVisualRepository _RepDetEvaVisual = new DetEvaluacionVisualRepository();
        //    Console.WriteLine("entreeeee");
        //    try
        //    {
        //        _RepDetEvaVisual.NSSInsertarCiudadano(45, "OPERACIONES");
        //        Console.WriteLine("Termineee");
        //        NUnit.Framework.Assert.True(true);
        //    }
        //    catch (Exception ex) {
        //        Console.WriteLine("Termineee con error: "+ ex.ToString());
        //    }
        //}

        //[Test]
        //[Category("EntityFrameworkACT")]
        //public void NSSRechazarSolicitud()
        //{
        //    DetalleEvaluacionVisual detevaluacionvisual = new DetalleEvaluacionVisual();
        //    DetEvaluacionVisualRepository _RepDetEvaVisual = new DetEvaluacionVisualRepository();
        //    Console.WriteLine("entre a rechazar");
        //    try
        //    {
        //        _RepDetEvaVisual.NSSRechazarSolicitud(65,6,"NSS001",751737,"OPERACIONES");
        //        Console.WriteLine("Termine de rechazar");
        //        NUnit.Framework.Assert.True(true);
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine("Termineee con error: " + ex.ToString());
        //    }
        //}

        //[Test]
        //[Category("EntityFrameworkINS")]
        //public void NSSActualizarCiudadano()
        //{
        //    DetalleEvaluacionVisual detevaluacionvisual = new DetalleEvaluacionVisual();
        //    DetEvaluacionVisualRepository _RepDetEvaVisual = new DetEvaluacionVisualRepository();
        //    Console.WriteLine("entreeeee act");
        //    try
        //    {
        //        _RepDetEvaVisual.NSSActualizarCiudadano(46, "OPERACIONES");
        //        Console.WriteLine("Termineee act");
        //        NUnit.Framework.Assert.True(true);
        //    }
        //    catch (Exception ex)
        //    {
        //        Console.WriteLine("Termineee act con error: " + ex.ToString());
        //    }
        //}
    }    
}
