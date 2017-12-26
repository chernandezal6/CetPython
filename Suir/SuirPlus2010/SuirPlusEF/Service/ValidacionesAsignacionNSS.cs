using SuirPlusEF.Framework;
using SuirPlusEF.GenericModels;
using SuirPlusEF.Models;
using SuirPlusEF.Service;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SuirPlusEF.Service
{
    //public class ValidacionesAsignacionNSS
    //{
    //    public ValidacionesAsignacionNSS() { }
    //    public SuirPlusEF.Framework.OracleDbContext db;
    //    private string respuesta;
    //    public bool VerificarEstatus(string CodigoProceso, int CodigoValidacion) {
    //        db = new OracleDbContext();
    //        //buscamos la validacion requerida para saber si esta encendida o apagada
    //        bool result = false;
            
    //        int res = db.Validaciones.Count(x => x.IdProceso == CodigoProceso && x.IdValidacion == CodigoValidacion && x.Estatus == "A");
    //        if (res > 0)
    //        {
    //            return true;
    //        }
    //        return result;

    //    }


    //    //limpiar datos del acta para comparar

    //    public string limpiarMunicipio(string municipioActa)
    //    {
    //        if ((string.IsNullOrEmpty(municipioActa.Trim())) || municipioActa.Trim() == "0")
    //        { 
    //            respuesta = "000";
    //        }
    //        else
    //        {
    //            //quitar letras
    //            respuesta = ExtraerNumeros(municipioActa).ToString().PadLeft(3, '0');
    //        }
    //        return respuesta;
    //    }

    //    public string limpiarAno(string anoActa)
    //    {
    //        if ((string.IsNullOrEmpty(anoActa.Trim())) || anoActa.Trim() == "0")
    //        {
    //            respuesta = "0000";
    //        }
    //        else
    //        {
    //            //quitar letras
    //            respuesta = ExtraerNumeros(anoActa).ToString().PadLeft(4, '0');
    //        }
    //        return respuesta;
    //    }

    //    public string limpiarNumero(string numActa)
    //    {
    //        /*
    //               segun comunicado:
    //                * Quitar los 0 a la izquierda
    //                * Quitar todo lo que no sea numero
    //                * Convertir los NULL en CERO, cuando no se tenga, el campo va a tener UN CERO (0),
    //                  tal como lo devuelve el webservice la JCE. 
    //         */
    //        if ((string.IsNullOrEmpty(numActa.Trim())) || numActa.Trim() == "0")
    //        {
    //            respuesta = "0";
    //        }
    //        else
    //        {
    //            respuesta = ExtraerNumeros(numActa).ToString();
    //        }
    //        return respuesta;
    //    }

    //    public string limpiarFolio(string folioActa)
    //    {

    //        /*
    //           segun comunicado:
    //            * Quitar los 0 a la izquierda
    //            * Quitar todo lo que no sea numero
    //            * Convertir los NULL en CERO, cuando no se tenga, el campo va a tener UN CERO (0),
    //              tal como lo devuelve el webservice la JCE. 
    //        */
    //        if ((string.IsNullOrEmpty(folioActa.Trim())) || folioActa.Trim() == "0")
    //        {
    //            respuesta = "0";
    //        }
    //        else
    //        {
    //            respuesta = ExtraerNumeros(folioActa).ToString();
    //        }
    //        return respuesta;
    //    }

    //    public string limpiarLibro(string libroActa, string anoActa) {
    //        var literal = string.Empty;            
    //        respuesta =limpiarLibroCompleto(libroActa,anoActa, ref literal);
    //        Console.WriteLine("sali de limpiar el libro del acta = " + respuesta +" | "+ literal);
    //        return respuesta;
    //    }
    //    public string getLiterarFromLibro(string libroActa, string anoActa)
    //    {
    //        var literal = string.Empty;
    //            respuesta = limpiarLibroCompleto(libroActa, anoActa, ref literal);

    //        return literal;
    //    }

    //    public string limpiarLibroCompleto(string libroActa, string anoActa,ref string literal)
    //    {
    //        var ano = limpiarAno(anoActa);
    //        var libroCompleto = libroActa.Trim();
    //        Console.WriteLine("entre a limpiar el libro del acta = " + libroCompleto + " | "+ ano);

    //        /*
    //          segun comunicado:
    //            * Quitar los 0 a la izquierda
    //            * Quitar todo lo que no sea numero
    //            * Si el libro_acta termina en –XX y XX = a los últimos dos dígitos del ano_acta, se lo quitamos.
    //              Ejemplo:
    //                Libro_acta: 2-98 | ano_acta: 1998. Se convierte en:
    //                Libro_acta: 2
    //            * Si en el libro_acta está contenido el ano_acta al final del campo, se lo quitamos.
    //              Ejemplo:
    //                Ejemplo #1
    //                  Libro_acta: 12000 | ano_acta: 2000. Se convierte en:
    //                  Libro_acta: 1
    //                Ejemplo #2
    //                  Libro_acta: 1H2000 | ano_acta: 2000. Se convierte en:
    //                  Libro_acta: 1H (El H se le quita con la otra regla más abajo)
    //            * Cuando termine con letras, se van a tomar las letras (sin el guion) y se van a grabar en el literal_acta.
    //                Ejemplo:
    //                  Libro_acta: 00002-UM. Se convierte en
    //                  libro_acta: 2
    //                  literal_acta: UM
    //        */
    //        if (libroCompleto.Length > 4) {
    //            Console.WriteLine("imprime esto:1 -" + libroCompleto); 
    //            Console.WriteLine("imprime esto: " + libroCompleto.Substring(libroCompleto.Length-4));
    //            respuesta = libroCompleto.Substring(libroCompleto.Length - 4);
    //        }

    //            //if (libroCompleto.Contains("-"))
    //            //{
    //            //    Console.WriteLine("tiene guion? = True");
    //            //    int i = libroCompleto.IndexOf('-');
    //            //    Console.WriteLine("esta es la posicion del guion =" + i);
    //            //    Console.WriteLine("cantidad de posiciones= " + libroCompleto.Length);
    //            //    Console.WriteLine("contenido del campo libro= " + libroCompleto);
    //            //    var despuesDelGuion = libroCompleto.Substring(i, libroCompleto.Length - i).Replace("-", "");
    //            //    Console.WriteLine("esto es lo que queda despues del guion =" + despuesDelGuion);
    //            //    Console.WriteLine("cantidad de posiciones despues del guion =" + despuesDelGuion.Length);
    //            //    if (libroCompleto.Length < 4)
    //            //    {
    //            //        Console.WriteLine("contiene guiones y es < 4 " + libroCompleto.Length);
    //            //        if (despuesDelGuion.Length == 2)
    //            //        {
    //            //            if (despuesDelGuion != ano.Substring(-2, 2))
    //            //            {
    //            //                Console.WriteLine("despues del guion las posiciones son: "+ despuesDelGuion + " | substring del año a dos posiciones "+ ano.Substring(-2, 2));

    //            //                respuesta = ExtraerNumeros(libroCompleto).ToString();
    //            //                literal = ExtraerLetras(libroCompleto);

    //            //            }
    //            //            else
    //            //            {
    //            //                Console.WriteLine("despues del guion las posiciones son diferentes a 2: " + despuesDelGuion + " | substring del año a dos posiciones " + ano.Substring(-2, 2));
    //            //                respuesta = ExtraerNumeros(libroCompleto.Substring(0, i)).ToString();
    //            //                literal = ExtraerLetras(libroCompleto);


    //            //            }
    //            //        }
    //            //    }
    //            //    else if (libroCompleto.Length > 4)
    //            //    {

    //            //        Console.WriteLine("contiene guiones y es > 4 " + libroCompleto.Length);
    //            //        Console.WriteLine("contiene " + libroCompleto);

    //            //        var anoEnLibro = libroCompleto.Substring(-4, 4);
    //            //        Console.WriteLine("contiene guiones y es > 4 " + libroCompleto.Length);
    //            //        if (anoEnLibro != ano)
    //            //        {
    //            //            Console.WriteLine("despues del guion vemos si el ano esta contenido en el libro son: " + anoEnLibro + " | este es año enviado " + ano);
    //            //            respuesta = ExtraerNumeros(libroCompleto).ToString();
    //            //            literal = ExtraerLetras(libroCompleto);
    //            //        }
    //            //        else
    //            //        {
    //            //            Console.WriteLine("despues del guion los anos son diferentes: " + anoEnLibro + " | este es año enviado " + ano);
    //            //            respuesta = ExtraerNumeros(libroCompleto.Substring(0, -4)).ToString();
    //            //            literal = ExtraerLetras(libroCompleto);
    //            //        }

    //            //    }
    //            //    return respuesta;

    //            //}
    //            //else
    //            //{
    //            //    Console.WriteLine("tiene guion? = False");
    //            //}


    //        if (string.IsNullOrEmpty(libroCompleto))
    //        {
    //            respuesta = "0";
    //        }
    //        return respuesta;
    //    }

    //    public string limpiarOficialia(string oficialiaActa)
    //    {
    //        /*
    //          segun comunicado:
    //            * Quitar los 0 a la izquierda
    //            * Quitar todo lo que no sea numero
    //            * Convertir los NULL en CERO, cuando no se tenga, el campo va a tener UN CERO (0),
    //              tal como lo devuelve el webservice la JCE.
    //        */
    //        if ((string.IsNullOrEmpty(oficialiaActa.Trim())) || oficialiaActa.Trim()== "0")
    //        {
    //            respuesta = "0";
    //        }
    //        else
    //        {
    //            respuesta = ExtraerNumeros(oficialiaActa).ToString();
    //        }
    //        return respuesta;
    //    }

    //    public string limpiarPrimerNombre(string nombre)
    //    {
    //        Char delimiter = ' ';
    //        String[] primerNombre = nombre.TrimStart(' ').Split(delimiter);

    //        respuesta = primerNombre[0];
    //        return respuesta.ToUpper();
    //    }

    //    public string limpiarPrimerApellido(string primerApellido)
    //    {
    //        return respuesta.ToUpper();
    //    }

    //    public string limpiarFechaNacimiento(DateTime? fechaNacimiento)
    //    {
    //        respuesta = String.Format("{0:dd/MM/yyyy}", fechaNacimiento);
    //        return respuesta;
    //    }

    //    public Int32 ExtraerNumeros(string valor)
    //    {
    //        var soloNumeros = System.Text.RegularExpressions.Regex.Replace(valor, "[^0-9.]", "");
    //        if (soloNumeros.Trim().Length > 0) {
    //            return Convert.ToInt32(soloNumeros);
    //        }
    //        return 0;
    //    }

    //    public string ExtraerLetras(string valor) {
    //        var soloLetras = System.Text.RegularExpressions.Regex.Replace(valor, @"[^A-Z]+", String.Empty);

    //        return soloLetras.Trim();
    //    }
    //}
}
