package utils
{
	import flash.utils.getDefinitionByName;

	public class ClassLoader
	{
		public static function getClassInstance(className:String):*
		{
			return new (getDefinitionByName(className) as Class)();
		}
		public static function getClass(className:String):*
		{
			return getDefinitionByName(className) as Class;
		}
	}
}