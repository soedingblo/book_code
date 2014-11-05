/***
 * Excerpted from "Using JRuby",
 * published by The Pragmatic Bookshelf.
 * Copyrights apply to this code. It may not be used to create training material, 
 * courses, books, articles, and the like. Contact us if you are in doubt.
 * We make no guarantees that this code is fit for any purpose. 
 * Visit http://www.pragmaticprogrammer.com/titles/jruby for more book information.
***/
package book.embed;

import java.util.Arrays;
import org.jruby.embed.ScriptingContainer;

public class Historian3 {
    public static void main(String[] args) {
        ScriptingContainer container = new ScriptingContainer();

        container.setLoadPaths(Arrays.asList("lib"));

        String expr = "require 'git'\n" +
                      "Git.open('.').diff('HEAD^', 'HEAD')";

        System.out.println(container.runScriptlet(expr));
    }
}
