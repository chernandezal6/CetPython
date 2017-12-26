using System;

namespace SuirPlus.Exepciones
{
	/// <summary>
	/// Excepcion general del SuirPlus.
	/// Implementa los procedimientos para setear mensajes customizados.
	/// </summary>
	public class SUIRException:ApplicationException 
	{

		private string myCustomMsg;

		/// <summary>
		/// Constructor generico
		/// </summary>
		/// <param name="message">Mensaje que viene heradado de la clase base de Excepciones</param>
		public SUIRException(string message):base(message) 	{}

		public void setMessage(string message)
		{
			this.myCustomMsg = message;
		}

		public string getMessage()
		{
			return this.myCustomMsg;
		}

	}

	public class DataNoFoundException:SUIRException
	{

		public DataNoFoundException():base("Registro no encontrado.") 	{}

	}
    public class InvalidNSSException : Exception
    {
        public InvalidNSSException(int id_nss)
            : base("Posibles causas de esta excepción:\n\t1.- No existe trabajador con dicho NSS\n\t2.- Existe con el NSS especificado pero esta inactivo, o no trabaja para el empleador especificado.")
        {
        }
    }

    public class InvalidDocumentException : Exception
    {
        public InvalidDocumentException(string cedula)
            : base("Posibles causas de esta excepción:\n\t1.- No existe trabajador con dicha cédula\n\t2.- Existe con la cédula especificada pero esta inactivo o no trabaja para el empleador especificado.")
        {
        }
    }

    public class InvalidTutorException : Exception
    {
        public InvalidTutorException(string cedula)
            : base("Posibles causas de esta excepción:\n\t1.- No existe tutor con dicha cédula\n\t2.- Existe con la cédula especificada pero esta inactivo.\n\t3.- La cédula corresponde a un menor de edad.\n\t4.- La cédula coincide con la de la madre")
        {
        }
    }
 
}
