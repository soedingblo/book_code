/***
 * Excerpted from "Programming Google Glass, Second Edition",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/erpgg2 for more book information.
***/
package glass.partify;

public final class Log {
	public final static String TAG = Log.class.getPackage().toString();

	public static void d(String message) {
		android.util.Log.d(TAG, message);
	}
}