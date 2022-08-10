using UnityEngine;
using System.Collections;		// required for Coroutines
using System.Runtime.InteropServices;	// required for DllImport

namespace Minimal
{ 
	public static class Minimal 
	{
#if UNITY_EDITOR_WIN
		public const string PluginName = "Minimal";
#elif UNITY_STANDALONE_OSX || UNITY_EDITOR_OSX
		//	gr: unity no longer resolves this to the correct path at runtime. Now we need an .asmdef alongside this file to force
		//		the output to .app. Which places it in Game.app/Contents/PlugIns <--- note capital I to match updated macos rules, which unity has followed
		//	but this must be in the @rpath, as just the filename is what is needed to resolve
		public const string PluginName = "libMinimal.dylib";
#elif UNITY_IPHONE
		public const string PluginName = "__Internal";
#else
		public const string PluginName = "Minimal";
#endif
		public static int CreateVersionThousand(int Major,int Minor,int Patch)
		{
			return (Major * 1000 * 1000) + (Minor*1000) + Patch; 
		}

		[DllImport(PluginName, CallingConvention = CallingConvention.Cdecl)]
		private static extern int	Minimal_GetVersionThousand();

		public static int			VersionThousand => Minimal_GetVersionThousand();
	}

}
