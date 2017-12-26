using System.Security.Principal;
using System;

namespace SuirPlus.Seguridad
{
	/// <summary>
	/// 
	/// </summary>
	public sealed class CustomPrincipal : IPrincipal
	{

		private Usuario myUsuario;
		
		public CustomPrincipal(Usuario usuario, string[] roles, string[] permisos)
		{

			this.myUsuario = usuario;
			this.myUsuario.Roles = roles;
			this.myUsuario.Permisos = permisos;

		}

		public IIdentity Identity
		{
			get
			{
				return this.myUsuario;
			}
		}

		public bool IsInRole(string role)
		{
			// TODO:  Add CustomPrincipal.IsInRole implementation
			return false;
		}

	}
}
